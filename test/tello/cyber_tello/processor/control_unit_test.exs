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

    test "it should reset Tello" do
      state = %State{takeoff_at: NaiveDateTime.utc_now(), sdk_mode?: true}

      {:ok, new_state} = ControlUnit.process_command(state, "emergency")

      assert false == Map.get(new_state, :sdk_mode?)
      assert nil == Map.get(new_state, :takeoff_at)
    end
  end
end
