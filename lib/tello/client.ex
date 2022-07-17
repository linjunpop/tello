defmodule Tello.Client do
  @moduledoc """
  The Tello Client as a supervisor.
  """

  use Supervisor

  alias Tello.Controller
  alias Tello.StatusListener

  @type init_arg :: [
          controller: Controller.init_arg(),
          status_listener: StatusListener.init_arg()
        ]

  @doc """
  Start a client
  """
  @spec start_link([], init_arg()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link([], init_arg) do
    uid = System.unique_integer()

    Supervisor.start_link(__MODULE__, [uid: uid, init_arg: init_arg],
      name: :"#{__MODULE__}.#{uid}"
    )
  end

  @doc false
  def init(uid: uid, init_arg: init_arg) do
    controller_arg = Keyword.get(init_arg, :controller)

    children = [
      {Controller, [uid: uid, arg: controller_arg]}
    ]

    children =
      case Keyword.get(init_arg, :status_listener) do
        nil ->
          children

        status_listener_arg ->
          children ++ [{StatusListener, [uid: uid, arg: status_listener_arg]}]
      end

    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc false
  @spec pid_for(pid, Controller.t() | StatusListener.t()) :: pid | nil
  def pid_for(client, module) do
    client
    |> Supervisor.which_children()
    |> Enum.find_value(fn
      {^module, pid, :worker, _arg} ->
        pid

      _other ->
        nil
    end)
  end
end
