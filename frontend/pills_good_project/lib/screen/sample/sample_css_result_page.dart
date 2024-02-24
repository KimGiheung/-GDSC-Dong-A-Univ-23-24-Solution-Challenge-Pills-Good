import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pills_good_project/screen/image_search_disease.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Drug Research App')),
        body: Material(
          child: ImageSearchDisease(),
        ),
      ),
    );
  }
}


class ResultPage extends StatefulWidget {
  //final String selectedValue;
  final String selectedDisease;
  //final int selectedPill;
  final String? selectedPill; // selectedPill 매개변수 추가, 필요에 따라 nullable로 설정

  //final String selectedDisease;

  ResultPage({Key? key, required this.selectedDisease, required this.selectedPill}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}


class _ResultPageState extends State<ResultPage> {
  final _controller = TextEditingController();
  String _result = '';
  bool _isTaking = false;
  List<String> _resultList = [];
  String _interactionResult = '';
  String _constitutionResult = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    makePostRequest();
  }

  void makePostRequest() async {
    var headers = {
      'Content-Type': 'application/json'
    };
    var request = http.Request('POST', Uri.parse('https://ab94-124-51-164-190.ngrok-free.app/api/v3/manual/patient'));
    request.body = json.encode({
      /*
      "constitution":[],
      "pills":[642100410, 646900720]
*/

      "constitution":[widget.selectedDisease],
      "pills": [widget.selectedPill],

    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      final responseJson = json.decode(responseString);
      if(responseJson['data'] != null && responseJson['data']['taking'] != null) {
        setState(() {
          _isTaking = responseJson['data']['taking'];
          _interactionResult = responseJson['data']['interactionResult'];
          _constitutionResult = responseJson['data']['constitutionResult'].isNotEmpty ? responseJson['data']['constitutionResult'] : '';
          _result = responseString;
        });
      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
      ),
      body: Container(
        color: _isTaking ? Colors.blue : Colors.red,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('기저질환: ${widget.selectedDisease}'),
              Text('나의 알약목록 : ${widget.selectedPill}'),
              Text('상호작용 결과: $_interactionResult'),
              if (_constitutionResult.isNotEmpty) Text('기저질환 유무: $_constitutionResult'),// interactionResult 값을 출력합니다.

              //Text(_result),
            ],
          ),
        ),
      ),
    );
  }
}