import 'package:flutter/material.dart';
import 'package:vision/storyPage.dart';

class storyShape extends StatelessWidget {
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
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.lightBlueAccent)),
          margin: EdgeInsets.all(10),
        ),
      ],
    );
  }
}

class storyRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //The problem is the expanded taking space vertically. but only on the bottom
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,

      children: [
    storyShape(),
    storyShape(),
    storyShape(),
    storyShape(),
    storyShape()
      ],
    );
  }
}