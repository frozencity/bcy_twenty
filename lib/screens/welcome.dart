
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:google_fonts/google_fonts.dart';


class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool loggedIn;

  @override
  Widget build(BuildContext context) {

   // loggedIn = AuthProvider().loggedIn;


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
        padding: EdgeInsets.symmetric(horizontal: 42.0, vertical: 32.0),
        width: 350,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
        ),


          child: SignInButton(
            Buttons.Google,
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                      title: widget.title,
                    )),
              );
            },

          ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'Top Ticket',
              transitionOnUserGestures: true,
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
      ),
    );





  }
}
