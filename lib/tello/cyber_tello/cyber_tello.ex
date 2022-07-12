defmodule Tello.CyberTello do
  @moduledoc """
  Tello in Cyberspace 👾

  This module acts as a virtual Tello, receives commands,
  then process and change the state of the virtual Tello.

  Implementation based on the official documentation:
  https://dl-cdn.ryzerobotics.com/downloads/Tello/Tello%20SDK%202.0%20User%20Guide.pdf

  ## Architecture

  ```mermaid
  flowchart TD
    subgraph Client
      Tello.Controller((Tello.Controller))
    end

    subgraph CyberTello
      Gateway(Tello.CyberTello.Gateway)
      Memory[(Tello.CyberTello.Memory)]

      subgraph CPU
        Processor(Tello.CyberTello.Processor)
        ControlUnit(Tello.CyberTello.ControlUnit)

        Processor -.- ControlUnit
      end

      Memory -->|Save State| Processor

      Tello.Controller -->|Send command| Gateway

      Gateway -->|Pass command| Processor
      Gateway -->|Reply| Tello.Controller

      Processor -->|Read State| Memory
    end
  ```

  ## Usage

  ```elixir
  # Start CyberTello
  {:ok, cyber_tello} = Tello.CyberTello.start_link()

  # Get the UDP port which CyberTello receive messages
  {:ok, cyber_tello_port} = Tello.CyberTello.port()

  # Then you can initial a `Tello.Controller` connects to `Tello.CyberTello`
  {:ok, tello_client} = Tello.start_client({{127, 0, 0, 1}, cyber_tello_port})

  # Send commands to `Tello.CyberTello`
  Tello.Controller.command(tello_client)
  ```
  """

  use Supervisor

  alias Tello.CyberTello.{Gateway, Memory}

  @doc """
  Start a CyberTello.

  You can pass an initial state as `initial_args`, please check `Tello.CyberTello.State`.
  """
  def start_link(initial_args \\ %{}) do
    Supervisor.start_link(__MODULE__, initial_args, name: __MODULE__)
  end

  @impl true
  def init(initial_args) do
    children = [
      {Gateway, 0},
      {Memory, [state: initial_args]}
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end

  # Client

  @doc """
  Get the UDP port used by `Tello.CyberTello` to receives commands
  """
  def port() do
    GenServer.call(Gateway, :port)
  end

  @doc false
  def test_command(command) do
    with {:ok, socket} <- :gen_udp.open(0),
         {:ok, port} <- port(),
         :ok <- :gen_udp.connect(socket, {127, 0, 0, 1}, port),
         :ok <- :gen_udp.send(socket, command) do
      :gen_udp.close(socket)
    end
  end
end
