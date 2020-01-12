import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'sponsors.dart';
import 'welcome.dart';
import 'package:bcy_twenty/data/db.dart';
import 'talklists.dart';


class Home extends StatelessWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  // bool _fav = false;
  static var _db = DatabaseService();
  var listLength = 1;
  var listTimeLength = 1;

  superProvider(BuildContext context){
    return MultiProvider(
      providers: [
        StreamProvider<List<Sponsor>>(create: (_) => _db.streamSponsor(),),
        StreamProvider<List<Talks>>(create: (_) => _db.streamTalks(),),
        StreamProvider<List<Times>>(create: (_) => _db.streamTimes(),),
      ],
      child: DefaultTabController(
        length: 2,
        child: Scaffold(

          drawer: Drawer(
            child: SafeArea(
              top: false,
              child: Column(
                  children: <Widget>[
                    DrawerHeader(
                      child: Image.network('https://static.wixstatic.com/media/651283_7f56157435b24a3196068850feaeafc7~mv2.jpg/v1/fill/w_250,h_250,al_c,q_90/651283_7f56157435b24a3196068850feaeafc7~mv2.webp'),
                    ),
                    ListTile(
                      leading: Icon(EvaIcons.calendarOutline),
                      title: Text('Schedules'),
                      selected: true,
                      onTap: (){},
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(EvaIcons.chargingOutline),
                      title: Text('Sponsors'),
                      onTap: (){
                        //go to BCY sponser page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BarcampSponsor()),
                        );
                      },
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(EvaIcons.speakerOutline),
                      title: Text('Speakers'),
                      onTap: (){},
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(EvaIcons.gridOutline),
                      title: Text('Rooms'),
                      onTap: (){},
                      dense: true,
                    ),
                    ListTile(
                      leading: Icon(EvaIcons.hashOutline),
                      title: Text('Topics'),
                      onTap: (){},
                      dense: true,
                    ),

                    Expanded(child: Container()),
                    ListTile(
                      leading: Icon(EvaIcons.logOutOutline),
                      title: Text('Logout'),
                      onTap: (){
                        //AuthProvider().signOutGoogle();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WelcomeScreen(title: title,)),
                        );
                      },
                      dense: true,
                    ),

                  ]
              ),
            ),
          ),
          body: Container( //This is to fill the SafeArea with the Color.
            child: SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                child: TalkLists(),
              ),
            ),
          ),


        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return superProvider(context);
  }
}

