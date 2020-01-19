import 'package:bcy_twenty/screens/talk_detail.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sponsors.dart';
import 'welcome.dart';
import 'package:bcy_twenty/data/db.dart';
import 'talklists.dart';
import 'package:bcy_twenty/tab_bar.dart';

///  This Class Defines Drawer Navigation and its contents.
///  Then calls talklist.dart for the rest of the lists.

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List proTalk;
  List d1Time;
  List d2Time;

  var talkTitles;
  var talkSpeakers;
  var talkTime;
  var talkRoom;

  String initialDay = 'Day 1';
  int room = 0; // 0 = Conference Room, 1 = Other Rooms

  var PseudoRandomColors = [
    Colors.redAccent[100],
    Colors.greenAccent[100],
    Colors.yellowAccent[100],
    Colors.lightBlueAccent[100],
    Colors.deepOrangeAccent[100],
    Colors.blueGrey[100],
    Colors.yellow[100],
    Colors.green[100],
    Colors.red[100],
  ];

  var d1TabTimes;
  var d2TabTimes;

  SharedPreferences prefs;

  Future<Null> _getData() async {
    prefs = await SharedPreferences.getInstance();
  }

  var d1tabs;
  var d2tabs;


  @override
  Widget build(BuildContext context) {
    var _db = DatabaseService();
    d1Time = Provider.of<List<D1Times>>(context);
    d2Time = Provider.of<List<D2Times>>(context);


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

    if (d1Time != null && d2Time != null) {
      d1TabTimes = d1Time.map((ct) {
        return ct.time;
      }).toList();


      d1tabs = List.generate(d1TabTimes.length, (index) {
        //print(orTitleList);
        return Tab(
          child: Text(
            d1TabTimes[index],
            style: Theme
                .of(context)
                .textTheme
                .subtitle,
            textAlign: TextAlign.center,
          ),
        );
      });

      d2TabTimes = d2Time.map((ct) {
        return ct.time;
      }).toList();

      d2tabs = List.generate(d2TabTimes.length, (index) {
        //print(orTitleList);
        return Tab(
          child: Text(
            d2TabTimes[index],
            style: Theme
                .of(context)
                .textTheme
                .subtitle,
            textAlign: TextAlign.center,
          ),
        );
      });
    }
    // var tabBarViews =

    dayOneConferenceRoom() {
      return Consumer<List<D1ConferenceTalks>>(
        builder: (_, ctList, __) {
          if (ctList==null) {return CircularProgressIndicator();}
          var conferenceTitleList = ctList.map((ct) {
            return ct.title;
          }).toList();
          var conferenceSpeakerList = ctList.map((ct) {
            return ct.speaker;
          }).toList();
          var conferenceTimeList = ctList.map((ct) {
            return ct.time;
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 75,
                title: Text(
                  'BCY 2020',
                  style: Theme.of(context).textTheme.title,
                ),
                actions: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 10), child: dropDown()),
                ],
              ),

              SliverPadding(
                padding: EdgeInsets.only(top: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      /// To convert this infinite list to a list with "n" no of items,
                      /// uncomment the following line:
                      /// if (index > n) return null;

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return TalkDetail(
                                title: conferenceTitleList[index] ?? '',
                                speaker: conferenceSpeakerList[index] ?? '',
                                room: 'Conference Room',
                                time: conferenceTimeList[index] ?? '',
                                day: initialDay ?? '',
                                category: '',
                                bgcolor: PseudoRandomColors[index] ?? Colors.blue,
                              );
                            }),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: PseudoRandomColors[index],
                            border: Border.all(
                              color: Colors.grey[200],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                conferenceTitleList[index] ?? '',
                                style: TextStyle(
                                  fontSize: 21,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      EvaIcons.personOutline,
                                      size: 14,
                                    ),
                                    Text(conferenceSpeakerList[index]),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(EvaIcons.starOutline),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: conferenceTitleList.length ?? 0,
                  ),
                ),
              ),

              // TalkLists(),
            ],
          );
        },
      );
    }

    dayOneOtherRooms() {
      return Consumer<List<D1Times>>(
        builder: (_, timesList, __) {
          if (timesList==null) {return CircularProgressIndicator();}

          d1TabTimes = timesList.map((ct) {
            return ct.time;
          }).toList();

          return Consumer<List<D1orTalks>>(
            builder: (context, ctList, __) {
              if (ctList==null) {return CircularProgressIndicator();}

              int tabIndex = DefaultTabController.of(context).index;
              String currentTabTime = d1TabTimes[tabIndex];
              var orTitleList = ctList
                  .where((i) => i.time.contains(currentTabTime))
                  .map((ct) {
                return ct.title;
              }).toList();
              var orSpeakerList = ctList
                  .where((i) => i.time.contains(currentTabTime))
                  .map((ct) {
                return ct.speaker;
              }).toList();
              var orRoomList = ctList
                  .where((i) => i.time.contains(currentTabTime))
                  .map((ct) {
                return ct.room;
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 75,
                    title: Text(
                      'BCY 2020',
                      style: Theme.of(context).textTheme.title,
                    ),
                    actions: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: dropDown()),
                    ],
                  ),
                  SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      TabBar(
                        onTap: (tabIndex) {
                          setState(() {
                            currentTabTime = d1TabTimes[tabIndex];
                            orTitleList = ctList
                                .where((i) => i.time.contains(currentTabTime))
                                .map((ct) {
                              return ct.title;
                            }).toList();
                            orSpeakerList = ctList
                                .where((i) => i.time.contains(currentTabTime))
                                .map((ct) {
                              return ct.speaker;
                            }).toList();
                            orRoomList = ctList
                                .where((i) => i.time.contains(currentTabTime))
                                .map((ct) {
                              return ct.room;
                            }).toList();
                            print(orTitleList);
                          });
                        },
                        indicatorColor: Colors.blue,
                        indicatorSize: TabBarIndicatorSize.label,
                        isScrollable: true,
                        tabs: d1tabs,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        /// To convert this infinite list to a list with "n" no of items,
                        /// uncomment the following line:
                        /// if (index > n) return null;
                        //DefaultTabController().index;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return TalkDetail(
                                  title: orTitleList[index] ?? '',
                                  speaker: orSpeakerList[index] ?? '',
                                  room: orRoomList[index] ?? '',
                                  time: currentTabTime ?? '',
                                  day: initialDay ?? '',
                                  category: '',
                                  bgcolor: PseudoRandomColors[index] ?? Colors.blue,
                                );
                              }),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: PseudoRandomColors[index],
                              border: Border.all(
                                color: Colors.grey[200],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  orTitleList[index] ?? '',
                                  style: TextStyle(
                                    fontSize: 21,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        EvaIcons.personOutline,
                                        size: 14,
                                      ),
                                      Text(orSpeakerList[index]),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        EvaIcons.pinOutline,
                                        size: 14,
                                      ),
                                      Text(orRoomList[index]),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(EvaIcons.starOutline),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: orTitleList.length ?? 0,
                    ),
                  )
                ],
              );
            },
          );
        },
      );
    }

    dayTwoConferenceRoom() {
      return Consumer<List<D2ConferenceTalks>>(
        builder: (_, ctList, __) {
          if (ctList==null) {return CircularProgressIndicator();}


          var conferenceTitleList = ctList.map((ct) {
            return ct.title;
          }).toList();
          var conferenceSpeakerList = ctList.map((ct) {
            return ct.speaker;
          }).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 75,
                title: Text(
                  'BCY 2020',
                  style: Theme.of(context).textTheme.title,
                ),
                actions: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 10), child: dropDown()),
                ],
              ),

              SliverPadding(
                padding: EdgeInsets.only(top: 16.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      /// To convert this infinite list to a list with "n" no of items,
                      /// uncomment the following line:
                      /// if (index > n) return null;

                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5.0),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: PseudoRandomColors[index],
                            border: Border.all(
                              color: Colors.grey[200],
                            ),
                            borderRadius:
                            BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                conferenceTitleList[index] ?? '',
                                style: TextStyle(
                                  fontSize: 21,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 16.0),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      EvaIcons.personOutline,
                                      size: 14,
                                    ),
                                    Text(conferenceSpeakerList[index]),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(EvaIcons.starOutline),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: conferenceTitleList.length,
                  ),
                ),
              ),

              // TalkLists(),
            ],
          );
        },
      );
    }

    dayTwoOtherRooms() {
      return Consumer<List<D2Times>>(
        builder: (_, timesList, __) {
          if (timesList==null) {return CircularProgressIndicator();}

          d2TabTimes = timesList.map((ct) {
            return ct.time;
          }).toList();

          return Consumer<List<D2orTalks>>(
            builder: (context, ctList, __) {
              if (ctList==null) {return CircularProgressIndicator();}

              int tabIndex = DefaultTabController.of(context).index;
              String currentTabTime = d2TabTimes[tabIndex];
              var orTitleList = ctList
                  .where((i) => i.time.contains(currentTabTime))
                  .map((ct) {
                return ct.title;
              }).toList();
              var orSpeakerList = ctList
                  .where((i) => i.time.contains(currentTabTime))
                  .map((ct) {
                return ct.speaker;
              }).toList();
              var orRoomList = ctList
                  .where((i) => i.time.contains(currentTabTime))
                  .map((ct) {
                return ct.room;
              }).toList();

              return CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 75,
                    title: Text(
                      'BCY 2020',
                      style: Theme.of(context).textTheme.title,
                    ),
                    actions: <Widget>[
                      Container(
                          margin: EdgeInsets.only(right: 10),
                          child: dropDown()),
                    ],
                  ),
                  SliverPersistentHeader(
                    floating: true,
                    pinned: true,
                    delegate: SliverAppBarDelegate(
                      TabBar(
                        onTap: (tabIndex) {
                          setState(() {
                            currentTabTime = d2TabTimes[tabIndex];
                            orTitleList = ctList
                                .where((i) => i.time.contains(currentTabTime))
                                .map((ct) {
                              return ct.title;
                            }).toList();
                            orSpeakerList = ctList
                                .where((i) => i.time.contains(currentTabTime))
                                .map((ct) {
                              return ct.speaker;
                            }).toList();
                            orRoomList = ctList
                                .where((i) => i.time.contains(currentTabTime))
                                .map((ct) {
                              return ct.room;
                            }).toList();
                            print(orTitleList);
                          });
                        },
                        indicatorColor: Colors.blue,
                        indicatorSize: TabBarIndicatorSize.label,
                        isScrollable: true,
                        tabs: d2tabs,
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        /// To convert this infinite list to a list with "n" no of items,
                        /// uncomment the following line:
                        /// if (index > n) return null;
                        //DefaultTabController().index;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return TalkDetail(
                                  title: orTitleList[index] ?? '',
                                  speaker: orSpeakerList[index] ?? '',
                                  room: orRoomList[index] ?? '',
                                  time: currentTabTime ?? '',
                                  day: initialDay ?? '',
                                  category: '',
                                  bgcolor: PseudoRandomColors[index] ?? Colors.blue,
                                );
                              }),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: PseudoRandomColors[index],
                              border: Border.all(
                                color: Colors.grey[200],
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  orTitleList[index] ?? '',
                                  style: TextStyle(
                                    fontSize: 21,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 16.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        EvaIcons.personOutline,
                                        size: 14,
                                      ),
                                      Text(orSpeakerList[index]),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 5.0),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        EvaIcons.pinOutline,
                                        size: 14,
                                      ),
                                      Text(orRoomList[index]),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(EvaIcons.starOutline),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: orTitleList.length ?? 0,
                    ),
                  )
                ],
              );
            },
          );
        },
      );
    }

    var dayOneRooms = [
      dayOneConferenceRoom(),
      dayOneOtherRooms(),
    ];

    var dayTwoRooms = [
      dayTwoConferenceRoom(),
      dayTwoOtherRooms(),
    ];

    selectedDays() {
      if (room == 0){print('$initialDay and Conference Room');}
      else{print('$initialDay and OtherRoom');}

      if (initialDay == 'Day 1') {
        return dayOneRooms[room];
      } else {
        return dayTwoRooms[room];
      }
    }

    _builtAppStructure(BuildContext context){
      return DefaultTabController(
        length: d1TabTimes.length ?? 0,
        child: Scaffold(
          drawer: Drawer(
            child: SafeArea(
              top: false,
              child: Column(children: <Widget>[
                DrawerHeader(
                  child: Image.network(
                      'https://static.wixstatic.com/media/651283_7f56157435b24a3196068850feaeafc7~mv2.jpg/v1/fill/w_250,h_250,al_c,q_90/651283_7f56157435b24a3196068850feaeafc7~mv2.webp'),
                ),
                ListTile(
                  leading: Icon(EvaIcons.calendarOutline),
                  title: Text('Schedules'),
                  selected: true,
                  onTap: () {},
                  dense: true,
                ),
                ListTile(
                  leading: Icon(EvaIcons.chargingOutline),
                  title: Text('Sponsors'),
                  onTap: () {
                    //go to BCY sponser page
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BarcampSponsor()),
                    );
                  },
                  dense: true,
                ),
                ListTile(
                  leading: Icon(EvaIcons.hashOutline),
                  title: Text('Topics'),
                  onTap: () {},
                  dense: true,
                ),
                ListTile(
                  leading: Icon(EvaIcons.personOutline),
                  title: Text('Profile'),
                  onTap: () {},
                  dense: true,
                ),
                Expanded(child: Container()),
                ListTile(
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
              ]),
            ),
          ),
          body: Container(
            //This is to fill the SafeArea with the Color.
            child: SafeArea(
              bottom: false,
              child: Container(
                color: Colors.white,
                child: selectedDays(),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 2,
            shape: CircularNotchedRectangle(),
            notchMargin: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        room = 0;
                      });
                    },
                    child: Text(
                      'Conference Room',
                      style: TextStyle(
                        color: room == 0 ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: FlatButton(
                    onPressed: () {
                      setState(() {
                        room = 1;
                      });
                    },
                    child: Text(
                      'Other Rooms',
                      style: TextStyle(
                        color: room == 1 ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(
              EvaIcons.cameraOutline,
              color: Colors.blue,
            ),
            backgroundColor: Colors.white,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        ),
      );
    }

    return _builtAppStructure(context);

  }
}
