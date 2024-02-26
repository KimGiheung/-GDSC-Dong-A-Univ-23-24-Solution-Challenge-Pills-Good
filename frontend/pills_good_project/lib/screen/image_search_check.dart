import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pills_good_project/screen/auto_search_disease.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//import 'package:smooth_page_indicator/smooth_page_indicator.dart';
//import 'package:carousel_slider/carousel_slider.dart';

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


  int activeIndex = 0; // 현재 활성화된 이미지의 인덱스를 추적합니다.

  final List<String> images = [
    'assets/레보록신정.png',
    'assets/명인할로페리돌정1.5밀리그램.png',
    //'assets/pill.png',
    // 추가 이미지 경로를 여기에 넣으세요.
  ];

  // 이미지에 따라 변경될 텍스트 배열
  final List<String> imageTexts = [
    '레보록신정',
    '명인할로페리돌정',
    // 각 이미지에 해당하는 텍스트를 여기에 넣으세요.
  ];

  Widget imageSlider(String path, int index) => Container(
    width: double.infinity,
    height: 240,
    color: Colors.grey,
    child: Image.asset(path, fit: BoxFit.cover),
  );

  Widget indicator() => Container(
    margin: const EdgeInsets.only(bottom: 20.0),
    alignment: Alignment.bottomCenter,
    child: AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: images.length,
      effect: JumpingDotEffect(
          dotHeight: 6,
          dotWidth: 6,
          activeDotColor: Colors.orange,
          dotColor: Colors.white.withOpacity(0.6)),
    ),
  );



  // Firebase Storage에서 member.json 파일을 불러오는 함수  (되는건데 임시로만 주석처리)
  /*
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

   */
  Future<void> listFiles() async {
    await Firebase.initializeApp();
    final storageRef = FirebaseStorage.instance.ref().child('Ai_input_img');
    final result = await storageRef.listAll();

    // 파일 목록을 날짜순으로 정렬
    var files = result.items;
    // 파일 메타데이터를 사용하여 정렬을 구현해야 함
    // 예: 파일 이름 또는 메타데이터에 날짜 정보가 포함되어 있다고 가정
  }


  Future<void> displayLatestFile(String filePath) async {
    // 파일 다운로드 URL 가져오기
    final downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL();

    // 이 URL을 사용하여 Flutter 앱에서 이미지나 데이터를 표시
    // 예: Image.network(downloadURL) 를 사용하여 이미지 표시
  }

  Future<void> downloadAndDisplayImage() async {
    final imagePath = 'Ai_output/latestImage.png'; // 최신 이미지 파일 경로
    await displayLatestFile(imagePath);
  }

  Future<void> downloadAndDisplayJson() async {
    final jsonPath = 'Ai_output/latestData.json'; // 최신 JSON 파일 경로
    // JSON 파일 다운로드 및 파싱 로직 구현
  }

  //파이어베이스 스토리지 -> 이미지 가져오기 (테스트 안해봤지만 일단 주석
  /*
  Future<Image> loadImageFromFirebaseStorage() async {
    try {
      // Firebase Storage 인스턴스와 참조 설정
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('AI_output/K-001027_0_0_0_2_90_040_200.png'); // 이미지 경로 수정 필요

      // 이미지 파일의 URL 가져오기
      final String url = await imageRef.getDownloadURL();

      // 이미지 URL을 사용하여 Image 위젯 생성
      return Image.network(url);
    } catch (e) {
      // 오류 발생 시 콘솔에 출력하고 기본 이미지 반환
      print('Error loading image: $e');
      return Image.asset('assets/kk.png'); // 기본 이미지 경로 수정 필요
    }
  }*/


  //파이어베이스에서 url 가져오기
  @override
  void initState() {
    super.initState();
    //getLatestFileMetadata();
    //loadLatestFile();
    //loadMemberJson();
  }

  @override
  Widget build(BuildContext context) {
    //return Scaffold(
     //   appBar: AppBar(
       //   title: Text('Image Slider with Indicator'),
        //),
    return Scaffold(
        body: Material(
        child: Column(
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


              //사진 들어가는 부분
              Positioned(
                left: 56,
                top: 113,
                child: Container(
                  width: 268,
                  height: 160,
                  child: Stack(
                    alignment:Alignment.bottomCenter,
                    children: <Widget>[
                      CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 160, //슬라이더의 높이 조정
                            initialPage: 0,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            onPageChanged: (index,reason)=>setState((){
                              activeIndex=index;
                            }),
                          ),
                      itemCount: images.length,
                      itemBuilder: (context, index, realIndex){
                            final path=images[index];
                            return imageSlider(path, index);
                      },
                      ),
                      indicator(),
                    ],
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
                        builder: (context) => AutoSearchDisease(selectedPill: '레보록신정 , 명인할로페리돌정' ?? ''),
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
                        left: 34,
                        top: 18,
                        child: Text(
                          // 현재 활성화된 이미지 인덱스에 맞는 텍스트를 표시합니다.
                          imageTexts[activeIndex],
                          style: TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontSize: 15,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],

            /*
          ),
        ),
    ],
        ),
        ],
    );
  }
}
*/
          ),
        ),
        ],
        ),
        ),
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