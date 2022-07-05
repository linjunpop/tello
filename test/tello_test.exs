defmodule TelloTest do
  use ExUnit.Case
  doctest Tello

  test "greets the world" do
    assert Tello.hello() == :world
  end
end
