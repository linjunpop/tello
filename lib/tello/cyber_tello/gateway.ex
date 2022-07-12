defmodule Tello.CyberTello.Gateway do
  @moduledoc """
  Network Gateway for `Tello.CyberTello`.

  Opens up the UDP server to receive commands from `Tello.Controller`
  and reply message too.
  """

  use GenServer
  require Logger

  alias Tello.CyberTello.{Processor}

  # auto pick one by system
  @default_port 0

  @doc """
  Start the network gateway, using UDP `port`.

  The `port` default to `0`, which the underlying OS assigns a free UDP port.
  """
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
  def handle_cast({:reply, message, _to_server = {ip, port}}, socket) do
    :gen_udp.send(socket, ip, port, message)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:udp, _socket, ip, port, data}, state) do
    Processor.process_command(data, {ip, port})

    {:noreply, state}
  end

  # Client

  @doc """
  Reply message to `Tello.Controller`
  """
  @spec reply(String.t(), {:inet.ip_address(), :inet.port_number()}) :: :ok | {:error, any()}
  def reply(message, from) do
    GenServer.cast(__MODULE__, {:reply, message, from})
  end
end
