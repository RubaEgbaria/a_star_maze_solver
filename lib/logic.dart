import 'package:maze_solver/models.dart';

enum Distance { manhattan, euclidean }

// A* algorithm
// g(n) = cost of the path from the start node to node n
// h(n) = heuristic that estimates the cost of the cheapest path from n to the goal
// f(n) = g(n) + h(n)
// f(n) = stepsToGoal + stepsToStart
// current node -> check neighbours -> calculate f(n) -> add to open list
// open list -> sort by f(n) -> remove node with lowest f(n) -> add to closed list
// if two neighbours have the same f(n), choose the one with the lowest h(n)
// if f(n) and h(n) are the same, choose randomly

Map<String, String> solveMaze(
  List<Node> nodes,
  Distance heuristicType,
  int numOfCols,
  int numOfRows,
  Node goalNode,
) {
  // TODO:
  // test it on paper
  // test it on the app
  // read the assignment
  // think of the tricky parts

  List<Node> openList = [];
  List<Node> closedList = [];
  final Node startNode = nodes.firstWhere((node) => node.isStart);
  Node closestGoalNode = goalNode;
  closestGoalNode.stepsToGoal = 1000;

  final allMazeNodes = [
    for (int i = 0; i < numOfCols; i++)
      for (int j = 0; j < numOfRows; j++)
        if (nodes.any((node) => node.x == i && node.y == j))
          nodes.firstWhere((node) => node.x == i && node.y == j)
        else
          Node(i, j, NodeMode.none)
  ];

  openList.add(startNode);

  Node currentNode = startNode;

  if (heuristicType == Distance.manhattan) {
    currentNode.stepsToGoal = calculateManhattanDistance(currentNode, goalNode);
    currentNode.stepsToStart =
        calculateManhattanDistance(currentNode, startNode);
  } else if (heuristicType == Distance.euclidean) {
    currentNode.stepsToGoal = calculateEuclideanDistance(currentNode, goalNode);
    currentNode.stepsToStart =
        calculateEuclideanDistance(currentNode, startNode);
  }
  while (openList.isNotEmpty) {
    openList.sort((a, b) => a.stepsToGoal!.compareTo(b.stepsToGoal!));
    currentNode = openList.removeAt(0);
    closedList.add(currentNode);

    if (currentNode.isGoal) {
      break;
    }

    final List<Node> neighbours =
        getNeighbours(currentNode, allMazeNodes, numOfCols, numOfRows);

    for (final neighbour in neighbours) {
      if (closedList.contains(neighbour)) {
        continue;
      }

      final newStepsToStart = currentNode.stepsToStart!;
      if (!openList.contains(neighbour) ||
          newStepsToStart < neighbour.stepsToStart!) {
        neighbour.stepsToStart = newStepsToStart;
        neighbour.stepsToGoal = heuristicType == Distance.manhattan
            ? calculateManhattanDistance(neighbour, goalNode)
            : calculateEuclideanDistance(neighbour, goalNode);

        openList.add(neighbour);
        currentNode = neighbour;
      }
    }
  }

  return {
    'steps': '${closedList.length - 1}',
    'path':
        closedList.map((node) => '(${node.x}, ${node.y})').toList().toString(),
    'solution':
        openList.map((node) => '(${node.x}, ${node.y})').toList().toString(),
  };
}

int calculateManhattanDistance(Node node1, Node node2) {
  return (node1.x - node2.x).abs() + (node1.y - node2.y).abs();
}

int calculateEuclideanDistance(Node node1, Node node2) {
  return ((node1.x - node2.x).abs() + (node1.y - node2.y).abs()).round();
}

List<Node> getNeighbours(
    Node node, List<Node> nodes, int numOfCols, int numOfRows) {
  final List<Node> neighbours = [];

  const minX = 0;
  const minY = 0;
  final maxX = numOfCols - 1;
  final maxY = numOfRows - 1;

  final int x = node.x;
  final int y = node.y;

  final List<int> xValues = [x - 1, x, x + 1];
  final List<int> yValues = [y - 1, y, y + 1];

  for (final xValue in xValues) {
    for (final yValue in yValues) {
      if (xValue == x && yValue == y) {
        continue;
      }
      final Node neighbour = nodes.firstWhere(
        (node) => node.x == xValue && node.y == yValue,
        orElse: () => Node(xValue, yValue, NodeMode.none),
      );
      if (neighbour.isWall == false &&
          neighbour.x >= minX &&
          neighbour.x <= maxX &&
          neighbour.y >= minY &&
          neighbour.y <= maxY) neighbours.add(neighbour);
    }
  }
  return neighbours;
}
