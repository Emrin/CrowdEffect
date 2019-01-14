import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'chat.dart';


class ChatRoomPage extends StatefulWidget {
  final String roomId;

  ChatRoomPage({Key key, @required this.roomId}) : super(key: key);

  @override
  ChatRoomPageState createState() => new ChatRoomPageState(roomId: roomId);
  // _ChatRoomPageState createState() => new _ChatRoomPageState();
}

class ChatRoomPageState extends State<ChatRoomPage> {
  final String roomId;
  ChatRoomPageState({Key key, @required this.roomId});

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
                      Row(
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
                        StartButtonWidget(),
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


class StartButtonWidget extends StatelessWidget{
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => RTCScreen()));
            },
            child:
            Center(
              child: Icon(
                  Icons.call,
                  size: 30.0
              ),
            ),
          ),
        ),
      );
  }
}
