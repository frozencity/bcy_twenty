import 'package:bcy_twenty/data/attended.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bcy_twenty/data/db.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bcy_twenty/data/colors.dart';
import 'package:intl/intl.dart';
import 'package:bcy_twenty/tab_bar.dart';

class TalkLists extends StatefulWidget {
  TalkLists({Key key, this.title, this.initialDay, this.uuid,}) : super(key: key);
  final String title;
  final String initialDay;
  final String uuid;

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
  var code;

  final _formKey = GlobalKey<FormState>();




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
  var day1ConferenceCodeList;
  var conferenceTimeList;
  var day1OtherCodeList;
  var day2ConferenceCodeList;
  var day2OtherList;


  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
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
          conferenceTimeList = ctList.map((ct) {
            return ct.time;
          }).toList();

          day1ConferenceCodeList = ctList.map((ct) {
            return ct.code;
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
                padding: EdgeInsets.only(top: 16.0, bottom: 75.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      /// To convert this infinite list to a list with "n" no of items,
                      /// uncomment the following line:
                      /// if (index > n) return null;

                      /*return InkWell(
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
                           // padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                            decoration: BoxDecoration(
                              color: pseudoRandomColors[index],
                              border: Border.all(
                                color: isDark ? Colors.transparent : Colors.grey[200],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Container(
                                  margin: EdgeInsets.only(left:16.0, top: 16.0),
                                  child: Text(
                                    conferenceTitleList[index] ?? '',
                                    style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),


                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 16.0, left: 16.0, right: 16.0),
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
                                                color: Colors.black,
                                                size: 14,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(left: 5.0),
                                                  child: Text(
                                                      conferenceSpeakerList[index],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
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
                                              color: Colors.black,
                                              size: 14,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                    conferenceTimeList[index],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                *//*Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(EvaIcons.starOutline),
                                  ),
                                )*//*
                              ],
                            ),
                          ),
                        ),
                      );*/
                          return Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 5.0),
                            // padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                            decoration: BoxDecoration(
                              color: pseudoRandomColors[index],
                              border: Border.all(
                                color: isDark ? Colors.transparent : Colors.grey[200],
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[

                                Container(
                                  margin: EdgeInsets.only(left:16.0, top: 16.0),
                                  child: Text(
                                    conferenceTitleList[index] ?? '',
                                    style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),


                                Container(
                                  margin: EdgeInsets.only(top: 10, bottom: 16.0, left: 16.0, right: 16.0),
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
                                                color: Colors.black,
                                                size: 14,
                                              ),
                                              Container(
                                                  margin: EdgeInsets.only(left: 5.0),
                                                  child: Text(
                                                    conferenceSpeakerList[index],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                    ),
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
                                              color: Colors.black,
                                              size: 14,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  conferenceTimeList[index],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
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

              day1OtherCodeList = ctList.map((ct) {
                return ct.code;
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
                      padding: EdgeInsets.only(top:16.0, bottom: 48.0),
                      itemBuilder: (BuildContext context, int index) {
                        /// To convert this infinite list to a list with "n" no of items,
                        /// uncomment the following line:
                        /// if (index > n) return null;
                        //DefaultTabController().index;

                        /*return InkWell(
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
                          child:
                        );*/

                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: pseudoRandomColors[index],
                            border: Border.all(
                              color: isDark ? Colors.transparent : Colors.grey[200],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                orTitleList[index] ?? '',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
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
                                              color: Colors.black,
                                              size: 14,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  orSpeakerList[index],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
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
                                            color: Colors.black,
                                            size: 14,
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                orRoomList[index],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

          day2ConferenceCodeList = ctList.map((ct) {
            return ct.code;
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
                padding: EdgeInsets.only(top: 16.0, bottom: 75.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      /// To convert this infinite list to a list with "n" no of items,
                      /// uncomment the following line:
                      /// if (index > n) return null;

                      /*return InkWell(
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
                          child:
                        ),
                      );*/

                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 5.0),
                        // padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                        decoration: BoxDecoration(
                          color: pseudoRandomColors[index],
                          border: Border.all(
                            color: isDark ? Colors.transparent : Colors.grey[200],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              margin: EdgeInsets.only(left:16.0, top: 16.0),
                              child: Text(
                                conferenceTitleList[index] ?? '',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                ),
                              ),
                            ),


                            Container(
                              margin: EdgeInsets.only(top: 10, bottom: 16.0, left: 16.0, right: 16.0),
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
                                            color: Colors.black,
                                            size: 14,
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                conferenceSpeakerList[index],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
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
                                          color: Colors.black,
                                          size: 14,
                                        ),
                                        Container(
                                            margin: EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              conferenceTimeList[index],
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
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

              day2OtherList = ctList.map((ct) {
                return ct.code;
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
                      padding: EdgeInsets.only(top:16.0, bottom: 48.0),
                      itemBuilder: (BuildContext context, int index) {
                        /// To convert this infinite list to a list with "n" no of items,
                        /// uncomment the following line:
                        /// if (index > n) return null;
                        //DefaultTabController().index;

                        /*return InkWell(
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
                          child:
                        );*/

                        return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 5.0),
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: pseudoRandomColors[index],
                            border: Border.all(
                              color: isDark ? Colors.transparent : Colors.grey[200],
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                orTitleList[index] ?? '',
                                style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
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
                                              color: Colors.black,
                                              size: 14,
                                            ),
                                            Container(
                                                margin: EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  orSpeakerList[index],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
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
                                            color: Colors.black,
                                            size: 14,
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(left: 5.0),
                                              child: Text(
                                                orRoomList[index],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
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

    highlightedTextColors(int num){
      var color;

      if (room == num && isDark) { // selected Dark Theme
        color = Colors.blue;
      } else if (room != num && !isDark) { // selected White Theme
        color = Colors.black;
      } else if (room != num && isDark) {
        color = Colors.white;
      }

      return color;
    }

    void _showErrorDialog(){
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Error"),
            content: Text("Wrong Time"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: new Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    void _showDialog() {
      // flutter defined function
      final attended = Provider.of<Attended>(context, listen: false);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return ListenableProvider.value(
            value: attended,
            child: AlertDialog(
              title: new Text("Please enter a session code"),
              content: new Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.only(
                      left: 5, top: 5, bottom: 5, right: 16.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      icon: Icon(EvaIcons.codeOutline),
                      hintText: 'Secret Code',
                      labelText: 'Code *',
                    ),
                    validator: (value) {

                      print(day1ConferenceCodeList.toString());
                      var er = 'Wrong Code < OR > Time';

                      if (value.isEmpty) {
                        return 'Please enter a secret code.';
                      } else if (value.length > 4) {
                        return 'It\'s only 4 characters long.';
                      } else if (day1ConferenceCodeList.contains(value.toLowerCase())){
                        print('user entered $value and it\'s a match! ' + day1ConferenceCodeList.toString().contains(value).toString());
                        var index = day1ConferenceCodeList.indexOf(value.toLowerCase());
                        String start;
                        String end;
                        DateTime now = DateTime.now();
                        DateFormat dateFormat = new DateFormat.Hm();
                        DateTime startTime;
                        DateTime endTime;



                        Firestore.instance.collection('talks').document('Day 1').collection('Conference Room').where('code', isEqualTo: code)
                            .snapshots().listen(
                                (data) { //this will gets the topic details from firestore.
                                  print('Title :  ${data.documents[index]['title']}');
                                  print('Speaker : ${data.documents[index]['speaker']}');
                                  print('Start Time :  ${data.documents[index]['time']}');
                                  print('End Time : ${data.documents[index]['end']}');

                                  start = '${data.documents[index]['time']}';
                                  end = '${data.documents[index]['end']}';


                                  startTime = dateFormat.parse(start);
                                  startTime = new DateTime(now.year, now.month, now.day, startTime.hour, startTime.minute);
                                  endTime = dateFormat.parse(end);
                                  endTime = new DateTime(now.year, now.month, now.day, endTime.hour, endTime.minute);

                                  print ('Start Time is $startTime \& End Time is $endTime \& current Time is $now');
                                  if (now != null && startTime != null && endTime != null) {
                                    if(now.isAfter(startTime) && now.isBefore(endTime)) {
                                      print('Equal');

                                      //Update the Room.
                                      attended.addRoom();
                                      //prefs.setInt('Attended', attended.rooms);
                                      DatabaseService().updateUser(
                                          widget.uuid,
                                          {
                                            "attended_rooms": attended.rooms,
                                          }
                                      );
                                      Navigator.of(context).pop();

                                    } else {
                                      print('Not Equal');
                                      Navigator.of(context).pop();
                                      _showErrorDialog();
                                    }
                                  }
                                  return null;
                                }

                        );
                        var hour = TimeOfDay.now().hourOfPeriod;
                        var minute = TimeOfDay.now().minute;
                        var period = TimeOfDay.now().period;
                        var ampm = (period == DayPeriod.am) ? 'AM' : 'PM';


                        print('current time is $hour:$minute $ampm');

                        return null;

                      }
                      return er;
                    },
                    onSaved: (String value) {
                      code = value;
                    },
                  ),
                ),
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                FlatButton(
                  child: new Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: new Text("Submit"),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      print('success ' + code);
                    }

                    //Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      );
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
                color: isDark ? Colors.black : Colors.white,
                child: selectedDays(),
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 3,
            shape: CircularNotchedRectangle(
            ),
            color: isDark ? Color(0xff272727) : Colors.white,
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
                              color: highlightedTextColors(0),
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
                              color: highlightedTextColors(1),
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
            onPressed: () {
              _showDialog();
            },
            child: Icon(
              EvaIcons.giftOutline,
              color: Colors.blue,
            ),
            backgroundColor: isDark ? Color(0xff272727) : Colors.white,
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          extendBody: true,
        ),
      );
    }

    return _builtAppStructure(context);

  }
}
