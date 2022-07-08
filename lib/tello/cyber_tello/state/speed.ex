defmodule Tello.CyberTello.State.Speed do
  @moduledoc """
  A sub-struct of `Tello.CyberTello.State` to represent the speed information.

  - `x`: Speed on x-axis
  - `y`: Speed on y-axis
  - `z`: Speed on z-axis
  """
  @type t :: %__MODULE__{
          x: integer(),
          y: integer(),
          z: integer()
        }

  defstruct x: nil,
            y: nil,
            z: nil
end
