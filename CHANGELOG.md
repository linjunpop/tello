# CHANGELOG

## main

- Fixes `use Tello.StatusListener.Handler` will references wrong behaviour.

## v0.3.0

- Added `Tello.Manger.client_pids/1` to fetch the running `Tello.Client` PIDs.
- Use `integer` instead of `reference` as `Tello.Client` name's identity.

## v0.2.0

- Rename `Tello.Command` to `Tello.Controller`.
- Added `Tello.StatusListener` to receive status update from Tello.
- Allow to attach custom receiver to `Tello.Controller` to receive message form Tello, see `Tello.Controller.Receiver` for more detail.

## V0.1.0

- Initial release
