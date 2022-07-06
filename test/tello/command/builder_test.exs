defmodule Tello.Command.BuilderTest do
  use ExUnit.Case
  alias Tello.Client.Command.Builder

  describe "#control" do
    test "It should build command `command`" do
      assert "command" == Builder.control(:command)
    end

    test "It should build command `takeoff`" do
      assert "takeoff" == Builder.control(:takeoff)
    end

    test "It should build command `land`" do
      assert "land" == Builder.control(:land)
    end

    test "It should build command `stream`" do
      assert "streamon" == Builder.control(:stream, :on)
      assert "streamoff" == Builder.control(:stream, :off)
    end

    test "It should build command `emergency`" do
      assert "emergency" == Builder.control(:emergency)
    end

    test "It should build command `up`" do
      assert "up 100" == Builder.control(:up, 100)
      assert "up 200" == Builder.control(:up, 200)
      assert "up 28" == Builder.control(:up, 28)
    end

    test "It should build command `down`" do
      assert "down 100" == Builder.control(:down, 100)
    end

    test "It should build command `left`" do
      assert "left 100" == Builder.control(:left, 100)
    end

    test "It should build command `right`" do
      assert "right 100" == Builder.control(:right, 100)
    end

    test "It should build command `forward`" do
      assert "forward 100" == Builder.control(:forward, 100)
    end

    test "It should build command `back`" do
      assert "back 100" == Builder.control(:back, 100)
    end

    test "It should build command `rotate`" do
      assert "cw 130" == Builder.control(:rotate, :clockwise, 130)
      assert "ccw 130" == Builder.control(:rotate, :counterclockwise, 130)
    end

    test "It should build command `flip`" do
      assert "flip l" == Builder.control(:flip, :left)
      assert "flip r" == Builder.control(:flip, :right)
      assert "flip f" == Builder.control(:flip, :forward)
      assert "flip b" == Builder.control(:flip, :back)
    end

    test "It should build command `go`" do
      assert "go 10 20 30 23" == Builder.control(:go, {10, 20, 30}, 23, nil)
      assert "go 10 20 30 23" == Builder.control(:go, {10, 20, 30}, 23, "")
      assert "go 10 20 30 23 m2" == Builder.control(:go, {10, 20, 30}, 23, :m2)
    end

    test "It should build command `curve`" do
      assert "curve 10 20 30 20 10 40 23" ==
               Builder.control(:curve, {10, 20, 30}, {20, 10, 40}, 23, nil)

      assert "curve 10 20 30 20 10 40 23" ==
               Builder.control(:curve, {10, 20, 30}, {20, 10, 40}, 23, "")

      assert "curve 10 20 30 20 10 40 23 m2" ==
               Builder.control(:curve, {10, 20, 30}, {20, 10, 40}, 23, :m2)
    end

    test "It should build command `jump`" do
      assert "jump 10 30 21 40 51 m1 m3" ==
               Builder.control(:jump, {10, 30, 21}, 40, 51, :m1, :m3)
    end
  end

  describe "#set" do
    test "It should build command `speed`" do
      assert "speed 30" ==
               Builder.set(:speed, 30)
    end

    test "It should build command `rc`" do
      assert "rc left 100 forward 30 up 10 yaw -10" ==
               Builder.set(:rc, {:left, 100}, {:forward, 30}, {:up, 10}, -10)
    end

    test "It should build command `wifi`" do
      assert "wifi my-tello 123123" ==
               Builder.set(:wifi, "my-tello", "123123")
    end

    test "It should build command `mission_pad_detection`" do
      assert "mon" == Builder.set(:mission_pad_detection, :on)
      assert "moff" == Builder.set(:mission_pad_detection, :off)
    end

    test "It should build command `mission_pad_detection_mode`" do
      assert "mdirection 0" == Builder.set(:mission_pad_detection_mode, :downward)
      assert "mdirection 1" == Builder.set(:mission_pad_detection_mode, :forward)
      assert "mdirection 2" == Builder.set(:mission_pad_detection_mode, :both)
    end

    test "It should build command `ap`" do
      assert "ap my-router 123123" ==
               Builder.set(:ap, "my-router", "123123")
    end
  end

  describe "#read" do
    test "It should build the command `speed`" do
      assert "speed?" == Builder.read(:speed)
    end

    test "It should build the command `battery`" do
      assert "battery?" == Builder.read(:battery)
    end

    test "It should build the command `flight_time`" do
      assert "time?" == Builder.read(:flight_time)
    end

    test "It should build the command `wifi_snr`" do
      assert "wifi?" == Builder.read(:wifi_snr)
    end

    test "It should build the command `sdk_version`" do
      assert "sdk?" == Builder.read(:sdk_version)
    end

    test "It should build the command `serial_number`" do
      assert "sn?" == Builder.read(:serial_number)
    end
  end
end
