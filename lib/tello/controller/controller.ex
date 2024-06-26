defmodule Tello.Controller do
  @moduledoc """
  GenServer to connect to a Tello.

  Uses `Tello.Controller.start_link/1` to start a controller.

      iex> {:ok, controller} = Tello.Controller.start_link([ip: {127, 0, 0, 1}, port: tello_server_port, receiver: MyReceiver])
      {:ok, controller}

  You need to first enable the SDK mode

      # Enable Tello's SDK mode
      iex> Tello.Controller.enable(controller)
      :ok

  Then you can send commands to control your Tello.Application

  ## Example

      iex> Tello.Controller.get_sdk_version(controller)
      :ok


  > #### Note {: .info}
  >
  > The communication between this module and the Tello is always async,
  > so the return value of the functions only garantee the command has been sent to Tello.
  > You must check the response from Tello in your implementation of `Tello.Controller.Receiver`,
  """

  use GenServer
  require Logger

  alias Tello.Controller.{State, CommandBuilder, Receiver}

  @type t :: module()
  @type init_arg :: [
          ip: :inet.ip_address(),
          port: :inet.port_number(),
          receiver: Receiver.t() | nil
        ]

  # Server (callbacks)

  @doc false
  @spec start_link(uid: integer(), arg: init_arg()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(uid: uid, arg: arg) do
    GenServer.start_link(__MODULE__, arg, name: :"#{__MODULE__}.#{uid}")
  end

  @impl true
  @doc false
  def init(ip: ip, port: port) do
    init(ip: ip, port: port, receiver: nil)
  end

  def init(ip: ip, port: port, receiver: receiver_module) do
    {:ok, socket} = :gen_udp.open(0, [:binary, active: true])

    state = %State{
      socket: socket,
      tello_server: {ip, port},
      receiver_module: receiver_module
    }

    {:ok, state}
  end

  @impl true
  def handle_call(
        {:send, command},
        _from,
        state = %State{socket: socket, tello_server: {ip, port}}
      ) do
    case :gen_udp.send(socket, ip, port, command) do
      :ok ->
        {:reply, :ok, state}

      {:error, reason} ->
        Logger.error(reason)
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_info(
        {:udp, socket, ip, port, data},
        %State{receiver_module: nil} = state
      ) do
    Logger.debug("Receives data from #{inspect(socket)}, #{inspect(ip)}:#{port}, data: #{data}")

    {:noreply, state}
  end

  def handle_info(
        {:udp, _socket, _ip, _port, data},
        %State{receiver_module: receiver_module} = state
      ) do
    Receiver.receive_message(receiver_module, data)

    {:noreply, state}
  end

  @type coordinate :: {x :: integer(), y :: integer(), z :: integer()}
  @type mission_pad_id :: :m1 | :m2 | :m3 | :m4 | :m5 | :m6 | :m7 | :m8

  @doc """
  Enable Tello's SDK mode.

  ## Examples

      iex> Tello.Controller.enable(controller)
      :ok
  """
  @spec enable(pid) :: :ok | {:error, any()}
  def enable(controller) do
    GenServer.call(controller, {:send, "command"})
  end

  @doc """
  Auto takeoff.

  ## Examples

      iex> Tello.Controller.takeoff(controller)
      :ok
  """
  @spec takeoff(pid) :: :ok | {:error, any()}
  def takeoff(controller) do
    GenServer.call(controller, {:send, "takeoff"})
  end

  @doc """
  Auto landing.

  ## Examples

      iex> Tello.Controller.land(controller)
      :ok
  """
  @spec land(pid) :: :ok | {:error, any()}
  def land(controller) do
    GenServer.call(controller, {:send, "land"})
  end

  @doc """
  Stop motors immediately.

  ## Examples

      iex> Tello.Controller.emergency(controller)
      :ok
  """
  @spec emergency(pid) :: :ok | {:error, any()}
  def emergency(controller) do
    GenServer.call(controller, {:send, "emergency"})
  end

  @doc """
  Hover in the air.

  ## Examples

      iex> Tello.Controller.stop(controller)
      :ok
  """
  @spec stop(pid) :: :ok | {:error, any()}
  def stop(controller) do
    GenServer.call(controller, {:send, "stop"})
  end

  @doc """
  Set the video stream to on/off.

  ## Examples

      iex> Tello.Controller.stream(controller, :on)
      :ok
  """
  @spec stream(pid(), :on | :off) :: :ok | {:error, any()}
  def stream(controller, toggle) when toggle in [:on, :off] do
    command = CommandBuilder.control(:stream, toggle)

    GenServer.call(controller, {:send, command})
  end

  [:up, :down, :left, :right, :forward, :back]
  |> Enum.each(fn command ->
    @doc """
    Fly #{command} for `distance` in centimeter.

    ## Examples

      iex> Tello.Controller.#{command}(controller, 2)
      :ok
    """
    @spec unquote(command)(pid, integer) :: :ok | {:error, any()}
    def unquote(command)(controller, distance) do
      command = CommandBuilder.control(unquote(command), distance)

      GenServer.call(controller, {:send, command})
    end
  end)

  @doc """
  Flip `direction`

  Available direction:
  - `:left`
  - `:right`
  - `forward`
  - `back`

  ## Examples

      iex> Tello.Controller.flip(controller, :right)
      :ok
  """
  @spec flip(pid, :back | :forward | :left | :right) :: :ok | {:error, any()}
  def flip(controller, direction)
      when direction in [:left, :right, :forward, :back] do
    command = CommandBuilder.control(:flip, direction)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Rotate `degree` degrees on `direction`.

  ## Examples

      iex> Tello.Controller.rotate(controller, :clockwise, 45)
      :ok
  """
  @spec rotate(pid(), :clockwise | :counterclockwise, integer()) :: :ok | {:error, any()}
  def rotate(controller, direction, degree)
      when direction in [:clockwise, :counterclockwise] and degree in 1..360 do
    command = CommandBuilder.control(:rotate, direction, degree)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Fly to coordinate `x,y,z` at `speed` (cm/s).

  If `mission_pad_id` is set, the coordinates will be set of the Mission Pad.

  ## Examples

    iex> Tello.Controller.go(controller, {10, 20, 30}, 23)
    :ok

    iex> Tello.Controller.go(controller, {10, 10, 10}, 13, :m3)
    :ok
  """
  @spec go(pid(), coordinate, integer(), mission_pad_id() | nil) :: :ok | {:error, any()}
  def go(controller, {x, y, z}, speed, mission_pad_id \\ nil)
      when x in -500..500 and y in -500..500 and z in -500..500 and
             speed in 10..100 and
             mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8, nil] do
    command = CommandBuilder.control(:go, {x, y, z}, speed, mission_pad_id)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Fly to coordinates `x,y,z` of Mission Pad `first_mission_pad_id` after recognizing,
  and recognize coordinates `0,0,z` of Mission Pad `second_mission_pad_id`
  and rotate to the `yaw` value after hovering at the coordinates.

  ## Examples

      iex> Tello.Controller.jump(controller, {10, -20, 30}, 10, -30, :m1, :m5)
      :ok
  """
  @spec jump(
          pid,
          coordinate(),
          integer(),
          integer(),
          mission_pad_id(),
          mission_pad_id()
        ) :: :ok | {:error, any()}
  def jump(
        controller,
        {x, y, z},
        speed,
        yaw,
        first_mission_pad_id,
        second_mission_pad_id
      )
      when x in -500..500 and y in -500..500 and z in -500..500 and
             speed in 10..100 and
             yaw in -100..100 and
             first_mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] and
             second_mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] do
    command =
      CommandBuilder.control(
        :jump,
        {x, y, z},
        speed,
        yaw,
        first_mission_pad_id,
        second_mission_pad_id
      )

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Fly at a curve according to the two given coordinates of the Mission Pad `mission_pad_id`
  at `speed` (cm/s).

  ## Examples

      iex> Tello.Controller.curve(controller, {1, 2, 3}, {3, 2, 1}, 10, :m8)
      :ok
  """
  @spec curve(pid, coordinate(), coordinate(), integer(), mission_pad_id() | nil) ::
          :ok | {:error, any()}
  def curve(
        controller,
        _coordinate1 = {x1, y1, z1},
        _coordinate2 = {x2, y2, z2},
        speed,
        mission_pad_id \\ nil
      )
      when x1 in -500..500 and y1 in -500..500 and z1 in -500..500 and
             x2 in -500..500 and y2 in -500..500 and z2 in -500..500 and
             speed in 10..100 and
             mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] do
    command = CommandBuilder.control(:curve, {x1, y1, z1}, {x2, y2, z2}, speed, mission_pad_id)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Set speed to `speed` cm/s

  ## Examples

      iex> Tello.Controller.set_speed(controller, 30)
      :ok
  """
  @spec set_speed(pid(), integer()) :: :ok | {:error, any()}
  def set_speed(controller, speed) when speed in 10..100 do
    command = CommandBuilder.set(:speed, speed)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Set remote controller via four channels

  ## Examples

      iex> Tello.Controller.set_remote_controller(controller, {:left, 10}, {:forward, 20}, {:up, 10}, -30)
      :ok
  """
  @spec set_remote_controller(
          pid(),
          {:left, integer()} | {:right, integer()},
          {:backward, integer()} | {:forward, integer()},
          {:down, integer()} | {:up, integer()},
          integer()
        ) :: :ok | {:error, any()}
  def set_remote_controller(
        controller,
        channel_left_right = {a_direction, a_value},
        channel_forward_backward = {b_direction, b_value},
        channel_up_down = {c_direction, c_value},
        yaw
      )
      when a_direction in [:left, :right] and
             a_value in 0..100 and
             b_direction in [:forward, :backward] and
             b_value in 0..100 and
             c_direction in [:up, :down] and
             c_value in 0..100 and
             yaw in -100..100 do
    command =
      CommandBuilder.set(:rc, channel_left_right, channel_forward_backward, channel_up_down, yaw)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Set Wi-Fi SSID and password

  ## Examples

      iex> Tello.Controller.set_wifi(controller, "mywifi", "mypass")
      :ok
  """
  @spec set_wifi(pid(), String.t(), String.t()) :: :ok | {:error, any()}
  def set_wifi(controller, ssid, password) do
    command = CommandBuilder.set(:wifi, ssid, password)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Toggle Mission Pad detection on/off

  ## Examples

      iex> Tello.Controller.set_mission_pad_detection(controller, :on)
      :ok
  """
  @spec set_mission_pad_detection(pid(), :off | :on) :: :ok | {:error, any()}
  def set_mission_pad_detection(controller, toggle)
      when toggle in [:on, :off] do
    command = CommandBuilder.set(:mission_pad_detection, toggle)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Set Mission Pad detection mode

  ## Examples

      iex> Tello.Controller.set_mission_pad_detection_mode(controller, :both)
      :ok
  """
  @spec set_mission_pad_detection_mode(
          pid(),
          :both | :downward | :forward
        ) :: :ok | {:error, any()}
  def set_mission_pad_detection_mode(controller, mode)
      when mode in [:downward, :forward, :both] do
    command = CommandBuilder.set(:mission_pad_detection_mode, mode)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Set the Tello to station mode, and connect to the access point.

  ## Examples

      iex> Tello.Controller.connect_to_ap(controller, "myssid", "mypass")
      :ok
  """
  @spec connect_to_ap(pid(), String.t(), String.t()) :: :ok | {:error, any()}
  def connect_to_ap(controller, ssid, password) do
    command = CommandBuilder.set(:ap, ssid, password)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Get current speed (cm/s).

  ## Examples

      iex> Tello.Controller.get_speed(controller)
      :ok
  """
  @spec get_speed(pid) :: :ok | {:error, any()}
  def get_speed(controller) do
    command = CommandBuilder.read(:speed)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Get current battery percentage.

  ## Examples

      iex> Tello.Controller.get_battery(controller)
      :ok
  """
  @spec get_battery(pid) :: :ok | {:error, any()}
  def get_battery(controller) do
    command = CommandBuilder.read(:battery)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Get current flight time.

  ## Examples

      iex> Tello.Controller.get_time(controller)
      :ok
  """
  @spec get_time(pid) :: :ok | {:error, any()}
  def get_time(controller) do
    command = CommandBuilder.read(:time)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Get Wi-Fi SNR.

  ## Examples

      iex> Tello.Controller.get_wifi_snr(controller)
      :ok
  """
  @spec get_wifi_snr(pid) :: :ok | {:error, any()}
  def get_wifi_snr(controller) do
    command = CommandBuilder.read(:wifi_snr)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Get Tello SDK version

  ## Examples

      iex> Tello.Controller.get_sdk_version(controller)
      :ok
  """
  @spec get_sdk_version(pid) :: :ok | {:error, any()}
  def get_sdk_version(controller) do
    command = CommandBuilder.read(:sdk_version)

    GenServer.call(controller, {:send, command})
  end

  @doc """
  Get Tello serial number

  ## Examples

      iex> Tello.Controller.get_serial_number(controller)
      :ok
  """
  @spec get_serial_number(pid) :: :ok | {:error, any()}
  def get_serial_number(controller) do
    command = CommandBuilder.read(:serial_number)

    GenServer.call(controller, {:send, command})
  end
end
