import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loginPage.dart';
import 'dart:io';
import 'dart:convert' as convert;
import 'profilePage.dart';

var followingsUsername;
var followingsId;
var itemInFollowingPage = <Widget>[];

//there is a bug where it doesn't clear the list when we leave so we just reset the list when we press back button

class followingPage extends StatefulWidget {
  @override
  _followingPageState createState() => _followingPageState();
}

class _followingPageState extends State<followingPage> {

  getFollowing() async {
    // print('checkpoint 1'); it works now no need for checkpoint

    var idData;
    var idList = [];
    idData = await http.get(Uri.http('${ipAddress}','/getFollowingId/${chosenId}')); //this return 5 id if have follower

    idData = idData.body;
    idData = convert.jsonDecode(idData);

    //print('id data: ${idData}');
    //print('checkpoint 2');

    //there is an error it will stuck  if user have no follower
    if (idData.isEmpty == false) {
      for (var i in idData) { //for each json
        //print('followers ID: ${i}');
        idList.add(i['followingsId']); //the 'user' we're following
      }
    }

    //print('id list: ${idList}');
    //print('checkpoint 3');

    //same error happen here
    for (var i in idList) {
      //print('var I: ${i}');
      var httpResponse = await http.get(Uri.http('${ipAddress}','/getFollowingUsername/${i}'));
      var httpBody = httpResponse.body;
      //print('http body: ${httpBody}');
      var httpEncoded = convert.jsonDecode(httpBody);
      //print('http encoded: ${httpEncoded}'); no error here
      //the error is the code doesn't run below
      httpEncoded = httpEncoded[0];
      followingsUsername = httpEncoded['username'];
      followingsId = httpEncoded['id'];
      //print('followers username: ${followersUsername}');
      //the system changes the var add the tile.if you break the step it wont work
      itemInFollowingPage.add(followersTile());
    }

    //print('checkpoint 4');
    return idList;

  }

  emptyItemInFollowing(){
    itemInFollowingPage = [];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: emptyItemInFollowing(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("${chosenUsername} Followings"),
          ),
          body: FutureBuilder(
            future: getFollowing(), builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(itemCount:itemInFollowingPage.length,itemBuilder: (content, index) {
                return itemInFollowingPage[index];
              });
            }
            else {
              return CircularProgressIndicator();
            }
          },
          )),
    );
  }
}

class followersTile extends StatelessWidget{
  var id = followingsId;
  var username = followingsUsername;
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(username),onTap: () => {chosenId = id,chosenUsername = username,Navigator.push(context, new MaterialPageRoute(builder: (context) => profilePage()))},);
  }
}

