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
    # Receives data from #Port<0.8>, {192, 168, 10, 1}:8889, data: mid:-1;x:-100;y:-100;z:-100;mpry:-1,-1,-1;pitch:0;roll:-1;yaw:21;vgx:0;vgy:0;vgz:0;templ:84;temph:87;tof:10;h:0;bat:100;baro:94.48;time:50;agx:-10.00;agy:16.00;agz:-999.00;
    Logger.info("Receives data from #{inspect(socket)}, #{inspect(ip)}:#{port}, data: #{data}")

    {:noreply, socket}
  end
end
