# Tello Architecture

  ```mermaid
  flowchart TD
    Application(Tello.Application)
    RyzeTello(((Ryze Tello)))

    Application --- Manager

    subgraph TelloCore[Core]
      Manager(Tello.Manager)

      Manager -.- Client1
      Manager -.- Client2

      subgraph ClientCluster[Tello Client Cluster]
        Client1(Tello.Client)
        Client2(Tello.Client)

        Controller1(Tello.Controller)
        Controller2(Tello.Controller)

        StatusListener2(Tello.StatusListener)

        More(...)

        Client1 -.- Controller1
        Client2 -.- Controller2
        Client2 -.- StatusListener2
      end
    end

    subgraph CyberTello
      Gateway(Tello.CyberTello.Gateway)
      Memory[(Tello.CyberTello.Memory)]

      subgraph CPU
        Processor(Tello.CyberTello.Processor)
        ControlUnit(Tello.CyberTello.ControlUnit)

        Processor -.- ControlUnit
      end

      Memory -.- Processor
      Gateway -.- Processor
    end

    Controller1 --- Gateway
    Controller2 --- RyzeTello
    StatusListener2 --- RyzeTello
  ```