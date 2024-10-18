import 'package:flutter/material.dart';
import 'package:maze_solver/models/models.dart';

Widget goalResultWidget(Node goalNode, Map<String, String> goalResult) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Goal: (${goalNode.x}, ${goalNode.y})"),
      Text("# steps: ${goalResult["steps"] ?? "N/A"}"),
      Text("Path: ${goalResult["path"] ?? "N/A"}"),
      Text("Tested nodes: ${goalResult["tested"] ?? "N/A"}"),
    ],
  );
}
