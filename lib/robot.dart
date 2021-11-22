import 'package:sumo_connect/strategy.dart';
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

  Robot(this.name, this.address);
}