// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'main.dart';

var itemInPage = <Widget>[noteTextField()];
var changedNote = '';

class notePage extends StatefulWidget {
  @override
  _notePage createState() => _notePage();
}

class _notePage extends State<notePage> {
  goToMainPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => mainPage()));
  }

  addNote() {
    setState(() {
      itemInPage.add(Padding(padding: EdgeInsets.all(10),
        child: ListTile(
          tileColor: Colors.blueGrey,
          leading: Text(
            changedNote,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black26,
        floatingActionButton: FloatingActionButton(
          onPressed: () => addNote(),
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: Text("Note Page"),
        ),
        body: Column(children: [
          Expanded(
            child: ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: itemInPage,
                  );
                }),
          )
        ]));
  }
}

class noteContainer extends StatelessWidget {
  var changedNote;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            color: Colors.blue),
        margin: EdgeInsets.all(20),
        height: 100,
        width: 900,
        child: Column(
          children: [Text(changedNote)],
        ));
  }
}

class noteTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: InputDecoration(hintText: "Type Here"),
        style: TextStyle(color: Colors.white),
        onChanged: (String str) => {changedNote = str});
  }
}