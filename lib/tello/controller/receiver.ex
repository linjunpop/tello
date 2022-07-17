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

  require Logger

  @type t :: module()
  @callback receive_message(data :: binary()) :: any()

  defmacro __using__(_) do
    quote do
      @behaviour Tello.Controller.Receiver
    end
  end

  @spec receive_message(t(), binary()) :: any
  def receive_message(receiver_module, data) do
    Code.ensure_loaded(receiver_module)

    if function_exported?(receiver_module, :receive_message, 1) do
      receiver_module.receive_message(data)
    else
      Logger.warn(
        "Please implement `receive_message/1` for the custom `Tello.Controller.Receiver` handler."
      )
    end
  end
end
