import "dart:math";
import "package:flutter/material.dart";
import "package:maze_solver/widgets/goal_result_widget.dart";
import "package:maze_solver/widgets/grid_builder.dart";
import "package:maze_solver/astar_logic/logic.dart";
import "package:maze_solver/models/models.dart";
import "package:maze_solver/widgets/result_dialog.dart";

class CreateRandomMazeWidget extends StatefulWidget {
  const CreateRandomMazeWidget({super.key});

  @override
  CreateRandomMazeWidgetState createState() => CreateRandomMazeWidgetState();
}

class CreateRandomMazeWidgetState extends State<CreateRandomMazeWidget> {
  Map<String, String> result = {};
  final numberOfRows = Random().nextInt(5) + 5;
  final numberOfColumns = Random().nextInt(5) + 5;

  Map<String, String> goalResult = {};
  Distance selectedHeuristic = Distance.manhattan;
  bool canMoveDiagonally = false;

  late final Node startNode = Node(
    Random().nextInt(numberOfRows - 1),
    Random().nextInt(numberOfColumns - 1),
    NodeMode.start,
  );

  late final goalNode = Node(
    Random().nextInt(numberOfRows - 1),
    Random().nextInt(numberOfColumns - 1),
    NodeMode.goal,
  );
  late final totalNodes = numberOfRows * numberOfColumns;

  late final wallNodeCount = Random().nextInt(10) + 1;

  late List<Node> wallNodes = [
    for (int i = 0; i < wallNodeCount; i++)
      Node(
        Random().nextInt(numberOfRows),
        Random().nextInt(numberOfColumns),
        NodeMode.wall,
      ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text("Maze Solver", style: TextStyle(color: Colors.blueGrey)),
            Divider(
              color: Colors.blueGrey,
              thickness: 2,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridBuilder(
              numberOfRows: numberOfRows,
              numberOfColumns: numberOfColumns,
              numberOfGoals: 1,
              nodes: [startNode, goalNode, ...wallNodes],
              selectedMode: null,
            ),
          ),
          const SizedBox(height: 20),
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
                        style: TextStyle(fontWeight: FontWeight.bold))),
              ),
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
                        setState(() => selectedHeuristic = value!),
                  ),
                  const Text("Euclidean"),
                ],
              ),
              ElevatedButton(
                onPressed: () => setState(() {
                  try {
                    goalResult = solveMaze(
                      [startNode, goalNode, ...wallNodes],
                      selectedHeuristic,
                      numberOfColumns,
                      numberOfRows,
                      goalNode,
                      canMoveDiagonally,
                    );

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => ResultDialog(
                        result: goalResultWidget(goalNode, goalResult),
                      ),
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
    );
  }
}
