import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'main.dart';

import 'package:vision/loginPage.dart';

var chosenPostImg,
    chosenPostName,
    chosenPostDescription,  //the variable is changed accordingly in the post.dart
    chosenPostTarget,
    chosenPostContact,
    chosenPostId,
    chosenPostCategory,
    chosenPostHasRealImage = false; //avoiding it from being null

class postDetailedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black38,
        body: Column(children: [postImageLarge(), postTitle(), postDesc(),Container(height: 15,),postTarget(),Container(height: 15,),postContact(),Container(height: 15,),postCategory(),Container(height: 25,),addToProjectButton()]));
  }
}

class postImageLarge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    if(chosenPostImg != 'assets/images/skateLandscape.jpg'){
      chosenPostHasRealImage = true;
    }

    print('chosenPostImg (postDetailedPage.dart): ${chosenPostImg}');

    //chosenPostImage need id
    return chosenPostHasRealImage? Container(height: 174,width:630,child: Image.network(chosenPostImg,fit: BoxFit.fill,)) : Image.asset('assets/images/skateLandscape.jpg');
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
        child: Align(alignment: Alignment.centerLeft,child: Text("Target:",style: TextStyle(color: Colors.white,fontSize: 25),)),
      ),
      Container(child: Align(alignment: Alignment.centerLeft,child: Text(chosenPostTarget,style: TextStyle(color: Colors.white,fontSize: 25),)))
    ]);
  }
}

class postContact extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Align(alignment: Alignment.centerLeft,child: Text("Contacts:",style: TextStyle(color: Colors.white,fontSize: 25))),
      ),
      Container(child: Align(alignment: Alignment.centerLeft,child: Text(chosenPostContact,style: TextStyle(color: Colors.white,fontSize: 25),)))
    ]);
  }
}

class postCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        child: Align(alignment: Alignment.centerLeft,child: Text("Category:",style: TextStyle(color: Colors.white,fontSize: 25))),
      ),
      Container(child: Align(alignment: Alignment.centerLeft,child: Text(chosenPostCategory,style: TextStyle(color: Colors.white,fontSize: 25),)))
    ]);
  }
}

class addToProjectButton extends StatelessWidget{

  addProjectToSaved(){
    var dataToSend ={'userId':userId,'postId':chosenPostId};
    http.post(Uri.http('${ipAddress}:','/addSavedProject'),body: convert.jsonEncode(dataToSend) ,headers: {'Content-Type':'application/json'});
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: Alignment.bottomCenter,child: RaisedButton(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),color: Colors.red,child: Text("Add To Project",style: TextStyle(fontSize: 30),),onPressed: () => {addProjectToSaved()},));
  }
}
