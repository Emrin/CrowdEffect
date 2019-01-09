import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ChatRoomSelectionPage extends StatelessWidget{
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
                // Container(
                //   height:  mediaSize.height * 0.2,
                //   padding: EdgeInsets.symmetric(horizontal: 20.0),
                //   alignment: Alignment(-1.0,0.0),
                //     child: Container(
                //       child: Text('CrowdEffect',
                //           style: TextStyle(
                //               fontSize: 60.0, fontWeight: FontWeight.bold)),
                //     ),
                //   ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child : Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                        height: mediaSize.height * 0.25,
                        alignment: Alignment(-1.0,0.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                child: Text('Crowd',
                                    style: TextStyle(
                                        fontSize: 80.0, fontWeight: FontWeight.bold)),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 70.0),
                                child: Text('Effect',
                                    style: TextStyle(
                                        fontSize: 80.0, fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Icon(
                        Icons.settings,
                        size: 35.0,
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
                  child: IconButton(
                    onPressed: ()=>{},
                    icon: Icon(
                      Icons.info_outline,
                      size: 35.0
                    ),
                    tooltip: "Click on the card to enter the room",
                  ),
                )
              ],
            ),
          )
        ),
      );
    }
}