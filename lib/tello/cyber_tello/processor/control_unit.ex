defmodule Tello.CyberTello.Processor.ControlUnit do
  require Logger

  alias Tello.CyberTello.{State}

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

  # private functions

  defp set(state, key, value) do
    state
    |> Map.put(key, value)
  end
end
