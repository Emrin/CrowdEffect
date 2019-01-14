import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'add_room_image.dart';


class RoomInfo {
  String title = '';
  String description = '';
}

class AddRoomScreen extends StatefulWidget {
  @override
  AddRoomScreenState createState() {
    return AddRoomScreenState();
  }
}

class AddRoomScreenState extends State<AddRoomScreen> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  SharedPreferences prefs;
  RoomInfo roomInfo = new RoomInfo();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/fond.jpg'),
                fit: BoxFit.fill
            )
          ),
          child: SafeArea(
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                            height: mediaSize.height * 0.2,
                            alignment: Alignment(-1.0,0.0),
                            child: AutoSizeText(
                              'Add Room',
                              style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
                              maxLines: 1,
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
                    Form(
                    key: _formKey,
                     child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: TextFormField(
                              validator: (value) {
                                if (value.isEmpty || value.length > 10) {
                                  return 'Please enter valid title (Max. 10)';
                                }
                              },
                              onSaved: (value){
                                roomInfo.title = value;
                              },
                              decoration: new InputDecoration(
                                hintText: 'Enter a title',
                                icon: const Icon(Icons.title),
                                labelStyle:
                                new TextStyle(decorationStyle: TextDecorationStyle.dotted)
                              ),
                            ),
                          ),
                          Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40.0),
                        child: TextFormField(
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          validator: (value) {
                            if (value.isEmpty || value.length > 150) {
                              return 'Please enter valid description (Max. 150)';
                            }
                          },
                          onSaved: (value){
                            roomInfo.description = value;
                          },
                          decoration: new InputDecoration(
                            hintText: 'Enter a description',
                            icon: const Icon(Icons.description),
                            labelStyle:
                            new TextStyle(decorationStyle: TextDecorationStyle.dotted)
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: Container(),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              child: RaisedButton(
                              color: Colors.red,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: RaisedButton(
                              onPressed: () async{
                                // Validate will return true if the form is valid, or false if
                                // the form is invalid.
                                if (_formKey.currentState.validate()) {
                                  // If the form is valid
                                  _formKey.currentState.save();
                                  prefs = await SharedPreferences.getInstance();

                                    DocumentReference room = Firestore.instance
                                    .collection('rooms')
                                    .document();
                                    room.setData({'title': roomInfo.title, 'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/flutter1-15096.appspot.com/o/rooms%2Fnew_channel.png?alt=media&token=cd54fb4a-c4c8-4b54-9b17-3fe74246008c', 'description': roomInfo.description, 'creator': prefs.getString('id')})
                                    .whenComplete((){
                                        print(room.documentID);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddRoomImageScreen(documentId: room.documentID)));

                                      });
                                }
                              },
                              child: Text('Submit'),
                      ),
                    ),
                                        ],
                                      ),
                                    ),
                                      ],
                                    ),
                    )
                                ],
                              ),
                    ),
          ),
          ),
    );
  }
}