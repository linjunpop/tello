defmodule Tello.CommandBuilderTest do
  use ExUnit.Case
  alias Tello.Client.CommandBuilder

  describe "#control" do
    test "It should build command `command`" do
      assert "command" == CommandBuilder.control(:command)
    end

    test "It should build command `takeoff`" do
      assert "takeoff" == CommandBuilder.control(:takeoff)
    end

    test "It should build command `land`" do
      assert "land" == CommandBuilder.control(:land)
    end

    test "It should build command `stream`" do
      assert "streamon" == CommandBuilder.control(:stream, :on)
      assert "streamoff" == CommandBuilder.control(:stream, :off)
    end

    test "It should build command `emergency`" do
      assert "emergency" == CommandBuilder.control(:emergency)
    end

    test "It should build command `up`" do
      assert "up 100" == CommandBuilder.control(:up, 100)
      assert "up 200" == CommandBuilder.control(:up, 200)
      assert "up 28" == CommandBuilder.control(:up, 28)
    end

    test "It should build command `down`" do
      assert "down 100" == CommandBuilder.control(:down, 100)
    end

    test "It should build command `left`" do
      assert "left 100" == CommandBuilder.control(:left, 100)
    end

    test "It should build command `right`" do
      assert "right 100" == CommandBuilder.control(:right, 100)
    end

    test "It should build command `forward`" do
      assert "forward 100" == CommandBuilder.control(:forward, 100)
    end

    test "It should build command `back`" do
      assert "back 100" == CommandBuilder.control(:back, 100)
    end

    test "It should build command `rotate`" do
      assert "cw 130" == CommandBuilder.control(:rotate, :clockwise, 130)
      assert "ccw 130" == CommandBuilder.control(:rotate, :counterclockwise, 130)
    end

    test "It should build command `flip`" do
      assert "flip l" == CommandBuilder.control(:flip, :left)
      assert "flip r" == CommandBuilder.control(:flip, :right)
      assert "flip f" == CommandBuilder.control(:flip, :forward)
      assert "flip b" == CommandBuilder.control(:flip, :back)
    end

    test "It should build command `go`" do
      assert "go 10 20 30 23" == CommandBuilder.control(:go, {10, 20, 30}, 23, nil)
      assert "go 10 20 30 23" == CommandBuilder.control(:go, {10, 20, 30}, 23, "")
      assert "go 10 20 30 23 m2" == CommandBuilder.control(:go, {10, 20, 30}, 23, :m2)
    end

    test "It should build command `curve`" do
      assert "curve 10 20 30 20 10 40 23" ==
               CommandBuilder.control(:curve, {10, 20, 30}, {20, 10, 40}, 23, nil)

      assert "curve 10 20 30 20 10 40 23" ==
               CommandBuilder.control(:curve, {10, 20, 30}, {20, 10, 40}, 23, "")

      assert "curve 10 20 30 20 10 40 23 m2" ==
               CommandBuilder.control(:curve, {10, 20, 30}, {20, 10, 40}, 23, :m2)
    end

    test "It should build command `jump`" do
      assert "jump 10 30 21 40 51 m1 m3" ==
               CommandBuilder.control(:jump, {10, 30, 21}, 40, 51, :m1, :m3)
    end
  end

  describe "#set" do
    test "It should build command `speed`" do
      assert "speed 30" ==
               CommandBuilder.set(:speed, 30)
    end

    test "It should build command `rc`" do
      assert "rc left 100 forward 30 up 10 yaw -10" ==
               CommandBuilder.set(:rc, {:left, 100}, {:forward, 30}, {:up, 10}, -10)
    end

    test "It should build command `wifi`" do
      assert "wifi my-tello 123123" ==
               CommandBuilder.set(:wifi, "my-tello", "123123")
    end

    test "It should build command `mission_pad_detection`" do
      assert "mon" == CommandBuilder.set(:mission_pad_detection, :on)
      assert "moff" == CommandBuilder.set(:mission_pad_detection, :off)
    end

    test "It should build command `mission_pad_detection_mode`" do
      assert "mdirection 0" == CommandBuilder.set(:mission_pad_detection_mode, :downward)
      assert "mdirection 1" == CommandBuilder.set(:mission_pad_detection_mode, :forward)
      assert "mdirection 2" == CommandBuilder.set(:mission_pad_detection_mode, :both)
    end
  end
end
