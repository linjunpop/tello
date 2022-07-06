defmodule Tello.VirtualTello do
  @moduledoc false

  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = [
      {Tello.VirtualTello.UDPServer, 0},
      {Tello.VirtualTello.StateManager, []}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end

  # Client

  def port() do
    GenServer.call(Tello.VirtualTello.UDPServer, :port)
  end
end
