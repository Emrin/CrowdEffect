import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'login.dart';

void main() => runApp(new MyApp());

bool _showInfo = false;

class ChatRoomSelectionPage extends StatefulWidget {
  final String currentUserId;

  ChatRoomSelectionPage({Key key, @required this.currentUserId}) : super(key: key);

  @override
  ChatRoomSelectionPageState createState() => new ChatRoomSelectionPageState(currentUserId: currentUserId);
}

class ChatRoomSelectionPageState extends State<ChatRoomSelectionPage>{

  ChatRoomSelectionPageState({Key key, @required this.currentUserId});
  final String currentUserId;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<Null> _handleSignOut() async {
    // this.setState(() {
    //   isLoading = true;
    // });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    // this.setState(() {
    //   isLoading = false;
    // });

    Navigator.of(context)
        .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MyApp()), (Route<dynamic> route) => false);
}

  @override
    Widget build(BuildContext context) {
      final mediaSize = MediaQuery.of(context).size;
      return Scaffold(
        body: Container(
          // Add box decoration
          decoration: BoxDecoration(
            // Box decoration takes a gradient
            gradient: LinearGradient(
              // Where the linear gradient begins and ends
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [0.0, 1.0],
              colors: [
                // Colors are easy thanks to Flutter's Colors class.
                Color.fromRGBO(65, 67, 69, 1.0),
                Color.fromRGBO(35, 37, 38, 1.0)
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child : Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                        height: mediaSize.height * 0.25,
                        alignment: Alignment(-1.0,0.0),
                          child:  AutoSizeText(
                            'Crowd Effect',
                            style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                            maxLines: 2,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          size: 35.0,
                        ),
                        onPressed: (){
                          _handleSignOut();
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: CarouselSlider(
                    items: [1,2,3,4,5].map((i) {
                      return new Builder(
                        builder: (BuildContext context) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed('/room');
                            },
                            child: Container(
                              width: mediaSize.width * 0.7,
                              // margin: new EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: mediaSize.height * 0.25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                                      image: DecorationImage(
                                        // image: NetworkImage('https://source.unsplash.com/collection/$i'),
                                        image: AssetImage('assets/img.jpg'),
                                        fit: BoxFit.cover
                                      )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 24.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Text('Title $i',
                                            style: TextStyle(
                                              fontSize: 25.0,
                                              color: Colors.black
                                            ),
                                          )
                                        ),
                                        Text('$i/10',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Colors.black
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                                         child: SingleChildScrollView(
                                           child: Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ac ante in mi pellentesque scelerisque.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ac ante in mi pellentesque scelerisque.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ac ante in mi pellentesque scelerisque.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ac ante in mi pellentesque scelerisque.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ac ante in mi pellentesque scelerisque.',
                                                style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.grey
                                                ),
                                        ),
                                    ),
                                      ),
                                  )
                                ],
                              )
                            ),
                          );
                        },
                      );
                    }).toList(),
                    height: mediaSize.height * 0.5,
                    distortion: true,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  alignment: Alignment(0, 0),
                  child: Column(
                    children: <Widget>[
                      AnimatedOpacity(
                        opacity: _showInfo ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 500),
                        child: Text('Click on a card to enter the room')
                      ),
                      IconButton(
                        onPressed: (){
                          setState(() {
                             _showInfo = !_showInfo;
                          });
                        },
                        icon: Icon(
                          Icons.info_outline,
                          size: 35.0
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ),
      );
    }
}