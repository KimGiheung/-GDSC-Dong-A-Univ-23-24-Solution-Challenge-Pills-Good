import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:path_provider/path_provider.dart';

//import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
//import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'dart:io';


class UploadImageDemo extends StatefulWidget {
  @override
  _UploadImageDemoState createState() => _UploadImageDemoState();
}

class _UploadImageDemoState extends State<UploadImageDemo> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images = [];

  Future<void> pickImages() async {
    final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      setState(() {
        _images = selectedImages;
      });
    }
  }

  Future<void> uploadImages() async {
    try {
      for (var image in _images!) {
        String fileName = DateFormat('yyyyMMddHHmmss').format(DateTime.now()) + '.png';
        File file = File(image.path);

        // Firebase Storage에 업로드
        await FirebaseStorage.instance.ref('Ai_input_img/$fileName').putFile(file);
      }
    } catch (e) {
      print(e); // 오류 처리
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                pickImages();
              },
              child: Text('Select Images'),
            ),
            ElevatedButton(
              onPressed: () {
                uploadImages();
              },
              child: Text('Upload Images'),
            ),
          ],
        ),
      ),
    );
  }
}
