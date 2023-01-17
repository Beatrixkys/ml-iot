import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ml_iot_app/screens/ble_rec_screen.dart';

import 'package:provider/provider.dart';

import '../../constants.dart';

class BLEList extends StatefulWidget {
  const BLEList({super.key});

  @override
  State<BLEList> createState() => _BLEListState();
}

class _BLEListState extends State<BLEList> {
  @override
  Widget build(BuildContext context) {
    final devices = Provider.of<List<ScanResult>>(context);
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return BLECard(
          device: devices[index],
        );
      },
    );
  }
}

class BLECard extends StatelessWidget {
  final ScanResult device;

  const BLECard({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    num distance = pow(10, ((-69 - (device.rssi)) / (10 * 2)));
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  BLEDistanceScreen(deviceid: device.device.id)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue,
        ),
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        child: Row(children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.5,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.device.name,
                  style: kLightHeadingTextStyle,
                ),
                Text(
                  device.device.id.toString(),
                  style: kLightHeadingTextStyle,
                ),
                Text("RSSI: ${device.rssi.toString()}"),
                Text("Adv Data: ${device.advertisementData.manufacturerData.toString()}"),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              ("${num.parse(distance.toStringAsFixed(2))} m"),
              style: kLightHeadingTextStyle,
            ),
          ),
        ]),
      ),
    );
  }
}

//10^-69-(rssi))/10*2