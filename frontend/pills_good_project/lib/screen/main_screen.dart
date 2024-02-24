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
                top: 389,
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
                top: 555,
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
            ],
          ),
        ),
      ],
    );
  }
}


//별로 달라진게 없는 코드
/*import 'package:flutter/material.dart';
import 'package:pills_good/screen/auto_search_screen.dart';
import 'package:pills_good/screen/auto_search_screen.dart';

void main() {
  runApp(const FigmaToCodeApp());
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
                  child: Image.asset('./assets/main_screen_background.png',
                      fit: BoxFit.fill),
                ),
              ),
              Positioned(
                left: 47,
                top: 389,
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
                top: 555,
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
            ],
          ),
        ),
      ],
    );
  }
}


class AutoSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Search Screen'),
      ),
      body: Center(
        child: Text('Auto Search Screen'),
      ),
    );
  }
}
/*
class ManualSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Search Screen'),
      ),
      body: Center(
        child: Text('Manual Search Screen'),
      ),
    );
  }
}
*/


*/


/*연구해볼 코드 
import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
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
                  child: Image.asset('./assets/main_screen_background.png',
                      fit: BoxFit.fill),
                ),
              ),
              Positioned(
                left: 47,
                top: 389,
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
                top: 555,
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
            ],
          ),
        ),
      ],
    );
  }
}

class AutoSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auto Search Screen'),
      ),
      body: Center(
        child: Text('Auto Search Screen'),
      ),
    );
  }
}

class ManualSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manual Search Screen'),
      ),
      body: Center(
        child: Text('Manual Search Screen'),
      ),
    );
  }
}

*/

//배경화면 + 사진버튼 넣기

/*import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

// Generated by: https://www.figma.com/community/plugin/842128343887142055/
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          MainScreen(),
        ]),
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
                  child: Image.asset('./assets/main_screen_background.png',
                      fit: BoxFit.fill),
                ),
              ),
              Positioned(
                left: 47,
                top: 389,
                child: Container(
                  width: 286,
                  height: 153,
                  child:
                      Image.asset('./assets/auto_search.png', fit: BoxFit.fill),
                ),
              ),
              Positioned(
                left: 47,
                top: 555,
                child: Container(
                  width: 286,
                  height: 153,
                  child: Image.asset('./assets/manual_search.png',
                      fit: BoxFit.fill),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

*/


/*
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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/380x825"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 47,
                top: 389,
                child: Container(
                  width: 286,
                  height: 153,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/286x153"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 47,
                top: 555,
                child: Container(
                  width: 286,
                  height: 153,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          NetworkImage("https://via.placeholder.com/286x153"),
                      fit: BoxFit.fill,
                    ),
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

*/


// backgrond color 코드

/*

import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('./assets/main_screen_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Text(
          '메인 화면',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        //child: Text('사진 검색'),
      ),
    );
  }
}
*/

////////////////////


/*
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('사진 검색'),
      ),
    );
  }
}
*/