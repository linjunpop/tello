defmodule Tello.StatusListener.Status.Acceleration do
  @moduledoc """
  A sub-struct of `Tello.StatusListener.Status`
  to represent the acceleration information.

  - `x`: Acceleration on x-axis
  - `y`: Acceleration on y-axis
  - `z`: Acceleration on z-axis
  """

  @type t :: %__MODULE__{
          x: float(),
          y: float(),
          z: float()
        }

  defstruct x: 0,
            y: 0,
            z: 0
end
