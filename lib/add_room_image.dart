import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';


class AddRoomImageScreen extends StatefulWidget {
  final String documentId;
  AddRoomImageScreen({Key key, @required this.documentId}) : super(key: key);

  @override
  AddRoomImageScreenState createState() {
    return AddRoomImageScreenState(documentId: documentId);
  }
}

class AddRoomImageScreenState extends State<AddRoomImageScreen> {

  AddRoomImageScreenState({Key key, @required this.documentId});
  final String documentId;
  bool isLoading = false;

  File roomImageFile;
  String imageUrl = '';

  void readLocal() async {
    Firestore.instance
    .collection('rooms')
    .document(documentId)
    .snapshots()
    .listen((data){
      imageUrl = data['imageUrl'];
    }
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        roomImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = documentId;
    print('filename :' + documentId);
    StorageReference reference = FirebaseStorage.instance.ref().child('rooms/'+fileName);
    StorageUploadTask uploadTask = reference.putFile(roomImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      print(value.error);
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
        Firestore.instance
            .collection('rooms')
            .document(documentId)
            .updateData({'imageUrl': downloadUrl}).then((data) async {
            print('upload OK');
            setState(() {
              isLoading = false;
            });
            // Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            print(err);
            // Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          // Fluttertoast.showToast(msg: 'This file is not an image 1');
          print(err);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('err');
        // Fluttertoast.showToast(msg: 'This file is not an image 2');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      print(err);
      // Fluttertoast.showToast(msg: err.toString());
    });
    
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey we created above
    final mediaSize = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/fond.jpg'),
                fit: BoxFit.fill
            )
          ),
          child: Stack(
          children: <Widget>[ 
            SafeArea(
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
                            'Room image',
                            style: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: Container(),),
                  Container(
                              child: Center(
                                child: Stack(
                                  children: <Widget>[
                                    (roomImageFile == null)
                                        ? (imageUrl != ''
                                            ? Material(
                                                child: CachedNetworkImage(
                                                  placeholder: Container(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                                    ),
                                                    width: 90.0,
                                                    height: 90.0,
                                                    padding: EdgeInsets.all(20.0),
                                                  ),
                                                  imageUrl: imageUrl,
                                                  width: 200.0,
                                                  height: 150.0,
                                                  fit: BoxFit.cover,
                                                ),
                                                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                                clipBehavior: Clip.hardEdge,
                                              )
                                            : Icon(
                                                Icons.photo,
                                                size: 200.0,
                                                color: Colors.grey,
                                              ))
                                        : Material(
                                            child: Image.file(
                                              roomImageFile,
                                              width: 200.0,
                                              height: 150.0,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                            clipBehavior: Clip.hardEdge,
                                          ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.camera_alt,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                      onPressed: getImage,
                                      padding: EdgeInsets.all(30.0),
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.grey,
                                      iconSize: 40.0,
                                    ),
                                  ],
                                ),
                              ),
                              width: double.infinity,
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
                                Firestore.instance
                                    .collection('rooms')
                                    .document(documentId)
                                    .delete()
                                    .whenComplete((){
                                      Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                                    });
                            },
                            child: Text('Cancel'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.0),
                          child: RaisedButton(
                            onPressed: () async{
                              Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                            },
                            child: Text('Submit'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: Container(),),
                ],
              ),
            ),
            ),
            // Loading
              Positioned(
                child: isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.black)),
                        ),
                        color: Colors.white.withOpacity(0.8),
                      )
                    : Container(),
              ),
          ]
          ),
        ),
    );
  }
}