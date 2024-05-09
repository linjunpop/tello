defmodule Tello.StatusListener.Handler do
  @moduledoc """
  The behaviour to define a custom handler for `Tello.StatusListener`.

  ```
  # Define custom handler
  defmodule MyHandler do
    use Tello.StatusListener.Handler

    def handle_status(%Tello.StatusListener.Status{} = status) do
      # Do something with the data
    end
  end

  # Set customer receiver while starting the client.
  {:ok, client, controller, status_listener} =
    Tello.start(
        controller: [ip: {127, 0, 0, 1}, port: tello_server_port],
        status_listener: [port: 8890, handler: MyHandler]
      )
  ```
  """
  require Logger

  alias Tello.StatusListener.Status

  @type t :: module()
  @callback handle_status(status :: Status.t()) :: none()

  defmacro __using__(_) do
    quote do
      @behaviour Tello.StatusListener.Handler
    end
  end

  @spec handle_data(t(), Status.t()) :: any
  def handle_data(handler_module, status) do
    Code.ensure_loaded(handler_module)

    if function_exported?(handler_module, :handle_status, 1) do
      handler_module.handle_status(status)
    else
      Logger.warning(
        "Please implement `handle_status/1` for the custom `Tello.StatusListener.Handler` handler."
      )
    end
  end
end
