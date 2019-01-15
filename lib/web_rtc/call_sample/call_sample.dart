import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:core';
import 'signaling.dart';
import 'package:flutter_webrtc/webrtc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallSample extends StatefulWidget {
  // User has joined chat room A and got an ID of 42.
  // => Tell Firebase that I am in A and my ID is 42.
  // Show other people in chat room A.
  // => Get list of IDs of people in room A from Firebase.
  // Display only shows people with IDs that are in that list.

  static String tag = 'call_sample';

  final String ip;
  final String roomId;
  final String currentUserId;

  CallSample({Key key, @required this.ip,
  this.roomId, this.currentUserId}) : super(key: key);

  @override
  _CallSampleState createState() => new _CallSampleState(
      serverIP: ip,
      roomId: roomId,
      currentUserId: currentUserId,
  );
}

class _CallSampleState extends State<CallSample> {
  final String roomId;

  Signaling _signaling;
  String _displayName =
      Platform.localHostname + '(' + Platform.operatingSystem + ")";
  List<dynamic> _peers;
  var _selfId;
  RTCVideoRenderer _localRenderer = new RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = new RTCVideoRenderer();
  bool _inCalling = false; // Call mode
  final String serverIP;
  final String currentUserId;

  _CallSampleState({Key key, @required this.serverIP, @required this.roomId,
  @required this.currentUserId});

  @override
  initState() {
    super.initState();
    initRenderers();
    _connect();
  }

  initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  @override
  deactivate() {
    super.deactivate();
    if (_signaling != null) _signaling.close();
  }

  void _connect() async {
    if (_signaling == null) {
      _signaling = new Signaling('ws://' + serverIP + ':4442', _displayName)
        ..connect();

      _signaling.onStateChange = (SignalingState state) {
        switch (state) {
          case SignalingState.CallStateNew:
            this.setState(() {
              _inCalling = true;
            });
            break;
          case SignalingState.CallStateBye:
            this.setState(() {
              _localRenderer.srcObject = null;
              _remoteRenderer.srcObject = null;
              _inCalling = false;
            });
            break;
          case SignalingState.CallStateInvite:
          case SignalingState.CallStateConnected:
          case SignalingState.CallStateRinging:
          case SignalingState.ConnectionClosed:
          case SignalingState.ConnectionError:
          case SignalingState.ConnectionOpen:
            break;
        }
      };

      _signaling.onPeersUpdate = ((event) {
        this.setState(() {
          _selfId = event['self'];
          _peers = event['peers'];
        });
        Firestore.instance.collection('users')
        .document(this.currentUserId)
        .updateData({'sipid': _selfId});
      });

      _signaling.onLocalStream = ((stream) {
        _localRenderer.srcObject = stream;
      });

      _signaling.onAddRemoteStream = ((stream) {
        _remoteRenderer.srcObject = stream;
      });

      _signaling.onRemoveRemoteStream = ((stream) {
        _remoteRenderer.srcObject = null;
      });
    }
  }

  _invitePeer(context, peerId) async {
    if (_signaling != null && peerId != _selfId) {
      _signaling.invite(peerId, 'video');
    }
  }

  _hangUp() {
    if (_signaling != null) {
      _signaling.bye();
    }
  }

  _buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    var listOfNeighbours;
    var users = Firestore.instance.collection('users');
    Query query = users.where('inRoom', isEqualTo: roomId);
    var neighbours = query.getDocuments();

    query.getDocuments().then((val) {
      var list = val.documents.map( (DocumentSnapshot docSnap) {
        return docSnap.data['id'];
      }).toList();
      print(list.toString());
    });

    // if peer['id'] in query return below
    // else return null
    // todo if peer [roomId] is same as roomId return this else return null
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(self
            ? peer['name'] + '[Your self]'
            : peer['name'] + '[' + peer['user_agent'] + ']'),
        onTap: () => _invitePeer(context, peer['id']),
        trailing: Icon(Icons.videocam),
        subtitle: Text('id: ' + peer['id']),
      ),
      Divider()
    ]);
  }

  Future<bool> _onWillPop() async {
    await Firestore.instance
        .collection('users')
        .document(currentUserId)
        .updateData({'inRoom': '', 'sipid': ''});
    return true;
  }

  // Modify this in a way that _build method (original of this class)
  // which I put on the bottom in an isolated manner;
  // is inside of this. Also _inCalling means call mode
  // In call mode a new screen shows where u have 2 cameras (for vid call)
  // and just a hangup icon for audio call.
  //
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    print('roomId : ' + roomId);
    return Scaffold(
      resizeToAvoidBottomPadding: false,

      floatingActionButton: _inCalling // if true show hangup icon
          ? FloatingActionButton(
        onPressed: _hangUp,
        tooltip: 'Hangup',
        child: new Icon(Icons.call_end),
      )
          : null,

      body: _inCalling
          ? OrientationBuilder(builder: (context, orientation) {
        return new Container(
          child: new Stack(children: <Widget>[
            new Positioned(
                left: 0.0,
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: new Container(
                  margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: new RTCVideoView(_remoteRenderer),
                  decoration: new BoxDecoration(color: Colors.black54),
                )),
            new Positioned(
              left: 20.0,
              top: 20.0,
              child: new Container(
                width: orientation == Orientation.portrait ? 90.0 : 120.0,
                height:
                orientation == Orientation.portrait ? 120.0 : 90.0,
                child: new RTCVideoView(_localRenderer),
                decoration: new BoxDecoration(color: Colors.black54),
              ),
            ),
          ]),
        );
      })

          :

      Container(
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
                      Firestore.instance
                          .collection('users')
                          .document(currentUserId)
                          .updateData({'inRoom': '', 'sipid': ''});
                      Navigator.of(context).pop();
                    },
                  )
                ],
              ),
              Container( // This lists all peers.
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.white))
                ),
                child: Column(
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0.0),
                        itemCount: (_peers != null ? _peers.length : 0),
                        itemBuilder: (context, i) {
//                          List<String> neighbourIds = ;
                          return _buildRow(context, _peers[i]);
                        }),
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
                    WillPopScope(
                      onWillPop: _onWillPop,
                      child: Container(

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // original build method
  @override
  Widget _build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      floatingActionButton: _inCalling // if true show hangup icon
          ? FloatingActionButton(
              onPressed: _hangUp,
              tooltip: 'Hangup',
              child: new Icon(Icons.call_end),
            )
          : null,
      body: _inCalling
          ? OrientationBuilder(builder: (context, orientation) {
              return new Container(
                child: new Stack(children: <Widget>[
                  new Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      bottom: 0.0,
                      child: new Container(
                        margin: new EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: new RTCVideoView(_remoteRenderer),
                        decoration: new BoxDecoration(color: Colors.black54),
                      )),
                  new Positioned(
                    left: 20.0,
                    top: 20.0,
                    child: new Container(
                      width: orientation == Orientation.portrait ? 90.0 : 120.0,
                      height:
                          orientation == Orientation.portrait ? 120.0 : 90.0,
                      child: new RTCVideoView(_localRenderer),
                      decoration: new BoxDecoration(color: Colors.black54),
                    ),
                  ),
                ]),
              );
            })
          : new ListView.builder( // if false
              shrinkWrap: true,
              padding: const EdgeInsets.all(0.0),
              itemCount: (_peers != null ? _peers.length : 0),
              itemBuilder: (context, i) {
                return _buildRow(context, _peers[i]);
              }),
    );
  }
}
