
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'home.dart';


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

    return Container(
      color: Colors.white,
      height: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network('https://static.wixstatic.com/media/651283_7f56157435b24a3196068850feaeafc7~mv2.jpg/v1/fill/w_250,h_250,al_c,q_90/651283_7f56157435b24a3196068850feaeafc7~mv2.webp'),
          SignInButton(
            Buttons.Google,
            onPressed: (){
              /*AuthProvider().signInWithGoogle().whenComplete((){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyHomePage(title: widget.title,)),
                );
              });*/
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home(title: widget.title,)),
              );

            },
          ),
          SignInButton(
            Buttons.Facebook,
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home(title: widget.title,)),
              );
            },
          ),
        ],
      ),
    );


  }
}
