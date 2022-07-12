defmodule Tello.StatusListener.Status.MissionPad do
  @moduledoc """
  A sub-struct of `Tello.StatusListener.Status`
  to represent the detected Mission Pad.

  - `id` - Mission Pad ID
  - `x` - The x coordinate detected on the Mission Pad
  - `y` - The y coordinate detected on the Mission Pad
  - `z` - The z coordinate detected on the Mission Pad
  - `pitch` - The pitch based on the Mission Pad
  - `roll` - The roll based on the Mission Pad
  - `yaw` - The yaw based on the Mission Pad
  """

  @type t :: %__MODULE__{
          id: binary(),
          x: integer(),
          y: integer(),
          z: integer(),
          pitch: integer(),
          roll: integer(),
          yaw: integer()
        }

  defstruct id: -1,
            x: 0,
            y: 0,
            z: 0,
            pitch: 0,
            roll: 0,
            yaw: 0
end
