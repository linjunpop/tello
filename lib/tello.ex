defmodule Tello do
  @moduledoc """
  An unofficial Ryze Tech Tello SDK
  """

  alias Tello.Client.Manager

  def start_client(tello_server = {_ip, _port}) do
    spec = {Tello.Client, tello_server}

    DynamicSupervisor.start_child(Manager, spec)
  end

  def terminate_client(tello_client) do
    DynamicSupervisor.terminate_child(Manager, tello_client)
  end
end
