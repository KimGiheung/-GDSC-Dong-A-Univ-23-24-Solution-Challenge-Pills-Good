import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:pills_good_project/screen/splash_screen.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

/*
import 'dart:async'; // 스플래시 화면 지연에 필요
import 'package:firebase_core/firebase_core.dart';
import 'package:p3/widget/bottom_bar.dart';

import 'package:p3/screen/home_screen.dart';
import 'package:p3/screen/find_screen.dart';
import 'package:p3/screen/search_screen.dart';
import 'package:p3/screen/mypage_screen.dart';

import 'package:p3/screen/splash_screen.dart';
*/

//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
//void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  //makePostRequest();

  //fetchData();
  //await FirebaseAuth.instance.signInAnonymously();
  //FirebaseAuth mAuth = FirebaseAuth.getInstance();

  /*
  void fetchData() async {
    var url = 'https://ab94-124-51-164-190.ngrok-free.app/api/v3/patient';
    var request = http.Request('POST', Uri.parse(url));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } else {
      print(response.reasonPhrase);
    }
  }
  */



/*
  final dio = Dio();

  void getHttp() async {
    final response = await dio.get('https://dart.dev');
    print(response);
  }*/

  //makePostRequest();

  runApp(MyApp());

/*
  try {
    final userCredential =
    await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }*/
}

/*
void fetchData() async {
  String jsonData = await rootBundle.loadString('assets/sample.json');
  Map<String, dynamic> data = jsonDecode(jsonData);
  print(data);

  // 이제 'data' 변수를 사용해서 원하는 작업을 할 수 있습니다.
}
*/
/*
void makePostRequest() async {
  var headers = {
    'Content-Type': 'application/json'
  };
  var request = http.Request('POST', Uri.parse('https://ab94-124-51-164-190.ngrok-free.app/api/v1/drug-research'));
  request.body = json.encode({
    "drugName": "리팜핀"
  });
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  }
  else {
    print(response.reasonPhrase);
  }

}
*/



class MyApp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  //TabController controller;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'pills_good',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          hintColor: Colors.white),
      home: SplashScreen(), // SplashScreen을 첫 화면으로 설정
      // DefaultTabController(length: 4, child:Scaffold(body:TabBarView(
    );
  }
}




