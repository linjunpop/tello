defmodule Tello do
  @moduledoc """
  An unofficial Ryze Tech Tello SDK

  ## Usage

  ```elixir
  # Start a client
  {:ok, tello_client, controller, status_listener} = Tello.start()

  # Enable the Tello's SDK mode
  :ok = Tello.Controller.enable(controller)

  # Control Tello
  :ok = Tello.Controller.get_sdk_version(controller)
  :ok = Tello.Controller.takeoff(controller)
  ```
  """

  alias Tello.{Manager, StatusListener, Controller}

  @type init_arg :: [
          controller: Controller.init_arg(),
          status_listener: StatusListener.init_arg()
        ]

  @default_arg [
    controller: [ip: {192, 168, 10, 1}, port: 8889, receiver: nil],
    status_listener: [port: 8890, handler: nil]
  ]

  @spec start(init_arg) :: {:ok, client :: pid, controller :: pid, status_listener :: nil | pid}
  @doc """
  Start a new `Tello.Client`.
  """
  def start(init_arg \\ @default_arg) do
    spec = {Tello.Client, init_arg}

    case DynamicSupervisor.start_child(Manager, spec) do
      {:ok, client_pid} ->
        controller_pid = Tello.Client.pid_for(client_pid, :controller)
        status_listener_pid = Tello.Client.pid_for(client_pid, :status_listener)

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
