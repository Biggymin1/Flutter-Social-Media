import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'loginPage.dart';
import 'main.dart';

class storyPage extends StatelessWidget {

  var requestLink = 'http://${ipAddress}/api/getStory/Media/${chosenStoryId}';
  var storyController = VideoPlayerController.network('http://${ipAddress}/api/getStoryMedia/${chosenStoryId}');

  @override
  Widget build(BuildContext context) {
    print("requestLink:${requestLink}");
    storyController.initialize();
    storyController.play();
    return Scaffold(
      body: InkWell(onTap: () => {storyController.seekTo(Duration.zero)},child: VideoPlayer(storyController)),
      appBar: AppBar(
        title: Text(
          "Story",
          style: TextStyle(color: Colors.blue),
        ),
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
