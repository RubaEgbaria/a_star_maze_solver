import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maze_solver/maze_builder_widget.dart';

class CreateMazeWidget extends StatefulWidget {
  const CreateMazeWidget({super.key});

  @override
  CreateMazeWidgetState createState() => CreateMazeWidgetState();
}

class CreateMazeWidgetState extends State<CreateMazeWidget> {
  final numberOfGoals = [1, 2];

  final TextEditingController _numberOfRowsController = TextEditingController();
  final TextEditingController _numberOfColumnsController =
      TextEditingController();
  int numberOfGoalsSelected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          children: [
            Text('Maze solver', style: TextStyle(color: Colors.blueGrey)),
            Divider(
              color: Colors.blueGrey,
              thickness: 2,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: _numberOfRowsController,
              decoration: const InputDecoration(
                labelText: 'Number of rows',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextFormField(
              controller: _numberOfColumnsController,
              decoration: const InputDecoration(
                labelText: 'Number of columns',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            DropdownButtonFormField(
                hint: const Text('Number of goals'),
                items: numberOfGoals.map((int value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? value) {
                  setState(() {
                    numberOfGoalsSelected = value!;
                    print(numberOfGoalsSelected);
                  });
                }),
            ElevatedButton(
              onPressed: () {
                final rowsNum = int.parse(_numberOfRowsController.value.text);
                final columnsNum =
                    int.parse(_numberOfColumnsController.value.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MazeBuilderWidget(
                          numberOfGoalsSelected, rowsNum, columnsNum)),
                );
              },
              child: const Text("Create maze"),
            ),
          ],
        )),
      ),
    );
  }
}
