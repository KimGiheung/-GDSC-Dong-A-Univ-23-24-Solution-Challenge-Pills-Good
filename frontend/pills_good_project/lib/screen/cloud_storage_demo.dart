import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

late CloudStorageDemoState pageState;

class CloudStorageDemo extends StatefulWidget {
  @override
  CloudStorageDemoState createState() {
    pageState = CloudStorageDemoState();
    return pageState;
  }
}

class CloudStorageDemoState extends State<CloudStorageDemo> {
  File? _image; // _image를 nullable 타입으로 변경합니다.
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  late User _user;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = "";

  @override
  void initState() {
    super.initState();
    _prepareService();
  }

  void _prepareService() async {
    _user = _firebaseAuth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cloud Storage Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: (_image != null) ? FileImage(_image!) : null, // null 체크를 추가합니다.
              radius: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  child: Text("Gallery"),
                  onPressed: () {
                    _uploadImageToStorage(ImageSource.gallery);
                  },
                ),
                TextButton(
                  child: Text("Camera"),
                  onPressed: () {
                    _uploadImageToStorage(ImageSource.camera);
                  },
                )
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            CircleAvatar(
              backgroundImage: NetworkImage(_profileImageURL),
              radius: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_profileImageURL),
            )
          ],
        ),
      ),
    );
  }

  void _uploadImageToStorage(ImageSource source) async {
    var pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;
    File image = File(pickedImage.path);

    setState(() {
      _image = image;
    });

    Reference storageReference = _firebaseStorage.ref().child("profile/${_user.uid}");

    UploadTask storageUploadTask = storageReference.putFile(_image!); // null 체크를 추가합니다.

    await storageUploadTask.whenComplete(() {});

    String downloadURL = await storageReference.getDownloadURL();

    setState(() {
      _profileImageURL = downloadURL;
    });
  }
}