defmodule Tello.VirtualTello.Handler do
  require Logger

  @spec handle_command(String.t()) :: :ok | {:error, String.t()}
  def handle_command("command") do
    Logger.debug("Entering SDK mode")
    :ok
  end
end
