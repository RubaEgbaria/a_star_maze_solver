import "package:flutter/material.dart";
import "package:maze_solver/models/models.dart";

class GridBuilder extends StatefulWidget {
  final int numberOfRows;
  final int numberOfColumns;
  final int numberOfGoals;
  final List<Node> nodes;
  final NodeMode? selectedMode;

  const GridBuilder({
    required this.numberOfGoals,
    required this.numberOfRows,
    required this.numberOfColumns,
    required this.nodes,
    required this.selectedMode,
    super.key,
  });

  @override
  GridBuilderState createState() => GridBuilderState();
}

class GridBuilderState extends State<GridBuilder> {
  int get numOfCurrentGoals =>
      widget.nodes.where((element) => element.isGoal).length;
  int get numOfCurrentStarts =>
      widget.nodes.where((element) => element.isStart).length;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.numberOfColumns,
      ),
      itemCount: widget.numberOfRows * widget.numberOfColumns,
      itemBuilder: (BuildContext context, int index) {
        final y = index % widget.numberOfColumns;
        final x = index ~/ widget.numberOfColumns;

        Node? node = widget.nodes.firstWhere(
            (element) => element.x == x && element.y == y,
            orElse: () => Node(x, y, NodeMode.none));

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2),
            color: node.isStart
                ? Colors.orange.shade400
                : node.isGoal
                    ? Colors.green
                    : node.isWall
                        ? Colors.grey.shade400
                        : null,
          ),
          child: Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  node.isStart = widget.selectedMode == NodeMode.start;
                  node.isWall = widget.selectedMode == NodeMode.wall;
                  node.isGoal = widget.selectedMode == NodeMode.goal;

                  if (numOfCurrentGoals >= widget.numberOfGoals &&
                      node.isGoal) {
                    node.isGoal = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.orange,
                        content: Text(
                            "You have already set $numOfCurrentGoals goals"),
                      ),
                    );
                  }

                  if (numOfCurrentStarts >= 1 && node.isStart) {
                    node.isStart = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.orange,
                        content: Text("Only one start node is allowed"),
                      ),
                    );
                  }

                  if (NodeMode.none == widget.selectedMode) {
                    node.isStart = false;
                    node.isGoal = false;
                    node.isWall = false;
                  }

                  if (!widget.nodes.contains(node)) {
                    widget.nodes.add(node);
                  }
                });
              },
              child: Text(
                node.isStart
                    ? "S"
                    : node.isGoal
                        ? "G"
                        : node.isWall
                            ? "W"
                            : "(${node.x}, ${node.y})",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }
}
