{:ok, _} =
  Tello.CyberTello.start_link([])

{:ok, tello_server_port} =
  Tello.CyberTello.port()

defmodule MyReceiver do
  use Tello.Controller.Receiver

  def receive_message(data) do
    IO.inspect("receives message from Tello: #{data}")
  end
end

defmodule MyStatusHandler do
  use Tello.StatusListener.Handler

  def handle_status(status) do
    IO.inspect("Status: #{inspect(status)}")
  end
end

{:ok, client, controller, status_listener} =
  Tello.start(
    controller: [ip: {127, 0, 0, 1}, port: tello_server_port, receiver: MyReceiver],
    status_listener: [port: 8890, handler: MyStatusHandler]
  )

Tello.Controller.enable(controller)
Tello.Controller.takeoff(controller)
