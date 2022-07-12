defmodule Tello.StatusListener do
  @moduledoc """
  Receives status update messages from Tello.
  """

  use GenServer
  require Logger

  alias Tello.StatusListener.{Parser, Handler}

  @type t :: module()
  @type init_arg :: [
          port: :inet.port_number(),
          handler: Handler.t() | nil
        ]

  # Server (callbacks)

  @spec start_link(uid: reference(), arg: init_arg()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(uid: uid, arg: arg) do
    GenServer.start_link(__MODULE__, arg, name: :"#{__MODULE__}.#{uid}")
  end

  @impl true
  def init(arg) do
    port = Keyword.get(arg, :port, 8890)
    handler = Keyword.get(arg, :handler, nil)

    {:ok, socket} = :gen_udp.open(port, [:binary, active: true])

    {:ok, %{socket: socket, port: port, handler: handler}}
  end

  @impl true
  def handle_info({:udp, _socket, _ip, _port, data}, %{handler: nil} = state) do
    status = Parser.parse(data)

    Logger.debug("Status: #{inspect(status)}")

    {:noreply, state}
  end

  def handle_info({:udp, _socket, _ip, _port, data}, %{handler: handler} = state) do
    status = Parser.parse(data)

    if function_exported?(handler, :handle_status, 1) do
      handler.handle_status(status)
    else
      Logger.warn(
        "Please implement `handle_status/1` for the custom `Tello.StatusListener.Handler` handler."
      )
    end

    {:noreply, state}
  end
end
