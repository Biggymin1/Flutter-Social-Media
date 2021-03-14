import 'package:flutter/material.dart';
import 'package:vision/loginPage.dart';
import 'package:vision/main.dart';
import 'package:http/http.dart' as http;
import 'package:vision/profilePage.dart';
import 'dart:convert' as convert;

var followersUsername;
var itemInFollowersPage = <Widget>[];

class followerPage extends StatefulWidget {
  @override
  _followerPageState createState() => _followerPageState();
}

class _followerPageState extends State<followerPage> {

  getFollowers() async {
   // print('checkpoint 1'); it works now no need for checkpoint

    var idData;
    var idList = [];
    idData = await http.get(Uri.http('${ipAddress}','/getFollowersId/${chosenId}')); //this return 5 id if have follower

    idData = idData.body;
    idData = convert.jsonDecode(idData);

    //print('id data: ${idData}');
    //print('checkpoint 2');

    //there is an error it will stuck  if user have no follower
    if (idData.isEmpty == false) {
      for (var i in idData) {
        //print('followers ID: ${i}');
        idList.add(i['followersId']);
        }
      }

      //print('id list: ${idList}');
      //print('checkpoint 3');

      //same error happen here
      for (var i in idList) {
        //print('var I: ${i}');
        var httpResponse = await http.get(Uri.http('${ipAddress}','/getFollowersUsername/${i}'));
        var httpBody = httpResponse.body;
        //print('http body: ${httpBody}');
        var httpEncoded = convert.jsonDecode(httpBody);
        //print('http encoded: ${httpEncoded}'); no error here
        //the error is the code doesn't run below
        httpEncoded = httpEncoded[0];
        followersUsername = httpEncoded['username'];
        //print('followers username: ${followersUsername}');
        itemInFollowersPage.add(followersTile());
      }

      //print('checkpoint 4');
      return idList;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${chosenUsername} Followers"),
        ),
        body: FutureBuilder(
          future: getFollowers(), builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(itemCount:itemInFollowersPage.length,itemBuilder: (content, index) {
              return itemInFollowersPage[index];
            });
          }
          else {
            return CircularProgressIndicator();
          }
        },
        ));
  }
}

class followersTile extends StatelessWidget{
  var username = followersUsername;
  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(username),onTap: () => {chosenUsername = username,Navigator.push(context, new MaterialPageRoute(builder: (context) => profilePage()))},);
  }
}

