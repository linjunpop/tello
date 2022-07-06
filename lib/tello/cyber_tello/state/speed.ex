defmodule Tello.CyberTello.State.Speed do
  @type t :: %__MODULE__{
          x: integer(),
          y: integer(),
          z: integer()
        }

  defstruct x: nil,
            y: nil,
            z: nil
end
