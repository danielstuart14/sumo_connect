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
  final startStrategy start;
  final patrolStrategy patrol;
  final attackStrategy attack;

  const Strategy(this.start, this.patrol, this.attack);
}