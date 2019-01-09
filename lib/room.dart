import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ChatRoomPage extends StatefulWidget {
  @override
  ChatRoomPageState createState() => new ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
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
                height: mediaSize.height * 0.2,
                child: AutoSizeText(
                  'Room Title',
                  style: TextStyle(fontSize: 80.0),
                  maxLines: 2,
                ),
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
                          child: IconButton(
                            icon: Icon(Icons.thumb_up),
                            onPressed: (){
                              Navigator.pop(context);
                            }
                          )
                          ),
                        Expanded(child: IconButton(icon: Icon(Icons.thumb_down), onPressed: (){},))
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: Expanded(
                    child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.map),
                        title: Text('Map'),
                      ),
                      ListTile(
                        leading: Icon(Icons.photo_album),
                        title: Text('Album'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('Phone'),
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