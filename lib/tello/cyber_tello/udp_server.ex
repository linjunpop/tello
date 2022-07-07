defmodule Tello.CyberTello.UDPServer do
  @moduledoc """
  A virtual Tello which opens up a UDP server.
  Implementation based on the official documentation:
  https://dl-cdn.ryzerobotics.com/downloads/Tello/Tello%20SDK%202.0%20User%20Guide.pdf
  """

  use GenServer
  require Logger

  alias Tello.CyberTello.{Processor}

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
  def handle_call({:reply, message, _to_server = {ip, port}}, _from, socket) do
    :gen_udp.send(socket, ip, port, message)
  end

  @impl true
  def handle_info({:udp, _socket, ip, port, data}, _state) do
    Processor.process_command(data, {ip, port})
  end

  # Client

  def port do
    GenServer.call(__MODULE__, :port)
  end

  def reply(message, from) do
    GenServer.call(__MODULE__, {:reply, message, from})
  end
end
