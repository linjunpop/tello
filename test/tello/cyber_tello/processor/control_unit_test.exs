defmodule Tello.CyberTello.Processor.ControlUnitTest do
  use ExUnit.Case
  alias Tello.CyberTello.State
  alias Tello.CyberTello.Processor.ControlUnit

  describe "command" do
    test "it should set SDK mode" do
      state = %State{sdk_mode?: false}

      {:ok, new_state} = ControlUnit.process_command(state, "command")

      assert true == Map.get(new_state, :sdk_mode?)
    end
  end

  describe "takeoff" do
    test "it should launch Tello" do
      state = %State{takeoff_at: nil}

      {:ok, new_state} = ControlUnit.process_command(state, "takeoff")

      takeoff_at = Map.get(new_state, :takeoff_at)

      diff =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.diff(takeoff_at, :millisecond)

      assert diff <= 100
    end
  end

  describe "land" do
    test "it should land Tello" do
      state = %State{takeoff_at: NaiveDateTime.utc_now()}

      {:ok, new_state} = ControlUnit.process_command(state, "land")

      assert nil == Map.get(new_state, :takeoff_at)
    end
  end

  describe "emergency" do
    test "it should halt Tello" do
      state = %State{takeoff_at: NaiveDateTime.utc_now(), sdk_mode?: true}

      {:ok, new_state} = ControlUnit.process_command(state, "emergency")

      assert false == Map.get(new_state, :sdk_mode?)
      assert nil == Map.get(new_state, :takeoff_at)
    end
  end

  describe "stop" do
    test "it should stop Tello" do
      state = %State{
        speed: %State.Speed{x: 0, y: 3, z: 9},
        acceleration: %State.Acceleration{x: 12, y: 22, z: 9}
      }

      {:ok, new_state} = ControlUnit.process_command(state, "stop")

      assert %State.Speed{x: 0, y: 0, z: 0} == Map.get(new_state, :speed)
      assert %State.Acceleration{x: 0, y: 0, z: 0} == Map.get(new_state, :acceleration)
    end
  end

  describe "stream" do
    test "it should turn on the video stream" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "streamon")

      assert :on == Map.get(new_state, :video_stream)
    end

    test "it should turn off the video stream" do
      state = %State{video_stream: :on}

      {:ok, new_state} = ControlUnit.process_command(state, "streamoff")

      assert :off == Map.get(new_state, :video_stream)
    end
  end

  describe "up" do
    test "it should fly up from ground" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "up 30")

      assert 30 == Map.get(new_state, :height)
    end

    test "it should fly up high" do
      state = %State{height: 42}

      {:ok, new_state} = ControlUnit.process_command(state, "up 30")

      assert 72 == Map.get(new_state, :height)
    end
  end

  describe "down" do
    test "it should fly down" do
      state = %State{height: 32}
      {:ok, new_state} = ControlUnit.process_command(state, "down 30")

      assert 2 == Map.get(new_state, :height)
    end

    test "it should only fly down to zero" do
      state = %State{height: 32}
      {:ok, new_state} = ControlUnit.process_command(state, "down 43")

      assert 0 == Map.get(new_state, :height)
    end
  end

  describe "left & right" do
    test "it should fly left" do
      state = %State{}
      {:ok, _new_state} = ControlUnit.process_command(state, "left 30")

      # TODO: noop now as the state don't have a coordinate.
    end

    test "it should fly right" do
      state = %State{}
      {:ok, _new_state} = ControlUnit.process_command(state, "right 43")

      # TODO: noop now as the state don't have a coordinate.
    end
  end

  describe "forward & back" do
    test "it should fly forward" do
      state = %State{}
      {:ok, _new_state} = ControlUnit.process_command(state, "forward 30")

      # TODO: noop now as the state don't have a coordinate.
    end

    test "it should fly back" do
      state = %State{}
      {:ok, _new_state} = ControlUnit.process_command(state, "back 43")

      # TODO: noop now as the state don't have a coordinate.
    end
  end

  describe "flip" do
    test "it should flip" do
      state = %State{}

      {:ok, _new_state} = ControlUnit.process_command(state, "flip l")
    end
  end

  describe "rotate" do
    test "it should rotate clockwise" do
      state = %State{yaw: 0}

      {:ok, new_state} = ControlUnit.process_command(state, "cw 30")

      assert 30 == new_state.yaw
    end

    test "it should rotate clockwise more than 360 degree" do
      state = %State{yaw: 20}

      {:ok, new_state} = ControlUnit.process_command(state, "cw 350")

      assert 10 == new_state.yaw
    end

    test "it should rotate counterclockwise" do
      state = %State{yaw: 0}

      {:ok, new_state} = ControlUnit.process_command(state, "ccw 30")

      assert 330 == new_state.yaw
    end

    test "it should rotate counterclockwise more than 360 degree" do
      state = %State{yaw: 20}

      {:ok, new_state} = ControlUnit.process_command(state, "ccw 350")

      assert 30 == new_state.yaw
    end
  end

  describe "go" do
    test "it should go to coordinate" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "go 0 300 0 10")

      # TODO: noop
    end

    test "it should go to coordinate on mission pad" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "go 0 300 0 10 m1")

      # TODO: noop
    end
  end

  describe "curve" do
    test "it should fly a curve" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "curve 0 300 0 10 -200 -50 10")

      # TODO: noop
    end

    test "it should fly a curve on mission pad" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "curve 0 300 0 10 -200 -50 10 m1")

      # TODO: noop
    end
  end

  describe "jump" do
    test "it should jump" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "jump 0 300 0 10 15 m1 m3")

      # TODO: noop
    end
  end

  describe "speed" do
    test "it should set the speed" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "speed 33")

      assert 33 == new_state.speed
    end
  end

  describe "mission pad" do
    test "it should turn on mission pad detection" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "mon")

      assert new_state.mission_pad
      assert -1 == new_state.mission_pad.id
    end

    test "it should turn off mission pad detection" do
      state = %State{}

      {:ok, new_state} = ControlUnit.process_command(state, "moff")

      assert nil == new_state.mission_pad
    end

    test "it should set mission pad detection mode to `downward`" do
      state = %State{mission_pad: %State.MissionPad{}}

      {:ok, new_state} = ControlUnit.process_command(state, "mdirection 0")

      assert :downward == new_state.mission_pad.detection_mode
    end

    test "it should set mission pad detection mode to `forward`" do
      state = %State{mission_pad: %State.MissionPad{}}

      {:ok, new_state} = ControlUnit.process_command(state, "mdirection 1")

      assert :forward == new_state.mission_pad.detection_mode
    end

    test "it should set mission pad detection mode to both `downward` and `forward`" do
      state = %State{mission_pad: %State.MissionPad{}}

      {:ok, new_state} = ControlUnit.process_command(state, "mdirection 2")

      assert :both == new_state.mission_pad.detection_mode
    end

    test "it should error when mission pad detection is off and trying to change the detection mode" do
      state = %State{mission_pad: nil}

      {:error, message} = ControlUnit.process_command(state, "mdirection 2")

      assert "Please enable Mission Pad detection first" == message
    end
  end

  describe "remote controller" do
    test "it should set remote controller's controls" do
      state = %State{mission_pad: %State.MissionPad{}}

      command = "rc -90 10 0 90"

      {:ok, new_state} = ControlUnit.process_command(state, command)

      # noop
    end
  end

  describe "wifi" do
    test "it should set Wi-Fi SSID and password" do
      state = %State{}

      command = "wifi tello-2 664455"

      {:ok, new_state} = ControlUnit.process_command(state, command)

      assert :access_point == new_state.wifi.mode
      assert "tello-2" == new_state.wifi.ssid
      assert "664455" == new_state.wifi.password
    end

    test "it should set Wi-Fi to Client mode and set SSID and password" do
      state = %State{}

      command = "ap myrouter 7755"

      {:ok, new_state} = ControlUnit.process_command(state, command)

      assert :client == new_state.wifi.mode
      assert "myrouter" == new_state.wifi.ssid
      assert "7755" == new_state.wifi.password
    end
  end

  describe "fetch" do
    test "it should read speed" do
      state = %State{speed: %State.Speed{x: 50, y: 0, z: 0}}

      {:ok, speed} = ControlUnit.fetch(state, "speed?")

      assert 50 == speed
    end

    test "it should read battery" do
      state = %State{battery: 0.5}

      {:ok, battery} = ControlUnit.fetch(state, "battery?")

      assert 0.5 == battery
    end

    test "it should read time" do
      takeoff_time =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.add(60, :second)

      state = %State{takeoff_at: takeoff_time}

      {:ok, time} = ControlUnit.fetch(state, "time?")

      assert time > 50000
    end

    test "it should read wifi SNR" do
      state = %State{wifi: %State.Wifi{snr: 0.7}}

      {:ok, wifi_snr} = ControlUnit.fetch(state, "wifi?")

      assert 0.7 == wifi_snr
    end

    test "it should read SDK version" do
      state = %State{sdk_version: "2.0"}

      {:ok, sdk_version} = ControlUnit.fetch(state, "sdk?")

      assert "2.0" == sdk_version
    end

    test "it should read serial number" do
      state = %State{serial_number: "xxxxx-yyyyy-uuuuu"}

      {:ok, serial_number} = ControlUnit.fetch(state, "sn?")

      assert "xxxxx-yyyyy-uuuuu" == serial_number
    end
  end
end
