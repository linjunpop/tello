defmodule Tello.VirtualTello.Controller do
  require Logger

  alias Tello.VirtualTello.State

  @spec handle_command(String.t()) :: {:ok, State.t()} | {:error, String.t()}
  def handle_command("command") do
    Logger.debug("Entering SDK mode")

    GenServer.call(Tello.VirtualTello.StateManager, {:set, :sdk_mode?, true})
  end

  def handle_command(rest) do
    Logger.debug("Received command: #{rest}")

    # TODO: set state
    GenServer.call(Tello.VirtualTello.StateManager, {:set, :sdk_mode?, true})
  end
end
