defmodule Tello.VirtualTello do
  @moduledoc """
  A virtual Tello which opens up a UDP server.
  Implementation based on the official documentation:
  https://dl-cdn.ryzerobotics.com/downloads/Tello/Tello%20SDK%202.0%20User%20Guide.pdf
  """

  use GenServer
  require Logger

  alias Tello.VirtualTello.Handler

  # auto pick one by system
  @default_port 0

  def start_link(port \\ @default_port) do
    GenServer.start_link(__MODULE__, %{port: port})
  end

  def init(%{port: port}) do
    :gen_udp.open(port, [:binary, active: true])
  end

  def handle_call(:port, _from, socket) do
    result = :inet.port(socket)

    {:reply, result, socket}
  end

  # define a callback handler for when gen_udp sends us a UDP packet
  def handle_info({:udp, socket, address, port, data}, socket) do
    Logger.info(
      "Receives data from #{inspect(socket)}, #{inspect(address)}:#{port}, data: #{data}"
    )

    handle_packet(data, socket)
  end

  # special case to `_quit` the server.
  defp handle_packet("_quit\n", socket) do
    Logger.debug("Received: _quit")
    # close the socket
    :gen_udp.close(socket)

    {:stop, :normal, nil}
  end

  defp handle_packet(data, socket) do
    result = Handler.handle_command(data)

    {:noreply, socket}
  end

  # Client

  def port(pid) do
    GenServer.call(pid, :port)
  end
end
