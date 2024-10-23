import "dart:math";
import "package:maze_solver/models/models.dart";

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
  bool canMoveDiagonally,
) {
  List<Node> openList = [];
  List<Node> closedList = [];
  List<Node> path = [];
  Map<Node, Node?> parentMap = {};

  final Node startNode = nodes.firstWhere((node) => node.isStart);

  openList.add(startNode);
  parentMap[startNode] = null;

  startNode.stepsToStart = 0;
  startNode.stepsToGoal = heuristicType == Distance.manhattan
      ? calculateManhattanDistance(startNode, goalNode)
      : calculateEuclideanDistance(startNode, goalNode);

  while (openList.isNotEmpty) {
    final currentNode = openList.reduce((value, element) {
      final fValue1 = value.stepsToStart + value.stepsToGoal;
      final fValue2 = element.stepsToStart + element.stepsToGoal;
      return fValue1 < fValue2 ? value : element;
    });
    closedList.add(currentNode);
    openList.remove(currentNode);

    if (currentNode.isGoal) {
      if (goalNode != currentNode) {
        // on the way to find the goal, we found another goal
        // so we break the loop and return an empty map
        return {};
      }
      Node? node = currentNode;
      while (node != null) {
        path.add(node);
        node = parentMap[node];
      }
      // Reverse to get the right order
      path = path.reversed.toList();
      break;
    }
    final List<Node> neighbours = getNeighbours(
        currentNode, nodes, numOfCols, numOfRows, canMoveDiagonally);

    for (final neighbour in neighbours) {
      // Skip if neighbour is already in closedList
      if (closedList.contains(neighbour)) continue;

      final newStepsToStart = currentNode.stepsToStart + 1;

      if (!openList.contains(neighbour) ||
          newStepsToStart < neighbour.stepsToStart) {
        neighbour.stepsToStart = newStepsToStart;
        neighbour.stepsToGoal = (heuristicType == Distance.manhattan
            ? calculateManhattanDistance(neighbour, goalNode)
            : calculateEuclideanDistance(neighbour, goalNode));
        parentMap[neighbour] = currentNode;

        // Add to openList if not already present
        if (!openList.contains(neighbour)) {
          openList.add(neighbour);
        } else {
          // delete the neighbour from openList
          // and add it back with updated its position
          openList.add(neighbour);
        }
      }
    }
  }

  if (path.isEmpty) {
    return {};
  }

  // Return the results
  return {
    "steps": "${path.length - 1}",
    "path": path.map((node) => "(${node.x}, ${node.y})").toList().toString(),
    "tested":
        closedList.map((node) => "(${node.x}, ${node.y})").toList().toString(),
  };
}

int calculateManhattanDistance(Node node1, Node node2) {
  final xValue = (node2.x - node1.x).abs();
  final yValue = (node2.y - node1.y).abs();

  return xValue + yValue;
}

int calculateEuclideanDistance(Node node1, Node node2) {
  final xValue = pow(node2.x - node1.x, 2);
  final yValue = pow(node2.y - node1.y, 2);

  return sqrt(xValue + yValue).toInt();
}

List<Node> getNeighbours(Node node, List<Node> nodes, int numOfCols,
    int numOfRows, bool canMoveDiagonally) {
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
      if (!canMoveDiagonally &&
          ((xValue == x - 1 && yValue == y - 1) ||
              (xValue == x + 1 && yValue == y + 1) ||
              (xValue == x - 1 && yValue == y + 1) ||
              (xValue == x + 1 && yValue == y - 1))) {
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
