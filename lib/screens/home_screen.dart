import 'package:flutter/material.dart';

import '../constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> mlPages = ["Text Recognition", "Face Recognition"];
    List<String> mlRoutes = ["/textrec", "/facerec"];

    List<String> iotPages = ["BLE Devices", "NFC Devices"];
    List<String> iotRoutes = ["/blerec", "/nfc"];
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Machine Learning Features",
              style: kHeadingTextStyle,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, mlRoutes[index]);
                    },
                    child: Tooltip(
                      message: "Click to Navigate",
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(mlPages[index]),
                      ),
                    ),
                  );
                },
                itemCount: mlPages.length,
              ),
            ),
            const Text(
              "IoT Features",
              style: kHeadingTextStyle,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, iotRoutes[index]);
                    },
                    child: Tooltip(
                      message: "Click to Navigate",
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: Text(iotPages[index]),
                      ),
                    ),
                  );
                },
                itemCount: mlPages.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
