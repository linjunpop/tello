defmodule Tello.CyberTello do
  @moduledoc false

  use Supervisor

  alias Tello.CyberTello.{UDPServer, Memory}

  def start_link(initial_args) do
    Supervisor.start_link(__MODULE__, initial_args, name: __MODULE__)
  end

  @impl true
  def init(initial_args) do
    children = [
      {UDPServer, 0},
      {Memory, [state: initial_args]}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end

  # Client

  def port() do
    GenServer.call(UDPServer, :port)
  end

  @doc false
  def send_command(command) do
    with {:ok, socket} <- :gen_udp.open(0),
         {:ok, port} <- port(),
         :ok <- :gen_udp.connect(socket, {127, 0, 0, 1}, port),
         :ok <- :gen_udp.send(socket, command) do
      :gen_udp.close(socket)
    end
  end
end
