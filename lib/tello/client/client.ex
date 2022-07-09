defmodule Tello.Client do
  @moduledoc """
  GenServer to connect to a Tello.
  """

  defmodule Tello.Client.State do
    @moduledoc false
    defstruct [:socket, :tello_server]
  end

  alias Tello.Client.State

  use GenServer
  require Logger

  # Server (callbacks)

  def start_link(uid: uid, arg: [ip: ip, port: port]) do
    GenServer.start_link(__MODULE__, [ip: ip, port: port], name: :"#{__MODULE__}.#{uid}")
  end

  @impl true
  def init(ip: ip, port: port) do
    {:ok, socket} = :gen_udp.open(0, [:binary, active: true])

    state = %State{
      socket: socket,
      tello_server: {ip, port}
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
