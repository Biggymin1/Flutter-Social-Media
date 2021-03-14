import 'package:flutter/material.dart';

var chosenStoryName;

class storyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Story",
          style: TextStyle(color: Colors.blue),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
