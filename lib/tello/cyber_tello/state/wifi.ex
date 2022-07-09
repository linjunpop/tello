defmodule Tello.CyberTello.State.Wifi do
  @moduledoc """
  A sub-struct of `Tello.CyberTello.State` to represent Wi-Fi status.

  - `low`: Lowest temperature of the board
  - `high`: Lowest temperature of the board
  """

  @type t :: %__MODULE__{
          mode: :client | :access_point,
          ssid: String.t(),
          password: String.t(),
          snr: float()
        }

  defstruct mode: :access_point,
            ssid: "Tello-CyberTello",
            password: "12345678",
            snr: 0.8
end
