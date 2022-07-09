defmodule Tello.CyberTello.Processor do
  @moduledoc """
  Process the commands receives from `Tello.Client`.
  """

  require Logger

  alias Tello.CyberTello.{Gateway, Memory, State}
  alias Tello.CyberTello.Processor.ControlUnit

  @doc """
  Process the command.

  1. Get Tello's current state from `Tello.CyberTello.Memory`
  2. Mutate state based on the `command` by `Tello.CyberTello.Processor.ControlUnit`
  3. Send result to `from` by `Tello.CyberTello.Gateway`
  """
  @spec process_command(String.t(), {:inet.ip_address(), :inet.port_number()}) ::
          :ok | {:error, any()}
  def process_command(command, from) do
    current_state = Memory.get()

    if String.ends_with?(command, "?") do
      read(current_state, command, from)
    else
      handle_control_command(current_state, command, from)
    end
  end

  defp handle_control_command(state, command, from) do
    case ControlUnit.process_command(state, command) do
      {:ok, %State{} = new_state} ->
        Memory.set(new_state)
        Gateway.reply("ok", from)

        :ok

      {:error, err} ->
        Logger.error(inspect(err))

        Gateway.reply("error #{inspect(err)}", from)

        {:error, err}
    end
  end

  defp read(state, command, from) do
    case ControlUnit.fetch(state, command) do
      {:ok, value} ->
        Gateway.reply(value, from)

        :ok

      {:error, err} ->
        Logger.error(inspect(err))

        Gateway.reply("error #{inspect(err)}", from)

        {:error, err}
    end
  end
end
