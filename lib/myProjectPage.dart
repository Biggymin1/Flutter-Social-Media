import 'package:flutter/material.dart';
import 'main.dart';

class projectPage extends StatefulWidget {
  @override
  _projectPage createState() => _projectPage();
}

class _projectPage extends State<projectPage> {
  goToMainPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => mainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToMainPage(),
        child: Icon(Icons.keyboard_return),
      ),
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Project Page"),
      ),
      body: Column(
        children: [projectContainer(),projectContainer()],
      ),
    );
  }
}

class projectContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:
        BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)),color: Colors.blue),
        margin: EdgeInsets.all(20),
        height: 100,
        width: 900,
        child: Column(children: [Text("hello",style: TextStyle(fontWeight: FontWeight.bold),)],)
    );
  }
}