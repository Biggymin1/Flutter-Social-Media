import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'loginPage.dart';
import 'dart:convert' as convert;
import 'main.dart';
import 'loginPage.dart';
import 'package:path/path.dart';

import 'deprecatedAdd.dart';

var postName, postDesc, postCreator, target, category, contact, imageUrl,postImage,postImageName;

//imagUrl is the post name in storage

Map? dataToSend;

getPostUrl() async{
  var received = await http.get(Uri.http('${ipAddress}', '/api/postIdCreate'));
  var body = received.body;
  var body1 = convert.jsonDecode(body);
  var query = body1[0];
  var count = query['count'];
  imageUrl = count + 1; //this is because it gave us the number of row

  return count;
}

submitPost() async{

  print('submit post()');
  print('imageUrl: ${imageUrl}');

  if (imageUrl == null) {
    imageUrl = "none";
  }

  if (category == null) {
    category = 'none';
  }

  dataToSend = {
    "nameOfPost": postName,
    "postDesc": postDesc,
    "contact": contact,
    "target": target, //all these property is changed in the input field except imageUrl
    "imageUrl": imageUrl,
    "category": category,
    "postOwner": username
  };
  http.post(Uri.http('${ipAddress}','/api/createPost'),
      body: convert.jsonEncode(dataToSend),
      headers: {"Content-Type": "application/json"});
}

class postPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Publish a post"),
      ),
      backgroundColor: Colors.black38,
      body: Center(
          child: SingleChildScrollView(
              child: Column(
        children: [imageChooser(), textContainer(), submitButton()],
      ))),
    );
  }
}

class textContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          postNameTextField(),
          postDescTextField(),
          targetTextField(),
          contactTextField()
        ],
      ),
    );
  }
}

class postNameTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => {postName = text},
      decoration: InputDecoration(
        hintText: "Post Name",
      ),
    );
  }
}

class postDescTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => {postDesc = text},
      decoration: InputDecoration(hintText: "Post Description"),
    );
  }
}

class targetTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => {target = text},
      decoration: InputDecoration(
          hintText:
              "Post Target. Example what can this project do to the world"),
    );
  }
}

class contactTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => {contact = text},
      decoration: InputDecoration(
          hintText:
              "Contact maybe Instagram,Twitter,Whatsapp or Email the choice is yours"),
    );
  }
}

class submitButton extends StatelessWidget {

  submitImage()async{
    var baseName = basename(postImage.path);
    print(baseName);
    postImageName = baseName;

    var uploadRequest = new http.MultipartRequest("POST",Uri.http('${ipAddress}','/uploadPostImage'));
    print('checkpoint 1');

    //print(postImage.path);

    //a good way is to store the postImage = postId
    //but we need to get the post id first if we gonna do that
    //but that gonna cause error if some user is doing at same time
    //so the backend needs to do it in one operation

    var multipartFile = await http.MultipartFile.fromPath('postImage',postImage.path,filename: imageUrl.toString()); //imageUrl is the id and the backend will handle either post or profile
    print(multipartFile.filename);
    print(multipartFile.field);
    uploadRequest.files.add(multipartFile);

    http.StreamedResponse response = await uploadRequest.send();

  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("Submit Post"), onPressed: () async => {await getPostUrl(),submitPost(),submitImage()});
    //get post url is for getting the id
  }
}

class imageChooser extends StatefulWidget {
  @override
  _imageChooserState createState() => _imageChooserState();
}

class _imageChooserState extends State<imageChooser> {
  var image;
  var file;

  Future getImage() async{
    file = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    postImage = File(file.path);

    setState(() {
      image = File(file.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            child: Text("GET IMAGE"), onPressed: () => {getImage()}),
        image == null
        ? ElevatedButton(onPressed: () => {}, child: Text("test"))
            : ClipRRect(child: Image.file(image),)
      ],
    );
  }
}
