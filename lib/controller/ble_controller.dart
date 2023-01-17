//consider flutter blue instead
//!! priority is returning the RSSI to measure the distance
//https://pub.dev/packages/flutter_blue
import 'package:flutter_blue/flutter_blue.dart';

import '../model/ble_model.dart';

class BLE {
  FlutterBlue flutterBlue = FlutterBlue.instance;

//discover the device
 void deviceDiscovery() {
    List<BLEData> devicesfound = [];
    // Start scanning
    flutterBlue.startScan(timeout: const Duration(seconds: 7));

// Listen to scan results

    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        //add device to list

        devicesfound.add(BLEData(name: r.device.name, rssi: r.rssi));
        //devicesfound[i] = ({device:r.device, rssi:r.rssi});
        //print('${r.device} and ${r.rssi}');

      }

      //return devicesfound;
    }
    );
// Stop scanning
    print('$devicesfound');
    flutterBlue.stopScan();


  }

  
  void deviceConnect(BluetoothDevice device) {
    device.connect();
  }

  int distanceCalc(int rssi) {
    int distance = 10 ^ (-69 - (rssi)) ~/ (10 * 2);

    return distance;
  }

}
