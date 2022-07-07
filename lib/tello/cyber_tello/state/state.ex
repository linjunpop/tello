defmodule Tello.CyberTello.State do
  @moduledoc """
  The CyberTello's state
  """

  alias Tello.CyberTello.State.{MissionPad, Speed, Temperature, Acceleration}

  @type t :: %__MODULE__{
          sdk_mode?: boolean(),
          mission_pad: MissionPad.t(),
          speed: Speed.t(),
          battery: float(),
          takeoff_at: NaiveDateTime.t(),
          wifi_snr: float(),
          sdk_version: binary(),
          serial_number: binary(),
          pitch: integer(),
          roll: integer(),
          yaw: integer(),
          temperature: Temperature.t(),
          tof_distance: integer(),
          height: integer(),
          barometer: integer(),
          acceleration: Acceleration.t()
        }

  defstruct sdk_mode?: false,
            mission_pad: nil,
            battery: nil,
            takeoff_at: nil,
            wifi_snr: nil,
            sdk_version: "2.0",
            serial_number: "virtual-tello",
            pitch: nil,
            roll: nil,
            yaw: nil,
            speed: nil,
            temperature: nil,
            tof_distance: nil,
            height: nil,
            barometer: nil,
            acceleration: nil
end
