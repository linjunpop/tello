{:ok, _} = Tello.CyberTello.start_link([])
|> IO.inspect()

{:ok, tello_server_port} = Tello.CyberTello.port()
|> IO.inspect()

defmodule Receiver do
  use Tello.Controller.Receiver

  def receive_message(data) do
    IO.inspect("receives message from Tello: #{data}")
  end
end

{:ok, client, controller, status_listener} =
   Tello.start(
      controller: [ip: {127, 0, 0, 1}, port: tello_server_port, receiver: Receiver]
    )
|> IO.inspect()

Tello.Controller.enable(controller)
Tello.Controller.takeoff(controller)
