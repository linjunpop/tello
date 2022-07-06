defmodule Tello.CyberTello.State.Acceleration do
  @type t :: %__MODULE__{
          x: integer(),
          y: integer(),
          z: integer()
        }

  defstruct x: nil,
            y: nil,
            z: nil
end
