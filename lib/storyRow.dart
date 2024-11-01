import 'package:flutter/material.dart';
import 'body.dart';
import 'main.dart';
import 'storyPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'loginPage.dart';

class storyShape extends StatelessWidget {

  var coverId = chosenStoryOwnerId;
  var mediaId = chosenStoryId;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: InkWell(onTap: () => {print('story pressed'),Navigator.push(context, new MaterialPageRoute(builder: (context) => storyPage()))},),
          width: 100,
          height: 100,

          decoration: BoxDecoration(
            image: new DecorationImage(image: NetworkImage('http://${ipAddress}/api/getProfileImage/${coverId}'),fit: BoxFit.cover),
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.lightBlueAccent)),
          margin: EdgeInsets.all(10),
        ),
      ],
    );
  }
}

void loadStory()async{

  var followingsIdList = [];

  //get following
  var followingRequest = await http.get(Uri.http('${ipAddress}','/getFollowingId/${userId}')); //so the request is tested and working
  //the backend sends "following" key
  var followingRequestBody = followingRequest.body;
  var bodyJson = jsonDecode(followingRequestBody); //query
  var accesedJson = bodyJson[0]; //it has been tested till here
  print("accesedQuery:${accesedJson["usersId"]}");
  if(bodyJson.length > 1){
    for(var i in accesedJson){ //for each json in query
      var usersId,followingsId;
      usersId = i['usersId'];
      followingsId = i['followingsId'];
      followingsIdList.add(followingsId);
      print('followingsIdList: ${followingsIdList}');
    }
  }
  else{
    var followingsId = accesedJson["followingsId"];
    followingsIdList.add(followingsId);
    print('followingsIdList: ${followingsIdList}');
  }

  //k it works now

  //check if the people the user is following has a story
  var storyBodyQuery;
  for(var i in followingsIdList){
    var storyRequest = await http.get(Uri.http('${ipAddress}', '/api/getUserStory/${followingsIdList[0]}'));
    var storyRequestBody = storyRequest.body;
    storyBodyQuery = jsonDecode(storyRequestBody);
    print("storyBodyJson:${storyBodyQuery}");

    if(storyBodyQuery.isEmpty == false){
      var firstStoryJson = storyBodyQuery[0]; //we only take the first story from each user that's why we don't use for loop
      var mediaId = firstStoryJson['id'];
      var profileImageId = firstStoryJson['ownerId'];

      chosenStoryId = await mediaId;
      chosenStoryOwnerId = await profileImageId;
      addStory();

    }
  } //this is for each user we follow
}

var itemInStoryRow = <Widget> [];

void addStory(){
  itemInStoryRow.add(storyShape());
  //storyShape won't change after it has been created.
  //storyShape uses a global variable named chosenStoryId in login.dart. you can use this to your advantage
}

class storyRow extends StatefulWidget {
  @override
  _storyRowState createState() => _storyRowState();
}

class _storyRowState extends State<storyRow> {

  checkIfItemInRowIsEmpty()async{
    if(itemInStoryRow.isEmpty == true){
      loadStory();
      print("itemInStoryRow:${itemInStoryRow}");
    }
    return itemInStoryRow;
  }

  @override
  Widget build(BuildContext context) {
    //there is an error where the list can't be empty
    //The problem is the expanded taking space vertically. but only on the bottom
    return FutureBuilder(
      future: checkIfItemInRowIsEmpty(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: itemInStoryRow.length,
              itemBuilder: (context,index){
                return itemInStoryRow[index];
              });
        }
        else{
          return CircularProgressIndicator();
        }
      },
    );
  }
}

//itemInStoryRow.isEmpty == false?itemInStoryRow:<Widget>[Container(child: Text("No Story Available",style: TextStyle(color: Colors.white),),)]

class debugButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {loadStory()}, child: Icon(Icons.ac_unit));
  }
}