{:ok, _} = Tello.CyberTello.start_link([])
|> IO.inspect()

{:ok, tello_server_port} = Tello.CyberTello.port()
|> IO.inspect()

defmodule Receiver do
  use Tello.Client.Receiver

  def receive_message(data) do
    IO.inspect("receives message from Tello: #{data}")
  end
end

{:ok, supervisor, client, status_listener} =
   Tello.start(
      client: [ip: {127, 0, 0, 1}, port: tello_server_port, receiver: Receiver]
    )
|> IO.inspect()

Tello.Command.enable(client)
Tello.Command.takeoff(client)
