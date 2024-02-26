import 'dart:io';
import 'package:path/path.dart'; // 상단에 추가
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pills_good_project/screen/image_search_check.dart';
import 'package:pills_good_project/storage_service.dart';
import 'package:image_picker/image_picker.dart';

import 'package:pills_good_project/screen/image_search_load.dart';
import 'package:pills_good_project/screen/sample/upload_image_demo.dart';

import 'package:pills_good_project/screen/image_search_disease.dart';

import 'package:pills_good_project/screen/sample/test_image_slider.dart';
import 'package:pills_good_project/screen/drag_research_form.dart';


import 'package:pills_good_project/screen/add_item.dart';
//import 'package:flutter/storage_service.dart';
import 'cloud_storage_demo.dart'; // CloudStorageDemo 페이지를 import 합니다.
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';

class AutoSearchScreen extends StatefulWidget {

  static const routeName = '/getimage';
  final Storage storage=Storage();

  @override
  _AutoSearchScreenState createState() => _AutoSearchScreenState();

}


class _AutoSearchScreenState extends State<AutoSearchScreen> {
  //FilePicker 관련
  List<File>? _images; // 여러 이미지 파일을 저장할 리스트
  final ImagePicker _picker = ImagePicker();



/*
  Future<void> pickImages() async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (results != null) {
      final List<File> images = results.files.map((file) => File(file.path!)).toList();

      final Storage storage = Storage();
      for (var image in images) {
        final fileName = basename(image.path);
        final downloadURL = await storage.uploadFile(image.path, fileName);
        print('Download URL: $downloadURL');
      }

      setState(() {
        _images = images;
      });

      // 파일 업로드 후 다음 페이지로 넘어가는 로직 추가
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageSearchLoad(images: _images!),
        ),
      );
    } else {
      print('No images selected.');
    }
  }
*/

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
                  /*
  @override
  Widget build(BuildContext context) {
    final Storage storage=Storage();
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
                      colors: [Color(0xFFFCE3A7), Color(0xFFFFFAEE)],
                    ),
                  ),
                ),
              ),*/

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
                  /*
              Positioned(
              left: 59,
              top: 333,

              child: GestureDetector(
                onTap: () async {
                  final results=await FilePicker.platform.pickFiles(
                    allowMultiple:true,  //여러 파일 사진 가능
                    //type: FileType.image, // 이미지 파일만 선택할 수 있도록 제한
                    type:FileType.custom,
                    allowedExtensions:['png','jpg'],
                  );

                  if(results!=null){
                    final List<File> images=results.files.map((file)=>File(file.path!)).toList();
                    final Storage storage = Storage();
                  }

                  //업로드할 파일 각각에 대해 Future 리스트 생성
                  List<Future<String>> uploadFutures = [];

                  for (var image in images) {
                    final fileName = basename(image.path);
                    // 업로드 작업을 uploadFutures 리스트에 추가
                    uploadFutures.add(storage.uploadFile(image.path, fileName));
                  }


                  for (var image in images) {
                    final fileName = basename(image.path);
                    // 업로드 작업을 uploadFutures 리스트에 추가
                    uploadFutures.add(storage.uploadFile(image.path, fileName));
                  }


                  //final Storage storage=Storage();
                  for(var image in images){
                    final fileName=basename(image.path);
                    final downloadURL=await storage.uploadFile(image.path, fileName);
                    print('Download URL : $downloadURL');
                  }


                  if (results == null) {
                    print('No images selected.');
                    return; // 함수를 여기서 종료
                  }
                    // 선택된 파일의 개수를 count 변수에 저장
                    int count = results.files.length;

                    // 선택된 모든 파일의 경로를 저장하는 리스트
                    List<File> images = results.files.map((file) => File(file.path!)).toList();

                    // 파일 선택 성공 메시지와 선택된 파일 개수 출력
                    print('Total images selected: $count');

                    // 상태를 업데이트하거나 UI에 표시
                    setState(() {
                      _images = images; // 정의된 변수 이름으로 수정
                      _imageCount = count; // 선택된 이미지의 개수를 저장하기 위한 상태 변수
                    });

                  final path=results.files.single.path!;
                  final fileName=results.files.single.name;

                  try {
                    await storage.uploadFile(path, fileName);
                    print('Upload complete');
                    print('File path: $path');
                    print('File name: $fileName');
///////////////////////////////////////////////////////////////
                    // 파일 업로드 성공 후 다음 화면으로 이동
                    if (_images != null ) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageSearchLoad(images: _images!),
                        ),
                      );
                    }


                  } catch (e) {
                    print('Failed to upload file: $e');
                  }

                  storage
                      .uploadFile(path, fileName)
                      .then((value)=>print('Done'));
                  print(path);
                  print(fileName);
                },
                child: Container(
                  width: 260,
                  height: 57,
                  child: Image.asset('./assets/selectGallery.png',
                      fit: BoxFit.fill),
                ),
                //child: Image.asset('./assets/selectGallery.png'),  // 원하는 이미지를 넣으세요.
              ),
          ),
              */


/*
              Positioned(
                left:94,
                top:175,
                child: ElevatedButton(
                    child: Text('[test]img&json 불러오기'),
                    onPressed: ()  {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageSearchDisease(),
                        ),
                      );
                    }
                ),
              ),
              */
                  /*
              Positioned(
                left:94,
                top:241,
                child: ElevatedButton(
                    child: Text('[test]파이어베이스-json'),
                    onPressed: ()  {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageSearchCheck(),
                        ),
                      );
                    }
                ),
              ),
*/
                  /*
              Positioned(
                left:94,
                top:341,
                child: ElevatedButton(
                    child: Text('[test]확인'),
                    onPressed: ()  {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UploadImageDemo(),
                        ),
                      );
                    }
                ),
              ),
              */


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







/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pills_good_project/storage_service.dart';
import 'package:pills_good_project/screen/manual_search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
///////

class AutoSearchScreen extends StatefulWidget {
  static const routeName = '/getimage';
  final Storage storage=Storage();

  @override
  _AutoSearchScreenState createState() => _AutoSearchScreenState();
}

class _AutoSearchScreenState extends State<AutoSearchScreen> {
  File? _image;
  //String? _imageUrl; // url을 저장할 멤버 변수를 추가합니다.

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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:
                AssetImage('./assets/auto_search_background.svg'), // 배경 이미지 추가
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              ElevatedButton(
                  child: Text('upload File'),
                  onPressed: () async {
                    final results=await FilePicker.platform.pickFiles(
                      allowMultiple:false,
                      type:FileType.custom,
                      allowedExtensions:['png','jpg'],
                    );

                    if(results==null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:Text('No file selected'),
                        ),
                      );
                      return null;
                    }

                    final path=results.files.single.path!;
                    final fileName=results.files.single.name;

                    try {
                      await widget.storage.uploadFile(path, fileName);
                      print('Upload complete');
                      print('File path: $path');
                      print('File name: $fileName');
                      //print('File URL: $_imageUrl');
                    } catch (e) {
                      print('Failed to upload file: $e');
                    }

                    final url = await widget.storage.uploadFile(path, fileName);
                    print('File URL: $url');

                    widget.storage

                        .uploadFile(path, fileName)
                        .then((value)=>print('Done'));

                    print(path);
                    print(fileName);



                    /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CloudStorageDemo()),*/
                    /* );*/
                  }),
              Positioned(
                left: 59,
                top: 387,
                child: GestureDetector(
                  onTap: () {
                    getImage(ImageSource.gallery);
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManualSearchScreen(),
                      ),
                    );
                    */
                  },
                  child: Container(
                    width: 260,
                    height: 57,
                    child: Image.asset('./assets/selectGallery.png',
                        fit: BoxFit.fill),
                  ),
                ),
              ),

              Positioned(
                left: 59,
                top: 333,
                child: GestureDetector(
                  onTap: () {
                    getImage(ImageSource.camera);
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManualSearchScreen(),
                      ),
                    );
                    */
                  },
                  child: Container(
                    width: 260,
                    height: 57,
                    child: Image.asset('./assets/selectCamera.png',
                        fit: BoxFit.fill),
                  ),
                ),
              ),


              //_imageUrl == null ? Container() : Image.network(_imageUrl!), // url이 있는 경우에만 이미지를 표시합니다.
              //_image == null ? Container() : Image.file(_image!),
              //Image.network(url),
              _image == null
                  ? Container()
                  : Image.file(_image!), // 선택한 이미지를 화면에 표시합니다.
            ],
          ),
        ),
      ),
    );
  }
}
*/


////////////////////////////////////////////////////////////
/*
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

*/
/*
FirebaseStorage _storage = FirebaseStorage.instance;
Reference _ref = _storage.ref("test/text");
_ref.putString("Hello World !!");
*/

/*
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AutoSearchScreen extends StatefulWidget {
  static const routeName = '/getimage';

  @override
  _AutoSearchScreenState createState() => _AutoSearchScreenState();
}

class _AutoSearchScreenState extends State<AutoSearchScreen> {
  File? _image;

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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.accents[2 % Colors.accents.length],
              ),
              onPressed: () {
                getImage(ImageSource.camera);
              },
              child: Text('카메라로 찍기'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.accents[5 % Colors.accents.length],
              ),
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: Text('앨범에서 선택하기'),
            ),
            _image == null
                ? Container()
                : Image.file(_image!), // 선택한 이미지를 화면에 표시합니다.
          ],
        ),
      ),
    );
  }
}
*/

// 이미지 제대로 넣은 사진

/*
import 'package:flutter/material.dart';
import 'package:pills_good/screen/auto_search_screen.dart';
import 'package:pills_good/screen/manual_search_screen.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  static const routeName = '/getimage';

  //@override
  //_GetimageSubScreenState createState() => _GetimageSubScreenState();

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
            AutoSearchScreen(),
          ],
        ),
      ),
    );
  }
}

class AutoSearchScreen extends StatelessWidget {
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
                  child: Image.asset('./assets/auto_search_background.png',
                      fit: BoxFit.fill),
                ),
              ),
              Positioned(
                left: 49,
                top: 132,
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
                    width: 282,
                    height: 199,
                    child: Image.asset('./assets/registerImg.png',
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Positioned(
                left: 59,
                top: 387,
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
                    width: 260,
                    height: 57,
                    child: Image.asset('./assets/selectGallery.png',
                        fit: BoxFit.fill),
                  ),
                ),
              ),
              Positioned(
                left: 60,
                top: 333,
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
                    width: 260,
                    height: 57,
                    child: Image.asset('./assets/selectCamera.png',
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
*/




//appBar 있는 코드
/*import 'package:flutter/material.dart';

class AutoSearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('auto Search Screen'),
      ),
      body: Center(
        child: Text('자동약찾기'),
      ),
    );
  }
}
*/