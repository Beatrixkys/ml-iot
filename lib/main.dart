import 'package:flutter/material.dart';
import 'package:ml_iot_app/screens/ble_rec_screen.dart';
import 'package:ml_iot_app/screens/face_rec_screen.dart';
import 'package:ml_iot_app/screens/home_screen.dart';
import 'package:ml_iot_app/screens/text_rec_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ML and IoT Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Verdana",
        ),
        routes: {
          '/homescreen': (context) => const HomeScreen(),
          '/textrec': (context) => const TextRecScreen(),
          '/facerec': (context) => const FaceRecScreen(),
          '/': (context) => const BLERecScreen(),
        });
  }
}
