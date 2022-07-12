# Usage

```elixir
# Start a client
{:ok, tello_client, controller, status_listener} = Tello.start()

# Enable the Tello's SDK mode
:ok = Tello.Controller.enable(controller)

# Control Tello
:ok = Tello.Controller.get_sdk_version(controller)
:ok = Tello.Controller.takeoff(controller)
```