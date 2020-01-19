import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bcy_twenty/data/db.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class TalkLists extends StatefulWidget {
  @override
  _TalkListsState createState() => _TalkListsState();
}

class _TalkListsState extends State<TalkLists> {
  List proTalk;
  List proTime;


  var talkTitles;
  var talkSpeakers;
  var talkTime;
  var talkRoom;

  var PseudoRandomColors = [
    Colors.redAccent[200],
    Colors.greenAccent[200],
    Colors.yellowAccent[200],
    Colors.lightBlueAccent[200],
    Colors.deepOrangeAccent[200],
    Colors.blueGrey[200],
    Colors.yellow[200],
    Colors.green[200],
    Colors.red[200],
  ];

  @override
  Widget build(BuildContext context) {

    proTalk = Provider.of<List<Talks>>(context);
    proTime = Provider.of<List<D1Times>>(context);

    if (proTalk != null){
      talkTitles = proTalk.map((talkList) => talkList.title).toList();
      talkSpeakers = proTalk.map((talkList) => talkList.speaker).toList();
      talkTime = proTalk.map((talkList) => talkList.time).toList();
      talkRoom = proTalk.map((talkList) => talkList.room).toList();

      // timeHeaders = proTime.map((t) => t.time).toList();
    }

    return SliverPadding(
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
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      talkTitles[index] ?? '',
                      style: TextStyle(
                        fontSize: 21,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        children: <Widget>[
                          Icon(EvaIcons.personOutline, size: 14,),
                          Text(talkSpeakers[index]),
                        ],
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        onPressed: (){},
                        icon: Icon(EvaIcons.starOutline),
                      ),
                    )

                  ],
                ),
              ),
            );
          },
          childCount: talkTitles.length,
        ),
      ),
    );

  }
}
