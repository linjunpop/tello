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

  # private functions

  defp set(state, key, value) do
    state
    |> Map.put(key, value)
  end
end
