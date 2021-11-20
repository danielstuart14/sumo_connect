enum startStrategy {
  straight,
  zigzag,
  circle,
  ticToc,
  wait
}

enum patrolStrategy {
  straight,
  zigzag,
  stopAndGo,
  tornado
}

enum attackStrategy {
  forward,
  kick,
  dribbling
}

class Strategy {
  late startStrategy start;
  late patrolStrategy patrol;
  late attackStrategy attack;

  Strategy(this.start, this.patrol, this.attack);
}