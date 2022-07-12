defmodule Tello do
  @moduledoc """
  An unofficial Ryze Tech Tello SDK
  """

  alias Tello.{Manager, Client, Controller, StatusListener}

  @default_arg [
    controller: [ip: {192, 168, 10, 1}, port: 8889, receiver: nil],
    status_listener: [port: 8890, handler: nil]
  ]

  @spec start(Client.init_arg()) ::
          {:ok, client :: pid, controller :: pid, status_listener :: nil | pid}
  @doc """
  Start a new `Tello.Client`.

  ```
  {:ok, tello_client, controller, status_listener} = Tello.start()
  ```
  """
  def start(init_arg \\ @default_arg) do
    spec = {Tello.Client, init_arg}

    case DynamicSupervisor.start_child(Manager, spec) do
      {:ok, client_pid} ->
        controller_pid = Tello.Client.pid_for(client_pid, Controller)
        status_listener_pid = Tello.Client.pid_for(client_pid, StatusListener)

        {:ok, client_pid, controller_pid, status_listener_pid}

      other ->
        other
    end
  end

  @doc """
  Terminate a `Tello.Client` and it's children.
  """
  @spec terminate(pid) :: :ok | {:error, :not_found}
  def terminate(client_pid) do
    DynamicSupervisor.terminate_child(Manager, client_pid)
  end
end
