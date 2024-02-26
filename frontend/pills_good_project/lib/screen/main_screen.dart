import 'package:flutter/material.dart';
import 'package:pills_good_project/screen/auto_search_screen.dart';
import 'package:pills_good_project/screen/manual_search_screen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
void main() {
  runApp(const FigmaToCodeApp());

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
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(
          children: [
            MainScreen(),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 380,
          height: 825,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 380,
                  height: 825,
                  decoration: ShapeDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFFFCE3A7), Color(0xFFFFFAEE)],
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                  ),
                ),
              ),
              /*
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 380,
                  height: 825,
                  child: Image.asset('./assets/main_screen_background.png',
                      fit: BoxFit.fill),
                ),
              ),

               */

              Positioned(
                left: 72,
                top: 72,
                child: Text(
                  '나의 약 안전하고 건강하게',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 72,
                top: 87,
                child: Text(
                  'Pill’s Good',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 33,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),

              Positioned(
                left: 47,
                top: 277,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AutoSearchScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 286,
                    height: 153,
                    child: Image.asset('./assets/auto_search.png',
                        fit: BoxFit.fill),
                  ),
                ),
              ),

              Positioned(
                left: 47,
                top: 428,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManualSearchScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 286,
                    height: 153,
                    child: Image.asset('./assets/manual_search.png',
                        fit: BoxFit.fill),
                  ),
                ),
              ),

              Positioned(
                left:56,
                top:581,
                child:Container(
                  width: 268,
                  height: 116,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 268,
                          height: 116,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(width: 3, color: Color(0xFFFFE292)),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 2,
                                offset: Offset(2, 2),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 40,
                        top: 27,
                        child: Text(
                          '큰 글씨로 보기',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 33,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 52,
                        top: 66,
                        child: Text(
                          '시력에 어려움이 있다면?',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            ],
          ),
        ),
      ],
    );
  }
}

