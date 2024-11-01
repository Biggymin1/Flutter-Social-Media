import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'main.dart';
import 'post.dart';
import 'fabChild.dart';
import 'topButton.dart';
import 'storyRow.dart';
import 'postDetailedPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


import 'deprecatedAdd.dart';

//the top button has been moved in body dart inside the widget because we need to use setState
var currentAlgorithm = 'explore'; //default is explore
var itemInbody = [];
double endDetection = 0.00;

//used for post generation
var post1,post2,post3;
var post1Name,post1Image,post1Desc,post1Target,post1Contact,post1Category,post1Id,post1Owner;
var post2Name,post2Image,post2Desc,post2Target,post2Contact,post2Category,post2Id,post2Owner;
var post3Name,post3Image,post3Desc,post3Target,post3Contact,post3Category,post3Id,post3Owner;

class body extends StatefulWidget {
  @override
  _bodyState createState() => _bodyState();
}

class _bodyState extends State<body> {

  clearList(){
    setState((){
      itemInbody.clear();
    });
  }

  buildPostWidget() async{

    var collectedPost;
    //there is an error different post different detail

    print('building post widget');
    if(currentAlgorithm == 'explore') {
      collectedPost = await loadPostExplore();
    }
    if(currentAlgorithm == 'solve') {
      collectedPost = await loadPostSolve();
    }
    if(currentAlgorithm == 'following') {
      collectedPost = await loadPostFollowing(); //make sure to check if they are decoded
    }

    //print(collectedPost);

    post1 =  collectedPost[0];
    post2 =  collectedPost[1];
    post3 =  collectedPost[2];

    post1Name = post1["name"];
    post2Name = post2["name"];
    post3Name = post3["name"];

    post1Image = post1["img_url"];
    post2Image = post2["img_url"];
    post3Image = post3["img_url"];

    post1Desc = post1["description"];
    post2Desc = post2["description"];
    post3Desc = post3["description"];

    post1Target = post1["target"];
    post2Target = post2["target"];
    post3Target = post3["target"];

    post1Contact = post1["contact"];
    post2Contact = post2["contact"];
    post3Contact = post3["contact"];

    post1Category = post1["category"];
    post2Category = post2["category"];
    post3Category = post3["category"];

    post1Id = post1["id"];
    post2Id = post2["id"]; //the backend send id data as integer
    post3Id = post3["id"];

    post1Owner = post1["postOwner"];
    post2Owner = post2["postOwner"];
    post3Owner = post3["postOwner"];

    // print(post3Image);

    //filtering image
    if(post1Image == "none"){
      post1Image = "assets/images/skateLandscape.jpg";
    }
    else{
      post1Image = 'http://${ipAddress}/api/getPostImage/${post1Id}.jpg';  //we don't load image here just defining the path
      /*
      if(post1Image is http.Response){
        post1Image = post1Image.body;
      }*/
          //using id is fine since the image id == post id
    }


    if(post2Image == "none"){
      post2Image = "assets/images/skateLandscape.jpg";
    }
    else{
      post2Image = 'http://${ipAddress}/api/getPostImage/${post2Id}.jpg';

      print('post 2 image: ${post2Image}');
      /*
      if(post2Image is http.Response){
        post2Image = post2Image.body;
      }*/
      //here the thing,only need to access body if image don't exist we need to check
      //using id is fine since the image id == post id
    }

    if(post3Image == "none"){
      post3Image = "assets/images/skateLandscape.jpg";
    }
    else{
      post3Image = 'http://${ipAddress}/api/getPostImage/${post3Id}.jpg';
      /*if(post3Image is http.Response){
        post3Image = post3Image.body;
      }*/
      //using id is fine since the image id == post id
    }

    // print(post3Image);

    //the error where different post different detail is because the name and desc,etc is changing. we need to make it local (solved)

    setState(() {

      itemInbody.add(postFinished1());
      itemInbody.add(postFinished2());
      itemInbody.add(postFinished3());

    });
}

  @override
  Widget build(BuildContext context) {

    print("userId:${userId}");

    if(itemInbody.isEmpty == true){
      buildPostWidget();
    }

    return Column(
      children: <Widget>[
        Expanded(child: storyRow()),
        Expanded(flex: 1,child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [RaisedButton(
    color: Colors.orange,
    child: Text("Following",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
    padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
    onPressed: () => {clearList(),currentAlgorithm = 'following',print('Current Algorithm: $currentAlgorithm')},
    splashColor: Colors.white,
    shape: RoundedRectangleBorder(
    side: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(radius))),RaisedButton(
            color: Colors.green,
            splashColor: Colors.white,
            child: Text("Solve",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
            onPressed: () => {clearList(),currentAlgorithm = 'solve',print('Current Algorithm: $currentAlgorithm')},
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(radius))),RaisedButton(
            color: Colors.red,
            child: Text("Explore",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            onPressed: () => {clearList(),currentAlgorithm = 'explore',print('Current Algorithm: $currentAlgorithm')},
            splashColor: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
            shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white,),
                borderRadius: BorderRadius.circular(radius)))],)),
        Expanded(
            flex: 5,
            child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is UserScrollNotification) {
                    endDetection = notification.metrics.extentAfter;
                    //print(notification); yeah it works no more console log
                  }
                  if (endDetection < 50) {
                    return buildPostWidget();
                    //print('Item In body: ${itemInbody}');
                  }
                  return true;
                },
                child: FutureBuilder(future: loadPostExplore(), builder: (context,snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(itemCount: itemInbody.length,itemBuilder: (context,index){
                        return itemInbody[index];
                      });
                    }
                    else{
                      return CircularProgressIndicator();
                    }
                  }) //child of notificationListener
                ) //child of expanded
            ) //this is the third expanded widget
      ], //a reminder that everything inside this page is inside a collumn
    );
  } //this is from build
}

class scrollGuide extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.lightBlueAccent,child: Text('Scroll down to Start exploring'),);
  }
}