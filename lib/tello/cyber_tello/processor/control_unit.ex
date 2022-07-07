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

  # private functions

  defp set(state, key, value) do
    Logger.debug("Set state for #{key} to #{value}")

    state
    |> Map.put(key, value)
  end
end
