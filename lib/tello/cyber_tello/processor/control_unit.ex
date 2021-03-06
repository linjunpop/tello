defmodule Tello.CyberTello.Processor.ControlUnit do
  @moduledoc """
  The control unit for `Tello.CyberTello.Processor`.
  """

  require Logger

  alias Tello.CyberTello.{State}

  @doc """
  Mutate the `state` based on the `command`.

  Returns new `Tello.CyberTello.State`.
  """
  @spec process_command(State.t(), String.t()) :: {:ok, State.t()} | {:error, any()}
  def process_command(state, "command") do
    new_state = set(state, :sdk_mode?, true)

    {:ok, new_state}
  end

  def process_command(state, "takeoff") do
    new_state = set(state, :takeoff_at, NaiveDateTime.utc_now())

    {:ok, new_state}
  end

  def process_command(state, "land") do
    new_state = set(state, :takeoff_at, nil)
    {:ok, new_state}
  end

  def process_command(_state, "emergency") do
    {:ok, struct!(State)}
  end

  def process_command(state, "stop") do
    new_state =
      state
      |> set(:speed, %State.Speed{x: 0, y: 0, z: 0})
      |> set(:acceleration, %State.Acceleration{x: 0, y: 0, z: 0})

    {:ok, new_state}
  end

  def process_command(state, "streamon") do
    new_state =
      state
      |> set(:video_stream, :on)

    {:ok, new_state}
  end

  def process_command(state, "streamoff") do
    new_state =
      state
      |> set(:video_stream, :off)

    {:ok, new_state}
  end

  def process_command(%State{height: current_height} = state, "up" <> " " <> value) do
    new_state =
      state
      |> set(:height, current_height + String.to_integer(value))

    {:ok, new_state}
  end

  def process_command(%State{height: current_height} = state, "down" <> " " <> value) do
    height = current_height - String.to_integer(value)

    height = if height < 0, do: 0, else: height

    new_state =
      state
      |> set(:height, height)

    {:ok, new_state}
  end

  def process_command(state, "left" <> " " <> _value) do
    # TODO: noop
    {:ok, state}
  end

  def process_command(state, "right" <> " " <> _value) do
    # TODO: noop
    {:ok, state}
  end

  def process_command(state, "forward" <> " " <> _value) do
    # TODO: noop
    {:ok, state}
  end

  def process_command(state, "back" <> " " <> _value) do
    # TODO: noop
    {:ok, state}
  end

  def process_command(state, "flip" <> " " <> direction) do
    new_state =
      case direction do
        "l" ->
          state

        "r" ->
          state

        "f" ->
          state

        "b" ->
          state
      end

    {:ok, new_state}
  end

  def process_command(%State{yaw: yaw} = state, "cw" <> " " <> degree) do
    new_yaw =
      (yaw + String.to_integer(degree))
      |> Integer.mod(360)

    new_state =
      state
      |> set(:yaw, new_yaw)

    {:ok, new_state}
  end

  def process_command(state, "ccw" <> " " <> degree) do
    process_command(state, "cw #{360 - String.to_integer(degree)}")
  end

  def process_command(state, "go" <> " " <> go_args) do
    # TODO: noop
    case String.split(go_args, " ", parts: 5, trim: false) do
      [_x, _y, _z, _speed, _mission_pad_id] ->
        nil

      [_x, _y, _z, _speed] ->
        nil
    end

    {:ok, state}
  end

  def process_command(state, "curve" <> " " <> curve_args) do
    # TODO: noop
    case String.split(curve_args, " ", parts: 8, trim: false) do
      [_x1, _y1, _z1, _x2, _y2, _z2, _speed, _mission_pad_id] ->
        nil

      [_x1, _y1, _z1, _x2, _y2, _z2, _speed] ->
        nil
    end

    {:ok, state}
  end

  def process_command(state, "jump" <> " " <> jump_args) do
    # TODO: noop
    [_x, _y, _z, _speed, _yaw, _first_mission_pad_id, _second_mission_pad_id] =
      jump_args
      |> String.split(" ", parts: 7, trim: false)

    {:ok, state}
  end

  def process_command(state, "speed" <> " " <> speed) do
    new_state =
      state
      |> set(:speed, String.to_integer(speed))

    {:ok, new_state}
  end

  def process_command(state, "mon") do
    new_state =
      state
      |> set(:mission_pad, %State.MissionPad{})

    {:ok, new_state}
  end

  def process_command(state, "moff") do
    new_state =
      state
      |> set(:mission_pad, nil)

    {:ok, new_state}
  end

  def process_command(
        %State{mission_pad: nil} = _state,
        "mdirection" <> " " <> _detection_mode_code
      ) do
    {:error, "Please enable Mission Pad detection first"}
  end

  def process_command(
        %State{mission_pad: mission_pad} = state,
        "mdirection" <> " " <> detection_mode_code
      ) do
    detection_mode =
      case String.to_integer(detection_mode_code) do
        0 -> :downward
        1 -> :forward
        2 -> :both
      end

    mission_pad =
      mission_pad
      |> struct(detection_mode: detection_mode)

    new_state =
      state
      |> set(:mission_pad, mission_pad)

    {:ok, new_state}
  end

  def process_command(state, "rc" <> " " <> _rc_args) do
    {:ok, state}
  end

  def process_command(%State{wifi: wifi} = state, "wifi" <> " " <> wifi_args) do
    [ssid, password] =
      wifi_args
      |> String.split(" ")

    wifi =
      wifi
      |> struct(ssid: ssid, password: password)

    new_state =
      state
      |> set(:wifi, wifi)

    {:ok, new_state}
  end

  def process_command(%State{wifi: wifi} = state, "ap" <> " " <> wifi_args) do
    [ssid, password] =
      wifi_args
      |> String.split(" ")

    wifi =
      wifi
      |> struct(mode: :client, ssid: ssid, password: password)

    new_state =
      state
      |> set(:wifi, wifi)

    {:ok, new_state}
  end

  def fetch(%State{speed: %State.Speed{x: x}} = _state, "speed?") do
    {:ok, x}
  end

  def fetch(%State{battery: battery} = _state, "battery?") do
    {:ok, battery}
  end

  def fetch(%State{takeoff_at: nil} = _state, "time?"), do: {:ok, 0}

  def fetch(%State{takeoff_at: takeoff_at} = _state, "time?") do
    diff =
      takeoff_at
      |> NaiveDateTime.diff(NaiveDateTime.utc_now(), :millisecond)

    {:ok, diff}
  end

  def fetch(%State{wifi: %State.Wifi{snr: wifi_snr}} = _state, "wifi?") do
    {:ok, wifi_snr}
  end

  def fetch(%State{sdk_version: sdk_version} = _state, "sdk?") do
    {:ok, sdk_version}
  end

  def fetch(%State{serial_number: serial_number} = _state, "sn?") do
    {:ok, serial_number}
  end

  # private functions

  defp set(state, key, value) do
    state
    |> Map.put(key, value)
  end
end
