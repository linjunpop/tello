defmodule Tello.CyberTello do
  @moduledoc false

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Tello.CyberTello.UDPServer, 0},
      {Tello.CyberTello.StateManager, []}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end

  # Client

  def port() do
    GenServer.call(Tello.CyberTello.UDPServer, :port)
  end
end
