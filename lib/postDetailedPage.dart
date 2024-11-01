import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'main.dart';

import 'loginPage.dart';
import 'package:flutter/services.dart';

import 'deprecatedAdd.dart';

var chosenPostImg,
    chosenPostName,
    chosenPostDescription, //the variable is changed accordingly in the post.dart
    chosenPostTarget,
    chosenPostContact,
    chosenPostId,
    chosenPostCategory,
    chosenPostHasRealImage = false; //avoiding it from being null

class postDetailedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
        backgroundColor: Colors.black38,
        body: Column(children: [
          postImageLarge(),
          postTitle(),
          postDesc(),
          Container(
            height: 15,
          ),
          postTarget(),
          Container(
            height: 15,
          ),
          postContact(),
          Container(
            height: 15,
          ),
          postCategory(),
          Container(
            height: 25,
          ),
          addToProjectButton()
        ]));
  }
}

class postImageLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (chosenPostImg != 'assets/images/skateLandscape.jpg') {
      chosenPostHasRealImage = true;
    }

    //print('chosenPostImg (postDetailedPage.dart): ${chosenPostImg}');

    //chosenPostImage need id
    return chosenPostHasRealImage
        ? Container(
            height: 174,
            width: 630,
            child: Image.network(
              chosenPostImg,
              fit: BoxFit.fill,
            ))
        : Image.asset('assets/images/skateLandscape.jpg');
  }
}

class postTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        chosenPostName,
        style: TextStyle(fontSize: 45, color: Colors.white),
      ),
    );
  }
}

class postDesc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(chosenPostDescription,
          style: TextStyle(fontSize: 25, color: Colors.white)),
    );
  }
}

class postTarget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Target:",
              style: TextStyle(color: Colors.white, fontSize: 25),
            )),
      ),
      Container(
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                chosenPostTarget,
                style: TextStyle(color: Colors.white, fontSize: 25),
              )))
    ]);
  }
}

class postContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Contacts:",
                style: TextStyle(color: Colors.white, fontSize: 25))),
      ),
      Container(
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                chosenPostContact,
                style: TextStyle(color: Colors.white, fontSize: 25),
              )))
    ]);
  }
}

class postCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Category:",
                style: TextStyle(color: Colors.white, fontSize: 25))),
      ),
      Container(
          child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                chosenPostCategory,
                style: TextStyle(color: Colors.white, fontSize: 25),
              )))
    ]);
  }
}

class addToProjectButton extends StatefulWidget {
  @override
  _addToProjectButtonState createState() => _addToProjectButtonState();
}

class _addToProjectButtonState extends State<addToProjectButton> {
  var buttonText = '';

  addProjectToSaved() {
    print("adding project ${chosenPostId} to user ${userId}");
    var dataToSend = {'userId': userId, 'postId': chosenPostId};
    http.post(Uri.http('${ipAddress}', '/addSavedProject'),
        body: convert.jsonEncode(dataToSend),
        headers: {'Content-Type': 'application/json'});

    setState(() {
      //rebuilding with latest data
    });
  }

  deleteProjectFromSaved() {
    print("removing project ${chosenPostId} from user ${userId}");
    var dataToSend = {'userId': userId, 'postId': chosenPostId};
    http.post(Uri.http('${ipAddress}', '/deleteSavedProject'),
        body: convert.jsonEncode(dataToSend),
        headers: {'Content-Type': 'application/json'});

    setState(() {
      //rebuilding with latest data
    });
  }

  checkIfProjectIsSaved() async {
    print("checking if project is saved");
    print("userId:${userId}, chosenPostId:${chosenPostId}");
    var dataToSend = {'userId': userId, 'postId': chosenPostId};
    var request = await http.post(
        Uri.http('${ipAddress}', '/checkSavedProject'),
        body: convert.jsonEncode(dataToSend),
        headers: {'Content-Type': 'application/json'});
    var response = request.body;
    var body = convert.jsonDecode(response);
    if (body.isEmpty == true) {
      print("body:${body} empty");
      buttonText = 'Add Post To Saved Project';
      return 0;
    }
    else {
      buttonText = 'Remove Post From Saved Project';
      print("body:${body} not empty");
      return 1;
    }
  }

  addToSavedOrRemovedFromSaved() async{
    //1 means already saved
    var check = await checkIfProjectIsSaved();
    if (check == 0) {
      //already saved
      addProjectToSaved();
    }
    if(check == 1){
      deleteProjectFromSaved();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: FutureBuilder(
          future: checkIfProjectIsSaved(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              return RaisedButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)), color: Colors.red, child: Text(
                  buttonText,
                  style: TextStyle(fontSize: 30),
                ),
                onPressed: () => {
                  addToSavedOrRemovedFromSaved(),
                },
              );
            }
            else{
              return CircularProgressIndicator();
            }
          }
        ));
  }
}
