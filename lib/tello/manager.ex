defmodule Tello.Manager do
  use DynamicSupervisor

  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(init_arg) do
    DynamicSupervisor.init(
      strategy: :one_for_one,
      extra_arguments: [init_arg]
    )
  end

  @doc """
  Returns the Client PIDs
  """
  @spec client_pids :: [pid()]
  def client_pids() do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.map(fn {:undefined, pid, :supervisor, [Tello.Client]} ->
      pid
    end)
  end
end
