defmodule Tello.Client do
  @moduledoc """
  The Tello Client as a supervisor.
  """

  use Supervisor

  alias Tello.Controller
  alias Tello.StatusListener

  def start_link([], init_arg) do
    uid =
      :erlang.make_ref()
      |> :erlang.ref_to_list()
      |> List.to_string()

    Supervisor.start_link(__MODULE__, [uid: uid, init_arg: init_arg],
      name: :"#{__MODULE__}.#{uid}"
    )
  end

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

  @spec pid_for(pid, :controller | :status_listener) :: pid | nil
  def pid_for(supervisor, :controller) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.find_value(fn
      {Controller, pid, :worker, _arg} ->
        pid

      _other ->
        nil
    end)
  end

  def pid_for(supervisor, :status_listener) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.find_value(fn
      {Tello.StatusListener, pid, :worker, _arg} ->
        pid

      _other ->
        nil
    end)
  end
end
