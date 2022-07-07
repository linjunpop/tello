defmodule Tello.CyberTello.StateManager do
  use GenServer
  require Logger
  alias Tello.CyberTello.State

  def start_link(state: state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl true
  def init(%State{} = state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:set, key, value}, _from, state) do
    Logger.debug("Set state for #{key} to #{value}")

    new_state =
      state
      |> Map.put(key, value)

    {:reply, {:ok, new_state}, new_state}
  end

  @impl true
  def handle_call({:get, key}, _from, state) do
    value =
      state
      |> Map.get(key)

    {:reply, value, state}
  end
end
