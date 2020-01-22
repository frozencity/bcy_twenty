import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bcy_twenty/data/db.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:bcy_twenty/screens/talk_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcy_twenty/data/colors.dart';
import 'welcome.dart';
import 'package:bcy_twenty/tab_bar.dart';

class TalkLists extends StatefulWidget {
  TalkLists({Key key, this.title, this.initialDay}) : super(key: key);
  final String title;
  final String initialDay;

  @override
  _TalkListsState createState() => _TalkListsState();
}

class _TalkListsState extends State<TalkLists> {
  List proTalk;
  List d1Time;
  List d2Time;

  var talkTitles;
  var talkSpeakers;
  var talkTime;
  var talkRoom;




  int room = 0; // 0 = Conference Room, 1 = Other Rooms



  var d1TabTimes;
  var d2TabTimes;

  SharedPreferences prefs;

  Future<Null> _getData() async {
    prefs = await SharedPreferences.getInstance();
  }

  var d1tabs;
  var d2tabs;
  var pseudoRandomColors = BCYColors.pseudoRandomColors;


  @override
  Widget build(BuildContext context) {
    var _db = DatabaseService();
    d1Time = Provider.of<List<D1Times>>(context);
    d2Time = Provider.of<List<D2Times>>(context);
    var initialDay = widget.initialDay;



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
              /*SliverAppBar(
                expandedHeight: 75,
                title: Text(
                  'BCY 2020',
                  style: Theme.of(context).textTheme.title,
                ),
                actions: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 10), child: dropDown()),
                ],
              ),*/

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
                                bgcolor: pseudoRandomColors[index] ?? Colors.blue,
                              );
                            }),
                          );
                        },
                        child: Hero(
                          tag: pseudoRandomColors[index],
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: pseudoRandomColors[index],
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
                                  margin: EdgeInsets.only(top: 10, bottom: 5.0,),
                                  child: Row(
                                    children: <Widget>[
                                      //Speaker Info Row
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 16.0, bottom: 8.0),
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                EvaIcons.personOutline,
                                                size: 14,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5.0),
                                                  child: Text(
                                                      conferenceSpeakerList[index]
                                                  )
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      //Time Info Row
                                      Container(
                                        margin: EdgeInsets.only(top: 16.0, bottom: 8.0),

                                        child: Row(
                                          children: <Widget>[
                                            Icon(
                                              EvaIcons.clockOutline,
                                              size: 14,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                    conferenceTimeList[index],
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                /*Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(EvaIcons.starOutline),
                                  ),
                                )*/
                              ],
                            ),
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
                  /*SliverAppBar(
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
                  ),*/
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
                                  bgcolor: pseudoRandomColors[index] ?? Colors.blue,
                                );
                              }),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: pseudoRandomColors[index],
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
              /*SliverAppBar(
                expandedHeight: 75,
                title: Text(
                  'BCY 2020',
                  style: Theme.of(context).textTheme.title,
                ),
                actions: <Widget>[
                  Container(
                      margin: EdgeInsets.only(right: 10), child: dropDown()),
                ],
              ),*/

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
                            color: pseudoRandomColors[index],
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
                  /*SliverAppBar(
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
                  ),*/
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
                                  bgcolor: pseudoRandomColors[index] ?? Colors.blue,
                                );
                              }),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: pseudoRandomColors[index],
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
        length: (d1TabTimes == null) ? 0 : d1TabTimes.length,
        child: Scaffold(

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
            elevation: 3,
            shape: CircularNotchedRectangle(),
            notchMargin: 8,
            child: Container(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[

                        Container(
                          color: (room==0) ? Colors.blue : Colors.transparent,
                          height: 2,
                          width: 100.0,
                        ),

                        FlatButton(
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

                      ],
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[

                        Container(
                          color: (room==1) ? Colors.blue : Colors.transparent,
                          height: 2,
                          width: 100.0,
                        ),

                        FlatButton(
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

                      ],
                    ),
                  ),
                ],
              ),
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
