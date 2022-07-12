defmodule Tello.Controller.Receiver do
  @type t :: module()
  @callback receive_message(data :: binary()) :: none()

  defmacro __using__(_) do
    quote do
      @behaviour Tello.Controller.Receiver
    end
  end
end
