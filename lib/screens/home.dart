import 'package:bcy_twenty/data/colors.dart';
import 'package:bcy_twenty/data/db.dart';
import 'package:bcy_twenty/screens/profile.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'talklists.dart';
import 'sponsors.dart';
import 'welcome.dart';

///  This Class Defines Drawer Navigation and its contents.
///  Then calls talklist.dart for the rest of the lists.

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var selected = true;

  int pageNum = 0;

  String initialDay = 'Day 1';


  var titles = [
    'Profile',
    'Schedule',
    'Sponsors',

  ];





  @override
  Widget build(BuildContext context) {

    var _pages = [
      Profile(),
      TalkLists(initialDay: initialDay,),
      BarcampSponsor(),
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

    // TODO: implement build
    return Scaffold(
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
                color: (pageNum == 0) ? Colors.blue[100] : Colors.transparent,
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
                  color: (pageNum == 1) ? Colors.blue[100] : Colors.transparent,
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
                  color: (pageNum == 2) ? Colors.blue[100] : Colors.transparent,
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
                  color: Colors.transparent,
                  borderRadius: BorderRadius.all(Radius.circular(8))
              ),
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: ListTile(
                leading: Icon(EvaIcons.hashOutline),
                title: Text('Topics'),
                onTap: () {},
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

    );
  }

}
