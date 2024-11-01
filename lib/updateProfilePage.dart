import 'dart:convert';

import 'package:flutter/material.dart' ;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'main.dart';

import 'loginPage.dart';

/*
we just need to use profileImage to change profileImage since it automatically overwrite all image
*/

var newCreationCategory_specialization;
var newCreationImage,newPassword,newEmail,newUsername;

class updateProfilePage extends StatefulWidget{
  @override
  _updateProfilePageState createState() => _updateProfilePageState();
}

class _updateProfilePageState extends State<updateProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Update Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [imageAndGetImage(), textContainer(),categoryList(),updateProfileButton()],
        ),
      ),
    );
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
    return ElevatedButton(onPressed: () => {newCreationCategory_specialization = 'business'}, child: Text('Business'));
  }
}

class musicButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {newCreationCategory_specialization = 'music'}, child: Text('Music'));
  }
}

class technologyButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {newCreationCategory_specialization = 'technology'}, child: Text('Technology'));
  }
}

class artButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {newCreationCategory_specialization = 'art'}, child: Text('Art'));
  }
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
      newCreationImage = File(imageFile.path);
    });
  }

  changeImage() async{
    imageFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      newCreationImage = File(imageFile.path);
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
                          newCreationImage,
                          fit: BoxFit.fill,
                        ))),
                ElevatedButton(onPressed: () => {changeImage()}, child: Text("Change image")),
              ],
            )
                : Column(
                  children: [ClipRRect(
                      borderRadius: BorderRadius.circular(300.0),
                      child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.blue),
                          height: 300,
                          width: 300,
                          child: Align(alignment: Alignment.center,child: Text("Choose an image")))),
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
              usernameTextField(),
            ])));
  }
}

class usernameTextField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (text) => {newUsername = text},
      decoration: InputDecoration(
          hintText: "Username", icon: Icon(Icons.account_circle)),
    );
  }
}

updateProfile()async{
  var dataToSend = {'userId':userId,"newUsername":newUsername,"newCategory":newCreationCategory_specialization};

  //upload newImage (tested and working)
  var uploadRequest = new http.MultipartRequest("POST",Uri.http('${ipAddress}','/uploadProfileImage'));
  var multipartFile = await http.MultipartFile.fromPath('postImage',newCreationImage.path,filename: '${userId}'); //imageUrl is the id and th
  uploadRequest.files.add(multipartFile);
  uploadRequest.send();

  //upload data (tested and working)
  var uploadDataRequest = await http.post(Uri.http('${ipAddress}', '/api/updateProfile'),body: jsonEncode(dataToSend),headers: {"Content-Type":'application/json'});
}

class updateProfileButton extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {updateProfile()}, child: Text("Update Profile"));
  }
}