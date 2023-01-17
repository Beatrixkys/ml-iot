//install flutter package https://pub.dev/packages/google_mlkit_text_recognition

//Create upload image section
//extract list of strings from image
//Display list of strings in a text field

import 'package:flutter/material.dart';
import 'package:ml_iot_app/constants.dart';

class TextRecScreen extends StatelessWidget {
  const TextRecScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Text Recognition", ),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Add an Image with Text",
              style: kHeadingTextStyle,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(10)),
              child: (const Text("Image Goes Here")),
            ),
            ElevatedButton(onPressed: () {}, child: const Text("Click to Add")),
            const Text(
              "Text From Image",
              style: kHeadingTextStyle,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Generated Text Goes here",
                    contentPadding: EdgeInsets.all(15),
                    labelText: "Text From Image",
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
