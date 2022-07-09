{:ok, _} = Tello.CyberTello.start_link([])
|> IO.inspect()

{:ok, tello_server_port} = Tello.CyberTello.port()
|> IO.inspect()

{:ok, supervisor, client, status_listener} = Tello.start(client: [ip: {127, 0, 0, 1}, port: tello_server_port])
|> IO.inspect()

Tello.Command.enable(client)
Tello.Command.takeoff(client)
