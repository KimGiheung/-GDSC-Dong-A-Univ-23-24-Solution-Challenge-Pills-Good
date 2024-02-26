import 'dart:io';
import 'package:path/path.dart'; // 상단에 추가
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pills_good_project/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pills_good_project/screen/image_search_load.dart';
//import 'package:flutter/storage_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';

class AutoSearchScreen extends StatefulWidget {

  static const routeName = '/getimage';
  final Storage storage=Storage();

  @override
  _AutoSearchScreenState createState() => _AutoSearchScreenState();

}


class _AutoSearchScreenState extends State<AutoSearchScreen> {

  List<File>? _images; // 여러 이미지 파일을 저장할 리스트
  final ImagePicker _picker = ImagePicker();




  File? _image;
  //String? _imageUrl; // url을 저장할 멤버 변수를 추가합니다.

  int _imageCount = 0; // 선택된 이미지의 개수

  Future getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();
    return Scaffold(
      body: Material( // 여기에 Material 위젯을 추가합니다.
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
                          colors: [Color(0xFFFCE3A7), Color(0xFFFFFAEE)],
                        ),
                      ),
                    ),
                  ),


                  Positioned(
                    left: 49,
                    top: 132,
                    child: GestureDetector(
                      child: Container(
                        width: 282,
                        height: 199,
                        child: Image.asset('./assets/registerImg.png',
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 59,
                    top: 333,
                    child: GestureDetector(
                      onTap: () async {
                        final results = await FilePicker.platform.pickFiles(
                          allowMultiple: true,
                          type: FileType.custom,
                          allowedExtensions: ['png', 'jpg'],
                        );

                        if (results != null) {
                          final List<File> images = results.files.map((file) =>
                              File(file.path!)).toList();
                          final Storage storage = Storage(); // Storage 클래스 인스턴스 생성

                          List<Future<String>> uploadFutures = [];
                          for (var image in images) {
                            final fileName = basename(image.path);
                            uploadFutures.add(
                                storage.uploadFile(image.path, fileName));
                          }

                          await Future.wait(uploadFutures);

                          // 모든 업로드가 완료된 후 다음 화면으로 이동
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ImageSearchLoad(
                                      images: images), // ImageSearchLoad 생성자가 images 리스트를 받도록 구현되어야 함
                            ),
                          );
                        } else {
                          print('No images selected.');
                        }
                      },
                      child: Container(
                        width: 260,
                        height: 57,
                        child: Image.asset(
                            './assets/selectGallery.png', fit: BoxFit.fill),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 60,
                    top: 387,
                    child: GestureDetector(
                      onTap: () {
                        getImage(ImageSource.camera);
                        /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AutoSearchScreen(),
                      ),
                    );*/
                      },
                      child: Container(
                        width: 260,
                        height: 57,
                        child: Image.asset('./assets/selectCamera.png',
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),

                  _image == null
                      ? Container()
                      : Image.file(_image!), // 선택한 이미지를 화면에 표시합니다.


                  Positioned(
                    left: 63,
                    top: 66,
                    child: Text(
                      '어떤 약을 복용하실건가요?',
                      style: TextStyle(
                        color: Color(0xFF3F3F3F),
                        fontSize: 23,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        height: 0,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 63,
                    top: 93,
                    child: Text(
                      '필스 굿이 동시 복용이 가능한지 알려드릴게요.',
                      style: TextStyle(
                        color: Color(0xFF3F3F3F),
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

