defmodule Tello.CyberTello do
  @moduledoc false

  use Supervisor

  alias Tello.CyberTello.{UDPServer, StateManager}

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {UDPServer, 0},
      {StateManager, []}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end

  # Client

  def port() do
    GenServer.call(UDPServer, :port)
  end

  def get(key) do
    GenServer.call(StateManager, {:get, key})
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
