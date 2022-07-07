defmodule Tello.CyberTello.Controller do
  require Logger

  alias Tello.CyberTello.State

  @spec handle_command(String.t()) :: {:ok, State.t()} | {:error, String.t()}
  def handle_command("command") do
    GenServer.call(Tello.CyberTello.StateManager, {:set, :sdk_mode?, true})
  end

  def handle_command("takeoff") do
    GenServer.call(Tello.CyberTello.StateManager, {:set, :takeoff_at, NaiveDateTime.utc_now()})
  end

  def handle_command("land") do
    GenServer.call(Tello.CyberTello.StateManager, {:set, :takeoff_at, nil})
  end

  def handle_command(rest) do
    Logger.debug("Received command: #{rest}")

    # TODO: set state
    GenServer.call(Tello.CyberTello.StateManager, {:set, :sdk_mode?, true})
  end
end
