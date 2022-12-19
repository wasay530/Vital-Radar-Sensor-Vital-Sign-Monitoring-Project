import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'slides.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'actor.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
    @override
    Widget build(BuildContext context) {
      return NeumorphicApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.light,
        theme: NeumorphicThemeData(
          lightSource: LightSource.topLeft,
          accentColor: NeumorphicColors.accent,
          depth: 4,
          intensity: 0.5,
        ),
        darkTheme: NeumorphicThemeData(
          baseColor: Color(0xFF3E3E3E),
          lightSource: LightSource.topLeft,
          depth: 6,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _minpad = 5.0;


  /// Initialise the state
  @override
  void initState() {
    super.initState();

    /// We require the initializers to run after the loading screen is rendered
    Timer(Duration(seconds: 2), () {
      SchedulerBinding.instance.addPostFrameCallback((_) {

        runInitTasks();
      });
    });

  }
  @protected
  Future runInitTasks() async {
    var x=await getStringValuesSF();
    if (x!=null)
    {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return actorForm();
          }));
    }
    else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) {
            return IntroScreenDefault();
          }));
    }
  }



  @override
  Widget build(BuildContext context) {
    //TextStyle textStyle=Theme.of(context).textTheme.title;

    return Scaffold(
      backgroundColor: Colors.black,
      body: new InkWell(
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            /// Paint the area where the inner widgets are loaded with the
            /// background to keep consistency with the screen background
            new Container(
              decoration: BoxDecoration(color: Colors.black),
            ),
            /// Render the background image
            new Container(
              child: Image.asset('images/starter.png', fit: BoxFit.cover),
            ),
            /// Render the Title widget, loader and messages below each other
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new Expanded(
                  flex: 3,
                  child: new Container(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                          ),

                        ],
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /// Loader Animation Widget
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Colors.white),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                      ),
                      Text('Please Wait'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('tokenValue');
  return stringValue;
}

writeToken(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('tokenValue', text);
  debugPrint("*********************************************************************************************");
  debugPrint(
      "A new content,i.e. ${text} has been stored in local storage");
  debugPrint("*********************************************************************************************");
}