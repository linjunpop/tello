defmodule Tello.VirtualTello.Responder do
  def reply(socket, {ip, port}, message) do
    :gen_udp.send(socket, ip, port, message)
  end
end
