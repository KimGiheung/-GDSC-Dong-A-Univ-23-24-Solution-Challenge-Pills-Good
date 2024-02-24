import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart';

import 'dart:io';

class Storage{
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;
//변수타입 void -> String
  Future<String> uploadFile(String filePath, String fileName) async {
    //File file = File(filePath);

    File file = File(filePath);

    try {
      await storage.ref('Ai_input_img/$fileName').putFile(file);
      //Ai_input_img
      // Once the file upload is complete, get the download URL
      final downloadURL = await storage.ref('Ai_input_img/$fileName').getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e);
      //추가
      return '';
    }

  }
}


/*
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_storage;

class Storage{
  final firebase_storage.FirebaseStorage=
    firebase_storage.FilebaseStorage.instance;

  Future<void> uploadFile(
      String filePath,
      String fileName,
      )async{
      File file=File(filePath);

    try{
      await storage.ref('test/$fileName').putFile(file);
    }on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

}
 */