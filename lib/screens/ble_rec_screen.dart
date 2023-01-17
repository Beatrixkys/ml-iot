//install flutter blue package
//recognise a list of blue features
//display list of ble features + RSSI

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
//import 'package:flutter_blue/gen/flutterblue.pbserver.dart';
//import 'package:flutter_blue/gen/flutterblue.pbserver.dart';
//import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ml_iot_app/constants.dart';
import 'package:ml_iot_app/controller/database_controller.dart';
import 'package:ml_iot_app/screens/components/ble_card.dart';

class BLERecScreen extends StatefulWidget {
  const BLERecScreen({super.key});

  @override
  State<BLERecScreen> createState() => _BLERecScreenState();
}

class _BLERecScreenState extends State<BLERecScreen> {
  late Timer timer;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) {
      FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));

      setState(() {});

      FlutterBlue.instance.stopScan();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //List<BLEData> devicesfound = [];

    return Scaffold(
      appBar: AppBar(
        title: const Text("BLE Recognition"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(color: Colors.blueGrey),
          child: RefreshIndicator(
            onRefresh: () async {
              //initState();
              FlutterBlue.instance
                  .startScan(timeout: const Duration(seconds: 4));
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    "List of Bluetooth Devices In Area",
                    style: kLightHeadingTextStyle,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        //initState();
                        FlutterBlue.instance
                            .startScan(timeout: const Duration(seconds: 4));
                      },
                      child: const Text("scan")),
                  space,
                  const Divider(),
                  const Text("Hilti Tags", style: kLightHeadingTextStyle),
                  space,
                  StreamBuilder<List<ScanResult>>(
                      stream: FlutterBlue.instance.scanResults,
                      initialData: const [],
                      builder: (c, snapshot) {
                        var list = snapshot.data!;
                        var hList = list.where((element) => element
                            .advertisementData.manufacturerData
                            .containsKey(780));
                        if (hList.isNotEmpty) {
                          return Column(
                            children: hList
                                .map(
                                  (r) => BLECard(
                                    device: r,
                                  ),
                                )
                                .toList(),
                          );
                        }

                        return const Center(child: Text("No Hilti Tags Found"));
                      }),
                  const Divider(),
                  const Text("All Devices", style: kLightHeadingTextStyle),
                  StreamBuilder<List<ScanResult>>(
                      stream: FlutterBlue.instance.scanResults,
                      initialData: const [],
                      builder: (c, snapshot) {
                        if (snapshot.hasData) {
                          var list = snapshot.data!.where((element) => !element
                              .advertisementData.manufacturerData
                              .containsKey(780));
                          return Column(
                            children: list
                                .map(
                                  (r) => BLECard(
                                    device: r,
                                  ),
                                )
                                .toList(),
                          );
                        }

                        return const Center(child: Text("No Devices Found"));
                      }),
                  space,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BLEDistanceScreen extends StatefulWidget {
  final DeviceIdentifier deviceid;
  const BLEDistanceScreen({super.key, required this.deviceid});

  @override
  State<BLEDistanceScreen> createState() => _BLEDistanceScreenState();
}

class _BLEDistanceScreenState extends State<BLEDistanceScreen> {
  List<String> distancestring = ["Hotter", "Hot", "Cold", "Colder"];
  List<String> signalStrengthstring = ["Stronger", "Strong", "Weak", "Weaker"];
  List<Color> color = [
    Colors.red,
    Colors.redAccent,
    Colors.blueAccent,
    Colors.blue
  ];

  late Timer timer;
  late Timer displaytimer;
  int timercd = 7;
  num distance = 0;
  var name = "";
  var rssi = 0;
  var index = 0;

  @override
  void initState() {
    DatabaseService().saveBLE(rssi, widget.deviceid.toString());
    timer = Timer.periodic(const Duration(seconds: 7), (Timer t) {
      if (FlutterBlue.instance.isScanning == false) {
        FlutterBlue.instance.startScan(timeout: const Duration(seconds: 3));
      }
    });

    displaytimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (timercd == 0) {
        setState(() {
          timercd = 7;
          DatabaseService().updateBLE(rssi, widget.deviceid.toString());

        });
      } else {
        setState(() {
          timercd--;
        });
      }
    });
    super.initState();
  }

  int levels(int rssi) {
    if (rssi > -60) {
      return 0;
    } else if (-60 > rssi && rssi > -67) {
      return 1;
    } else if (-67 > rssi && rssi > -90) {
      return 2;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FlutterBlue.instance.scanResults,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              var list2 = snapshot.data;

              try {
                var list = list2!.firstWhere(
                  (element) => element.device.id == widget.deviceid,
                  //orElse: () => list2.first,
                );
//distance
                distance = pow(10, ((-69 - (list.rssi)) / (10 * 2)));
//rssi strength

                name = list.device.name;
                rssi = list.rssi;
                index = levels(rssi);


                

                
                return Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: color[index],
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const Spacer(),
                        const Text(
                          "Device",
                          style: kBLETitleTextStyle,
                        ),
                        Text(
                          name != "" ? name : widget.deviceid.toString(),
                          style: kBLENameTextStyle,
                        ),
                        space,
                        const Text(
                          "Distance",
                          style: kBLETitleTextStyle,
                        ),
                        showDistance(distance, index),
                        space,
                        const Text(
                          "Signal Strength",
                          style: kBLETitleTextStyle,
                        ),
                        showSignalStrength(rssi, index),
                        const Text(
                          "Next Scan In:",
                          style: kBLETitleTextStyle,
                        ),
                        Text("$timercd", style: kBigTextStyle),
                        ElevatedButton(
                            onPressed: () {
                              initState();

                              //FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
                            },
                            child: const Text("Refresh")),
                        const Spacer(),
                      ],
                    ),
                  ),
                );
              } on StateError {
                return Center(
                    child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Spacer(),
                    (const Text("Asset Scanning")),
                    ElevatedButton(
                        onPressed: () {
                          initState();
                          //FlutterBlue.instance.startScan(timeout: const Duration(seconds: 4));
                        },
                        child: const Text("Refresh")),
                    const Spacer(),
                  ],
                ));
              }
            }

            return Center(
                child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Spacer(),
                (const Text("Not in Range")),
                ElevatedButton(
                    onPressed: () {
                      //initState();
                      FlutterBlue.instance
                          .startScan(timeout: const Duration(seconds: 4));
                    },
                    child: const Text("Refresh")),
                const Spacer(),
              ],
            ));
          }),
    );
  }

  Widget showDistance(distance, index) {
    return Column(
      children: [
        Text(
          distancestring[index],
          textAlign: TextAlign.center,
          style: kBigTextStyle,
        ),
        Text(
          "${num.parse(distance.toStringAsFixed(2))} m",
          textAlign: TextAlign.center,
          style: kBiggestTextStyle,
        ),
      ],
    );
  }

  Widget showSignalStrength(rssi, index) {
    return Column(
      children: [
        Text(
          signalStrengthstring[index],
          textAlign: TextAlign.start,
          style: kBigTextStyle,
        ),
        Text(
          rssi.toString(),
          textAlign: TextAlign.start,
          style: kBigTextStyle,
        ),
      ],
    );
  }
}
