enum NodeMode { start, goal, wall, none }

enum Distance { manhattan, euclidean }

class Node {
  final int x;
  final int y;
  final NodeMode mode;
  bool isStart = false;
  bool isGoal = false;
  bool isWall = false;
  int stepsToStart = 0;
  int stepsToGoal = 0;

  Node(this.x, this.y, this.mode)
      : isStart = mode == NodeMode.start,
        isGoal = mode == NodeMode.goal,
        isWall = mode == NodeMode.wall;
}
