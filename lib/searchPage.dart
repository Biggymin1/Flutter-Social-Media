import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'loginPage.dart';
import 'main.dart';
import 'postDetailedPage.dart';
import 'dart:convert' as convert;

import 'profilePage.dart';

var searchResult = <Widget>[searchField()];
var search = '';


class searchPage extends StatefulWidget {
  @override
  _searchPageState createState() => _searchPageState();
}

class _searchPageState extends State<searchPage> {

  makeSearchRequest()async{
    //the first line is making sure the search result doesn't stack
    searchResult = <Widget>[Container(
    color: Colors.black38,
    child: TextField(
    decoration: InputDecoration(hintText: "Post or Users",),
    style: TextStyle(color: Colors.white),
    onChanged: (String str) => {search = str}),
    ),];
    print('searching for ${search}');
    var postReq = await http.get(Uri.http('${ipAddress}','/search/${search}'));
    var postReqResponse = postReq.body;
    var postReqDecoded = convert.jsonDecode(postReqResponse);

    var postSearchResult = postReqDecoded[0];
    var userSearchResult = postReqDecoded[1];

    /*
    print('postSearchResult: ${postSearchResult}');
    print('userSearchResult: ${userSearchResult}'); the data is recieved and readable (tested)
    */


    for(var i in postSearchResult){
      //print(i); //no error until inside setState (tested)
      setState(() {
        var postName = i["name"];
        var postId = i['img_url'];  //just a reminder that id = imageName in backend
        var finalizedUrlForImage = 'http://${ipAddress}/api/getPostImage/${postId}';
        searchResult.add(ListTile(tileColor: Colors.lightGreenAccent,title: Text(postName),));
      });
    }

    for(var i in userSearchResult){
      setState(() {
        var userName = i['username'];
        var id = i['id'];
        searchResult.add(ListTile(tileColor: Colors.red,title: Text(userName),onTap: () => {
          chosenUsername = userName,
          chosenId = id,
          print("chosenUsername:${chosenUsername},chosenId:${chosenId}"),
          Navigator.push(context, new MaterialPageRoute(builder: (context) => profilePage()))
        },));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text("Search"),onPressed: () => makeSearchRequest(),),
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: 1, //had no idea why we use but it works. but even if item is in 1 in list and we use list.length it wont work don't know why
                  itemBuilder: (context, index) {
                    return Column(children: searchResult,);
                  }))
        ]),
    );
  }
}

class searchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: TextField(
          decoration: InputDecoration(hintText: "Post or Users",),
          style: TextStyle(color: Colors.white),
          onChanged: (String str) => {search = str}),
    );
  }
}

/*class searchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(color: Colors.black,child: Text("Search",style: TextStyle(color: Colors.white),),onPressed: () => makeSearchRequest(),);
  }
}*/
