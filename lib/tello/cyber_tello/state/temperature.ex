defmodule Tello.CyberTello.State.Temperature do
  @type t :: %__MODULE__{
          low: integer(),
          high: integer()
        }

  defstruct low: nil,
            high: nil
end
