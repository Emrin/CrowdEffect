import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'signup.dart';
import 'room_selection.dart';
import 'room.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/roomselection': (BuildContext context) => new ChatRoomSelectionPage(),
        '/room': (BuildContext context) => new ChatRoomPage()
      },
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final mediaHeight = MediaQuery.of(context).size.height;
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.0, 1.0],
              colors: [
                Color.fromRGBO(65, 67, 69, 1.0),
                Color.fromRGBO(35, 37, 38, 1.0)
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: SafeArea(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: mediaHeight * 0.25,
                alignment: Alignment(-1.0,0.0),
                  // child: Stack(
                  //   children: <Widget>[
                  //     Container(
                  //       child: Text('Crowd',
                  //           style: TextStyle(
                  //               fontSize: 80.0, fontWeight: FontWeight.bold
                  //             )
                  //         ),
                  //     ),
                  //     Container(
                  //       padding: EdgeInsets.only(top: 70.0),
                  //       child: Text('Effect',
                  //           style: TextStyle(
                  //               fontSize: 80.0, fontWeight: FontWeight.bold)),
                  //     ),
                  //   ],
                  // ),
                  child:  AutoSizeText(
                    'Crowd Effect',
                    style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                    maxLines: 2,
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
                                  Navigator.pushReplacementNamed(context, "/roomselection");
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
                        SizedBox(height: mediaHeight * 0.05),
                        Container(
                          height: mediaHeight * 0.07,
                          color: Colors.transparent,
                          child: Material(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black,
                                      style: BorderStyle.solid,
                                      width: 1.0),
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(20.0)),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20.0),
                                onTap: () {
                                },
                                child: 
                                    Center(
                                      child: Text('Sign up with Google',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat')),
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
                  height: mediaHeight * 0.05,
                  child: Center(
                    child: Text(
                      'App made by Emrin & Mattis',
                    ),
                  ),
                ),
            ],
          ),
          ),
        )
      );
  }
}