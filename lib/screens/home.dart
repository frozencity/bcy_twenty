import 'package:bcy_twenty/data/attended.dart';
import 'package:bcy_twenty/screens/topics.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:bcy_twenty/data/db.dart';
import 'package:bcy_twenty/screens/profile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'talklists.dart';
import 'sponsors.dart';
import 'welcome.dart';
import 'package:bcy_twenty/data/auth.dart';

///  This Class Defines Drawer Navigation and its contents.
///  Then calls talklist.dart for the rest of the lists.

class Home extends StatefulWidget {
  Home(
      {
        Key key,
        this.title,
        this.uuid,
        this.email,
        this.img,
        this.name,
      }
      ) : super(key: key);
  final String title;
  final String uuid;
  final String email;
  final String img;
  final String name;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {

  var selected = true;

  int pageNum = 0;

  String initialDay = 'Day 1';


  var titles = [
    'Profile',
    'Schedule',
    'Sponsors',
    'Topics',
  ];


  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      bool isDark = Theme.of(context).brightness == Brightness.dark;
      print(isDark);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: isDark ? Colors.black : Colors.transparent,
          //systemNavigationBarDividerColor: Colors.black,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      );

    }
    super.didChangeAppLifecycleState(state);
  }




  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;


    var _pages = [
      Profile(
        title: widget.title,
        uuid: widget.uuid,
        name: widget.name,
        email: widget.email,
        img: widget.img,
      ),
      TalkLists(initialDay: initialDay, uuid: widget.uuid,),
      BarcampSponsor(),
      Topics(
        id: widget.uuid,
        email: widget.email,
      )
    ];

    dropDown() {
      return DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(

          ),
          child: DropdownButton<String>(
            value: initialDay,
            icon: Icon(EvaIcons.chevronDownOutline),
            iconSize: 24,
            elevation: 2,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
            onChanged: (String newValue) {
              setState(() {
                initialDay = newValue;
              });
            },
            items: <String>[
              'Day 1',
              'Day 2',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );
    }

    //bool isDark = Theme.of(context).brightness == Brightness.dark;
    void changeBrightness() {
      DynamicTheme.of(context)
          .setBrightness(isDark ? Brightness.light : Brightness.dark);
    }

    highlightColors(int num){
      var color;

      if (pageNum == num && isDark == false) { // Selected Dark Theme
        color = Colors.blue[100];
      } else if (pageNum == num && isDark == true) { //Selected White Theme
        color = Colors.green;
      } else {
        color = Colors.transparent;
      }

      return color;
    }


    var _db = DatabaseService();
    print(isDark);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? Colors.black : Colors.transparent,
        //systemNavigationBarDividerColor: Colors.black,
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
      child: MultiProvider(
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
          StreamProvider<List<Register>>(create: (_) => _db.getRegistrationList(),),
          ChangeNotifierProvider(create: (context) => Attended()),

        ],
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
                titles[pageNum],
              style: Theme.of(context).textTheme.title,
            ),
            actions: <Widget>[
              (pageNum == 1) ? dropDown() : Container(),
            ],
          ),
          drawer: Drawer(
            child: SafeArea(
              top: false,
              child: Column(children: <Widget>[
                DrawerHeader(
                  child: Image.network(
                      'https://static.wixstatic.com/media/651283_7f56157435b24a3196068850feaeafc7~mv2.jpg/v1/fill/w_250,h_250,al_c,q_90/651283_7f56157435b24a3196068850feaeafc7~mv2.webp'),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: highlightColors(0),
                    borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    leading: Icon(
                        (pageNum == 0) ? EvaIcons.person : EvaIcons.personOutline,
                    ),
                    title: Text('Profile'),
                    selected: (pageNum == 0) ? true : false,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        pageNum = 0;
                      });
                    },
                    dense: true,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: highlightColors(1),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    leading: Icon(
                        (pageNum == 1) ? EvaIcons.calendar : EvaIcons.calendarOutline,
                    ),
                    title: Text('Schedules'),
                    selected: (pageNum == 1) ? true : false,
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        pageNum = 1;

                      });
                    },
                    dense: true,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: highlightColors(2),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    leading: Icon(
                        (pageNum == 2) ? EvaIcons.charging : EvaIcons.chargingOutline,
                    ),
                    title: Text('Sponsors'),
                    selected: (pageNum == 2) ? true : false,
                    onTap: () {
                      //go to BCY sponser page
                      Navigator.pop(context);
                      setState(() {
                        pageNum = 2;
                      });
                    },
                    dense: true,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: highlightColors(3),
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    leading: Icon(
                        (pageNum == 3) ? EvaIcons.hash : EvaIcons.hashOutline
                    ),
                    title: Text('Topics'),
                    onTap: () {
                      Navigator.pop(context);
                      setState(() {
                        pageNum = 3;
                      });
                    },
                    dense: true,
                  ),
                ),

                Expanded(child: Container()),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    leading: Icon(isDark ? EvaIcons.sunOutline : EvaIcons.moonOutline),
                    title: Text('Change Theme'),
                    onTap: () {
                      //AuthProvider().signOutGoogle();
                      changeBrightness();
                    },
                    dense: true,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(8))
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ListTile(
                    leading: Icon(EvaIcons.logOutOutline),
                    title: Text('Logout'),
                    onTap: () {
                      //AuthProvider().signOutGoogle();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen(
                              title: widget.title,
                            )),
                      );
                    },
                    dense: true,
                  ),
                ),
              ]),
            ),
          ),
          body: _pages[pageNum],

        ),
      ),
    );
  }

}
