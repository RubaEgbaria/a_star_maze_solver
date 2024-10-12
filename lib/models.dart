enum NodeMode { start, goal, wall, none }

class Node {
  final int x;
  final int y;
  final NodeMode mode;
  bool isStart = false;
  bool isGoal = false;
  bool isWall = false;
  int? stepsToStart = 0;
  int? stepsToGoal = 0;

  Node(this.x, this.y, this.mode) {
    switch (mode) {
      case NodeMode.start:
        isStart = true;
        break;
      case NodeMode.goal:
        isGoal = true;
        break;
      case NodeMode.wall:
        isWall = true;
        break;
      default:
        break;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Node) return false;
    return x == other.x && y == other.y;
  }

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
