defmodule Tello.CyberTello.State.Acceleration do
  @moduledoc """
  A sub-struct of `Tello.CyberTello.State` to represent the acceleration information.

  - `x`: Acceleration on x-axis
  - `y`: Acceleration on y-axis
  - `z`: Acceleration on z-axis
  """

  @type t :: %__MODULE__{
          x: float(),
          y: float(),
          z: float()
        }

  defstruct x: nil,
            y: nil,
            z: nil
end
