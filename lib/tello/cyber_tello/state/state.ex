defmodule Tello.CyberTello.State do
  @moduledoc """
  The CyberTello's state

  ## See also
  - `Tello.CyberTello.State.Acceleration`
  - `Tello.CyberTello.State.MissionPad`
  - `Tello.CyberTello.State.Speed`
  - `Tello.CyberTello.State.Temperature`
  """

  alias Tello.CyberTello.State.{MissionPad, Speed, Temperature, Acceleration, Wifi}

  @type t :: %__MODULE__{
          sdk_mode?: boolean(),
          mission_pad: MissionPad.t() | nil,
          speed: Speed.t(),
          battery: float(),
          takeoff_at: NaiveDateTime.t(),
          wifi: Wifi.t(),
          sdk_version: binary(),
          serial_number: binary(),
          pitch: integer(),
          roll: integer(),
          yaw: integer(),
          temperature: Temperature.t(),
          tof_distance: integer(),
          height: integer(),
          barometer: integer(),
          acceleration: Acceleration.t(),
          video_stream: :on | :off
        }

  defstruct sdk_mode?: false,
            mission_pad: nil,
            battery: 0.9,
            takeoff_at: nil,
            wifi: %Wifi{},
            sdk_version: "2.0",
            serial_number: "virtual-tello",
            pitch: 0,
            roll: 0,
            yaw: 0,
            speed: %Speed{x: 0, y: 0, z: 0},
            temperature: %Temperature{low: 13, high: 15},
            tof_distance: 10,
            height: 0,
            barometer: 4_955_163,
            acceleration: %Acceleration{x: 0, y: 0, z: 0},
            video_stream: :off
end
