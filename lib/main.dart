import 'package:bcy_twenty/screens/sponsors.dart';
import 'package:bcy_twenty/screens/talk_detail.dart';
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

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    //var AppColor = Color(0xff3c8be6);



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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            return AuthProvider();
          },
        ),

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
          home: TalkDetail(),

      ),
    );
  }
}
