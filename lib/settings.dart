import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'main.dart';


class SettingsScreen extends StatefulWidget {
  @override
  State createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController controllerNickname;

  SharedPreferences prefs;

  String id = '';
  String nickname = '';
  String photoUrl = '';

  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = new FocusNode();

  @override
  void initState() {
    super.initState();
    readLocal();
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    nickname = prefs.getString('nickname') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';

    controllerNickname = new TextEditingController(text: nickname);

    // Force refresh input
    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      print(value.error);
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(id)
              .updateData({'nickname': nickname, 'photoUrl': photoUrl}).then((data) async {
            await prefs.setString('photoUrl', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image 1');
          print(err);
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image 2');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();

    setState(() {
      isLoading = true;
    });

    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'nickname': nickname, 'photoUrl': photoUrl}).then((data) async {
      await prefs.setString('nickname', nickname);
      await prefs.setString('photoUrl', photoUrl);

      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success");
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: err.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    return 
      Scaffold(
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
            child: Stack(
            children: <Widget>[
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                              height: mediaSize.height * 0.2,
                              alignment: Alignment(-1.0,0.0),
                              child: AutoSizeText(
                                'Settings',
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
                      // Avatar
                      Container(
                        child: Center(
                          child: Stack(
                            children: <Widget>[
                              (avatarImageFile == null)
                                  ? (photoUrl != ''
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
                                            imageUrl: photoUrl,
                                            width: 90.0,
                                            height: 90.0,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(Radius.circular(45.0)),
                                          clipBehavior: Clip.hardEdge,
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 90.0,
                                          color: Colors.grey,
                                        ))
                                  : Material(
                                      child: Image.file(
                                        avatarImageFile,
                                        width: 90.0,
                                        height: 90.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(45.0)),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                              IconButton(
                                icon: Icon(
                                  Icons.camera_alt,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                                onPressed: getImage,
                                padding: EdgeInsets.all(30.0),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.grey,
                                iconSize: 30.0,
                              ),
                            ],
                          ),
                        ),
                        width: double.infinity,
                        margin: EdgeInsets.all(20.0),
                      ),

                      // Input
                      Column(
                        children: <Widget>[
                          // Username
                          Container(
                            child: Text(
                              'Nickname',
                              style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.black),
                            ),
                            margin: EdgeInsets.only(left: 10.0, bottom: 5.0, top: 10.0),
                          ),
                          Container(
                            child: Theme(
                              data: Theme.of(context).copyWith(primaryColor: Colors.black),
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Sweetie',
                                  contentPadding: new EdgeInsets.all(5.0),
                                  hintStyle: TextStyle(color: Colors.grey),
                                ),
                                controller: controllerNickname,
                                onChanged: (value) {
                                  nickname = value;
                                },
                                focusNode: focusNodeNickname,
                              ),
                            ),
                            margin: EdgeInsets.only(left: 30.0, right: 30.0),
                          ),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),

                      // Button
                      Container(
                        child: FlatButton(
                          onPressed: handleUpdateData,
                          child: Text(
                            'UPDATE',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          color: Colors.green,
                          highlightColor: new Color(0xff8d93a0),
                          splashColor: Colors.transparent,
                          textColor: Colors.white,
                          padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                        ),
                        margin: EdgeInsets.only(top: 50.0, bottom: 50.0),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
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
            ],
        ),
          ),
      );
  }
}