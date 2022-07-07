defmodule Tello.CyberTello.Processor.ControlUnitTest do
  use ExUnit.Case
  alias Tello.CyberTello.State
  alias Tello.CyberTello.Processor.ControlUnit

  describe "Change the state" do
    test "it should set SDK mode" do
      state = %State{sdk_mode?: false}

      {:ok, new_state} = ControlUnit.process_command(state, "command")

      assert true == Map.get(new_state, :sdk_mode?)
    end

    test "it should launch Tello" do
      state = %State{takeoff_at: nil}

      {:ok, new_state} = ControlUnit.process_command(state, "takeoff")

      takeoff_at = Map.get(new_state, :takeoff_at)

      diff =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.diff(takeoff_at, :millisecond)

      assert diff <= 100
    end

    test "it should land Tello" do
      state = %State{takeoff_at: NaiveDateTime.utc_now()}

      {:ok, new_state} = ControlUnit.process_command(state, "land")

      assert nil == Map.get(new_state, :takeoff_at)
    end

    test "it should halt Tello" do
      state = %State{takeoff_at: NaiveDateTime.utc_now(), sdk_mode?: true}

      {:ok, new_state} = ControlUnit.process_command(state, "emergency")

      assert false == Map.get(new_state, :sdk_mode?)
      assert nil == Map.get(new_state, :takeoff_at)
    end

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
end
