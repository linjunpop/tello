defmodule Tello.CyberTello.Processor do
  require Logger

  alias Tello.CyberTello.{UDPServer, Memory}
  alias Tello.CyberTello.Processor.ControlUnit

  def process_command(command, from) do
    current_state = Memory.get()

    case ControlUnit.process_command(current_state, command) do
      {:ok, new_state} ->
        Memory.set(new_state)
        UDPServer.reply("ok", from)

      {:error, err} ->
        Logger.error(inspect(err))

        UDPServer.reply("error #{inspect(err)}", from)
    end
  end
end
