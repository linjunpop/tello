defmodule Tello.Client.StatusListener do
  @moduledoc """
  Receives status update messages from Tello.
  """

  use GenServer
  require Logger

  # Server (callbacks)

  def start_link(uid: uid, arg: [port: port]) do
    GenServer.start_link(__MODULE__, port, name: :"#{__MODULE__}.#{uid}")
  end

  @impl true
  def init(port) do
    {:ok, socket} = :gen_udp.open(port, [:binary, active: true])

    {:ok, socket}
  end

  @impl true
  def handle_info({:udp, socket, ip, port, data}, socket) do
    Logger.info("Receives data from #{inspect(socket)}, #{inspect(ip)}:#{port}, data: #{data}")
    {:noreply, socket}
  end
end
