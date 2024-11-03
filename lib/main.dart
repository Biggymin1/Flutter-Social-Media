import 'package:flutter/material.dart';
import 'fabChild.dart';
import 'profilePage.dart';
import 'topButton.dart';
import 'post.dart';
import 'body.dart';
import 'fabChild.dart';
import 'loginPage.dart';
import 'searchPage.dart';

/*
Progress:
1)don't forget to add delete old story when loading (easy but won't be done until final)
2)Follow following button funcitionality (done)
3)bug
4}3d model (done)
 */

//our problem here is that our homeButton class has container that need to be in body but it also has FBA (solved)
//that need to be in scaffold (solved)
//userId is still null when we logged in (solved)

/*
All of the algorithm is in post.dart
username is the user username when logged in while chosenUsername is when viewing profile
for now there should be only 4 posts and specialization category business,technology,music,art
most variable is written like 'umum' like username,userId and etc. if there is chosen that might be for profile page

chosen post image will be a url not id in string example:
www.getPost/id

if your post url is all correct. check if the format is correct

the profile in backend automatically add '.jpg'
but not for post

*/

//userId has been set when logged in no need to call an api again (IMPORTANT)

//this is the only ip address we uses. for other script just import from here don't make new ip address variable for organising
//vision-biggymin.herokuapp.com is our url
var ipAddress = 'localhost:3000';
/*we have 2 choices localhost or heroku.
If we use heroku just change the address to the url
remeber that heroku is https while localhost is http*/

/*
wanIp:xxx.xxx.xxx.xxx
staticIp:xxx.xxx.xxx.xxx
 */

//chosenStuff is at loginPage.dart
//post 1,2,3 is in body.dart

//we can't just add a widget into a list.We need to make a widget that changes its data only when created.

var debugMode = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(debugShowCheckedModeBanner: false, home: loginPage()),
  );
}

class mainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Container(
            child: InkWell(
              onTap: () => {
                chosenUsername = username,chosenId = userId,
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => profilePage(),
                    ))
              },
              child: Icon(Icons.supervised_user_circle_outlined),
            ),
            decoration: BoxDecoration(shape: BoxShape.circle)),
        actions: [
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => searchPage(),
                  )))
        ],
        title: Text(
          "Vision",
          style: TextStyle(fontSize: 50, fontStyle: FontStyle.italic),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [body(), fabChild()],
      ),
    );
  }
}
