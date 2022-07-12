defmodule Tello.StatusListener.Handler do
  alias Tello.StatusListener.Status

  @type t :: module()
  @callback handle_message(status :: Status.t()) :: none()

  defmacro __using__(_) do
    quote do
      @behaviour Tello.StatusListener.Status
    end
  end
end
