defmodule Tello.Client.Supervisor do
  @moduledoc """
  The supervisor for Tello Client.
  """

  use Supervisor

  alias Tello.Client
  alias Tello.Client.StatusListener

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
    client_arg = Keyword.get(init_arg, :client)

    children = [
      {Client, [uid: uid, arg: client_arg]}
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

  @spec pid_for(pid, :client | :status_listener) :: pid | nil
  def pid_for(supervisor, :client) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.find_value(fn
      {Tello.Client, pid, :worker, _arg} ->
        pid

      _other ->
        nil
    end)
  end

  def pid_for(supervisor, :status_listener) do
    supervisor
    |> Supervisor.which_children()
    |> Enum.find_value(fn
      {Tello.Client.StatusListener, pid, :worker, _arg} ->
        pid

      _other ->
        nil
    end)
  end
end
