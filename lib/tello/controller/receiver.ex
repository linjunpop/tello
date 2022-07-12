defmodule Tello.Controller.Receiver do
  @moduledoc """
  The behaviour to define a custom receiver for `Tello.Controller`.

  ```
  # Define custom receiver
  defmodule MyReceiver do
    use Tello.Controller.Receiver

    def receive_message(data) do
      # Do something with the data
    end
  end

  # Set customer receiver while starting the client.
  {:ok, client, controller, status_listener} =
    Tello.start(
        controller: [ip: {127, 0, 0, 1}, port: tello_server_port, receiver: MyReceiver]
      )
  ```
  """

  @type t :: module()
  @callback receive_message(data :: binary()) :: none()

  defmacro __using__(_) do
    quote do
      @behaviour Tello.Controller.Receiver
    end
  end
end
