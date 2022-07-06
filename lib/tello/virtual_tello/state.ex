defmodule Tello.VirtualTello.State do
  @type t :: %__MODULE__{
          sdk_mode?: boolean()
        }

  defstruct sdk_mode?: false
end
