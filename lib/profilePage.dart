import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'createPostPage.dart';
import 'followerPage.dart';
import 'loginPage.dart';
import 'postDetailedPage.dart';
import 'updateProfilePage.dart';
import 'dart:convert' as convert;
import 'main.dart';
import 'followingPage.dart';

import 'deprecatedAdd.dart';

/*
the changing of chosen username or chosen id happen in search.dart

yes use chosen
 */

//don't change userId it's declared when logged in

var rank, id, created_at = '';
var margin = 5.0;
var fontsize = 25.0;
var padding = 5.0;
var finishedLoading = false;
var postName,
    postDesc,
    postImage,
    postTarget,
    postContact,
    postCategory,
    postId;

var userPosts = <Widget>[];

//Note: there is a bug that the user has no post so it just stuck

loadUserProfile() async {
  var recievedBodyStringsMain = '';
  userPosts = [];
  print("running loadUserProfile()");
  var request = await http.get(Uri.http('${ipAddress}',
      '/profile/${chosenUsername}')); //this is because we reuse this page for other username

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

  //Filtering making the word looks beautiful
  var created = requestEncoded["created_at"];
  var createdAtList = created.split('-');
  var createdAt3Sub = createdAtList[2];
  var createdAt3 = createdAt3Sub.toString().substring(0, 2);
  created_at = "${createdAtList[0]} ${createdAtList[1]} ${createdAt3}";

  print(created_at);
  categorySpecialization = requestEncoded['category_specialization'];
  //print('rank: ${rank}');

  //debug();
  //for user post data like how many post and the name of each one//second query

  //THE ONLY ERROR IS BECAUSE SOME USER DON"T POST ANYTHING THAT"S WHY IT's EMPTY (solved)
  //Make a code to check if empty.Also the code will stuck if can't find anything that's why you stuck on circularProgress (solved)
  var encodedPostJson =
      convert.jsonDecode(recievedBodyStringsMain); //this is for the posts data
  encodedPostJson =
      encodedPostJson[1]; //this is second query which is post data
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
      } else {
        postImage =
            'http://${ipAddress}/api/getPostImage/${postImgAccessed}.jpg';
      }

      //ayy this is not wrong
      // print('postName: ${postName}');
      userPosts.add(profilePostContainer());
      userPosts.add(spaceBetween());
      i = i + 1;
    }
  }

  //this function return a data but we never used the returned data since all of the data is stored globally (solved)
  //print('userPost ${userPosts}');
  return requestEncoded;

  //the data is received which means the error is in the build
}

debug() {
  var link = ('http://${ipAddress}/api/getProfileImage/${chosenId}');
  print("link:${link}");
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



            Map snapshotData = snapshot.data as Map;

            return Column(
              children: [
                Container(
                    child: Column(
                  //we can load this data at once because the backend sends all of them at the same time in json not individually
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Colors.blueGrey.withOpacity(0.50),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            color: Colors.transparent,
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(300),
                              child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              'http://${ipAddress}/api/getProfileImage/${chosenId}'))))),
                          Container(
                              child: Text(
                                  "${snapshotData!['username']},${snapshotData!['rank']}",
                                  style: TextStyle(
                                      fontSize: 35, color: Colors.white))),
                          Container(
                              child: Text("Id: ${snapshotData['id']}",
                                  style: TextStyle(
                                      fontSize: fontsize,
                                      color: Colors.white))),
                          Container(
                              child: Text("Joined: ${created_at}",
                                  style: TextStyle(
                                      fontSize: fontsize,
                                      color: Colors.white))),
                        ],
                      ),
                    ),
                    Container(color: Colors.transparent,height: 10,), //act as a spacer
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                              child: Text("Followers"),
                              onPressed: () => {
                                    chosenId = snapshotData!['id'],
                                    itemInFollowersPage = [],
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                followerPage()))
                                  }),
                          followFollowingButton(),
                          RaisedButton(
                              child: Text("Following"),
                              onPressed: () => {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                followingPage()))
                                  }),
                        ],
                      ),
                    ),
                    Container(color: Colors.transparent,height: 10,) //spacer
                  ],
                )),
                Container(
                  height: 250,
                  width: 300,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: userPosts,
                  ),
                )
              ],
            );
          } else {
            return CircularProgressIndicator();
          }
        });
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
        title: Text(
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

class profilePostContainer extends StatelessWidget {
  var name = postName;
  var image = postImage;
  var target = postTarget;
  var contact = postContact;
  var category = postCategory;
  var desc = postDesc;
  var id = postId;
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
      },
      child: Container(
        width: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient:
                LinearGradient(colors: [Colors.grey, Colors.blueGrey])),
        child: Expanded(
          child: Column(
            children: [
              Container(
                height: 10,
                color: Colors.transparent,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                    width: 300,
                    height: 40,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          color: Colors.transparent,
                        ),
                        Expanded(
                          child: Text(
                            name,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30),
                          ),
                        ),
                      ],
                    )),
              ),
              Container(
                height: 20,
                color: Colors.transparent,
              ),
              Row(
                children: [
                  Container(
                    width: 30,
                    color: Colors.transparent,
                  ),
                  Expanded(
                    child: Container(
                      height: 90,
                      width: 200,
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Expanded(
                            child: Text(
                              desc,
                              maxLines: 6,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
              Container(
                height: 35,
                color: Colors.transparent,
              ),
              Container(
                width: 300,
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.transparent,
                        child: Text(postCategory,style: TextStyle(color: Colors.white,fontSize: 20),),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

class spaceBetween extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 30, color: Colors.transparent);
  }
}

class followFollowingButton extends StatefulWidget {
  @override
  _followFollowingButtonState createState() => _followFollowingButtonState();
}

class _followFollowingButtonState extends State<followFollowingButton> {
  var currentState = 0; //if following = 1 else = 0

  //just for test
  var stateText;

  void changeState() {
    setState(() {
      if (currentState == 0) {
        currentState = 1;
        stateText = "Following";
      } else {
        currentState = 0;
        stateText = "Follow";
      }
    });
  }

  checkIfFollowing() async {
    print('checking if following');
    var dataToSend = {
      'userId': userId,
      "followingId": id
    }; //there is an error where id is not what we want
    var checkRequest = await http.post(
        Uri.http('${ipAddress}', '/api/checkIfFollowing'),
        body: convert.jsonEncode(dataToSend),
        headers: {'Content-Type': 'application/json'});
    var checkRequestBody = checkRequest.body;
    print("checkRequestBody:${checkRequestBody}");
    var jsonBody = convert.jsonDecode(checkRequestBody);
    if (jsonBody.isEmpty == true) {
      currentState = 0;
      print('this user is not following targetted user');
    } else {
      currentState = 1;
      print('this user is following targetted user');
    }

    if (userId == id) {
      stateText = "Edit Profile"; //not working don't know why
      currentState = 2;
      return 2;
    }

    if (currentState == 0) {
      //0 means not following
      stateText = "Follow";
      return 1;
    } else {
      if (userId == id) {
        stateText = "Edit Profile"; //not working don't know why
        currentState = 2;
        return 2;
      } else {
        if (currentState == 1) {
          stateText = 'Following';
          return 0;
        }
      }
    }
    //print('checkIfFollowingState:${currentState}');
    return stateText;
  }

  void follow() async {
    userId; //userId is declared when we logged in
    var dataToSend = {'userId': userId, 'followingId': id};
    //the profile page is loaded using username instead of id
    //but then we load the whole profile using that username and set the var "id"
    var postRequest = await http.post(Uri.http('${ipAddress}', '/api/follow'),
        body: convert.jsonEncode(dataToSend),
        headers: {"Content-Type": "application/json"});

    var check = checkIfFollowing();
    if (check != currentState) {
      //if the state changes then we rebuild
      setState(() {});
    }
  }

  void unfollow() async {
    var dataToSend = {'userId': userId, 'followingId': id};
    http.post(Uri.http('${ipAddress}', '/api/unfollow'),
        body: convert.jsonEncode(dataToSend),
        headers: {"Content-Type": "application/json"});

    var check = checkIfFollowing();
    if (check != currentState) {
      //if the state changes then we rebuild
      setState(() {});
    }
  }

  void editProfile() {
    Navigator.push(context,
        new MaterialPageRoute(builder: (context) => updateProfilePage()));
  }

  void followOrUnfollowOrEditProfile() {
    print('follow or unfollow or edit');
    print(currentState);
    if (currentState == 0) {
      print('running following');
      follow();
    }
    if (currentState == 2) {
      print('running edit');
      editProfile();
    }
    if (currentState == 1) {
      print('running unfollow');
      unfollow();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("userId:${userId},Id:${id}"); //tested and working
    if (userId == id) {
      currentState = 2;
      print('currentState:${currentState}');
    }

    return RaisedButton(
      onPressed: () => {followOrUnfollowOrEditProfile()},
      child: FutureBuilder(
          future: checkIfFollowing(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(userId == id
                  ? "Edit Profile"
                  : stateText); //this is backup if something fails
            } else {
              return CircularProgressIndicator();
            }
          }),
      color: Colors.blue,
    );
  }
}

class heightComparisonDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
