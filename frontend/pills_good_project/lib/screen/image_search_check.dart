import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pills_good_project/screen/manual_search_disease.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Drug Research App')),
        body: Material(
          child: ImageSearchCheck(),
        ),
      ),
    );
  }
}

class ImageSearchCheck extends StatefulWidget {
  @override
  _ImageSearchCheckState createState() => _ImageSearchCheckState();
}

class _ImageSearchCheckState extends State<ImageSearchCheck> {
  bool _isClicked = false; // 버튼의 클릭 상태를 추적하는 변수
  bool _isClicked_X = false; // 버튼의 클릭 상태를 추적하는 변수
  bool _isClicked2 = false; // 버튼의 클릭 상태를 추적하는 변수
  bool _isClicked2_X = false; // 버튼의 클릭 상태를 추적하는 변수

  // Firebase Storage에서 member.json 파일을 불러오는 함수
  Future<void> loadMemberJson() async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final memberJsonRef = storageRef.child('AI_output/K-001027_0_0_0_0_60_000_200.json');
      final String url = await memberJsonRef.getDownloadURL();
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final String contents = utf8.decode(response.bodyBytes);
        print('File contents: $contents');
      } else {
        print('Failed to load file');
      }
    } catch (e) {
      print('Error loading file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadMemberJson();
  }

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
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [const Color(0xFFFCE3A7), const Color(0xFFFFFAEE)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 63,
                top: 66,
                child: const Text(
                  '이미지 인식 결과',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 23,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Positioned(
                left: 56,
                top: 113,
                child: Container(
                  width: 268,
                  height: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("./assets/Rifampin2.png"),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 64,
                top: 93,
                child: const Text(
                  '인식된 알약을 확인해주세요.',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              // 여기에 나머지 UI 구성을 추가합니다.
          //제출하기 버튼
              Positioned(
                left: 64,
                top: 678,
                child: ElevatedButton(
                  onPressed: () {
                    // 버튼 클릭 시 실행될 함수

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManualSearchDisease(selectedPill: '타이레놀정500mg' ?? ''),
                        //builder: (context) => ImageSearchDisease(selectedPill: selectedPill ?? ''),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFF4C39), // 버튼 배경색
                    onPrimary: Color(0xFFFFFAEE), // 버튼 텍스트 색상
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21), // 버튼 모서리 둥글기
                    ),
                    minimumSize: Size(252, 42), // 버튼 크기
                    elevation: 4, // 버튼 그림자
                  ),
                  child: Text('제출하기'),
                ),
              ),
              ///////////////////////////////
              ///선택박스
              Positioned(
                left: 56,
                top: 319,
                child: Container(
                  width: 268,
                  height: 57,
                  child: Stack(
                    children: [

                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 268,
                          height: 57,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x7F000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),////////

                  Positioned(
                    left: 172,
                    top: 11,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _isClicked = !_isClicked; // 탭할 때마다 상태를 반전시킵니다.
                        });
                      },
                      child: Opacity(
                        opacity: 1.00,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: ShapeDecoration(
                            color: _isClicked ? Color(0xFFFFCB13) : Color(0xFFFFE292), // 클릭 상태에 따라 색상 변경 Color(0xFFFFE292)
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "O", // 컨테이너 내부에 "O" 텍스트 표시
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),


                      Positioned(
                        left: 214,
                        top: 11,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isClicked_X = !_isClicked_X; // 탭할 때마다 상태를 반전시킵니다.
                            });
                          },
                          child: Opacity(
                            opacity: 1.00,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: ShapeDecoration(
                                color: _isClicked_X ? Color(0xFFFF4C39) : Color(0x50FF4C39), // 클릭 상태에 따라 색상 변경 Color(0xFFFFE292)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "X", // 컨테이너 내부에 "O" 텍스트 표시
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 34,
                        top: 18,
                        child: Text(
                          '리팜핀정',
                          style: TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),


              ///선택박스
              Positioned(
                left: 56,
                top: 384,
                child: Container(
                  width: 268,
                  height: 57,
                  child: Stack(
                    children: [

                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 268,
                          height: 57,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(21),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x7F000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),////////

                      Positioned(
                        left: 172,
                        top: 11,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isClicked2 = !_isClicked2; // 탭할 때마다 상태를 반전시킵니다.
                            });
                          },
                          child: Opacity(
                            opacity: 1.00,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: ShapeDecoration(
                                color: _isClicked2 ? Color(0xFFFFCB13) : Color(0xFFFFE292), // 클릭 상태에 따라 색상 변경 Color(0xFFFFE292)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "O", // 컨테이너 내부에 "O" 텍스트 표시
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),


                      Positioned(
                        left: 214,
                        top: 11,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isClicked2_X = !_isClicked2_X; // 탭할 때마다 상태를 반전시킵니다.
                            });
                          },
                          child: Opacity(
                            opacity: 1.00,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: ShapeDecoration(
                                color: _isClicked2_X ? Color(0xFFFF4C39) : Color(0x50FF4C39), // 클릭 상태에 따라 색상 변경 Color(0xFFFFE292)
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  "X", // 컨테이너 내부에 "O" 텍스트 표시
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 34,
                        top: 18,
                        child: Text(
                          '니페딕스지속정',
                          style: TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              Positioned(
                left: 252,
                top: 125,
                child: Container(
                  width: 48,
                  height: 21,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 48,
                          height: 21,
                          decoration: ShapeDecoration(
                            color: Color(0xBF6B6A6A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 14,
                        top: 2,
                        child: Text(
                          '1/2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
/////////////////////////////////////////////////////////
              Positioned(
                left: 177,
                top: 283,
                child: Container(
                  width: 48,
                  height: 21,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFF4C39),
                            shape: OvalBorder(),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 15,
                        top: 0,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: ShapeDecoration(
                            color: Color(0xFF9B9999),
                            shape: OvalBorder(),
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


/*
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Drug Research App')),
        body: Material(
          child: ImageSearchCheck(),
        ),
      ),
    );
  }
}

class ImageSearchCheck extends StatefulWidget {
  @override
  _ImageSearchCheckState createState() => _ImageSearchCheckState();
}

class _ImageSearchCheckState extends State<ImageSearchCheck> {
  // Firebase Storage에서 member.json 파일을 불러오는 함수
  Future<void> loadMemberJson() async {
    try {
      // Firebase Storage 인스턴스 생성
      final storageRef = FirebaseStorage.instance.ref();
      // "AI_output/member.json"에 대한 참조 생성
      final memberJsonRef = storageRef.child('AI_output/K-001027_0_0_0_0_60_000_200.json');
      // 파일의 URL 가져오기
      final String url = await memberJsonRef.getDownloadURL();
      // URL을 사용하여 HTTP GET 요청을 통해 파일 내용을 불러옴
      final response = await http.get(Uri.parse(url));
      print("<헤더 출력하기>");
      print(response.headers);
      if (response.statusCode == 200) {
        final String contents = utf8.decode(response.bodyBytes);
        // 파일 내용 출력 (예시로 콘솔에 출력)
        print('File contents: $contents');
        // 파일 내용 출력 (예시로 콘솔에 출력)
        //print('File contents: ${response.body}');
      } else {
        print('Failed to load file');
      }
    } catch (e) {
      print('Error loading file: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // 위젯이 초기화될 때 member.json 파일 불러오기
    loadMemberJson();
  }

  @override
  Widget build(BuildContext context) {
    // UI 구성 코드
    return Center(
      child: Text('Loading...'),
    );
  }
}
*/





/*
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:pills_good_project/screen/result_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Drug Research App')),
        body: Material(
          child: ImageSearchCheck(),
        ),
      ),
    );
  }
}



class ImageSearchCheck extends StatefulWidget {
  @override
  _ImageSearchCheckState createState() => _ImageSearchCheckState();

}

class _ImageSearchCheckState extends State<ImageSearchCheck> {
  @override
  Widget build(BuildContext context) {
    // 여기에 UI를 구성하는 코드를 작성합니다.
    return Container();  // 우선은 빈 Container를 반환하도록 설정했습니다.
  }

}

*/