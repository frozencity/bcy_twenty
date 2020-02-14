import 'dart:html';

import 'package:bcy_twenty/data/db.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormPage extends StatefulWidget {

  FormPage({Key key, this.uuid, this.email, this.name, this.img,})
      : super(key: key);

  final String uuid;
  final String email;
  final String img;
  final String name;

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<FormPage> {
  String _gender = 'What do you consider yourself as?';
  String _edu = 'What\'s your highest level of education?';
  String _tshirt = 'What\'s your preferred T-Shirt Size?';

  String email;
  String name;
  String gender;
  String age;
  String job_title;
  String company;
  String education;
  String tshirt_size;

  bool isSelected = false;

  final _formKey = GlobalKey<FormState>();

  List<String> choices = List();

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    void changeBrightness() {
      DynamicTheme.of(context)
          .setBrightness(isDark ? Brightness.light : Brightness.dark);
    }

    ///TODO: remove this in production.
   // email = 'tomato@gmail.com';


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

        removeChoices(String docID, int index, int catVote, String catUsers, String email){
          choices.remove(categoryNames[index]);

          Firestore.instance.collection('categories').document(docID).updateData(
              {'votes': catVote-1, 'users': catUsers.replaceAll(', $email', '')}
          );

        }

        addChoices(String docID, int index, int catVote, String catUsers, String email){
          choices.add(categoryNames[index]);
          Firestore.instance..collection('categories').document(docID).updateData(
              {'votes': catVote+1,'users': catUsers + ', $email' }
          );
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
                              ? removeChoices(categoryIDs[index], index, categoryVotes[index], categoryUsers[index], widget.email)
                              : addChoices(categoryIDs[index], index, categoryVotes[index], categoryUsers[index], widget.email);

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

    gender_dropDown() {
      return DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(),
          child: DropdownButtonFormField<String>(
            value: _gender,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(EvaIcons.heartOutline),
              hintText: 'What do you consider yourself as?',
              labelText: 'Gender *',
            ),
            icon: Icon(EvaIcons.chevronDownOutline),
            iconSize: 24,
            elevation: 2,
            style: TextStyle(
              color: Theme.of(context).textTheme.caption.color,
              fontSize: Theme.of(context).textTheme.body1.fontSize,
            ),
            onChanged: (String newValue) {
              setState(() {
                _gender = newValue;
              });
            },
            items: <String>[
              'What do you consider yourself as?',
              'Male',
              'Female',
              'LGBTQ+',
              'Robot',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == 'What do you consider yourself as?') {
                return 'Please choose a gender';
              }
              return null;
            },
            onSaved: (String value) {
              gender = value;
            },
          ),
        ),
      );
    }

    education_dropDown() {
      return DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(),
          child: DropdownButtonFormField<String>(
            value: _edu,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(EvaIcons.npmOutline),
              hintText: 'Highest Level of Education',
              labelText: 'Education *',
            ),
            icon: Icon(EvaIcons.chevronDownOutline),
            iconSize: 24,
            elevation: 2,
            style: TextStyle(
              color: Theme.of(context).textTheme.caption.color,
              fontSize: Theme.of(context).textTheme.body1.fontSize,
            ),
            onChanged: (String newValue) {
              setState(() {
                _edu = newValue;
              });
            },
            items: <String>[
              'What\'s your highest level of education?',
              'Degree holder',
              'Diploma holder',
              'College Dropout',
              'High School Graduate',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == 'What\'s your highest level of education?') {
                return 'Please choose your education level';
              }
              return null;
            },
            onSaved: (String value) {
              education = value;
            },
          ),
        ),
      );
    }

    tshirt_dropDown() {
      return DropdownButtonHideUnderline(
        child: Theme(
          data: Theme.of(context).copyWith(),
          child: DropdownButtonFormField<String>(
            value: _tshirt,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              icon: Icon(EvaIcons.carOutline),
              hintText: 'What\'s your preferred T-Shirt Size?',
              labelText: 'T-Shirt Size *',
            ),
            icon: Icon(EvaIcons.chevronDownOutline),
            iconSize: 24,
            elevation: 2,
            style: TextStyle(
              color: Theme.of(context).textTheme.caption.color,
              fontSize: Theme.of(context).textTheme.body1.fontSize,
            ),
            onChanged: (String newValue) {
              setState(() {
                _tshirt = newValue;
              });
            },
            items: <String>[
              'What\'s your preferred T-Shirt Size?',
              'S',
              'M',
              'L',
              'XL',
              'XXL',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == 'What\'s your preferred T-Shirt Size?') {
                return 'Please choose one.';
              }
              return null;
            },
            onSaved: (String value) {
              tshirt_size = value;
            },
          ),
        ),
      );
    }

    interested_topics() {
      return categories();
    }

    double screenWidth = MediaQuery.of(context).size.width;

    bool isBigScreen = screenWidth > 600;

    print(widget.uuid);

    return StreamProvider<List<Categories>>(
      create: (_) => DatabaseService().streamCategories(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            isDark ? EvaIcons.sunOutline : EvaIcons.moonOutline,
            color: isDark ? Colors.white : Colors.black,
          ),
          backgroundColor: isDark ? Color(0xff363636) : Colors.white,
          onPressed: () {
            setState(() {
              changeBrightness();
            });

            //changeColor();
          },
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 600,
              decoration: BoxDecoration(
                  color: isDark ? Color(0xff363636) : Color(0xeeffffff),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow:
                      isDark ? [] : [BoxShadow(color: Colors.grey[400])]),
              margin: EdgeInsets.all(isBigScreen ? 32.0 : 16.0),
              padding: EdgeInsets.all(isBigScreen ? 16.0 : 0),
              child: Form(
                key: _formKey,
                child: Wrap(
                  spacing: 50,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          left: 48, top: 16, bottom: 16, right: 48.0),
                      child: Text(
                        'Personal Info',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          left: 5, top: 5, bottom: 25, right: 48.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(EvaIcons.personOutline),
                          hintText: 'What do people call you?',
                          labelText: 'Name *',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please write your name.';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          name = value;
                        },
                      ),
                    ),

                    /// Gender
                    Container(
                      margin: EdgeInsets.only(
                          left: 5, top: 5, bottom: 25, right: 48.0),
                      child: gender_dropDown(),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          left: 5, top: 5, bottom: 25, right: 48.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(EvaIcons.calendarOutline),
                          hintText: 'How old are you?',
                          labelText: 'Age *',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please write your true age.';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          age = value;
                        },
                      ),
                    ),

                    // Divider
                    Container(
                      margin: EdgeInsets.all(48.0),
                      height: 1,
                      color: Colors.grey[400],
                    ),

                    /// Work
                    Container(
                      margin: EdgeInsets.only(
                          left: 48, top: 16, bottom: 16, right: 48.0),
                      child: Text(
                        'Work',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          left: 5, top: 5, bottom: 25, right: 48.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(EvaIcons.printerOutline),
                          hintText: 'what do you do?',
                          labelText: 'Job Title *',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your job.';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          job_title = value;
                        },
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          left: 5, top: 5, bottom: 25, right: 48.0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          icon: Icon(EvaIcons.briefcaseOutline),
                          hintText: 'Where do you work?',
                          labelText: 'Company *',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please write your company (or) school name';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          company = value;
                        },
                      ),
                    ),

                    // Divider
                    Container(
                      margin: EdgeInsets.all(48.0),
                      height: 1,
                      color: Colors.grey[400],
                    ),

                    /// Education
                    Container(
                      margin: EdgeInsets.only(
                          left: 48, top: 16, bottom: 16, right: 48.0),
                      child: Text(
                        'Education',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          left: 5, top: 5, bottom: 25, right: 48.0),
                      child: education_dropDown(),
                    ),

                    // Divider
                    Container(
                      margin: EdgeInsets.all(48.0),
                      height: 1,
                      color: Colors.grey[400],
                    ),

                    Container(
                      margin: EdgeInsets.only(
                          left: 48, top: 16, bottom: 16, right: 48.0),
                      child: Text(
                        'Interest',
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 16, bottom: 25, right: 48.0),
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

                    /// T-Shirt Size
                    Container(
                      margin: EdgeInsets.only(
                          left: 5, top: 5, bottom: 25, right: 48.0),
                      child: tshirt_dropDown(),
                    ),

                    // Divider
                    Container(
                      margin: EdgeInsets.all(48.0),
                      height: 1,
                      color: Colors.grey[400],
                    ),

                    Container(
                      margin: EdgeInsets.only(
                        bottom: 48.0,
                      ),
                      alignment: Alignment.center,
                      child: RaisedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            print(name +
                                "\n" +
                                gender +
                                "\n" +
                                age +
                                "\n" +
                                tshirt_size);

                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            DatabaseService().registerUser(
                                widget.uuid,
                                Register(
                                  name: name,
                                  tshirt_size: tshirt_size,
                                  age: age,
                                  education: education,
                                  company: company,
                                  gender: gender,
                                  email: widget.email,
                                  job_title: job_title,
                                ));

                            print(choices);

                            /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Success(
                                      //   title: widget.title,
                                      )),
                            );*/
                          }
                        },
                        child: Text(
                          'Submit',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
