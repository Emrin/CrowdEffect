import 'package:flutter/material.dart';

import 'signup.dart';
import 'room_selection.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/signup': (BuildContext context) => new SignupPage(),
        '/rooms': (BuildContext context) => new ChatRoomSelectionPage(),
        
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
                height: mediaHeight * 0.3,
                alignment: Alignment(-1.0,0.0),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(15.0, 00.0, 0.0, 0.0),
                        child: Text('Chat',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(16.0, 70.0, 0.0, 0.0),
                        child: Text('Room',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: mediaHeight * 0.1,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                            ),
                          ),
                        ),
                        Container(
                          height: mediaHeight * 0.1,
                          child: TextField(
                            style: TextStyle(
                              color: Colors.white
                            ),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white)
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)
                                ),
                            ),
                            obscureText: true,
                          ),
                        ),
                       GestureDetector(
                              onTap: () {
                               Navigator.of(context).pushNamed('/rooms');
                              },
                          child:  Container(
                          height: mediaHeight * 0.06,
                          child: Material(
                            borderRadius: BorderRadius.circular(20.0),
                            shadowColor: Colors.black,
                            color: Colors.grey,
                            elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: mediaHeight * 0.02),
                        Container(
                          height: mediaHeight * 0.06,
                          color: Colors.transparent,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 1.0
                                ),
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20.0)
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child:
                                      // ImageIcon(AssetImage('assets/facebook.png')),
                                      Text("fb")
                                ),
                                SizedBox(width: 10.0),
                                Center(
                                  child: Text('Log in with facebook',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          )
                                        ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: mediaHeight * 0.02),
                      ],
                    ),
                )
                ),
                Container(
                  height: mediaHeight * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'New to ChatRoom ?',
                      ),
                      SizedBox(width: 5.0),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushNamed('/signup');
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ),
            ],
          ),
          ),
        )
      );
  }
}