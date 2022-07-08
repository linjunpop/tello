defmodule Tello.CyberTello.State.Temperature do
  @moduledoc """
  A sub-struct of `Tello.CyberTello.State` to represent the temperature of board.

  - `low`: Lowest temperature of the board
  - `high`: Lowest temperature of the board
  """

  @type t :: %__MODULE__{
          low: integer(),
          high: integer()
        }

  defstruct low: nil,
            high: nil
end
