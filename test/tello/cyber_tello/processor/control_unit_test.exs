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
  end
end
