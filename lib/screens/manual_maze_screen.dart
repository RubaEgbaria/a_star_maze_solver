import "package:flutter/material.dart";
import "package:maze_solver/widgets/goal_result_widget.dart";
import "package:maze_solver/widgets/grid_builder.dart";
import "package:maze_solver/astar_logic/logic.dart";
import "package:maze_solver/models/models.dart";
import "package:maze_solver/widgets/result_dialog.dart";

class ManualMazeScreen extends StatefulWidget {
  final int numberOfGoals;
  final int numberOfRows;
  final int numberOfColumns;

  const ManualMazeScreen(
      this.numberOfGoals, this.numberOfRows, this.numberOfColumns,
      {super.key});

  @override
  ManualMazeScreenState createState() => ManualMazeScreenState();
}

class ManualMazeScreenState extends State<ManualMazeScreen> {
  List<Node> nodes = [];
  NodeMode selectedMode = NodeMode.none;
  Map<String, String> goalResult = {};
  Node nearestGoalNode = Node(0, 0, NodeMode.none);
  bool isSameNumOfSteps = false;
  Map<String, String> firstGoalResult = {};
  Map<String, String> secondGoalResult = {};
  Distance selectedHeuristic = Distance.manhattan;
  bool canMoveDiagonally = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maze Solver")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Select which node to set:",
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
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
            Expanded(
              child: GridBuilder(
                numberOfRows: widget.numberOfRows,
                numberOfColumns: widget.numberOfColumns,
                numberOfGoals: widget.numberOfGoals,
                nodes: nodes,
                selectedMode: selectedMode,
              ),
            ),
            // select heuristic type and allow diagonal movement
            // then solve maze button
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CheckboxListTile(
                    value: canMoveDiagonally,
                    onChanged: (value) =>
                        setState(() => canMoveDiagonally = value!),
                    title: const Text("Allow diagonal movement")),
                const Padding(
                    padding: EdgeInsets.all(10),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Select heuristic type",
                            style: TextStyle(fontWeight: FontWeight.bold)))),
                Row(
                  children: [
                    Radio<Distance>(
                      value: Distance.manhattan,
                      groupValue: selectedHeuristic,
                      onChanged: (Distance? value) =>
                          setState(() => selectedHeuristic = value!),
                    ),
                    const Text("Manhattan"),
                  ],
                ),
                Row(
                  children: [
                    Radio<Distance>(
                        value: Distance.euclidean,
                        groupValue: selectedHeuristic,
                        onChanged: (Distance? value) =>
                            setState(() => selectedHeuristic = value!)),
                    const Text("Euclidean"),
                  ],
                ),
                ElevatedButton(
                  onPressed: () => setState(() {
                    final goalsNodes =
                        nodes.where((node) => node.isGoal).toList();

                    firstGoalResult = {};
                    secondGoalResult = {};

                    final firstGoalNode = goalsNodes.first;
                    final secondGoalNode = goalsNodes.last;

                    if (goalsNodes.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text("Please set the goals"),
                        ),
                      );
                      return;
                    }

                    try {
                      firstGoalResult = solveMaze(
                        nodes,
                        selectedHeuristic,
                        widget.numberOfColumns,
                        widget.numberOfRows,
                        firstGoalNode,
                        canMoveDiagonally,
                      );

                      if (goalsNodes.length > 1) {
                        secondGoalResult = solveMaze(
                          nodes,
                          selectedHeuristic,
                          widget.numberOfColumns,
                          widget.numberOfRows,
                          secondGoalNode,
                          canMoveDiagonally,
                        );
                      }

                      final stepsGoal1 =
                          int.tryParse(firstGoalResult["steps"] ?? "0") ?? 0;
                      final stepsGoal2 =
                          int.tryParse(secondGoalResult["steps"] ?? "0") ?? 0;

                      isSameNumOfSteps = stepsGoal1 == stepsGoal2;

                      if (!isSameNumOfSteps ||
                          stepsGoal2 == 0 ||
                          stepsGoal1 == 0) {
                        goalResult = stepsGoal1 == 0 ||
                                (stepsGoal2 < stepsGoal1 && stepsGoal2 != 0)
                            ? secondGoalResult
                            : firstGoalResult;

                        nearestGoalNode = stepsGoal1 == 0 ||
                                (stepsGoal2 < stepsGoal1 && stepsGoal2 != 0)
                            ? goalsNodes.last
                            : goalsNodes.first;
                      }

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          if (isSameNumOfSteps) {
                            return ResultDialog(
                                result: _buildTwoGoalsResults(
                                    firstGoalResult,
                                    secondGoalResult,
                                    firstGoalNode,
                                    secondGoalNode));
                          }
                          return ResultDialog(
                              result: _buildNearestGoalResults(
                                  goalResult, nearestGoalNode));
                        },
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("Error solving maze: $e"),
                        ),
                      );
                    }
                  }),
                  child: const Text("Solve maze"),
                ),
                const SizedBox(height: 20),
              ],
            )
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

Widget _buildNearestGoalResults(
    Map<String, String> goalResult, Node nearestGoalNode) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Goal with the Least Number of Steps",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text("Goal: (${nearestGoalNode.x}, ${nearestGoalNode.y})"),
        const SizedBox(height: 8),
        Text("# steps: ${goalResult["steps"] ?? "N/A"}"),
        const SizedBox(height: 8),
        Text("Path: ${goalResult["path"] ?? "N/A"}"),
        const SizedBox(height: 8),
        Text("Tested nodes: ${goalResult["tested"] ?? "N/A"}"),
      ],
    ),
  );
}

Widget _buildTwoGoalsResults(
    Map<String, String> firstGoalResult,
    Map<String, String> secondGoalResult,
    Node firstGoalNode,
    Node secondGoalNode) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          firstGoalResult["path"] == null || secondGoalResult["path"] == null
              ? "No Solution Found, walls are blocking the path"
              : "Both Goals Have the Same Number of Steps",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        goalResultWidget(firstGoalNode, firstGoalResult),
        const SizedBox(height: 20),
        goalResultWidget(secondGoalNode, secondGoalResult),
      ],
    ),
  );
}
