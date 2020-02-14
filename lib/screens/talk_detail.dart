import 'package:flutter/material.dart';

class TalkDetail extends StatelessWidget {
  // static final String path = "lib/src/pages/profile/profile5.dart";

  final String title;
  final String speaker;
  final String time;
  final String day;
  final String category;
  final String room;
  final Color bgcolor;

  TalkDetail({
    this.title,
    this.speaker,
    this.time,
    this.day,
    this.category,
    this.room,
    this.bgcolor,
  });

  @override
  Widget build(BuildContext context) {
    final Color color1 = Colors.blue;
    final Color color2 = Color(0xff33B7FF);

    return Scaffold(

      body: Stack(
        children: <Widget>[
          Hero(
            tag: bgcolor,
            child: Container(
              height: 360,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                /*gradient: LinearGradient(
                    colors: [color1, color2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),*/
                color: bgcolor,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: Column(
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontStyle: FontStyle.italic),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: double.infinity,
                  height: 400,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(blurRadius: 10, color: Colors.grey)
                            ]),
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                child: Center(
                                  child: Text(
                                    "Topic Information",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Divider(
                                color: Colors.black38,
                              ),
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text("Speaker"),
                                    subtitle: Text(speaker),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.calendar_today),
                                    title: Text("Day"),
                                    subtitle: Text(day),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.room),
                                    title: Text("Room"),
                                    subtitle: Text(room),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.timer),
                                    title: Text("Time"),
                                    subtitle: Text(time),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.settings_overscan,
          color: Colors.black,
        ),
        backgroundColor: bgcolor,
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
