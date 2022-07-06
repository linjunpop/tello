defmodule Tello.Client do
  defmodule Tello.Client.State do
    defstruct [:socket, :tello_server]
  end

  alias Tello.Client.State

  use GenServer
  require Logger

  # Server (callbacks)

  @spec start_link([], {:inet.ip_address(), :inet.port_number()}) :: GenServer.on_start()
  def start_link([], tello_server = {_ip, _port} \\ {{192, 168, 10, 1}, 8889}) do
    uid =
      :erlang.make_ref()
      |> :erlang.ref_to_list()
      |> List.to_string()

    GenServer.start_link(__MODULE__, tello_server, name: :"#{__MODULE__}.#{uid}")
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
  def handle_call(
        {:send, command},
        _from,
        state = %State{socket: socket, tello_server: {ip, port}}
      ) do
    case :gen_udp.send(socket, ip, port, command) do
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
end
