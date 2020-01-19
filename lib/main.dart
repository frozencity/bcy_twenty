import 'package:bcy_twenty/data/db.dart';
import 'package:bcy_twenty/screens/sponsors.dart';
import 'package:bcy_twenty/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:bcy_twenty/tab_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'data/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  SharedPreferences prefs;

  Future<Null> _getData() async {
    prefs = await SharedPreferences.getInstance();
  }


  @override
  Widget build(BuildContext context) {
    //var AppColor = Color(0xff3c8be6);
    var _db = DatabaseService();



    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        //systemNavigationBarDividerColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    _builtAppFrame(BuildContext context){
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(
            create: (_) {
              return AuthProvider();
            },
          ),
          StreamProvider<List<Sponsor>>(create: (_) => _db.streamSponsor(),),
          StreamProvider<List<Talks>>(create: (_) => _db.streamTalks(),),
          StreamProvider<List<D1Times>>(create: (_) => _db.streamD1Times(),),
          StreamProvider<List<D2Times>>(create: (_) => _db.streamD2Times(),),
          StreamProvider<List<D1ConferenceTalks>>(create: (_) => _db.streamDay1ConferenceRoomTalks(),),
          StreamProvider<List<D2ConferenceTalks>>(create: (_) => _db.streamDay2ConferenceRoomTalks(),),
          StreamProvider<List<D1orTalks>>(create: (_) => _db.streamD1orTalks(),),
          StreamProvider<List<D2orTalks>>(create: (_) => _db.streamD2orTalks(),),
        ],
        child: MaterialApp(
          title: 'Barcamp Yangon 2020',
          theme: ThemeData(
            // This is the theme of the application.
            //
            primaryColor: Colors.blue,
            canvasColor: Colors.white,
            backgroundColor: Colors.white,

            fontFamily: GoogleFonts.lato().fontFamily,

            appBarTheme: AppBarTheme(
                color: Colors.white,
                brightness: Brightness.light,
                iconTheme: IconThemeData(
                  color: Colors.black45,
                )
            ),
          ),
          // home: MyHomePage(title: 'Barcamp Yangon 2020'),
          home: WelcomeScreen(title: 'Barcamp Yangon 2020'),

        ),
      );
    }

    return FutureBuilder<Null>(
      future: _getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // print('Boolean Value in FutureBuilder: ${snapshot.data}');
          return _builtAppFrame(context);
        } else
          return MaterialApp(
            home: LinearProgressIndicator(),
          );
      },
    );
  }
}
