import 'package:sumo_connect/robot.dart';

Bluetooth bleHandler = Bluetooth();

class Bluetooth {
  Robot? connectedTo;

  connect(Robot robot) {
    if (connectedTo != null) {
      return;
    }

    print("Connected to: " + robot.address);
    connectedTo = robot;
  }

  disconnect() {
    if (connectedTo == null) {
      return;
    }

    print("Disconnected");
    connectedTo!.strategy = null;
    connectedTo = null;
  }
}