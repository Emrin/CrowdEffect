import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';


import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'login.dart';
import 'settings.dart';
import 'room.dart';
import 'add_room.dart';
import 'web_rtc/call_sample/call_sample.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(new MyApp());
} 

class ChatRoomSelectionPage extends StatefulWidget {
  final String currentUserId;

  ChatRoomSelectionPage({Key key, @required this.currentUserId}) : super(key: key);

  @override
  ChatRoomSelectionPageState createState() => new ChatRoomSelectionPageState(currentUserId: currentUserId);
}

class ChatRoomSelectionPageState extends State<ChatRoomSelectionPage>{

  ChatRoomSelectionPageState({Key key, @required this.currentUserId});
  final String currentUserId;

  Future<List> getRooms() async {
    final QuerySnapshot result =
    await Firestore.instance.collection('rooms').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    return documents;
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/fond.jpg'),
                fit: BoxFit.fill
            )
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(height: mediaSize.height *0.025,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child : Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: mediaSize.height * 0.25,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/logo.png'),
                                  fit: BoxFit.fitWidth
                              )
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          size: 35.0,
                        ),
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
                        },
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: BuildRoomCardsList(mediaSize, currentUserId),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: <Widget>[
                      InfoButtonWidget(),
                      Expanded(child: Container()),
                      AddRoomButtonWidget(),
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


Widget BuildRoomCardsList(mediaSize, currentUserId){
  return StreamBuilder(
      stream: Firestore.instance.collection('rooms').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return CarouselSlider(
              items: snapshot.data.documents.map((DocumentSnapshot document) {
                return GestureDetector(
                  onTap: () {
                    Firestore.instance.collection('users')
                    .document(currentUserId)
                    .updateData({'inRoom': document.documentID})
                    .whenComplete((){
                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      CallSample(
                        ip: '192.168.1.10',
                        roomId: document.documentID,
                        currentUserId: currentUserId,
                      )));
                    });
                  },
                  child: Container(
                      width: mediaSize.width * 0.7,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: mediaSize.height * 0.20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                              child: CachedNetworkImage(
                                placeholder: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                  ),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 5.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  ),
                                ),
                                imageUrl: document['imageUrl'],
                                fit: BoxFit.fitWidth,
                                width: double.infinity,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 24.0),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(document['title'],
                                      style: TextStyle(
                                          fontSize: 25.0,
                                          color: Colors.black
                                      ),
                                    )
                                ),
                                (document['creator'] == currentUserId) 
                                ? RaisedButton(
                                  color: Colors.red,
                                  onPressed: () {
                                      Firestore.instance
                                          .collection('rooms')
                                          .document(document.documentID)
                                          .delete()
                                          .whenComplete((){
                                          });
                                  },
                                  child: Text('Delete'),
                                )
                                : Container()
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 20.0),
                              child: SingleChildScrollView(
                                child: Text(document['description'],
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
              }).toList(),
              height: mediaSize.height * 0.40,
              distortion: true,
            );
        }
      }
  );
}

class InfoButtonWidget extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(50.0),
      shadowColor: Colors.black,
      color: Colors.grey,
      elevation: 7.0,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.black,
                style: BorderStyle.solid,
                width: 1.0
            ),
            borderRadius: BorderRadius.circular(50.0)),
        child: InkWell(
          borderRadius: BorderRadius.circular(50.0),
          onTap: () {
              var alertStyle = AlertStyle(
                    animationType: AnimationType.fromBottom,
                    isCloseButton: false,
                    titleStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0
                    ),
                    descStyle: TextStyle(
                      fontSize: 16.0
                    ),
                    animationDuration: Duration(milliseconds: 400),
                    alertBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      side: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
              );
              Alert(context: context,style: alertStyle , title: "Information", desc: "Click on a card to enter the room.", buttons: []).show();
          },
          child: 
              Center(
                child: Icon(
                    Icons.info_outline,
                    size: 30.0
                ),
              ),
        ),
      ),
    );
  }
}


class AddRoomButtonWidget extends StatelessWidget{
    @override
  Widget build(BuildContext context) {
    return 
      Material(
        borderRadius: BorderRadius.circular(50.0),
        shadowColor: Colors.black,
        color: Colors.grey,
        elevation: 7.0,
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  style: BorderStyle.solid,
                  width: 1.0
              ),
              borderRadius: BorderRadius.circular(50.0)),
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddRoomScreen()));
            },
            child: 
                Center(
                  child: Icon(
                      Icons.add,
                      size: 30.0
                  ),
                ),
          ),
        ),
      );
  }
}
