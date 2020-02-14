import 'package:bcy_twenty/data/attended.dart';
import 'package:bcy_twenty/data/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Profile extends StatelessWidget {



  Profile(
      {
        Key key,
        this.title,
        this.uuid,
        this.email,
        this.img,
        this.name,
        this.tshirt_size,
      }
  ) : super(key: key);
  final String title;
  final String uuid;
  final String email;
  final String img;
  final String name;
  String tshirt_size;





  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    topBCYPass(){
      return Container(
        padding: EdgeInsets.all(16),
        width: 350,
        height: 225,
        decoration: BoxDecoration(
          color: isDark ? Color(0xff272727) : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Barcamp\nYangon\n2020',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: GoogleFonts.courierPrime().fontFamily,
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'February 15,16\n8AM - 5PM',
                      style: TextStyle(
                        fontFamily: GoogleFonts.courierPrime().fontFamily,
                      ),
                    ),
                  )
                ],
              ),
            ),

            Column(
              children: <Widget>[
                Text(
                  '#bcy2020',
                  style: TextStyle(
                    fontFamily: GoogleFonts.novaMono().fontFamily,
                  ),
                ),

                Image.network(
                  'https://pbs.twimg.com/profile_images/619941689/barcampyangon_400x400.png',
                  width: 100,
                  height: 100,
                ),
              ],
            )

          ],
        ),

      );
    }

    generateQR(String qrString){
      return Container(
        width: 100,
        height: 150,
        //QR
        child: Center(
          child: QrImage(
            data: qrString,
            version: QrVersions.auto,
            size: 150.0,
            // foregroundColor: isDark ? Colors.white : Colors.black,
            backgroundColor: Colors.white,
          ),
        ),

      );
    }

    void _showQRDialog(){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Scan This"),
            content: generateQR('$uuid ; $tshirt_size'),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    bottomBCYPass(){
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
        width: 350,
        height: 125,
        decoration: BoxDecoration(
          color: isDark ? Color(0xff272727) : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.topCenter,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '2',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 20,
                      ),
                    ),

                    TextSpan(
                      text: '\nDays',
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),

                    ),
                  ]
                ),
              )
            ),
            Container(
                alignment: Alignment.topCenter,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      children: [
                        TextSpan(
                          text: '138',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 20,
                          ),
                        ),

                        TextSpan(
                          text: '\nSessions',
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ]
                  ),
                )
            ),
            Consumer<Attended>(
                builder: (context, attended, child) {
                  var snapShot = Firestore.instance.collection('registration').document(uuid).snapshots();

                  if (snapShot != null){
                    snapShot.listen(
                            (doc){
                              print(uuid);
                              print('${doc.data['attended_rooms'] ?? 0}');
                          attended.rooms = int.parse('${doc.data['attended_rooms'] ?? 0}');
                          tshirt_size = '${doc.data['tshirt_size']}';
                        }
                    );
                  }

                  return Container(
                      alignment: Alignment.topCenter,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(

                          children: [
                            TextSpan(
                              text: attended.rooms.toString(),
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                                fontSize: 20,
                              ),
                            ),

                            TextSpan(
                              text: '\nRooms\nAttended',
                              style: TextStyle(
                                color: isDark ? Colors.white : Colors.black,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {

                                  final snackBar = SnackBar(
                                    content: Text(
                                        'You need to attend at least 3 sessions to get the Gifts.'),
                                  );

                                  print('snack');

                                  if (attended.rooms < 3) {
                                    Scaffold.of(context).showSnackBar(snackBar);
                                  } else {
                                    _showQRDialog();
                                  }

                                },
                            ),
                          ],


                        ),
                      )
                  );
                }
            ),
          ],
        ),
      );
    }



    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Hero(
            transitionOnUserGestures: true,
            tag: 'Top Ticket',
            child: Material(
              child: Ticket(
                  innerRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0)
                  ),
                  outerRadius: BorderRadius.all(Radius.circular(10)),
                  child: topBCYPass(),
                  boxShadow: [
                    new BoxShadow(
                      color: isDark ? Colors.transparent : Colors.grey[400],
                      offset: Offset(0,2),
                      blurRadius: 3,
                    )
                  ],
              ),
            ),
          ),

          Ticket(
              innerRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)
              ),
              outerRadius: BorderRadius.all(Radius.circular(10)),
              child: bottomBCYPass(),
              boxShadow: [
                new BoxShadow(
                  color: isDark ? Colors.transparent : Colors.grey[400],
                  offset: Offset(0,2),
                  blurRadius: 3,
                )
              ]
          ),

        ],
      ),
    );
  }
}
