import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageSearchDisease(),
    );
  }
}

class ImageSearchDisease extends StatefulWidget {

  @override
  _ImageSearchDiseaseState createState() => _ImageSearchDiseaseState();

}

class _ImageSearchDiseaseState extends State<ImageSearchDisease> {
  String _imageUrl = '';
  String _jsonData = '';



  @override
  void initState() {
    super.initState();
    fetchLatestFiles();
  }

  Future<void> fetchLatestFiles() async {
    final storageRef = FirebaseStorage.instance.ref().child('/Ai_input_img');
    final result = await storageRef.listAll();

    // 파일 이름이나 메타데이터로 정렬 필요 (여기서는 단순화를 위해 첫 번째 파일 사용)
    Reference? latestImageRef;
    Reference? latestJsonRef;

    try {
      latestImageRef = result.items.firstWhere((ref) => ref.name.endsWith('.png'));
    } catch (e) {
      // firstWhere에서 아이템을 찾지 못했을 때 처리
    }

    try {
      latestJsonRef = result.items.firstWhere((ref) => ref.name.endsWith('.json'));
    } catch (e) {
      // firstWhere에서 아이템을 찾지 못했을 때 처리
    }

    if (latestImageRef != null) {
      final imageUrl = await latestImageRef.getDownloadURL();
      setState(() {
        _imageUrl = imageUrl;
      });
    }

    if (latestJsonRef != null) {
      final jsonUrl = await latestJsonRef.getDownloadURL();
      final response = await http.get(Uri.parse(jsonUrl));
      if (response.statusCode == 200) {
        setState(() {
          _jsonData = response.body;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage Files'),
      ),
      body: Column(
        children: <Widget>[
          _imageUrl.isNotEmpty
              ? Image.network(_imageUrl)
              : Container(height: 200, child: Center(child: Text('No Image Found'))),
          Expanded(
            child: SingleChildScrollView(
              child: Text(_jsonData.isNotEmpty ? jsonEncode(jsonDecode(_jsonData)) : 'No Data Found'),
            ),
          ),
        ],
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageSearchDisease(),
    );
  }
}

class ImageSearchDisease extends StatefulWidget {

  @override
  _ImageSearchDiseaseState createState() => _ImageSearchDiseaseState();
}



class _ImageSearchDiseaseState extends State<ImageSearchDisease> {
  String _imageUrl = '';
  String _jsonData = '';

  @override
  void initState() {
    super.initState();
    fetchLatestFiles();
  }


  Future<void> fetchLatestFiles() async {
    final storageRef = FirebaseStorage.instance.ref().child('Ai_output');
    final result = await storageRef.listAll();

    // 단순화를 위해 첫 번째 파일을 사용 (실제로는 파일 이름이나 메타데이터로 정렬 필요)
    if (result.items.isNotEmpty) {
      final latestImageRef = result.items.firstWhere((ref) => ref.name.endsWith('.png'), orElse: () => null);
      final latestJsonRef = result.items.firstWhere((ref) => ref.name.endsWith('.json'), orElse: () => null);

      if (latestImageRef != null) {
        final imageUrl = await latestImageRef.getDownloadURL();
        setState(() {
          _imageUrl = imageUrl;
        });
      }

      if (latestJsonRef != null) {
        final jsonUrl = await latestJsonRef.getDownloadURL();
        final response = await http.get(Uri.parse(jsonUrl));
        if (response.statusCode == 200) {
          setState(() {
            _jsonData = response.body;
          });
        }
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Storage Files'),
      ),
      body: Column(
        children: <Widget>[
          _imageUrl.isNotEmpty
              ? Image.network(_imageUrl)
              : Container(height: 200, child: Center(child: Text('No Image Found'))),
          Expanded(
            child: SingleChildScrollView(
              child: Text(_jsonData.isNotEmpty ? jsonEncode(jsonDecode(_jsonData)) : 'No Data Found'),
            ),
          ),
        ],
      ),
    );
  }
}


 */