defmodule Tello.Client.StatusListener.Status.Speed do
  @moduledoc """
  A sub-struct of `Tello.Client.StatusListener.Status`
  to represent the speed information.

  - `x`: Speed on x-axis
  - `y`: Speed on y-axis
  - `z`: Speed on z-axis
  """
  @type t :: %__MODULE__{
          x: integer(),
          y: integer(),
          z: integer()
        }

  defstruct x: 0,
            y: 0,
            z: 0
end
