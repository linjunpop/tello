defmodule Tello.Command do
  alias Tello.Client.CommandBuilder

  @type coordinate :: {x :: integer(), y :: integer(), z :: integer()}
  @type mission_pad_id :: :m1 | :m2 | :m3 | :m4 | :m5 | :m6 | :m7 | :m8

  @doc """
  Enable Tello's SDK mode.
  """
  def command(tello_client) do
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
    command = CommandBuilder.control(:stream, toggle)

    GenServer.call(tello_client, {:send, command})
  end

  [:up, :down, :left, :right, :forward, :back]
  |> Enum.each(fn command ->
    @doc """
    Fly #{command} for `distance` cm.
    """
    def unquote(command)(tello_client, distance) do
      command = CommandBuilder.control(unquote(command), distance)

      GenServer.call(tello_client, {:send, command})
    end
  end)

  @doc """
  Rotate `degree` degrees on `direction`.
  """
  @spec rotate(pid(), :clockwise | :counterclockwise, integer()) :: :ok | {:error, any()}
  def rotate(tello_client, direction, degree)
      when direction in [:clockwise, :counterclockwise] and degree in 1..360 do
    command = CommandBuilder.control(:rotate, direction, degree)

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
    command = CommandBuilder.control(:go, {x, y, z}, speed, mission_pad_id)

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
      CommandBuilder.control(
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
    command = CommandBuilder.control(:curve, {x1, y1, z1}, {x2, y2, z2}, speed, mission_pad_id)

    GenServer.call(tello_client, {:send, command})
  end

  @doc """
  Set speed to `speed` cm/s
  """
  def set_speed(tello_client, speed) when speed in 10..100 do
    command = CommandBuilder.set(:speed, speed)

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
    command =
      CommandBuilder.set(:rc, channel_left_right, channel_forward_backward, channel_up_down, yaw)

    GenServer.call(tello_client, {:send, command})
  end
end
