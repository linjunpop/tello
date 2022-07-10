defmodule Tello do
  @moduledoc """
  An unofficial Ryze Tech Tello SDK

  ## Usage

  ```elixir
  # Start a client
  {:ok, supervisor, client, status_listener} = Tello.start()

  # Enable the Tello's SDK mode
  :ok = Tello.Command.enable(client)

  # Control Tello
  :ok = Tello.Command.get_sdk_version(client)
  :ok = Tello.Command.takeoff(client)
  ```

  Please check `Tello.Command` for a full list of commands.

  ## Architecture

  ```mermaid
  flowchart TD
    Application(Tello.Application)
    Command(Tello.Command)
    RyzeTello(((Ryze Tello)))

    Application --- Manager
    Command --- Client1
    Command --- Client2

    subgraph TelloClient[Client]
      Manager(Tello.Client.Manager)

      Manager -.- Supervisor1
      Manager -.- Supervisor2

      subgraph ClientCluster[Cluster]
        Supervisor1(Tello.Client.Supervisor)
        Supervisor2(Tello.Client.Supervisor)

        Client1(Tello.Client)
        Client2(Tello.Client)

        StatusListener2(Tello.Client.StatusListener)

        More(...)

        Supervisor1 -.- Client1
        Supervisor2 -.- Client2
        Supervisor2 -.- StatusListener2
      end
    end

    subgraph CyberTello
      Gateway(Tello.CyberTello.Gateway)
      Memory[(Tello.CyberTello.Memory)]

      subgraph CPU
        Processor(Tello.CyberTello.Processor)
        ControlUnit(Tello.CyberTello.ControlUnit)

        Processor -.- ControlUnit
      end

      Memory -.- Processor
      Gateway -.- Processor
    end

    Client1 --- Gateway
    Client2 --- RyzeTello
    StatusListener2 --- RyzeTello
  ```

  ## See also

  - `Tello.Command`
  - `Tello.CyberTello`
  """

  alias Tello.Client.{Manager, Receiver}

  @type init_arg :: [
          client: [ip: :inet.ip_address(), port: :inet.port_number(), receiver: nil],
          status_listener: [port: :inet.port_number()] | nil,
          receiver: Receiver.t()
        ]

  @default_arg [
    client: [ip: {192, 168, 10, 1}, port: 8889, receiver: nil],
    status_listener: [port: 8890]
  ]

  @spec start(init_arg) :: {:ok, supervisor :: pid, client :: pid, status_listener :: nil | pid}
  @doc """
  Start a new `Tello.Client.Supervisor`.
  """
  def start(init_arg \\ @default_arg) do
    spec = {Tello.Client.Supervisor, init_arg}

    case DynamicSupervisor.start_child(Manager, spec) do
      {:ok, supervisor_pid} ->
        client_pid = Tello.Client.Supervisor.pid_for(supervisor_pid, :client)
        status_listener_pid = Tello.Client.Supervisor.pid_for(supervisor_pid, :status_listener)

        {:ok, supervisor_pid, client_pid, status_listener_pid}

      other ->
        other
    end
  end

  @doc """
  Terminate a `Tello.Client.Supervisor` and it's children.
  """
  @spec terminate(pid) :: :ok | {:error, :not_found}
  def terminate(supervisor_pid) do
    DynamicSupervisor.terminate_child(Manager, supervisor_pid)
  end
end
