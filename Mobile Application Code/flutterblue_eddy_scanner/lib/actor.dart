import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:intro_slider/intro_slider.dart';
import 'slides.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart' as bs;
import 'package:beacon_broadcast/beacon_broadcast.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math' as math;



// Data need to sent second screen
class Vital {
  final double hr;
  final double br;

  Vital(this.hr, this.br);
}


class actorForm extends StatefulWidget {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  State<StatefulWidget> createState() {
    return _actorFormState();
  }
}

class _actorFormState extends State<actorForm> {
  String _message = "";
  int _val=0;
  double myhr=0.0;
  double mybr=0.0;
  String _scanBarcode = 'Unknown';
  bool indi=true;
  bool already_checked=false;
  bool errorer=false;


  void _incrementcounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _val=_val+1;
      if(_val==59)
      {
        _val=0;

      }
    });
  }

  void _incrementstring() {
    setState(() {
      _message="Please stay still for about 30 seconds..";
    });
  }

  void _incrementstring2() {
    setState(() {
      _message="Gathering data";
    });
  }

  void _incrementstring3() {
    setState(() {
      _message="";
    });
  }
  Future<void> scanQR() async {

      var barcodeScanRes = await bs.FlutterBarcodeScanner.scanBarcode(
          "#ff6666",
          "Cancel", false, bs.ScanMode.DEFAULT);
    if(barcodeScanRes!=null) {
      setState(() {
        _scanBarcode = barcodeScanRes;
      });
    }
  }

  BeaconBroadcast beaconBroadcast = BeaconBroadcast();

  bool _isAdvertising = false;
  late BeaconStatus _isTransmissionSupported;
  late StreamSubscription<bool> _isAdvertisingSubscription;

  @override
  void initState() {
    super.initState();
    beaconBroadcast
        .checkTransmissionSupported()
        .then((isTransmissionSupported) {
      setState(() {
        _isTransmissionSupported = isTransmissionSupported;
      });
    });

    _isAdvertisingSubscription =
        beaconBroadcast.getAdvertisingStateChange().listen((isAdvertising) {
          setState(() {
            _isAdvertising = isAdvertising;
          });
        });
  }


  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/mainer.png');
    Image image = Image(
      image: assetImage,
      width: 325.0,
      height: 200.0,
    );

    AssetImage assetImage2 = AssetImage('images/heart.png');
    Image image2 = Image(
      image: assetImage2,
      width: 105.0,
      height: 100.0,
    );

    AssetImage assetImage3 = AssetImage('images/breathing.png');
    Image image3 = Image(
      image: assetImage3,
      width: 105.0,
      height: 100.0,
    );
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text(""),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          // NeumorphicButton(
          //   child: Icon(Icons.qr_code_scanner),
          //   onPressed: () {
          //     scanQR();
          //   },
          // ),
        ],
      ),
      backgroundColor: NeumorphicTheme.baseColor(context),
      body:Container(
        child:Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
            children: <Widget>[
          Visibility(
            child:Container(
            child: image,
            margin: EdgeInsets.only(
                bottom:0.0,top: 0.0),
          ),
            visible: indi,
          ),

              Visibility(child:NeumorphicText(
                'Please keep yourself in this position to measure vital signs and make sure Bluetooth is turned on',
                style: NeumorphicStyle(
                  depth: 4,  //customize depth here
                  color: Colors.blueGrey, //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 14, //customize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
                textAlign: TextAlign.center,
              ),
                visible: indi,
              ),
              Container(
                margin: EdgeInsets.only(
                    bottom: 150.0),
              ),
          Visibility(
            child:
              NeumorphicText(
                '$_message',
                style: NeumorphicStyle(
                  depth: 4,  //customize depth here
                  color: Colors.blueGrey, //customize color here
                ),
                textStyle: NeumorphicTextStyle(
                  fontSize: 18, //customize size here
                  // AND others usual text style properties (fontFamily, fontWeight, ...)
                ),
                textAlign: TextAlign.center,
              ),
            visible: indi,
          ),
              // NeumorphicProgress(
              //     percent: 1,
              //   ),
          Container(
            margin: EdgeInsets.only(
                top: 0.0),
          ),
              Visibility(child:
                  Column(
                    children:[
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        left: 35.0),
                  ),
                  Container(
                    child: CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 20.0,
                      percent: myhr/150.0,
                      center: image2,
                      progressColor: Colors.green,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20.0),
                  ),
                  Container(
                    child: CircularPercentIndicator(
                      radius: 80.0,
                      lineWidth: 20.0,
                      percent: mybr/30,
                      center: image3,
                      progressColor: Colors.green,
                    ),
                  ),
                ],
              ),
                      Container(
                        child: Padding(
                            padding: EdgeInsets.only(top: 10.0, bottom:10.0,right:30.0),
                            child:
                            SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                primaryYAxis: NumericAxis(minimum: 0, maximum: 160, interval: 20),
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <ChartSeries<_ChartData, String>>[
                                  BarSeries<_ChartData, String>(
                                      dataSource: [
                                        _ChartData('❤', myhr),
                                        _ChartData('🫁', mybr),
                                      ],
                                      xValueMapper: (_ChartData data, _) => data.x,
                                      yValueMapper: (_ChartData data, _) => data.y,
                                      name: 'BPM',
                                      color: Color.fromRGBO(1, 1, 1, 2))
                                ])),
                      ),


                    ],),
                visible: !indi,),
              Visibility(child:
              Center(
                child: Container(
                  // margin: const EdgeInsets.all(10.0),
                  // color: Colors.amber[600],
                  width: 160.0,
                  height: 20.0,
                  child: NeumorphicProgress(
                    percent: _val/30,
                  ),
                ),
              ),
                visible: indi,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: 20.0),
              ),

              Visibility(
                child:
                NeumorphicText(
                  'Please try again and follow the top guidance',
                  style: NeumorphicStyle(
                    depth: 4,  //customize depth here
                    color: Colors.red, //customize color here
                  ),
                  textStyle: NeumorphicTextStyle(
                    fontSize: 10, //customize size here
                    // AND others usual text style properties (fontFamily, fontWeight, ...)
                  ),
                  textAlign: TextAlign.center,
                ),
                visible: errorer,
              ),

            ],
          ),
        ),
      ),

      floatingActionButton:Container(
        height: 100.0,
        width: 100.0,
        child: FittedBox(
          child:NeumorphicFloatingActionButton(
            onPressed: (){
              setState(() {
                errorer=false;
              });
              if(already_checked)
                {
                  setState(() {
                    indi = !indi;
                  });
                }
              beaconBroadcast
                  .setUUID('39ED98FF-2900-441A-802F-9C398FC199D2')
                  .setMajorId(1)
                  .setMinorId(100)
                  .setLayout('m:2-3=0215,i:4-19,i:20-21,i:22-23,p:24-24')
                  .setManufacturerId(0x004c)
                  .start();

              _incrementstring();
              for(var i=1;i<30;i++)
              {
                Timer(Duration(seconds: i), () {
                  _incrementcounter();
                });
              }

              Timer(Duration(seconds: 4), () {
                beaconBroadcast.stop();
              });

              Timer(Duration(seconds: 21), () {
                _incrementstring2();
                FlutterBlue flutterBlue = FlutterBlue.instance;
                // Start scanning
                flutterBlue.startScan(timeout: Duration(seconds: 8));

                var subscription = flutterBlue.scanResults.listen((results) {
                  // do something with scan results
                  for (ScanResult r in results) {
                    // print('${r.advertisementData.manufacturerData}');
                    // print('${r.device.name} found! rssi: ${r.rssi}');
                    // Pass it to our previous function
                    var data=r.advertisementData.serviceData.values.toList();
                    if(data.length != 0) {
                      print(
                          "---------------------------------------------------");
                      print(data[0]);
                      var fin_data = data[0];
                      print(hex.encode(fin_data.sublist(2, 8)));
                      if (hex.encode(fin_data.sublist(2, 8)) ==
                          'aabbccddeeff') {
                        var heartrate = int.parse(
                            hex.encode(fin_data.sublist(8, 9)), radix: 16)
                            .toDouble();
                        var sub_heartrate = int.parse(
                            hex.encode(fin_data.sublist(9, 10)), radix: 16)
                            .toDouble();
                        var breathingrate = int.parse(
                            hex.encode(fin_data.sublist(10, 11)), radix: 16)
                            .toDouble();
                        var sub_breathingrate = int.parse(
                            hex.encode(fin_data.sublist(11, 12)), radix: 16)
                            .toDouble();

                        setState(() {
                          myhr = (heartrate + sub_heartrate / 100);
                          mybr = breathingrate + sub_breathingrate / 100;
                        });
                        print("Heart Rate: ${myhr}");
                        print("Breathing Rate: ${mybr}");
                        print("---------------------------------------------------");
                        flutterBlue.stopScan();
                      }

                    }

                  }
                });
                // flutterBlue.stopScan();
              });
              Timer(Duration(seconds: 29), () {
                _incrementstring3();
                print(myhr);
                if (myhr!=0.0 && mybr!=0.0) {
                  //   Navigator.push(context, new MaterialPageRoute(
                  //       builder: (context) =>
                  //       new resultForm(vital: new Vital(myhr, mybr))));
                  setState(() {
                    indi = !indi;
                    already_checked=true;
                  });
                }
                else
                  {
                    errorer=true;
                  }

              });
            },
            child: const Icon(Icons.monitor_heart),

          ),

        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

// This trailing comma makes auto-formatting nicer for build methods.
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

Widget getImageAsset() {
  AssetImage assetImage = AssetImage('images/mainer.png');
  Image image = Image(
    image: assetImage,
    width: 325.0,
    height: 200.0,
  );
  return Container(
    child: image,
    margin: EdgeInsets.only(
        bottom:0.0,top: 0.0),
  );

}


class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}


