import "package:flutter/material.dart";
import "package:maze_solver/screens/create_maze_screen.dart";
import "package:maze_solver/screens/create_random_maze_screen.dart";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Column(
          children: [
            Text("Maze solver", style: TextStyle(color: Colors.blueGrey)),
            Divider(color: Colors.blueGrey, thickness: 2),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: [
            Image.asset("lib/assets/maze.gif"),
            const Text("How would you like to start?",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey)),
            Column(
              children: [
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreateMazeWidget())),
                    child: const Text("Create a maze")),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CreateRandomMazeWidget())),
                    child: const Text("Random maze")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
