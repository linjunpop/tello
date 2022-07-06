defmodule Tello.VirtualTello.UDPServer do
  @moduledoc """
  A virtual Tello which opens up a UDP server.
  Implementation based on the official documentation:
  https://dl-cdn.ryzerobotics.com/downloads/Tello/Tello%20SDK%202.0%20User%20Guide.pdf
  """

  use GenServer
  require Logger

  alias Tello.VirtualTello.{Controller, Responder}

  # auto pick one by system
  @default_port 0

  def start_link(port \\ @default_port) do
    GenServer.start_link(__MODULE__, %{port: port}, name: __MODULE__)
  end

  @impl true
  def init(%{port: port}) do
    :gen_udp.open(port, [:binary, active: true])
  end

  @impl true
  def handle_call(:port, _from, socket) do
    result = :inet.port(socket)

    {:reply, result, socket}
  end

  @impl true
  def handle_info({:udp, _socket, ip, port, data}, socket) do
    Logger.debug("Receives data from #{inspect(socket)}, #{inspect(ip)}:#{port}, data: #{data}")

    handle_packet({ip, port}, data, socket)
  end

  defp handle_packet(_from_server = {ip, port}, data, socket) do
    case Controller.handle_command(data) do
      {:ok, _state} ->
        Responder.reply(socket, {ip, port}, "ok")

      {:error, err} ->
        Logger.error(inspect(err))
    end

    {:noreply, socket}
  end
end
