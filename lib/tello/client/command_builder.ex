defmodule Tello.Client.CommandBuilder do
  def control(command) when command in [:command, :takeoff, :land, :emergency, :stop] do
    "#{command}"
  end

  def control(:stream, :on) do
    "streamon"
  end

  def control(:stream, :off) do
    "streamoff"
  end

  def control(command, distance)
      when command in [:up, :down, :left, :right, :forward, :back]
      when distance in 20..500 do
    "#{command} #{distance}"
  end

  def control(:flip, direction) when direction in [:left, :right, :forward, :back] do
    direction_flag =
      case direction do
        :left -> "l"
        :right -> "r"
        :forward -> "f"
        :back -> "b"
      end

    "flip #{direction_flag}"
  end

  def control(:rotate, :clockwise, degree) when degree in 1..360 do
    "cw #{degree}"
  end

  def control(:rotate, :counterclockwise, degree) when degree in 1..360 do
    "ccw #{degree}"
  end

  def control(:go, {x, y, z}, speed, mission_pad_id)
      when x in -500..500 and y in -500..500 and z in -500..500 and
             speed in 10..100 do
    "go #{x} #{y} #{z} #{speed} #{mission_pad_id}"
    |> String.trim()
  end

  def control(:curve, {x1, y1, z1}, {x2, y2, z2}, speed, mission_pad_id)
      when x1 in -500..500 and y1 in -500..500 and z1 in -500..500 and
             x2 in -500..500 and y2 in -500..500 and z2 in -500..500 and
             speed in 10..100 do
    "curve #{x1} #{y1} #{z1} #{x2} #{y2} #{z2} #{speed} #{mission_pad_id}"
    |> String.trim()
  end

  def control(:jump, {x, y, z}, speed, yaw, from_mission_pad_id, to_mission_pad_id)
      when x in -500..500 and y in -500..500 and z in -500..500 and
             speed in 10..100 do
    "jump #{x} #{y} #{z} #{speed} #{yaw} #{from_mission_pad_id} #{to_mission_pad_id}"
    |> String.trim()
  end

  def set(:speed, speed) do
    "speed #{speed}"
  end
end
