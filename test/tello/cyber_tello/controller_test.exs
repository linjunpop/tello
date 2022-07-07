defmodule Tello.CyberTello.ControllerTest do
  use ExUnit.Case
  alias Tello.CyberTello
  alias Tello.CyberTello.{Controller, State}

  describe "Change the state" do
    test "it should set SDK mode" do
      state = %State{sdk_mode?: false}
      {:ok, _tello} = CyberTello.start_link(state)
      {:ok, _new_state} = Controller.handle_command("command")

      assert true == CyberTello.get(:sdk_mode?)
    end

    test "it should launch Tello" do
      state = %State{takeoff_at: nil}
      {:ok, _tello} = CyberTello.start_link(state)
      {:ok, _new_state} = Controller.handle_command("takeoff")

      takeoff_at = CyberTello.get(:takeoff_at)

      diff =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.diff(takeoff_at, :millisecond)

      assert diff <= 100
    end

    test "it should land Tello" do
      state = %State{takeoff_at: NaiveDateTime.utc_now()}
      {:ok, _tello} = CyberTello.start_link(state)
      {:ok, _new_state} = Controller.handle_command("land")

      assert nil == CyberTello.get(:takeoff_at)
    end
  end
end
