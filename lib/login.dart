import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CrowdEffect',
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
      ),
      home: LoginScreen(title: 'CrowdEffect'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn) {
      Firestore.instance.collection('users')
      .document(prefs.getString('id'))
      .updateData({"sipid": "", "inRoom": ""})
      .whenComplete((){
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatRoomSelectionPage(currentUserId: prefs.getString('id'))
          ),
      );
      });
    }

    this.setState(() {
      isLoading = false;
    });
  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    try{
      GoogleSignInAccount googleUser = await googleSignIn.signIn().catchError((onError){
        print("Error $onError");
        this.setState(() {
          isLoading = false;
        });
        });
      if (googleUser != null) {
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      FirebaseUser firebaseUser = await firebaseAuth.signInWithGoogle(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      ).catchError((onError) {
            print("error $onError");
            this.setState(() {
              isLoading = false;
            });
      });
      if (firebaseUser != null) {
        // Check is already sign up
        final QuerySnapshot result =
            await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          // Update data to server if new user
          Firestore.instance
              .collection('users')
              .document(firebaseUser.uid)
              .setData({'nickname': firebaseUser.displayName, 'photoUrl': firebaseUser.photoUrl, 'id': firebaseUser.uid, "sipid": "", "inRoom": ""});

          // Write data to local
          currentUser = firebaseUser;
          await prefs.setString('id', currentUser.uid);
          await prefs.setString('nickname', currentUser.displayName);
          await prefs.setString('photoUrl', currentUser.photoUrl);
        } else {
          // Write data to local
          await prefs.setString('id', documents[0]['id']);
          await prefs.setString('nickname', documents[0]['nickname']);
          await prefs.setString('photoUrl', documents[0]['photoUrl']);
        }
        // Fluttertoast.showToast(msg: "Sign in success");
        this.setState(() {
          isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoomSelectionPage(
                    currentUserId: firebaseUser.uid,
                  )
              ),
        );
      } else {
        // Fluttertoast.showToast(msg: "Sign in fail");
        this.setState(() {
          isLoading = false;
        });
      }
    }
    else{
      // Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
    }
    catch(e){
      print("Error $e");
      this.setState(() {
          isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/fond.jpg'),
                fit: BoxFit.fill
            )
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: SafeArea(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: mediaHeight * 0.1),
                  Container(
                    height: mediaHeight * 0.25,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/logo.png'),
                            fit: BoxFit.fitHeight
                        ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Container(
                              height: mediaHeight * 0.07,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.black,
                                color: Colors.grey,
                                elevation: 7.0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black,
                                          style: BorderStyle.solid,
                                          width: 1.0
                                      ),
                                      borderRadius: BorderRadius.circular(20.0)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20.0),
                                    onTap: () {
                                      handleSignIn();
                                    },
                                    child: 
                                        Center(
                                          child: Text('Sign in with Google',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  )
                                                ),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                    ),
                    Container(
                      height: mediaHeight * 0.1,
                      child: Center(
                        child: Text(
                          'App made by Emrin & Mattis',
                        ),
                      ),
                    ),
                ],
            ),
            ),
              ),
            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ]
          ),
        )
      );
  }
}
