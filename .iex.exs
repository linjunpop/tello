{:ok, _} = Tello.VirtualTello.start_link([])
|> IO.inspect()

{:ok, tello_server_port} = Tello.VirtualTello.port()
|> IO.inspect()

{:ok, tello_client} = Tello.Client.start_link({{127, 0, 0, 1}, tello_server_port})
|> IO.inspect()

Tello.Command.command(tello_client)
