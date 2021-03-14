import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:vision/followerPage.dart';
import 'package:vision/loginPage.dart';
import 'package:vision/postDetailedPage.dart';
import 'dart:convert' as convert;
import 'main.dart';

/*
the changing of chosen username or chosen id happen in search.dart

yes use chosen
 */

var rank, id, created_at = '';
var margin = 5.0;
var fontsize = 25.0;
var padding = 5.0;
var finishedLoading = false;
var postName, postDesc, postImage, postTarget, postContact, postCategory,postId;

var userPosts = <Widget>[];

//Note: there is a bug that the user has no post so it just stuck

loadUserProfile() async {
  var recievedBodyStringsMain = '';
  userPosts = [];
  print("running loadUserProfile()");
  var request = await http.get(Uri.http('${ipAddress}', '/profile/${chosenUsername}')); //this is because we reuse this page for other username

  //print(request); the data has reached here but stuck somewhere below (solved)

  //for data like username,rank,id and etc
  //dart only store response value in variable unlike js where you have a parameter. dart also store request value as a parameter and not variable
  recievedBodyStringsMain = request.body;
  // print('recievedBodyStringsMain: ${recievedBodyStringsMain}');
  var requestEncoded = convert.jsonDecode(recievedBodyStringsMain);
  requestEncoded = requestEncoded[0]; //first query
  requestEncoded = requestEncoded[0]; //the first element in query
  // print('request Encoded: ${requestEncoded}');
  rank = requestEncoded["rank"];
  id = requestEncoded["id"];
  created_at = requestEncoded["created_at"];
  categorySpecialization = requestEncoded['category_specialization'];
  userId = requestEncoded['id'];
  //print('rank: ${rank}');

  //for user post data like how many post and the name of each one//second query

  //THE ONLY ERROR IS BECAUSE SOME USER DON"T POST ANYTHING THAT"S WHY IT's EMPTY (solved)
  //Make a code to check if empty.Also the code will stuck if can't find anything that's why you stuck on circularProgress (solved)
  var encodedPostJson =
      convert.jsonDecode(recievedBodyStringsMain); //this is for the posts data
  encodedPostJson = encodedPostJson[1]; //this is second query which is post data
  // print('encodedPostJson: ${encodedPostJson}');
  if (encodedPostJson.isEmpty == false) {
    for (int i = 0; i != encodedPostJson.length;) {
      var accesedJson = encodedPostJson[i];
      //print("accesedJson: ${accesedJson}");
      postName = accesedJson['name'];
      var postImgAccessed = accesedJson['img_url'];
      postTarget = accesedJson['target'];
      postDesc = accesedJson['description'];
      postCategory = accesedJson['category'];
      postContact = accesedJson['contact'];
      postId = accesedJson['id'];

      if (postImgAccessed == "none") {
        postImage = "assets/images/skateLandscape.jpg";
      }
      else{
        postImage = 'http://${ipAddress}/api/getPostImage/${postImgAccessed}.jpg';
      }

      //ayy this is not wrong
      // print('postName: ${postName}');
      userPosts.add(profilePostTile());
      i = i + 1;
    }
  }

  //this function return a data but we never used the returned data since all of the data is stored globally (solved)
  //print('userPost ${userPosts}');
  return requestEncoded;

  //the data is received which means the error is in the build
}

class profilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black, body: page());
  }
}

class page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadUserProfile(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Container(
                    child: Column(
                  //we can load this data at once because the backend sends all of them at the same time in json not individually
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Colors.blueGrey.withOpacity(0.50),
                      child: Column(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(300),
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  child: Image.network(
                                      'http://${ipAddress}/api/getProfileImage/${chosenId}',fit: BoxFit.fill,))),
                          Container(
                              child: Text("${snapshot.data['username']},${snapshot.data['rank']}", style: TextStyle(fontSize: 35,color: Colors.white))),
                          Container(
                              child: Text("Id: ${snapshot.data['id']}",
                                  style: TextStyle(fontSize: fontsize,color: Colors.white))),
                          Container(
                              child: Text(
                                  "Joined: ${snapshot.data['created_at']}",
                                  style: TextStyle(fontSize: fontsize,color: Colors.white))),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                              child: Text("Followers"),
                              onPressed: () => {
                                    chosenId = snapshot.data['id'],
                                    itemInFollowersPage = [],
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                followerPage()))
                                  }),
                          RaisedButton(
                              child: Text("Following"), onPressed: () => {}),
                        ],
                      ),
                    ),
                  ],
                )),
                Expanded(
                    child: Container(
                  child: ListView(
                    children: userPosts,
                  ),
                ))
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class profileUsername extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: loadUserProfile(),
          builder: (context, snapshot) {
            //this also cause it to run multiple time
            if (snapshot.hasData) {
              return Column(
                //we can load this data at once because the backend sends all of them at the same time in json not individually
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      color: Colors.lightBlue,
                      child: Text("Username: ${chosenUsername}",
                          style: TextStyle(fontSize: fontsize))),
                  Container(
                      color: Colors.lightBlue,
                      child: Text("Rank: ${snapshot.data['rank']}",
                          style: TextStyle(fontSize: fontsize))),
                  Container(
                      color: Colors.lightBlue,
                      child: Text("Id: ${snapshot.data['id']}",
                          style: TextStyle(fontSize: fontsize))),
                  Container(
                      color: Colors.lightBlue,
                      child: Text("Created: ${snapshot.data['created_at']}",
                          style: TextStyle(fontSize: fontsize))),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

class profileText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Username: ${username}",
      style: TextStyle(fontSize: fontsize),
    );
  }
}

class profileRank extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Rank: ${rank}",
        style: TextStyle(fontSize: fontsize),
      ),
      margin: EdgeInsets.all(margin),
      color: Colors.lightBlue,
      padding: EdgeInsets.all(padding),
    );
  }
}

class profileId extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
          "ID: ${id}",
          style: TextStyle(fontSize: fontsize),
        ),
        margin: EdgeInsets.all(margin),
        color: Colors.lightBlue,
        padding: EdgeInsets.all(padding));
  }
}

class profileCreated_at extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(
          "Created At: ${created_at}",
          style: TextStyle(fontSize: fontsize),
        ),
        margin: EdgeInsets.all(margin),
        color: Colors.lightBlue,
        padding: EdgeInsets.all(padding));
  }
}

class profilePostTile extends StatelessWidget {
  var name = postName;
  var image = postImage;
  var target = postTarget;
  var contact = postContact;
  var category = postCategory;
  var desc = postDesc;
  var id = postId;
  @override
  Widget build(BuildContext context) {
    return ListTile(
        tileColor: Colors.black,
        leading: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        onTap: () => {
              chosenPostName = name,
              chosenPostDescription = desc,
              chosenPostTarget = target,
              chosenPostContact = contact,
              chosenPostCategory = category,
              chosenPostId = id,
              chosenPostImg = image,

          //the error is not that wrong var or what. just wrong api. the body makes the chosenPostImg = api. not the id
          //yeah use chosenPostImg
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => postDetailedPage()))
            });
  }
}
