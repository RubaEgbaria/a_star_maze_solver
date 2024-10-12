import 'dart:math';
import 'package:flutter/material.dart';
import 'package:maze_solver/logic.dart';
import 'package:maze_solver/maze_builder_widget.dart';
import 'package:maze_solver/models.dart';

class RandomMazeBuilderWidget extends StatefulWidget {
  const RandomMazeBuilderWidget({super.key});

  @override
  RandomMazeBuilderWidgetState createState() => RandomMazeBuilderWidgetState();
}

class RandomMazeBuilderWidgetState extends State<RandomMazeBuilderWidget> {
  Map<String, String> result = {};
  final numberOfRows = Random().nextInt(5) + 5;
  final numberOfColumns = Random().nextInt(5) + 5;

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
            Text('Maze Solver', style: TextStyle(color: Colors.blueGrey)),
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
            child: MazeGridBuilder(
              numberOfRows: numberOfRows,
              numberOfColumns: numberOfColumns,
              numberOfGoals: 1,
              nodes: [startNode, goalNode, ...wallNodes],
              selectedMode: null,
            ),
          ),
          const SizedBox(height: 20),
          // Solve the maze button
          ElevatedButton(
            onPressed: () {
              setState(() {
                result = solveMaze(
                    [startNode, goalNode, ...wallNodes],
                    Distance.manhattan,
                    numberOfColumns,
                    numberOfRows,
                    goalNode);
              });
            },
            child: const Text("Solve maze Manhatten distance"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                result = solveMaze(
                    [startNode, goalNode, ...wallNodes],
                    Distance.euclidean,
                    numberOfColumns,
                    numberOfRows,
                    goalNode);
              });
            },
            child: const Text("Solve maze Euclidean distance"),
          ),
          const SizedBox(height: 20),
          Text("# steps: ${result['steps']}"),
          const SizedBox(height: 10),
          Text("Path: ${result['path']}"),
          const SizedBox(height: 10),
          Text("Sol: ${result['solution']}"),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
