defmodule Tello.CyberTello.Memory do
  use GenServer
  require Logger
  alias Tello.CyberTello.State

  def start_link(state: args) do
    state = struct!(State, args)
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(%State{} = state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:set, new_state}, _from, _state) do
    {:reply, :ok, new_state}
  end

  # Client

  def get do
    GenServer.call(__MODULE__, :get)
  end

  def set(state) do
    GenServer.call(__MODULE__, {:set, state})
  end
end
