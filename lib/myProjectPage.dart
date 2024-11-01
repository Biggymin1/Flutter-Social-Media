import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'createPostPage.dart';
import 'loginPage.dart';
import 'postDetailedPage.dart';
import 'main.dart';
import 'package:http/http.dart' as http;

var savedPostTileName;
var savedPostTileId;
var savedPostTileImage,
    savedPostTileDesc,
    savedPostTileCategory,
    savedPostTileOwner, //this is saved in username
    savedPostTileTarget,
    savedPostTileOwnerId, //the id need to take the username get the id and etc
    savedPostTileContact;

class projectPage extends StatefulWidget {
  @override
  _projectPage createState() => _projectPage();
}

class _projectPage extends State<projectPage> {
  var itemInSavedProjectList = <Widget>[];

  goToMainPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => mainPage()));
  }

  getOwnerIdByUsername(var username)async{
    print('getting owner id by username ${username}');
    var request = await http.get(Uri.http(ipAddress,"/getUsernameId/${username}"));
    var bodyJson = jsonDecode(request.body);
    var query = bodyJson[0];
    var id = query['id'];
    return id;
  }

  loadSavedProject() async {
    print('running loadSavedProject()');
    //getting the id
    var savedProjectIdList = [];
    var request =
        await http.get(Uri.http(ipAddress, '/api/getSavedProjectId/${userId}'));
    var requestBody = jsonDecode(request.body);
    print("requestBody:${requestBody}");
    for (var i in requestBody) {
      //savedProject userId and postsId
      var postId = i['postsId'];
      savedProjectIdList.add(postId);
    } //tested and working till here

    //getting the data for each id, and changin the global var AND adding the widget
    print("savedProjectIdList:${savedProjectIdList}");
    for (var i in savedProjectIdList) {
      print(savedProjectIdList);
      var postId = i;
      print("postId:${postId}");
      var postDataReq =
          await http.get(Uri.http(ipAddress, '/api/getPostData/${postId}'));
      var postDataReqBody = postDataReq.body;
      var postDataReqBodyDecoded = jsonDecode(postDataReqBody);
      var postDataAccesed = postDataReqBodyDecoded[0];
      print("postDataDecoded:${postDataAccesed}");
      //finished request

      //started changing global variable
      savedPostTileName = postDataAccesed['name'];
      savedPostTileImage = postDataAccesed['img_url'];
      savedPostTileCategory = postDataAccesed['category'];
      savedPostTileOwner = postDataAccesed['postOwner'];
      savedPostTileDesc = postDataAccesed['description'];
      savedPostTileTarget = postDataAccesed['target'];
      savedPostTileContact = postDataAccesed['contact'];
      savedPostTileId = postId;

      savedPostTileOwnerId = await getOwnerIdByUsername(savedPostTileOwner);
      print("savedPostTileOwnerId:${savedPostTileOwnerId}");

      //adding the widget
      itemInSavedProjectList.add(Container(
        height: 2,
        width: MediaQuery.of(context).size.width,
        color: Colors.black,
      ));
      itemInSavedProjectList.add(projectContainer());
    }
    return itemInSavedProjectList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Saved Project",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: loadSavedProject(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: itemInSavedProjectList.length,
                itemBuilder: (context, index) {
                  return itemInSavedProjectList[index];
                });
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class projectContainer extends StatelessWidget {
  var postName = savedPostTileName;
  var postId = savedPostTileId;
  var postImage = 'http://${ipAddress}/api/getPostImage/${savedPostTileId}';
  var postDesc = savedPostTileDesc;
  var postCategory = savedPostTileCategory;
  var postOwner = savedPostTileOwner;
  var postOwnerId = savedPostTileOwnerId;
  var postTarget = savedPostTileTarget;
  var postContact = savedPostTileContact;

  @override
  Widget build(BuildContext context) {
    //print("${postName},${postId},${postImage},${postDesc},${postCategory},${postOwner},${postTarget},${postContact[0]}");

    return ListTile(
      tileColor: Colors.white70,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(300.0),
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                  image: NetworkImage(
                      'http://${ipAddress}/api/getProfileImage/${postOwnerId}'))),
        ),
      ),
      title: Text(postName),
      subtitle: Text(postOwner),
      onTap: () => {
        chosenPostId = postId,
        chosenPostName = postName,
        chosenPostImg = postImage,
        chosenPostCategory = postCategory,
        chosenPostDescription = postDesc,
        chosenPostContact = postContact,
        chosenPostTarget = postTarget,
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => postDetailedPage())),
      },
    );
  }
}
