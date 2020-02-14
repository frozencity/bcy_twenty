import 'package:bcy_twenty/data/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Topics extends StatefulWidget {
  Topics({
    Key key,
    this.id,
    this.email,
  });

  final String id;
  final String email;

  @override
  _TopicsState createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {

  List<String> choices = List();

  categories() {
    return Consumer<List<Categories>>(builder: (_, categories, __) {
      if (categories == null) {
        return CircularProgressIndicator();
      }

      var categoryNames = categories.map((ct) {
        return ct.name;
      }).toList();

      var categoryUsers = categories.map((ct) {
        return ct.users;
      }).toList();

      var categoryVotes = categories.map((ct) {
        return ct.votes;
      }).toList();

      var categoryIDs = categories.map((ct) {
        return ct.id;
      }).toList();

      removeChoices(String docID, int index, int catVote, String catUsers,
          String email) {
        choices.remove(categoryNames[index]);

        Firestore.instance
            .collection('categories')
            .document(docID)
            .updateData({
          'votes': catVote - 1,
          'users': catUsers.replaceAll(', $email', '')
        });
      }

      addChoices(String docID, int index, int catVote, String catUsers,
          String email) {
        choices.add(categoryNames[index]);
        Firestore.instance
            .collection('categories')
            .document(docID)
            .updateData(
            {'votes': catVote + 1, 'users': catUsers + ', $email'});
      }

      return Container(
          child: Wrap(
            children: List.generate(
              categoryNames.length, //list length
                  (int index) {
                //print(choices);
                return Container(
                  margin: EdgeInsets.all(5.0),
                  child: ChoiceChip(
                    label: Text(categoryNames[index]),
                    selected: choices.contains(categoryNames[index]),
                    onSelected: (selected) {
                      setState(() {
                        choices.contains(categoryNames[index])
                            ? removeChoices(
                            categoryIDs[index],
                            index,
                            categoryVotes[index],
                            categoryUsers[index],
                            widget.email)
                            : addChoices(
                            categoryIDs[index],
                            index,
                            categoryVotes[index],
                            categoryUsers[index],
                            widget.email);

                        //widget.onSelectionChanged(selectedChoices);
                      });
                    },
                  ),
                );
              },
            ),
          ));
    });
  }

  interested_topics() {
    return categories();
  }


  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Categories>>(
      create: (_) => DatabaseService().streamCategories(),
      child: Scaffold(
        body: Container(
          child: Column(
            children: <Widget>[
              Container(
                margin:
                EdgeInsets.only(top: 16, bottom: 25, right: 48.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      child: Icon(
                        EvaIcons.bulbOutline,
                        color: Colors.grey,
                      ),
                      left: 8.0,
                      top: 16.0,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 48),
                        child: interested_topics()),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
