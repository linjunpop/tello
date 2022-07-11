defmodule Tello.Client.StatusListener.ParserTest do
  use ExUnit.Case

  alias Tello.Client.StatusListener.{Parser, Status}

  describe "parse/1" do
    test "it should parse status update message" do
      message =
        "mid:-1;x:-100;y:-100;z:-100;mpry:-1,-1,-1;pitch:0;roll:-1;yaw:21;vgx:0;vgy:0;vgz:0;templ:84;temph:87;tof:10;h:0;bat:100;baro:94.48;time:50;agx:-10.00;agy:16.00;agz:-999.00;\r\n"

      expected = %Status{
        mission_pad: nil,
        speed: %Status.Speed{x: 0, y: 0, z: 0},
        pitch: 0,
        roll: -1,
        yaw: 21,
        temperature: %Status.Temperature{low: 84, high: 87},
        tof_distance: 10,
        height: 0,
        battery: 100,
        barometer: 94.48,
        time: 50,
        acceleration: %Status.Acceleration{x: -10.00, y: 16.00, z: -999.00},
        raw:
          "mid:-1;x:-100;y:-100;z:-100;mpry:-1,-1,-1;pitch:0;roll:-1;yaw:21;vgx:0;vgy:0;vgz:0;templ:84;temph:87;tof:10;h:0;bat:100;baro:94.48;time:50;agx:-10.00;agy:16.00;agz:-999.00;"
      }

      assert expected == Parser.parse(message)
    end
  end
end
