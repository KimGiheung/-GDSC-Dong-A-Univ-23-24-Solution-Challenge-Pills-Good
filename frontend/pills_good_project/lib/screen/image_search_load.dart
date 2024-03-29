import 'package:flutter/material.dart';
import 'dart:io';
import 'package:pills_good_project/screen/image_search_check.dart';
import 'package:pills_good_project/storage_service.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pills_good_project/screen/image_search_load.dart';
import 'package:pills_good_project/screen/image_search_disease.dart';
void main() {
  runApp(const FigmaToCodeApp());
}

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
          //ImageSearchLoad(),
        ]),
      ),
    );
  }
}

class ImageSearchLoad extends StatelessWidget {
  //final File imageFile;  // imageFile을 선택적 매개변수로 변경
  final List<File> images; // 생성자를 List<File> 타입으로 변경
  //ImageSearchLoad({required this.imageFile}); // 생성자에서 imageFile을 선택적으로 만듦
  ImageSearchLoad({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // GestureDetector를 사용하여 전체 위젯을 감쌉니다.
    return GestureDetector(
      onTap: () {
        // 탭 이벤트가 발생하면 실행될 코드
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ImageSearchCheck()), // NextPage는 다음 화면의 위젯입니다.
        );
      },

      child: Column(
        children: [
          Container(
            width: 380,
            height: 825,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 380,
                  height: 825,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('./assets/loading.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Next Page"),
      ),
      body: Center(
        child: Text("This is the next page"),
      ),
    );
  }
}


