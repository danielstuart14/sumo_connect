import 'package:sumo_connect/robot.dart';
import 'package:sumo_connect/strategy.dart';

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

  setStrategy(Strategy? strategy) {
    if (connectedTo == null) {
      return;
    }

    connectedTo!.strategy = strategy;
  }

  setPosition(Position? robot, Position? enemy) {
    if (connectedTo == null) {
      return;
    }

    connectedTo!.robotPos = robot;
    connectedTo!.enemyPos = enemy;
  }
}