defmodule Tello.StatusListener.Parser do
  @moduledoc """
  Parser to parse the status information returned from server
  """

  alias Tello.StatusListener.Status

  @doc """
  Parse the status update message,
  returns the `Tello.StatusListener.Status` struct.
  """
  @spec parse(String.t()) :: Status.t()
  def parse(status_str) do
    status_data =
      status_str
      |> String.trim()
      |> String.split(";")
      |> List.delete("")
      |> Enum.map(fn item ->
        [key, value] = String.split(item, ":")

        {key, value}
      end)
      |> Enum.into(%{})

    %Status{
      mission_pad: build_mission_pad(status_data),
      pitch: get_integer_value(status_data, "pitch"),
      roll: get_integer_value(status_data, "roll"),
      yaw: get_integer_value(status_data, "yaw"),
      speed: build_speed(status_data),
      temperature: build_temperature(status_data),
      tof_distance: get_integer_value(status_data, "tof"),
      height: get_integer_value(status_data, "h"),
      battery: get_integer_value(status_data, "bat"),
      barometer: get_float_value(status_data, "baro"),
      time: get_integer_value(status_data, "time"),
      acceleration: build_acceleration(status_data),
      _raw: String.trim(status_str)
    }
  end

  defp build_mission_pad(data) do
    mission_pad_id =
      data
      |> get_integer_value("mid")

    case mission_pad_id do
      -1 ->
        nil

      id ->
        [pitch, roll, yaw] =
          data
          |> Map.get("mpry")
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)

        %Status.MissionPad{
          id: id,
          x: get_integer_value(data, "x"),
          y: get_integer_value(data, "y"),
          z: get_integer_value(data, "z"),
          pitch: pitch,
          roll: roll,
          yaw: yaw
        }
    end
  end

  defp build_speed(data) do
    %Status.Speed{
      x: get_integer_value(data, "vgx"),
      y: get_integer_value(data, "vgy"),
      z: get_integer_value(data, "vgz")
    }
  end

  defp build_temperature(data) do
    %Status.Temperature{
      low: get_integer_value(data, "templ"),
      high: get_integer_value(data, "temph")
    }
  end

  defp build_acceleration(data) do
    %Status.Acceleration{
      x: get_float_value(data, "agx"),
      y: get_float_value(data, "agy"),
      z: get_float_value(data, "agz")
    }
  end

  defp get_integer_value(data, key) do
    data
    |> Map.get(key)
    |> String.to_integer()
  end

  defp get_float_value(data, key) do
    data
    |> Map.get(key)
    |> String.to_float()
  end
end
