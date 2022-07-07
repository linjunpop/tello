defmodule Tello.CyberTello.ControllerTest do
  use ExUnit.Case
  alias Tello.CyberTello
  alias Tello.CyberTello.Controller

  setup_all do
    {:ok, tello} = CyberTello.start_link([])

    {:ok, cyber_tello: tello}
  end

  describe "Change the state" do
    test "it should set SDK mode" do
      {:ok, _new_state} = Controller.handle_command("command")

      assert true == CyberTello.get(:sdk_mode?)
    end

    test "it should launch Tello" do
      {:ok, _new_state} = Controller.handle_command("takeoff")

      takeoff_at = CyberTello.get(:takeoff_at)

      diff =
        NaiveDateTime.utc_now()
        |> NaiveDateTime.diff(takeoff_at, :millisecond)

      assert diff <= 100
    end
  end
end
