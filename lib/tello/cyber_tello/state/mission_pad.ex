defmodule Tello.CyberTello.State.MissionPad do
  @moduledoc """
  A sub-struct of `Tello.CyberTello.State` to represent the detected Mission Pad.

  - `id` - Mission Pad ID
  - `x` - The x coordinate detected on the Mission Pad
  - `y` - The y coordinate detected on the Mission Pad
  - `z` - The z coordinate detected on the Mission Pad
  """

  @type t :: %__MODULE__{
          id: binary(),
          x: integer(),
          y: integer(),
          z: integer()
        }

  defstruct id: -1,
            x: 0,
            y: 0,
            z: 0
end
