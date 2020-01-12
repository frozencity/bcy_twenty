import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bcy_twenty/data/db.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:bcy_twenty/tab_bar.dart';

class TalkLists extends StatefulWidget {
  @override
  _TalkListsState createState() => _TalkListsState();
}

class _TalkListsState extends State<TalkLists> {
  static var proTalk;
  bool _fav = false;




  var talkTitles;
  var talkSpeakers;
  var talkTime;
  var talkRoom;

  @override
  Widget build(BuildContext context) {
    proTalk = Provider.of<List<Talks>>(context);

    talkTitles = proTalk.map((talkList) => talkList.title).toList();
    talkSpeakers = proTalk.map((talkList) => talkList.speaker).toList();
    talkTime = proTalk.map((talkList) => talkList.time).toList();
    talkRoom = proTalk.map((talkList) => talkList.room).toList();

    return CustomScrollView(
      slivers: <Widget>[

        SliverAppBar(
          expandedHeight: 75,
          title: Text(
            'Barcamp Yangon 2020',
            style: Theme.of(context).textTheme.title,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(EvaIcons.settingsOutline,),
              tooltip: 'Sort',
              onPressed: (){},
            ),
          ],

        ),

        SliverPersistentHeader(
          floating: true,
          pinned: true,
          delegate: SliverAppBarDelegate(
            TabBar(
              indicatorColor: Colors.blue,
              isScrollable: true,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: <Widget>[
                Tab(
                  child: Text('Day 1',style: Theme.of(context).textTheme.subtitle,),
                ),
                Tab(
                  child: Text('Day 2',style: Theme.of(context).textTheme.subtitle,),
                ),

              ],
            ),
          ),
        ),

        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              /// To convert this infinite list to a list with "n" no of items,
              /// uncomment the following line:
              /// if (index > n) return null;

              // if (index > talkTitleList.length) return null;
              return ListTile(
                title: Text(talkTitles[index]),
                subtitle: Text(talkSpeakers[index]+ '    .    ' + talkRoom[index]),
                trailing: IconButton(
                  onPressed: (){
                    setState(() {
                      _fav = _fav ? false : true;
                    });
                  },
                  icon: Icon(
                    _fav ? EvaIcons.checkmarkCircleOutline : EvaIcons.radioButtonOffOutline,
                    color: _fav ? Colors.green : Colors.grey,
                  ),
                ),
              );
            },
            childCount: talkTitles.length,
          ),
        ),

      ],
    );
  }
}
