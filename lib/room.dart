import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:core';
import 'web_rtc/basic_sample/basic_sample.dart';
import 'web_rtc/call_sample/call_sample.dart';
import 'web_rtc/route_item.dart';

///
/// This will be implemented inside call_sample.dart
///

class ChatRoomPage extends StatefulWidget {
  final String roomId;

  List<RouteItem> items;
  String _serverAddress = '';
  SharedPreferences prefs;

  ChatRoomPage({Key key, @required this.roomId}) : super(key: key);

  @override
  ChatRoomPageState createState() => new ChatRoomPageState(roomId: roomId);

}

class ChatRoomPageState extends State<ChatRoomPage> {
  final String roomId;
  ChatRoomPageState({Key key, @required this.roomId});

  String _serverAddress = '';
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    print('roomId : ' + roomId);
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
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: mediaSize.height * 0.2,
                        alignment: Alignment(-1.0,0.0),
                        child: AutoSizeText(
                          'Room Title',
                          style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 35.0,
                      ),
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                Container(
                  height: mediaSize.height * 0.3,
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white))
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(child: Center(child: Text('ROBERT DENIRO'))),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.thumb_up),
                                    onPressed: (){
                                      // Navigator.pop(context);
                                    }
                                ),
                                Text('10'),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                    icon: Icon(Icons.thumb_down),
                                    onPressed: (){
                                      // Navigator.pop(context);
                                    }
                                ),
                                Text('10'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row( // these will be users and call button
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  labelText: 'Enter IP of peer'
                              ),
                            ),
                          ),
                          Expanded(
                              child: IconButton(
                                  icon: Icon(Icons.call),
                                  onPressed: (){
                                    print("Pressed Call");
                                  }
                              )
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Expanded(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.phone),
                          title: Text('Call'),
                        ),
                          ListTile(
                            title: Text('P2P Call Sample'),
                            onTap: () => RouteItem(
                                title: 'P2P Call Sample',
                                subtitle: 'P2P Call Sample.',
                                push: (BuildContext context) {
                                  _serverAddress = '192.168.1.4';
                                  prefs.setString('server', _serverAddress);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CallSample(ip: _serverAddress)));
                                }).push(context),
                            trailing: Icon(Icons.arrow_right),
                          ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }

}
