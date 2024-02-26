import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:pills_good_project/screen/splash_screen.dart';
import 'package:flutter/services.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  runApp(MyApp());

}

class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pills_good',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          hintColor: Colors.white),
      home: SplashScreen(), // Set SplashScreen as first screen
    );
  }
}




