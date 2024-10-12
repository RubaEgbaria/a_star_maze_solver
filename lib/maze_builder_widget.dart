import 'package:flutter/material.dart';
import 'package:maze_solver/logic.dart';
import 'package:maze_solver/models.dart';

class MazeBuilderWidget extends StatefulWidget {
  final int numberOfGoals;
  final int numberOfRows;
  final int numberOfColumns;

  const MazeBuilderWidget(
      this.numberOfGoals, this.numberOfRows, this.numberOfColumns,
      {super.key});

  @override
  MazeBuilderWidgetState createState() => MazeBuilderWidgetState();
}

class MazeBuilderWidgetState extends State<MazeBuilderWidget> {
  List<Node> nodes = [];
  NodeMode selectedMode = NodeMode.none;
  Map<String, String> firstGoalResult = {};
  Map<String, String> secondGoalResult = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Maze Solver', style: TextStyle(color: Colors.blueGrey)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Select which node to set:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            // Radio buttons for selecting node types
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildRadioButton("Start", NodeMode.start),
                _buildRadioButton("Goal", NodeMode.goal),
                _buildRadioButton("Wall", NodeMode.wall),
                _buildRadioButton("None", NodeMode.none),
              ],
            ),

            const SizedBox(height: 5),
            // Maze grid
            Expanded(
              child: MazeGridBuilder(
                numberOfRows: widget.numberOfRows,
                numberOfColumns: widget.numberOfColumns,
                numberOfGoals: widget.numberOfGoals,
                nodes: nodes,
                selectedMode: selectedMode,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      firstGoalResult = solveMaze(
                          nodes,
                          Distance.manhattan,
                          widget.numberOfColumns,
                          widget.numberOfRows,
                          nodes.firstWhere((node) => node.isGoal));

                      secondGoalResult = solveMaze(
                          nodes,
                          Distance.manhattan,
                          widget.numberOfColumns,
                          widget.numberOfRows,
                          nodes.lastWhere((node) => node.isGoal));
                    });
                  },
                  child: const Text("Solve (Manhattan)"),
                ),
                const SizedBox(height: 20),
                // Solve the maze button
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      firstGoalResult = solveMaze(
                          nodes,
                          Distance.euclidean,
                          widget.numberOfColumns,
                          widget.numberOfRows,
                          nodes.firstWhere((node) => node.isGoal));

                      if (widget.numberOfGoals == 2) {
                        secondGoalResult = solveMaze(
                            nodes,
                            Distance.euclidean,
                            widget.numberOfColumns,
                            widget.numberOfRows,
                            nodes.lastWhere((node) => node.isGoal));
                      }
                    });
                  },
                  child: const Text("Solve (Euclidean)"),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Goal (${nodes.firstWhere((node) => node.isGoal).x}, "
                    "${nodes.firstWhere((node) => node.isGoal).y})"),
                Text("# steps: ${firstGoalResult['steps']}"),
                Text("Path: ${firstGoalResult['path']}"),
                Text("Solution nodes: ${firstGoalResult['solution']}"),
              ],
            ),
            if (widget.numberOfGoals == 2)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(color: Colors.blueGrey, thickness: 2),
                  Text("Goal (${nodes.lastWhere((node) => node.isGoal).x}, "
                      "${nodes.lastWhere((node) => node.isGoal).y})"),
                  Text("# steps: ${secondGoalResult['steps']}"),
                  Text("Path: ${secondGoalResult['path']}"),
                  Text("Solution nodes: ${secondGoalResult['solution']}"),
                ],
              ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioButton(String label, NodeMode mode) {
    return Row(
      children: [
        Radio<NodeMode>(
          value: mode,
          groupValue: selectedMode,
          onChanged: (NodeMode? value) {
            setState(
              () => selectedMode = value ?? NodeMode.none,
            );
          },
        ),
        Text(label),
      ],
    );
  }
}

class MazeGridBuilder extends StatefulWidget {
  final int numberOfRows;
  final int numberOfColumns;
  final int numberOfGoals;
  final List<Node> nodes;
  final NodeMode? selectedMode;

  const MazeGridBuilder(
      {required this.numberOfRows,
      required this.numberOfColumns,
      required this.numberOfGoals,
      required this.nodes,
      required this.selectedMode,
      super.key});

  @override
  MazeGridBuilderState createState() => MazeGridBuilderState();
}

class MazeGridBuilderState extends State<MazeGridBuilder> {
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
        int x = index % widget.numberOfColumns;
        int y = index ~/ widget.numberOfColumns;

        Node? node = widget.nodes.firstWhere(
            (element) => element.x == x && element.y == y,
            orElse: () => Node(x, y, NodeMode.none));

        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.2),
            color: node.isStart == true
                ? Colors.orange.shade400
                : node.isGoal == true
                    ? Colors.green
                    : node.isWall == true
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

                  numOfCurrentGoals;
                  numOfCurrentStarts;

                  if (numOfCurrentGoals >= widget.numberOfGoals &&
                      node.isGoal) {
                    node.isGoal = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.blueGrey,
                        content: Text(
                            "You have already set $numOfCurrentGoals goals"),
                      ),
                    );
                  }

                  if (numOfCurrentStarts >= 1 && node.isStart) {
                    node.isStart = false;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.blueGrey,
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
                node.isStart == true
                    ? "S"
                    : node.isGoal == true
                        ? "G"
                        : node.isWall == true
                            ? "W"
                            : "(${node.x}, ${node.y}) => ${node.stepsToGoal! + node.stepsToStart!}",
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }
}
