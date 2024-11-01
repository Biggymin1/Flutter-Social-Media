import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'body.dart' as body;
import 'createPostPage.dart';
import 'package:http/http.dart' as http;
import 'loginPage.dart';
import 'postDetailedPage.dart';
import 'main.dart';
import 'dart:convert' as convert;
import 'postDetailedPage.dart';

var postData, post1, post2, post3;
var followingUsername_forFollowingAlgorithm;

/*
var post1Name,post1Desc,post1Image,post1Target,post1Category;
var post2Name,post2Desc,post2Image,post2Target,post2Category;
var post3Name,post3Desc,post3Image,post3Target,post3Category;
*/

//explore algorithm
exploreAlgorithm() async {
  //for the explore page. totally random stuff
  postData = await http.get(Uri.http('${ipAddress}', '/api/explore'));
  print('data has been received in explore algorithm');
  postData = postData.body;
  // postData = postData[0];
  var postDataFinalized = await convert.jsonDecode(postData);
  post1 = postDataFinalized[0];
  post2 = postDataFinalized[1];
  post3 = postDataFinalized[2];

  //yeah it works now idk -_-
  // print(post1);

  print('returning data in explore algorithm');
  return [post1, post2, post3];
}

loadPostExplore() async {
  var finishedPost1, finishedPost2, finishedPost3;
  var postData = await exploreAlgorithm();
  print('load post explore received data from explore algorithm');

  post1 = postData[0];
  post2 = postData[1];
  post3 = postData[2];

  return [post1, post2, post3];
}

//solve algorithm
solveAlgorithm() async {
  //categorySpecialization is defined when logged in
  postData = await http
      .get(Uri.http('${ipAddress}', '/api/solve/${categorySpecialization}'));
  print('data has been received in solve algorithm');
  postData = postData.body;
  // postData = postData[0];
  postData = convert.jsonDecode(postData);
  post1 = postData[0];
  post2 = postData[1];
  post3 = postData[2];

  //yeah it works now idk -_-
  // print(post1);

  print('returning data in solve algorithm');
  return [post1, post2, post3];
}

loadPostSolve() async {
  var finishedPost1, finishedPost2, finishedPost3;
  var postData = await solveAlgorithm();
  print('load post solve received data from solve algorithm');

  post1 = postData[0];
  post2 = postData[1];
  post3 = postData[2];

  return [post1, post2, post3];
}

//following algorithm
followingAlgorithm() async {
  //this algorithm is not finished (finished now lol)

  getFollowers() async {
    // print('checkpoint 1'); it works now no need for checkpoint
    //userId is defined when logged in
    var followingUsername;
    var idData;
    var idList = [];
    //print('userId: $userId'); //it works till here
    idData = await http.get(Uri.http('${ipAddress}',
        '/getFollowingId/${userId}')); //this return 5 id if have follower
    //print('idData: $idData');

    idData = idData.body;
    idData = convert.jsonDecode(idData);

    //print('idData: $idData');

    //print('id data: ${idData}');
    //print('checkpoint 2');

    //there is an error it will stuck  if user have no follower
    if (idData.isEmpty == false) {
      for (var i in idData) {
        //this access each json
        //print('followers ID: ${i}');
        idList.add(i['followingsId']); //this access folowings id in json
      }
    }

    //print('id list: ${idList}');
    //print('checkpoint 3');

    //same error happen here
    for (var i in idList) {
      //print('var I: ${i}'); //it works till here (tested)
      var httpResponse = await http
          .get(Uri.http('${ipAddress}', '/getFollowersUsername/${i}'));
      var httpBody = httpResponse.body;
      //print('http body: ${httpBody}');
      var httpEncoded = convert.jsonDecode(httpBody);
      //print('http encoded: ${httpEncoded}'); it works
      httpEncoded = httpEncoded[0];
      followingUsername_forFollowingAlgorithm = httpEncoded[
          'username']; //this whole function is a modified version of the 1 in followers page
      //for now we only 1 need 1 because we gonna take that 1 user and load his post
    }

    //print('checkpoint 4');
    return idList;
  }

  //from here we just run our function
  await getFollowers(); //this will set a variable 'followingUsername_forFollowingAlgorithm' into the target username

  //print('wait for followers done');
  //print(followingUsername_forFollowingAlgorithm);

  var followingDataAndHisPostData = await http.get(Uri.http(
      '${ipAddress}', '/profile/${followingUsername_forFollowingAlgorithm}'));
  //reminder postData is in second query

  var bodyData = followingDataAndHisPostData.body;
  var bodyDataDecoded = convert.jsonDecode(bodyData);

  //print('body data decoded: $bodyDataDecoded');

  //accesing 2nd query
  var postData = bodyDataDecoded[1];

  //print('post data: $postData');

  print('returning data in following algorithm');

  post1 = postData[0];
  post2 = postData[1];
  post3 = postData[2];

  return [post1, post2, post3];
}

loadPostFollowing() async {
  var finishedPost1, finishedPost2, finishedPost3;
  var postData = await followingAlgorithm();
  print('load post explore received data from following algorithm');

  post1 = postData[0];
  post2 = postData[1];
  post3 = postData[2];

  return [post1, post2, post3];
}

class postFinished1 extends StatelessWidget {
  var postName = body.post1Name;
  var postImage = body.post1Image;
  var postDesc = body.post1Desc;
  var postTarget = body.post1Target;
  var postContact = body.post1Contact;
  var postCategory = body.post1Category;
  var postId = body.post1Id;
  var postOwner = body.post1Owner;
  var postHasRealImage;

  @override
  Widget build(BuildContext context) {
    if (postImage != 'assets/images/skateLandscape.jpg') {
      postHasRealImage = true;
    } else {
      postHasRealImage = false;
    }
    return InkWell(
      onTap: () => {
        if (postHasRealImage == true)
          {
            chosenPostHasRealImage = true,
          }
        else
          {chosenPostHasRealImage = false},
        chosenPostName = postName,
        chosenPostDescription = postDesc,
        chosenPostImg = postImage,
        chosenPostTarget = postTarget,
        chosenPostContact = postContact,
        chosenPostCategory = postCategory,
        chosenPostId = postId,
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => postDetailedPage()))
      },
      child: Container(
        margin: new EdgeInsets.all(20),
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              child: postHasRealImage
                  ? Container(
                      height: 174,
                      width: 630,
                      child: Image.network(
                        postImage,
                        fit: BoxFit.cover,
                      ))
                  : Image.asset(postImage),
              borderRadius: BorderRadius.circular(15),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(postName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40)),
            ),
            Align(alignment: Alignment.bottomLeft,child: Text(postOwner,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal),))
          ],
        ),
      ),
    );
  }
}

class postFinished2 extends StatelessWidget {
  var postName = body.post2Name;
  var postImage = body.post2Image;
  var postDesc = body.post2Desc;
  var postTarget = body.post2Target;
  var postContact = body.post2Contact;
  var postCategory = body.post2Category;
  var postId = body.post2Id;
  var postOwner = body.post2Owner;
  var postHasRealImage;

  @override
  Widget build(BuildContext context) {
    if (postImage != 'assets/images/skateLandscape.jpg') {
      postHasRealImage = true;
    } else {
      postHasRealImage = false;
    }
    return InkWell(
      onTap: () => {
        if (postHasRealImage == true)
          {
            chosenPostHasRealImage = true,
          }
        else
          {chosenPostHasRealImage = false},
        chosenPostName = postName,
        chosenPostDescription = postDesc,
        chosenPostImg = postImage,
        chosenPostTarget = postTarget,
        chosenPostContact = postContact,
        chosenPostCategory = postCategory,
        chosenPostId = postId,
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => postDetailedPage()))
      },
      child: Container(
        margin: new EdgeInsets.all(20),
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              child: postHasRealImage
                  ? Container(
                      height: 174,
                      width: 630,
                      child: Image.network(
                        postImage,
                        fit: BoxFit.cover,
                      ))
                  : Image.asset(postImage),
              borderRadius: BorderRadius.circular(15),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(postName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40)),
            ),
            Align(alignment: Alignment.bottomLeft,child: Text(postOwner,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal),))
          ],
        ),
      ),
    );
  }
}

class postFinished3 extends StatelessWidget {
  var postName = body.post3Name;
  var postImage = body.post3Image;
  var postDesc = body.post3Desc;
  var postTarget = body.post3Target;
  var postContact = body.post3Contact;
  var postCategory = body.post3Category;
  var postId = body.post3Id;
  var postOwner = body.post3Owner;
  var postHasRealImage;

  @override
  Widget build(BuildContext context) {
    if (postImage != 'assets/images/skateLandscape.jpg') {
      postHasRealImage = true;
    } else {
      postHasRealImage = false;
    }

    return InkWell(
      onTap: () => {
        if (postHasRealImage == true)
          {
            chosenPostHasRealImage = true,
          }
        else
          {chosenPostHasRealImage = false},
        chosenPostName = postName,
        chosenPostDescription = postDesc,
        chosenPostImg = postImage,
        chosenPostTarget = postTarget,
        chosenPostContact = postContact,
        chosenPostCategory = postCategory,
        chosenPostId = postId,
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => postDetailedPage()))
      },
      child: Container(
        margin: new EdgeInsets.all(20),
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              child: postHasRealImage
                  ? Container(
                      height: 174,
                      width: 630,
                      child: Image.network(postImage, fit: BoxFit.cover))
                  : Image.asset(postImage),
              borderRadius: BorderRadius.circular(15),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(postName,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 40)),
            ),
            Align(alignment: Alignment.bottomLeft,child: Text(postOwner,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.normal),))
          ],
        ),
      ),
    );
  }
}

class post extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {},
      child: Container(
        margin: new EdgeInsets.all(20),
        width: 400,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              child: Image.asset(
                'assets/images/skateLandscape.jpg',
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            Text("Lorem Ipsum Dolor Sit Amet",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40))
          ],
        ),
      ),
    );
  }
}
