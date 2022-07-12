defmodule Tello.StatusListener.Status do
  @moduledoc """
  Tello's status update message.

  ## See also
  - `Tello.StatusListener.Status.Acceleration`
  - `Tello.StatusListener.Status.MissionPad`
  - `Tello.StatusListener.Status.Speed`
  - `Tello.StatusListener.Status.Temperature`
  """

  alias Tello.StatusListener.Status.{MissionPad, Speed, Temperature, Acceleration}

  @type t :: %__MODULE__{
          mission_pad: MissionPad.t() | nil,
          speed: Speed.t(),
          battery: integer(),
          time: integer(),
          pitch: integer(),
          roll: integer(),
          yaw: integer(),
          temperature: Temperature.t(),
          tof_distance: integer(),
          height: integer(),
          barometer: float(),
          acceleration: Acceleration.t(),
          _raw: String.t()
        }

  defstruct mission_pad: nil,
            battery: nil,
            time: nil,
            pitch: 0,
            roll: 0,
            yaw: 0,
            speed: %Speed{},
            temperature: %Temperature{},
            tof_distance: nil,
            height: 0,
            barometer: nil,
            acceleration: %Acceleration{},
            _raw: ""
end
