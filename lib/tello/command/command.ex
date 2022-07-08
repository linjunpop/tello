defmodule Tello.Command do
  @moduledoc """
  Collection of functions to send command to a `Tello.Client`.
  """

  alias Tello.Client.Command.Builder

  @type coordinate :: {x :: integer(), y :: integer(), z :: integer()}
  @type mission_pad_id :: :m1 | :m2 | :m3 | :m4 | :m5 | :m6 | :m7 | :m8

  @doc """
  Enable Tello's SDK mode.
  """
  def enable(tello_client) do
    GenServer.call(tello_client, {:send, "command"})
  end

  @doc """
  Auto takeoff.
  """
  def takeoff(tello_client) do
    GenServer.call(tello_client, {:send, "takeoff"})
  end

  @doc """
  Auto landing.
  """
  def land(tello_client) do
    GenServer.call(tello_client, {:send, "land"})
  end

  @doc """
  Stop motors immediately.
  """
  def emergency(tello_client) do
    GenServer.call(tello_client, {:send, "emergency"})
  end

  @doc """
  Hover in the air.
  """
  def stop(tello_client) do
    GenServer.call(tello_client, {:send, "stop"})
  end

  @doc """
  Set the video stream to on/off.
  """
  @spec stream(pid(), :on | :off) :: :ok | {:error, any()}
  def stream(tello_client, toggle) when toggle in [:on, :off] do
    command = Builder.control(:stream, toggle)

    GenServer.call(tello_client, {:send, command})
  end

  [:up, :down, :left, :right, :forward, :back]
  |> Enum.each(fn command ->
    @doc """
    Fly #{command} for `distance` cm.
    """
    def unquote(command)(tello_client, distance) do
      command = Builder.control(unquote(command), distance)

      GenServer.call(tello_client, {:send, command})
    end
  end)

  @doc """
  Flip `direction`

  Available direction:
  - `:left`
  - `:right`
  - `forward`
  - `back`
  """
  def flip(tello_client, direction)
      when direction in [:left, :right, :forward, :back] do
    command = Builder.control(:flip, direction)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Rotate `degree` degrees on `direction`.
  """
  @spec rotate(pid(), :clockwise | :counterclockwise, integer()) :: :ok | {:error, any()}
  def rotate(tello_client, direction, degree)
      when direction in [:clockwise, :counterclockwise] and degree in 1..360 do
    command = Builder.control(:rotate, direction, degree)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Fly to coordinate `x,y,z` at `speed` (cm/s).

  If `mission_pad_id` is set, the coordinates will be set of the Mission Pad.
  """
  @spec go(pid(), coordinate, integer(), mission_pad_id) :: :ok | {:error, any()}
  def go(tello_client, _coordinate = {x, y, z}, speed, mission_pad_id \\ nil)
      when x in -500..500 and y in -500..500 and z in -500..500 and
             speed in 10..100 and
             mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] do
    command = Builder.control(:go, {x, y, z}, speed, mission_pad_id)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Fly to coordinates `x,y,z` of Mission Pad `first_mission_pad_id` after recognizing,
  and recognize coordinates `0,0,z` of Mission Pad `second_mission_pad_id`
  and rotate to the `yaw` value after hovering at the coordinates.
  """
  def jump(
        tello_client,
        _coordinate = {x, y, z},
        speed,
        yaw,
        first_mission_pad_id,
        second_mission_pad_id
      )
      when x in -500..500 and y in -500..500 and z in -500..500 and
             speed in 10..100 and
             first_mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] and
             second_mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] do
    command =
      Builder.control(
        :jump,
        {x, y, z},
        speed,
        yaw,
        first_mission_pad_id,
        second_mission_pad_id
      )

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Fly at a curve according to the two given coordinates of the Mission Pad `mission_pad_id`
  at `speed` (cm/s).
  """
  def curve(
        tello_client,
        _coordinate1 = {x1, y1, z1},
        _coordinate2 = {x2, y2, z2},
        speed,
        mission_pad_id \\ nil
      )
      when x1 in -500..500 and y1 in -500..500 and z1 in -500..500 and
             x2 in -500..500 and y2 in -500..500 and z2 in -500..500 and
             speed in 10..100 and
             mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] do
    command = Builder.control(:curve, {x1, y1, z1}, {x2, y2, z2}, speed, mission_pad_id)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Set speed to `speed` cm/s
  """
  def set_speed(tello_client, speed) when speed in 10..100 do
    command = Builder.set(:speed, speed)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Set remote controller via four channels
  """
  def set_remote_controller(
        tello_client,
        channel_left_right = {a_direction, a_value},
        channel_forward_backward = {b_direction, b_value},
        channel_up_down = {c_direction, c_value},
        yaw
      )
      when a_direction in [:left, :right] and
             a_value in -100..100 and
             b_direction in [:forward, :backward] and
             b_value in -100..100 and
             c_direction in [:up, :down] and
             c_value in -100..100 and
             yaw in -100..100 do
    command = Builder.set(:rc, channel_left_right, channel_forward_backward, channel_up_down, yaw)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Set Wi-Fi SSID and password
  """
  def set_wifi(tello_client, ssid, password) do
    command = Builder.set(:wifi, ssid, password)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Set Mission Pad detection to on/off
  """
  def set_mission_pad_detection(tello_client, toggle)
      when toggle in [:on, :off] do
    command = Builder.set(:mission_pad_detection, toggle)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Set Mission Pad detection mode
  """
  def set_mission_pad_detection_mode(tello_client, mode)
      when mode in [:downward, :forward, :both] do
    command = Builder.set(:mission_pad_detection_mode, mode)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Set the Tello to station mode, and connect to the access point.
  """
  def connect_to_ap(tello_client, ssid, password) do
    command = Builder.set(:ap, ssid, password)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Get current speed (cm/s).
  """
  def get_speed(tello_client) do
    command = Builder.read(:speed)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Get current battery percentage.
  """
  def get_battery(tello_client) do
    command = Builder.read(:battery)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Get current flight time.
  """
  def get_time(tello_client) do
    command = Builder.read(:time)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Get Wi-Fi SNR.
  """
  def get_wifi_snr(tello_client) do
    command = Builder.read(:wifi_snr)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Get Tello SDK version
  """
  def get_sdk_version(tello_client) do
    command = Builder.read(:sdk_version)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Get Tello serial number
  """
  def get_serial_number(tello_client) do
    command = Builder.read(:serial_number)

    GenServer.call(tello_client, {:send, command})
  end
end
