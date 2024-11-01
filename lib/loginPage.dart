import 'body.dart';
import 'post.dart';
import 'profilePage.dart';
import 'registerPage.dart';
import 'main.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';
import 'package:flutter_cube/flutter_cube.dart';

import 'deprecatedAdd.dart';

//profile stuff
var email, username, password = '';
var loginAuthentication, signUpResponse;
var chosenUsername, chosenId;
var categorySpecialization;
var userId;

//story stuff
var chosenStoryId;
var chosenStoryOwnerId;

Route route = MaterialPageRoute(builder: (context) => mainPage());

//this is not used. use fetchLoginAuthentication instead
login() {
  var dataToSend;
  dataToSend = {"username": username, "password": password};
  http.post(Uri.http('${ipAddress}', '/api/login'),
      body: convert.jsonEncode(dataToSend),
      headers: {"Content-Type": "application/json"});

  fetchLoginAuthentication();
}

Future<bool> fetchLoginAuthentication() async {
  var dataToSend;
  var loginJsonStrings = '';
  dataToSend = {"username": username, "password": password};
  print('fetching login');
  var uri = Uri.http('${ipAddress}', '/api/login');
  print('uri http: ${uri}');
  var loginResponse = await http.post(Uri.http('${ipAddress}', '/api/login'),
      body: convert.jsonEncode(dataToSend),
      headers: {"Content-Type": "application/json"});

  if (loginResponse.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    loginJsonStrings = loginResponse.body;
    Map<String, dynamic> responseJson = convert.jsonDecode(loginJsonStrings);
    //print(responseJson);
    loginAuthentication = responseJson['loginAuthentication'];
    userId = responseJson['userId'];
  }

  return true;
}

waitForLoginAuthentication() async {
  await fetchLoginAuthentication();
  if (loginAuthentication == true) {
    //the chosen username gonna be what the user typed in the login
    chosenUsername = username;
    await loadUserProfile();
    print("user category specialization: ${categorySpecialization}");
  }
}

class loginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (debugMode == true) {
      //used if you want to debug without internet connection
      Navigator.pushReplacement(context, route);
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text("Contributor Login"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(width: 300,height: 300,color: Colors.transparent,child: FittedBox(child: Image.asset('assets/images/logo new.png')),),
            textContainer(),
            signInButton(),
            Container(
              height: 40,
            ),
            Text(
              "If you don't have an account you can sign up here",
              style: TextStyle(color: Colors.white),
            ),
            registerUpButton()
          ],
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
            height: 100,
            child: Column(children: [
              usernameTextField(),
              passwordTextField(),
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

class signInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.black,
        shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
        onPressed: () async {
          //the backend sends a bool if username is matched
          await waitForLoginAuthentication(); //this might seem weird but this wait function actually run the check username and password function
          print('loginAuthentication: ${loginAuthentication}');
          if (loginAuthentication == true) {
            Navigator.pushReplacement(context, route);
          }
        });
  }
}

class registerUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("Register"),
        onPressed: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => registerPage()));
        });
  }
}

class signUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        child: Text("Sign Up"),
        onPressed: () {
          signUp();
          if (signUpResponse == "users has been added") {
            //this mean that user is not in database
          } else {}
        });
  }
}

void signUp() {
  Future<String> getResponse() async {
    signUpResponse =
        await (http.post(Uri.http('http://${ipAddress}', '/api/register')));
        return signUpResponse.body;
  }
}
