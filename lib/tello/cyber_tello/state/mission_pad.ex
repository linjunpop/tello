defmodule Tello.CyberTello.State.MissionPad do
  @type t :: %__MODULE__{
          id: binary(),
          x: integer(),
          y: integer(),
          z: integer()
        }

  defstruct id: nil,
            x: nil,
            y: nil,
            z: nil
end
