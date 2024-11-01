import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'createPostPage.dart';
import 'dart:io';
import 'main.dart';
import 'dart:convert';
import 'loginPage.dart';

var haveMedia = false;
File? choosenMedia;

class createStoryPage extends StatefulWidget {
  @override
  _createStoryPageState createState() => _createStoryPageState();
}

class _createStoryPageState extends State<createStoryPage> {
  VideoPlayerController? controller;

  void openCamera() async {
    var media = await ImagePicker.platform.pickVideo(source: ImageSource.camera);
    choosenMedia = File(media!.path);
    if (choosenMedia != null) {
      setState(() {
        print("chosenMedia: ${choosenMedia}");
        haveMedia = true;
        controller = VideoPlayerController.file(choosenMedia!);
      });
    } else {
      haveMedia = false;
    }
  }

  void reset() {
    haveMedia = false;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (haveMedia == true) {
      print('initializing video');
      controller!.initialize();
      controller!.play();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Story'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        leading:
            ElevatedButton(onPressed: () => {reset()}, child: Icon(Icons.undo)),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              child: Icon(Icons.camera),
              onPressed: () => {openCamera()},
            ),
          ),
          Container(
            child: haveMedia == true
                ? Container(color: Colors.blue, child: VideoPlayer(controller!))
                : Align(alignment: Alignment.center, child: Text("No video")),
            height: 500,
            width: 300,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.lightBlueAccent),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () => {if(haveMedia == true){
                    controller!.seekTo(Duration.zero)
                  }},
                  child: Icon(Icons.cached)),
              submitStoryButton(),
            ],
          )
        ],
      ),
    );
  }
}

class submitStoryButton extends StatelessWidget {
  void submitStory() async {

    //getting current id for story
    var idRequest = await http.get(Uri.http('${ipAddress}', '/api/getStoryId'));
    var requestResponse = idRequest.body;
    var responseJson = jsonDecode(requestResponse);
    print("responseJson:${responseJson}");
    var creationId = responseJson["storyId"];
    print('creationId:${creationId}');

    //uploading the data to database
    var dataToSend = {
      'storyId': creationId,
      'ownerId': userId
    }; //the backend takes 'storyId' and ownerId'
    var newData = jsonEncode(dataToSend);
    print("uploading story data");
    var postStory = await http.post(Uri.http('${ipAddress}', '/api/createStory'), body: newData, headers: {"Content-Type": "application/json"});
    print("done");

    //uploading the file
    var uploadRequest = new http.MultipartRequest(
        "POST", Uri.http('${ipAddress}', '/uploadStoryMedia'));
    print('checkpoint 1');

    var multipartFile = await http.MultipartFile.fromPath(
    'storyMedia', choosenMedia!.path,
    filename: '${creationId}'); //the backend will add the extension later
    print(multipartFile.filename);
    print(multipartFile.field);
    uploadRequest.files.add(multipartFile);

    http.StreamedResponse response = await uploadRequest.send();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () => {submitStory()}, child: Text("Create Story"));
  }
}
