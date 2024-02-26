import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pills_good_project/screen/result_page_true.dart';
import 'package:pills_good_project/screen/result_page_false.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Drug Research App')),
        body: Material(
          //child: ImageSearchDisease(),
        ),
      ),
    );
  }
}


class ResultPage2 extends StatefulWidget {
  final String selectedDisease;
  final String selectedPill;

  ResultPage2({Key? key, required this.selectedDisease, required this.selectedPill}) : super(key: key);

  @override
  _ResultPage2State createState() => _ResultPage2State();
}


class _ResultPage2State extends State<ResultPage2> {

  File? _image; /////
  final _controller = TextEditingController();
  String _result = '';
  bool _isTaking = false;
  List<String> _resultList = [];
  String _interactionResult = '';
  String _constitutionResult = '';

  @override
  void initState() {
    super.initState();
    //makePostRequest();
    fetchApiData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    makePostRequest();
    fetchApiData();
  }

/*
  void makePostRequest() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://73f1-124-51-164-190.ngrok-free.app/api/v3/manual/patient'));
    request.body = json.encode({
      "constitution": [widget.selectedDisease],
      "pills": [widget.selectedPill],
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        final responseJson = json.decode(responseString);
        if (responseJson['data'] != null && responseJson['data']['taking'] != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigateBasedOnResult(responseJson['data']['taking']);
          });
        }
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e.toString());
    }
  }
*/

  void makePostRequest() async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse(
        'https://73f1-124-51-164-190.ngrok-free.app/api/v3/manual/patient'));
    request.body = json.encode({
      "constitution": [widget.selectedDisease],
      "pills": [widget.selectedPill],
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      final responseJson = json.decode(responseString);
      if (responseJson['data'] != null &&
          responseJson['data']['taking'] != null) {
        setState(() {
          _isTaking = responseJson['data']['taking'];
          //navigateBasedOnResult(_isTaking);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigateBasedOnResult(_isTaking);
        });
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }


  void fetchApiData() async {
    //final result = await yourApiCall(widget.selectedPill, widget.selectedDisease); // API 호출

    //navigateBasedOnResult(result.taking); // 결과에 따른 페이지 전환 함수
    //navigateBasedOnResult(_isTaking);
  }

  void navigateBasedOnResult(bool isTaking) {
    if (isTaking) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          ResultPageTrue(selectedPill: widget.selectedPill ?? '',
              selectedDisease: widget.selectedDisease ?? '')));
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
          ResultPageFalse(selectedPill: widget.selectedPill ?? '',
              selectedDisease: widget.selectedDisease ?? '')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //child:Text('isTaking : ${_isTaking}, selectedPill: ${widget.selectedPill}, selectedDisease : ${widget.selectedDisease} '),
        // 컨테이너가 Scaffold의 전체 크기를 채우도록 설정
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFFFCE3A7), Color(0xFFFFFAEE)],
          ),
        ),
        child: Center(
          child: Text('Loading ...',
            style: TextStyle(
            color: Colors.black, // 여기에서 색상을 설정합니다.
          ),),
        ),
      ),
    );
  }
}
