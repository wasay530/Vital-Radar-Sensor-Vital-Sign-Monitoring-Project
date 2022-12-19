import 'main.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'actor.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IntroScreenDefault extends StatefulWidget {
  const IntroScreenDefault({Key? key}) : super(key: key);

  @override
  IntroScreenDefaultState createState() => IntroScreenDefaultState();
}

class IntroScreenDefaultState extends State<IntroScreenDefault> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      Slide(
        title: "Positioning",
        description:
        "Allow miles wound place the leave had. To sitting subject no improve studied limited",
        pathImage: "images/mainer.png",
        backgroundColor: const Color(0xDBD9D9FF),
      ),
    );
    slides.add(
      Slide(
        title: "Measure",
        description:
        "Press the pointed icon and wait for 30 seconds to get your heart and breathing rate",
        pathImage: "images/measure.png",
        backgroundColor: const Color(0xDBD9D9FF),
      ),
    );
  }

  void onDonePress() {
    // Do what you want
    writeToken("Checked");
    Navigator.push(context,
        MaterialPageRoute(builder: (context) {
          return actorForm();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      onDonePress: onDonePress,
    );
  }
}

writeToken(String text) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('tokenValue', text);
  debugPrint("*********************************************************************************************");
  debugPrint(
      "A new content,i.e. ${text} has been stored in local storage");
  debugPrint("*********************************************************************************************");
}
