import 'package:bcy_twenty/data/colors.dart';
import 'package:bcy_twenty/data/db.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool loggedIn;
  bool isFirstTime = true;
  SharedPreferences prefs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  @override
  Widget build(BuildContext context) {
    // loggedIn = AuthProvider().loggedIn;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (_auth.currentUser != null) {
      return FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> snapshot) {
            if (snapshot.hasData) {
              return Home(
                uuid: snapshot.data.uid,
                email: snapshot.data.email,
                img: snapshot.data.photoUrl,
              );
            }
            return LoginPage();
          });
    } else {
      return LoginPage();
    }
  }
}

///

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name;
  String email;
  String imageUrl;
  String id;
  GoogleSignInAccount _currentUser;

  bool loggedIn;
  bool isFirstTime = true;
  SharedPreferences prefs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<Null> _getData() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs != null) {
      isFirstTime = prefs.getBool('isFirstTime');
    }
  }

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    if (authResult.additionalUserInfo.isNewUser){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FillForm(
            id: id,
            email: email,
          ),
        ),
      );
    }

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    assert(user.email != null);
    assert(user.displayName != null);
    assert(user.photoUrl != null);
    assert(user.uid != null);

    name = user.displayName;
    email = user.email;
    id = user.uid;
    imageUrl = user.photoUrl;

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Sign Out Complete");
  }

  Future<FirebaseUser> signUp(email, password) async {
    try {
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _getData();
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        signInWithGoogle();
      }
    });
    googleSignIn.signInSilently();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // loggedIn = AuthProvider().loggedIn;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    topBCYPass() {
      return Container(
        padding: EdgeInsets.all(16),
        width: 350,
        height: 225,
        decoration: BoxDecoration(
          color: isDark ? Color(0xff272727) : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Barcamp\nYangon\n2020',
                    style: TextStyle(
                      fontSize: 36,
                      fontFamily: GoogleFonts.courierPrime().fontFamily,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 16.0),
                    child: Text(
                      'February 15,16\n8AM - 5PM',
                      style: TextStyle(
                        fontFamily: GoogleFonts.courierPrime().fontFamily,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  '#bcy2020',
                  style: TextStyle(
                    fontFamily: GoogleFonts.novaMono().fontFamily,
                  ),
                ),
                Image.network(
                  'https://pbs.twimg.com/profile_images/619941689/barcampyangon_400x400.png',
                  width: 100,
                  height: 100,
                ),
              ],
            )
          ],
        ),
      );
    }

    bottomBCYPass() {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 42.0, vertical: 32.0),
        width: 350,
        height: 180,
        decoration: BoxDecoration(
          color: isDark ? Color(0xff272727) : Colors.grey[100],
        ),
        child: Column(children: <Widget>[
          Container(
            margin: EdgeInsets.all(5.0),
            height: 42,
            child: SignInButton(
              Buttons.Email,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoginWithEmail(
                          //title: widget.title,
                          )),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            height: 1,
            color: Colors.grey[400],
          ),
          Container(
            margin: EdgeInsets.all(5.0),
            height: 42,
            child: SignInButton(
              isDark ? Buttons.GoogleDark : Buttons.Google,
              onPressed: () {
                signInWithGoogle().whenComplete(() {
                  if (id != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(
                                //title: widget.title,
                                uuid: id,
                                name: name,
                                email: email,
                                img: imageUrl,
                              )),
                    );
                  }
                });
              },
            ),
          ),
        ]),
      );
    }

    signInRegister() {
      return Container(
        width: 350,
        height: 405,
        child: Form(
          key: _formKey,
          child: Column(),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Hero(
              tag: 'Top Ticket',
              transitionOnUserGestures: true,
              child: Material(
                child: Ticket(
                  innerRadius: BorderRadius.only(
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0)),
                  outerRadius: BorderRadius.all(Radius.circular(10)),
                  child: topBCYPass(),
                  boxShadow: [
                    new BoxShadow(
                      color: isDark ? Colors.transparent : Colors.grey[400],
                      offset: Offset(0, 2),
                      blurRadius: 3,
                    )
                  ],
                ),
              ),
            ),
            Ticket(
                innerRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0)),
                outerRadius: BorderRadius.all(Radius.circular(10)),
                child: bottomBCYPass(),
                boxShadow: [
                  new BoxShadow(
                    color: isDark ? Colors.transparent : Colors.grey[400],
                    offset: Offset(0, 2),
                    blurRadius: 3,
                  )
                ]),
          ],
        ),
      ),
    );
  }
}

/// Login (or) Register Page

class LoginWithEmail extends StatefulWidget {
  @override
  _LoginWithEmailState createState() => _LoginWithEmailState();
}

class _LoginWithEmailState extends State<LoginWithEmail> {
  final _formKey = GlobalKey<FormState>();
  String email;
  String password;
  String name = '';
  SharedPreferences prefs;
  bool isLogin = true;
  String id;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<Null> _getData() async {
    prefs = await SharedPreferences.getInstance();

    if (prefs != null) {
      //isFirstTime = prefs.getBool('isFirstTime');
    }
  }

  Future<FirebaseUser> signUp(email, password) async {
    try {
      FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      FirebaseUser user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      assert(user != null);
      assert(await user.getIdToken() != null);
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      id = user.uid;
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: isDark ? Color(0xff363636) : Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            boxShadow: isDark ? [] : [BoxShadow(color: Colors.grey[400])]),
        margin: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 20.0,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              isLogin = true;
                            });
                          },
                          child: Text('Login'),
                        ),
                        Container(
                          height: 2,
                          width: 50,
                          color: isLogin
                              ? BCYColors.MainColor
                              : Colors.transparent,
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        FlatButton(
                          onPressed: () {
                            setState(() {
                              isLogin = false;
                            });
                          },
                          child: Text('Register'),
                        ),
                        Container(
                          height: 2,
                          width: 50,
                          color: isLogin
                              ? Colors.transparent
                              : BCYColors.MainColor,
                        )
                      ],
                    ),
                  ),
                ],
              ),

              ///Email
              Container(
                margin:
                    EdgeInsets.only(left: 5, top: 5, bottom: 20, right: 48.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(EvaIcons.emailOutline),
                    hintText: 'Your Email Address',
                    labelText: 'Email *',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please write your email address.';
                    }
                    return null;
                  },
                  onSaved: (String value) {
                    email = value;
                  },
                ),
              ),

              ///Password
              Container(
                margin:
                    EdgeInsets.only(left: 5, top: 5, bottom: 20, right: 48.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    icon: Icon(EvaIcons.compassOutline),
                    hintText: 'Your Password for BCY2020 App',
                    labelText: 'Password *',
                  ),
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password must be longer than 6 characters.';
                    }
                    return null;
                  },
                  obscureText: true,
                  onSaved: (String value) {
                    password = value;
                  },
                ),
              ),

              // Divider
              Container(
                margin: EdgeInsets.only(left: 48.0, right: 48.0, bottom: 16.0),
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
                      /*print(name +
                                        "\n" +
                                        gender +
                                        "\n" +
                                        age +
                                        "\n" +
                                        tshirt_size);*/

                      try {
                        if (!isLogin) {
                          /// If the user is registering, it will sign up and then sign in.
                          signUp(email, password).whenComplete(() {
                            signIn(email, password).whenComplete(() {
                              if (id != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FillForm(
                                        id: id,
                                        email: email,
                                      )),
                                );
                              }
                            }); //sign in
                          }); //sign up
                        } else {
                          signIn(email, password).whenComplete(() {
                            if (id != null) {
                              var snapShot = Firestore.instance
                                  .collection('registration')
                                  .document(id)
                                  .snapshots();

                              if (snapShot != null) {

                                snapShot.listen((doc){
                                  name = '${doc.data['name']}';
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                        //title: widget.title,
                                        uuid: id,
                                        name: name,
                                        email: email,
                                      )),
                                );

                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FillForm(
                                      id: id,
                                      email: email,
                                    ),
                                  ),
                                );
                              }
                            }
                          });
                        }
                      } catch (e) {
                        print(e.code);
                      }


                      //print(choices);
                    }
                  },
                  child: Text(
                    'Continue',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fill Form Page

class FillForm extends StatefulWidget {
  FillForm({
    Key key,
    this.id,
    this.email,
  });

  final String id;
  final String email;

  @override
  _FillFormState createState() => _FillFormState();
}

class _FillFormState extends State<FillForm> {
  String name;
  String gender;
  String age;
  String job_title;
  String company;
  String education;
  String tshirt_size;

  String _gender = 'What do you consider yourself as?';
  String _edu = 'Your highest level of education.';

  final _formKey = GlobalKey<FormState>();

  List<String> choices = List();
  String _tshirt = 'What\'s your preferred T-Shirt Size?';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    void changeBrightness() {
      DynamicTheme.of(context)
          .setBrightness(isDark ? Brightness.light : Brightness.dark);
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
                  {
                    'votes': catVote + 1,
                    'users': catUsers + ', $email',
                  }
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
              'Your highest level of education.',
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
              if (value == 'Your highest level of education.') {
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

    interested_topics() {
      return categories();
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

    return StreamProvider<List<Categories>>(
      create: (_) => DatabaseService().streamCategories(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register',
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          elevation: 1,
          automaticallyImplyLeading: false,
          backgroundColor: isDark ? Color(0xff272727) : Colors.white,
        ),
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
                  color: isDark ? Color(0xff363636) : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  boxShadow:
                      isDark ? [] : [BoxShadow(color: Colors.grey[400])]),
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(0),
              child: Wrap(
                children: <Widget>[
                  Form(
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

                        /// Name
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

                        /// Age
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

                        /// Job
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

                        /// Company
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

                        /// Edu DropDown
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
                        // Divider
                        Container(
                          margin: EdgeInsets.only(
                              left: 48.0, right: 48.0, bottom: 16.0),
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

                        /// T-Shirt Size
                        Container(
                          margin: EdgeInsets.only(
                              left: 5, top: 5, bottom: 25, right: 48.0),
                          child: tshirt_dropDown(),
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
                                    widget.id,
                                    Register(
                                      name: name,
                                      gender: gender,
                                      age: age,
                                      job_title: job_title,
                                      company: company,
                                      education: education,
                                      email: widget.email,
                                      tshirt_size: tshirt_size,
                                      attended_rooms: 0,
                                      id: widget.id,
                                    ));

                                //print(choices);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Home(
                                            uuid: widget.id,
                                            email: widget.email,
                                          )),
                                );
                              }
                            },
                            child: Text(
                              'Submit',
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(
                              left: 48.0, top: 5, bottom: 25, right: 48.0),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'By clicking Submit, you\'re acknowledging and agreeing to the '),
                                TextSpan(
                                  text:
                                      'terms and conditions as well as privacy policies',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: new TapGestureRecognizer()
                                    ..onTap = () {
                                      launch('https://www.barcampyangon.org/');
                                    },
                                ),
                                TextSpan(
                                    text:
                                        ' provided by the Barcamp Yangon Organizer Team')
                              ],
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
        ),
      ),
    );
  }
}
