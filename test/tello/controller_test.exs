defmodule Tello.ControllerTest do
  use ExUnit.Case
  alias Tello.Controller

  doctest Controller

  setup do
    {:ok, tello_server} = Tello.VirtualTello.start_link()
    {:ok, tell_server_port} = Tello.VirtualTello.port(tello_server)
    {:ok, controller} = Controller.start_link({{127, 0, 0, 1}, tell_server_port})

    %{tello_server: tello_server, controller: controller}
  end

  test "greets the world", %{controller: controller} do
    :ok = Controller.send_command(controller, "command")
  end
end
