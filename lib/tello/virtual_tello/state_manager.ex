defmodule Tello.VirtualTello.StateManager do
  use GenServer
  alias Tello.VirtualTello.State

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_state) do
    state = %State{}

    {:ok, state}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:set, key, value}, _from, state) do
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
