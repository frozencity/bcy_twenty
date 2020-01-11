import 'package:bcy_twenty/sponsors.dart';
import 'package:bcy_twenty/welcome.dart';
import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:bcy_twenty/tab_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.



  @override
  Widget build(BuildContext context) {
    //var AppColor = Color(0xff3c8be6);



    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        //systemNavigationBarDividerColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            return AuthProvider();
          },
        ),

      ],
      child: MaterialApp(
        title: 'Barcamp Yangon 2020',
        theme: ThemeData(
          // This is the theme of the application.
          //
          primaryColor: Colors.blue,
          canvasColor: Colors.white,
          backgroundColor: Colors.white,

          fontFamily: GoogleFonts.lato().fontFamily,

          appBarTheme: AppBarTheme(
            color: Colors.white,
            brightness: Brightness.light,
            iconTheme: IconThemeData(
              color: Colors.black45,
            )
          ),
        ),
       // home: MyHomePage(title: 'Barcamp Yangon 2020'),
          home: WelcomeScreen(title: 'Barcamp Yangon 2020'),

      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _fav = false;


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
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
                      MaterialPageRoute(builder: (context) => BarcampSponser()),
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
                      MaterialPageRoute(builder: (context) => WelcomeScreen(title: widget.title,)),
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
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    expandedHeight: 75,
                    title: Text(
                      widget.title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(EvaIcons.settingsOutline,),
                        tooltip: 'Sort',
                        onPressed: (){},
                      )
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

                  SliverStickyHeader(
                    header: new Container(
                      height: 60.0,
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      alignment: Alignment.centerLeft,
                      child: new Text(
                        'Header #0',
                        style: TextStyle(

                        ),
                      ),
                    ),

                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          /// To convert this infinite list to a list with "n" no of items,
                          /// uncomment the following line:
                          /// if (index > n) return null;
                          return ListTile(
                            title: Text('Topic Name $index'),
                            subtitle: Text('Speaker $index'),
                            trailing: IconButton(
                              onPressed: (){
                                setState(() {
                                  _fav = _fav ? false : true;
                                });
                              },
                              icon: Icon(_fav ? EvaIcons.checkmarkCircleOutline : EvaIcons.radioButtonOffOutline),
                            ),
                          );
                        },
                        /// Set childCount to limit no.of items
                        childCount: 3,
                      ),

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
