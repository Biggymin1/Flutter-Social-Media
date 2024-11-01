import 'dart:io';

import 'package:flutter/material.dart';
import 'profilePage.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:convert' as convert;
import 'package:image_picker/image_picker.dart';

import 'deprecatedAdd.dart';

var creationId;
var creationCategory;
var creationImage;

class registerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Contributor Registration"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [imageAndGetImage(), textContainer(),categoryList(),signUpButton()],
        ),
      ),
    );
  }
}

class textContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            margin: const EdgeInsets.only(left: 20.0, right: 20.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
            ),
            width: 350,
            height: 150,
            child: Column(children: [
              emailTextField(),
              passwordTextField(),
              usernameTextField(),
            ])));
  }
}

class emailTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => {email = text},
      decoration: InputDecoration(hintText: "Email", icon: Icon(Icons.email)),
    );
  }
}

class usernameTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => {username = text},
      decoration: InputDecoration(
          hintText: "Username", icon: Icon(Icons.account_circle)),
    );
  }
}

class passwordTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: true,
      onChanged: (text) => {password = text},
      decoration: InputDecoration(hintText: "Password", icon: Icon(Icons.lock)),
    );
  }
}

getProfileId() async {
  var received = await http.get(Uri.http('${ipAddress}:', '/api/profileIdCreate'));
  var body = received.body;
  var body1 = convert.jsonDecode(body);
  var query = body1[0];
  var count = query['count'];
  creationId = count + 1; //this is because it gave us the number of row
  //print('creationId: ${creationId}'); the id is fine

  return creationId;
}

class signUpButton extends StatelessWidget {

  submitImage()async{

    var uploadRequest = new http.MultipartRequest("POST",Uri.http('${ipAddress}','/uploadProfileImage'));
    print('checkpoint 1');

    //print(postImage.path);

    //a good way is to store the postImage = postId
    //but we need to get the post id first if we gonna do that
    //but that gonna cause error if some user is doing at same time
    //so the backend needs to do it in one operation

    var multipartFile = await http.MultipartFile.fromPath('postImage',creationImage.path,filename: '${creationId}'); //imageUrl is the id and the backend will handle either post or profile
    print(multipartFile.filename);
    print(multipartFile.field);
    uploadRequest.files.add(multipartFile);

    http.StreamedResponse response = await uploadRequest.send();

  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("Sign Up"),
        onPressed: () async{
           signUp();
          submitImage();
          if (signUpResponse == "users has been added") {
            //this mean that user is not in database
          } else {}
        });
  }
}

void signUp() async {
  await getProfileId();
  var dataToSend = {
    'password': '${password}',
    'username': '${username}',
    'email': '${email}',
    'id': '${creationId}',
    'categorySpecialization': '${creationCategory}'
  };

  signUpResponse = await (http.post(
      Uri.http('${ipAddress}', '/api/register'),
      headers: {"Content-Type": "application/json"},
      body: convert.jsonEncode(dataToSend)));
}

class imageAndGetImage extends StatefulWidget {
  @override
  _imageAndGetImageState createState() => _imageAndGetImageState();
}

class _imageAndGetImageState extends State<imageAndGetImage> {
  var haveImage = false;
  var imageFile;

  setImage() async{
    imageFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    haveImage = true;
    setState(()  {
      creationImage = File(imageFile.path);
    });
  }

  changeImage() async{
    imageFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      creationImage = File(imageFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.center,
        child: Container(
            child: haveImage == true
                ? Column(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(300.0),
                          child: Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              height: 300,
                              width: 300,
                              child: Image.file(
                                creationImage,
                                fit: BoxFit.fill,
                              ))),
                      ElevatedButton(onPressed: () => {changeImage()}, child: Text("Change image")),
                    ],
                  )
                : Column(
                  children: [ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.lightBlue),
                          height: 300,
                          width: 300,
                          child: Align(alignment: Alignment.center,child: Text("Please choose an image"),
                          ))),
                    ElevatedButton(
                        onPressed: () => {setImage()},
                        child: Text(
                          "Please choose an image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                )));
  }
}

class categoryList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: [businessButton(),technologyButton(),musicButton(),artButton()],);
  }
}

class businessButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {creationCategory = 'business'}, child: Text('Business'));
  }
}

class musicButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {creationCategory = 'music'}, child: Text('Music'));
  }
}

class technologyButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {creationCategory = 'technology'}, child: Text('Technology'));
  }
}

class artButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {creationCategory = 'art'}, child: Text('Art'));
  }
}
