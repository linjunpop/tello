defmodule Tello.Command do
  alias Tello.Client.CommandBuilder

  [:command, :takeoff, :land, :emergency, :stop]
  |> Enum.each(fn command ->
    def unquote(command)(tello_client) do
      GenServer.call(tello_client, {:send, "#{unquote(command)}"})
    end
  end)

  def stream(tello_client, toggle) when toggle in [:on, :off] do
    command = CommandBuilder.control(:stream, toggle)

    GenServer.call(tello_client, {:send, command})
  end

  [:up, :down, :left, :right, :forward, :back]
  |> Enum.each(fn command ->
    def unquote(command)(tello_client, distance) do
      command = CommandBuilder.control(unquote(command), distance)

      GenServer.call(tello_client, {:send, command})
    end
  end)

  def rotate(tello_client, direction, degree)
      when direction in [:clockwise, :counterclockwise] and degree in 1..360 do
    command = CommandBuilder.control(:rotate, direction, degree)

    GenServer.call(tello_client, {:send, command})
  end

  def go(tello_client, {x, y, z}, speed, mission_pad_id \\ "")
      when x in -500..500 and y in -500..500 and z in -500..500 and
             speed in 10..100 and
             mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] do
    command = CommandBuilder.control(:go, {x, y, z}, speed, mission_pad_id)

    GenServer.call(tello_client, {:send, command})
  end

  def jump(tello_client, {x, y, z}, speed, yaw, from_mission_pad_id, to_mission_pad_id)
      when x in -500..500 and y in -500..500 and z in -500..500 and
             speed in 10..100 and
             from_mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] and
             to_mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] do
    command =
      CommandBuilder.control(:jump, {x, y, z}, speed, yaw, from_mission_pad_id, to_mission_pad_id)

    GenServer.call(tello_client, {:send, command})
  end

  def curve(tello_client, {x1, y1, z1}, {x2, y2, z2}, speed, mission_pad_id \\ "")
      when x1 in -500..500 and y1 in -500..500 and z1 in -500..500 and
             x2 in -500..500 and y2 in -500..500 and z2 in -500..500 and
             speed in 10..100 and
             mission_pad_id in [:m1, :m2, :m3, :m4, :m5, :m6, :m7, :m8] do
    command = CommandBuilder.control(:curve, {x1, y1, z1}, {x2, y2, z2}, speed, mission_pad_id)

    GenServer.call(tello_client, {:send, command})
  end
end
