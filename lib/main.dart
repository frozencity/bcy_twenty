import 'package:bcy_twenty/data/colors.dart';
import 'package:bcy_twenty/screens/welcome.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  SharedPreferences prefs;
  bool isFirstTime = true;

  Future<Null> _getData() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs != null) {
      prefs.getBool('isFirstTime');
    }
  }


  @override
  Widget build(BuildContext context) {
    //var AppColor = Color(0xff3c8be6);


    _builtAppFrame(BuildContext context){
      return DynamicTheme(
          defaultBrightness: Brightness.light,
          data: (brightness) => ThemeData(
            primaryColor: Color(0xff003b6f),
            brightness: brightness,
            fontFamily: GoogleFonts.lato().fontFamily,
            canvasColor: (brightness == Brightness.dark)
                ? Colors.black
                : Colors.white,
            backgroundColor: (brightness == Brightness.dark)
                ? Colors.black
                : Colors.white,

            appBarTheme: AppBarTheme(
                color: (brightness == Brightness.light) ? Colors.white : BCYColors.KindaBlack,
                brightness: brightness,
                iconTheme: IconThemeData(
                  color: (brightness == Brightness.light) ? Colors.black45 : Colors.white,
                )
            ),
          ),
          themedWidgetBuilder: (context, theme) {
            return MaterialApp(
              title: 'Barcamp Yangon 2020',
              theme: theme,
              // home: MyHomePage(title: 'Barcamp Yangon 2020'),
              home: WelcomeScreen(title: 'Barcamp Yangon 2020'),

            );
          }
      );
    }

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? BCYColors.KindaBlack : Colors.transparent,
        //systemNavigationBarDividerColor: Colors.black,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: FutureBuilder<Null>(
        future: _getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // print('Boolean Value in FutureBuilder: ${snapshot.data}');
            return _builtAppFrame(context);
          } else
            return MaterialApp(
              color: Colors.white,
              home: LinearProgressIndicator(),
            );
        },
      ),
    );
  }
}
