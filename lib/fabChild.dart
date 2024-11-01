import 'package:flutter/material.dart';
import 'createPostPage.dart';
import 'myProjectPage.dart';
import 'createStoryPage.dart';

class fabChild extends StatefulWidget {
  @override
  _fabChild createState() => _fabChild();
}

class _fabChild extends State<fabChild> {

  //The problem here is the touch is not detected

    runStoryPage(){
      Navigator.push(context, new MaterialPageRoute(builder: (context) => createStoryPage(),));
    }

    runProjectPage(){
      Navigator.push(context, new MaterialPageRoute(builder: (context) => projectPage(),));
      print("going to project page");
    }

    runCreatePostPage(){
      Navigator.push(context, new MaterialPageRoute(builder: (context) => postPage(),));
      print("going to create post page");
    }

   open(){
     print(redBottomDistance);
    setState((){
        //check whether open or close. we ue bottom since red go vertically
      if(redBottomDistance == 30.0){
        redBottomDistance = 90.0;
        redRightDistance = 30.0;
        yellowRightDistance = 90.0;
        blueRightDistance = 75.0;
        blueBottomDistance = 75.0;
        print("going up");
      }
      else{
        if(redBottomDistance == 90.0){
          redBottomDistance = 30.0;
          redRightDistance = 30.0;
          yellowRightDistance = 30.0;
          blueRightDistance = 30.0;
          blueBottomDistance = 30.0;
          print("going down");
        }
      }
    });
  }

  var greenRightDistance = 30.0;
  var greenBottomDistance = 30.0;
  var redRightDistance = 30.0;
  var redBottomDistance = 30.0;
  var yellowRightDistance = 30.0;
  var yellowBottomDistance = 30.0;
  var blueBottomDistance = 30.0;
  var blueRightDistance = 30.0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      Positioned(
      right: yellowRightDistance,
      bottom: yellowBottomDistance,
      child: Container(
        height: 50,
        width: 50,
        decoration:
        BoxDecoration(color: Colors.yellow, shape: BoxShape.circle),
        child: InkWell(onTap: () => {runStoryPage()},
          child: Icon(Icons.book_sharp),
        ),
      ),
    ),Positioned(
      right: redRightDistance,
      bottom: redBottomDistance,
      child: Container(
        height: 50,
        width: 50,
        decoration:
        BoxDecoration(color: Colors.red, shape: BoxShape.circle),
        child: InkWell(onTap: () => {runProjectPage()},
          child: Icon(Icons.bookmark),
        ),
      ),
    ),Positioned(
          right: blueRightDistance,
          bottom: blueBottomDistance,
          child: Container(
            height: 50,
            width: 50,
            decoration:
            BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
            child: InkWell(
              onTap: () => runCreatePostPage(),
              child: Icon(Icons.add),
            ),
          ),
        ),Positioned(
          right: greenRightDistance,
          bottom: greenBottomDistance,
          child: Container(
            height: 50,
            width: 50,
            decoration:
                BoxDecoration(color: Colors.green, shape: BoxShape.circle),
            child: InkWell(
              onTap: () => open(),
              child: Icon(Icons.menu),
            ),
          ),
        ),
      ],
    );
  }
}