import 'package:flutter/material.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

class Profile extends StatelessWidget {

  Profile({Key key, this.title}) : super(key: key);
  final String title;

final String username = 'Ko Ko Ye';
final String email = 'kokoye2007@gmail.com';

  topBCYPass(){
    return Container(
      padding: EdgeInsets.all(16),
      width: 350,
      height: 225,
      decoration: BoxDecoration(
        color: Colors.white,
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

  bottomBCYPass(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
      width: 350,
      height: 125,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Container(
            //QR
            child: QrImage(
              data: username+';'+email,
              version: QrVersions.auto,
              size: 100.0,
            ),

          ),
          Container(
            //Details
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.novaMono().fontFamily,
                  ),
                ),

                Text(
                  email,
                  style: TextStyle(
                    fontFamily: GoogleFonts.novaMono().fontFamily,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      color: Colors.grey[400],
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
                  color: Colors.grey[400],
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
