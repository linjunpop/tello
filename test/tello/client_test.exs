defmodule Tello.ClientTest do
  use ExUnit.Case
  alias Tello.Client

  doctest Client

  setup do
    {:ok, tello_server} = Tello.VirtualTello.start_link([])
    {:ok, tello_server_port} = Tello.VirtualTello.port()
    {:ok, client} = Client.start_link({{127, 0, 0, 1}, tello_server_port})

    %{tello_server: tello_server, client: client}
  end

  describe "#set" do
    test "It should send the set message to udp server" do
      :ok = Client.set("speed 3")
    end
  end
end
