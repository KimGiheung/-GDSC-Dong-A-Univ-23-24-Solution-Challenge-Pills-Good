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

/*
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
  late File _image;
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
              backgroundImage: (_image != null) ? FileImage(_image) : null,
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

    UploadTask storageUploadTask = storageReference.putFile(_image);

    await storageUploadTask.whenComplete(() {});

    String downloadURL = await storageReference.getDownloadURL();

    setState(() {
      _profileImageURL = downloadURL;
    });
  }
}
*/

/*
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
  late File _image;
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
    _user = await _firebaseAuth.currentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cloud Storage Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 업로드할 이미지를 출력할 CircleAvatar
            CircleAvatar(
              backgroundImage:
              (_image != null) ? FileImage(_image) : null, //NetworkImage(""),
              radius: 30,
            ),
            // 업로드할 이미지를 선택할 이미지 피커 호출 버튼
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
            // 업로드 된 이미지를 출력할 CircleAvatar
            CircleAvatar(
              backgroundImage: NetworkImage(_profileImageURL),
              radius: 30,
            ),
            // 업로드 된 이미지의 URL
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

    //File image = await ImagePicker.pickImage(source: source);

    if (image == null) return;
    setState(() {
      _image = image;
    });

    // 프로필 사진을 업로드할 경로와 파일명을 정의. 사용자의 uid를 이용하여 파일명의 중복 가능성 제거
    StorageReference storageReference =
    _firebaseStorage.ref().child("profile/${_user.uid}");

    // 파일 업로드
    StorageUploadTask storageUploadTask = storageReference.putFile(_image);

    // 파일 업로드 완료까지 대기
    await storageUploadTask.onComplete;

    // 업로드한 사진의 URL 획득
    String downloadURL = await storageReference.getDownloadURL();

    // 업로드된 사진의 URL을 페이지에 반영
    setState(() {
      _profileImageURL = downloadURL;
    });
  }
}

*/