defmodule Tello.Controller do
  defmodule Tello.Controller.State do
    defstruct [:socket, :tello_server]
  end

  alias Tello.Controller.State

  use GenServer
  require Logger

  # Server (callbacks)

  def start_link(tello_server = {_ip, _port} \\ {{192, 168, 10, 1}, 8889}) do
    GenServer.start_link(__MODULE__, tello_server)
  end

  @impl true
  def init(tello_server) do
    {:ok, socket} = :gen_udp.open(0, [:binary, active: true])

    state = %State{
      socket: socket,
      tello_server: tello_server
    }

    {:ok, state}
  end

  @impl true
  def handle_call({:send, msg}, _from, state = %State{socket: socket, tello_server: {ip, port}}) do
    case :gen_udp.send(socket, ip, port, msg) do
      :ok ->
        {:reply, :ok, state}

      {:error, reason} ->
        Logger.error(reason)
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_info({:udp, socket, ip, port, data}, state) do
    Logger.info("Receives data from #{inspect(socket)}, #{inspect(ip)}:#{port}, data: #{data}")
    {:noreply, state}
  end

  # Client

  @spec send_command(pid, String.t()) :: String.t()
  def send_command(client, command) do
    GenServer.call(client, {:send, command})
  end
end
