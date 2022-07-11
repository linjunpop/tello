defmodule Tello.Client.StatusListener.Handler do
  alias Tello.Client.StatusListener.Status

  @type t :: module()
  @callback handle_message(status :: Status.t()) :: none()

  defmacro __using__(_) do
    quote do
      @behaviour Tello.Client.StatusListener.Status
    end
  end
end
