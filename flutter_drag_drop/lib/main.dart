import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DragAndDropScreen(),
    );
  }
}

class DragAndDropScreen extends StatefulWidget {
  @override
  _DragAndDropScreenState createState() => _DragAndDropScreenState();
}

class _DragAndDropScreenState extends State<DragAndDropScreen> {
  List<Container> containers = [];
  List<Container> draggableItems = [];

  @override
  void initState() {
    super.initState();
    draggableItems = [
      _buildDraggableContainer(Colors.red),
      _buildDraggableContainer(Colors.blue),
      _buildDraggableContainer(Colors.green),
      _buildDraggableContainer(Colors.yellow),
      _buildDraggableContainer(Colors.orange),
    ];
  }

  Container _buildDraggableContainer(Color color) {
    return Container(
      width: 100,
      height: 100,
      color: color,
      child: const Center(
        child: Text('Drag Me', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drag and Drop Example'),
      ),
      body: Row(
        children: [
          Expanded(
            child: DragTarget<Container>(
              builder: (context, candidateData, rejectedData) {
                return Container(
                  color: Colors.grey,
                  constraints: const BoxConstraints(minHeight: 50),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: containers
                          .map((item) => Draggable<Container>(
                                data: item,
                                feedback: item,
                                childWhenDragging: Container(),
                                child: item,
                              ))
                          .toList(),
                    ),
                  ),
                );
              },
              onWillAccept: (data) => true,
              onAccept: (data) {
                setState(() {
                  containers.add(data);
                });
              },
            ),
          ),
          SizedBox(width: 20),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: draggableItems
                .map((item) => DragTarget<Container>(
                      builder: (context, candidateData, rejectedData) {
                        return Draggable<Container>(
                          data: item,
                          feedback: item,
                          childWhenDragging: Container(),
                          child: item,
                        );
                      },
                      onWillAccept: (data) => true,
                      onAccept: (data) {
                        setState(() {
                          containers.remove(data);
                        });
                      },
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
