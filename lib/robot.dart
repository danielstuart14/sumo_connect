import 'package:sumo_connect/strategy.dart';

enum RobotStatus {
  idle,
  waiting,
  executing
}

class Position {
  final double x;
  final double y;
  const Position(this.x, this.y);
}

class Robot {
  final String name;
  final String address;
  Strategy? strategy;
  Position? robotPos;
  Position? enemyPos;
  RobotStatus status = RobotStatus.idle;

  Robot(this.name, this.address);
}