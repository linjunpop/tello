defmodule Tello do
  @moduledoc """
  An unofficial Ryze Tech Tello SDK

  ## Usage

  ```elixir
  # Start a client
  {:ok, tello_client} = Tello.start_client({192, 168, 10, 1}, 8889)

  # Enable the Tello's SDK mode
  :ok = Tello.Command.enable(tello_client)

  # Control Tello
  :ok = Tello.Command.get_sdk_version(tello_client)
  :ok = Tello.Command.takeoff(tello_client)
  ```

  Please check `Tello.Command` for a full list of commands.

  ## Architecture

  ```mermaid
  flowchart TD
    Application(Tello.Application)
    Command(Tello.Command)
    Tello2(((Ryze Tello)))

    Application --- Manager
    Command --- Client1
    Command --- Client2

    subgraph TelloClient[Client]
      Manager(Tello.Client.Manager)

      Manager -.- Client1
      Manager -.- Client2

      subgraph ClientCluster[Cluster]
        Client1(Tello.Client)
        Client2(Tello.Client)
        More(...)
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

      Memory --- Processor

      Gateway --- Processor
    end

    Client1 --- Gateway
    Client2 --- Tello2
  ```

  ## See also

  - `Tello.Command`
  - `Tello.CyberTello`
  """

  alias Tello.Client.Manager

  @doc """
  Start a new `Tello.Client`.
  """
  @spec start_client(:inet.ip_address(), :inet.port_number()) ::
          :ignore | {:error, any} | {:ok, pid} | {:ok, pid, any}
  def start_client(ip, port) do
    spec = {Tello.Client, {ip, port}}

    DynamicSupervisor.start_child(Manager, spec)
  end

  @doc """
  Terminate a `Tello.Client`.
  """
  @spec terminate_client(pid) :: :ok | {:error, :not_found}
  def terminate_client(tello_client) do
    DynamicSupervisor.terminate_child(Manager, tello_client)
  end
end
