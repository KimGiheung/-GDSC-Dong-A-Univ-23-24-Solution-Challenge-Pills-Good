import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pills_good_project/screen/result_page.dart';

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

class ImageSearchDisease extends StatefulWidget {

  @override
  _ImageSearchDiseaseState createState() => _ImageSearchDiseaseState();
}



class _ImageSearchDiseaseState extends State<ImageSearchDisease> {
  final _controller = TextEditingController();
  String _result = ''; // 결과를 저장할 변수
  List<String> _resultList = [];  // 여기를 수정했습니다.
  late String selectedValue; // 클래스 변수로 selectedValue 선언


  //List<String> _resultList;

  @override
  void initState() {
    super.initState();
    _resultList = _result.split('\n');
  }

  void makePostRequest() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://ab94-124-51-164-190.ngrok-free.app/api/v1/disease-research'));
    request.body = json.encode({
      "diseaseName": _controller.text
    });
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseString = await response.stream.bytesToString();
        print('Response String: $responseString'); // 서버 응답 출력
        Map<String, dynamic> responseJson = jsonDecode(responseString);

        if (responseJson.containsKey('data')) {
          List<dynamic> data = responseJson['data'];
          setState(() {
            _result = data.join('\n');
            _resultList = _result.split('\n'); // 여기에서 초기화
          });
        } else {
          print('The key "data" does not exist in the response'); // data 키가 없는 경우 출력
        }
      } else {
        setState(() {
          _result = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      print('Exception occured: $e'); // 예외 발생 시 출력
    }
  }



  void printDataValues(String jsonString) {
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    List<dynamic> dataValues = jsonData['data'];

    for (var value in dataValues) {
      print(value);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Material(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Enter drug name'),
            ),
          ),
          ElevatedButton(
            child: Text('Search'),
            onPressed: makePostRequest,
          ),
          //Text(_result), // _result를 화면에 표시
          Container(
            height: 300, // 적절한 높이 값을 설정하세요.
            child: ListView.builder(
              itemCount: _resultList.length,
              itemBuilder: (context, index) {
                return TextButton(
                  child: Text(_resultList[index]),
                  onPressed: () {
                   // String selectedValue = _resultList[index];
                    selectedValue = _resultList[index]; // 클래스 변수 업데이트

                    print('선택된 값: $selectedValue');
                  },
                );
              },
            ),
          ),

          ElevatedButton(

            child: Text('submit'),
            onPressed: makePostRequest,
          ),

          ElevatedButton(
              child: Text('알약은 임시데이터로 전송'),
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(selectedDisease: selectedValue, selectedPill: "642100410"),
                  ),
                );


              }),

        ],
      ),
    );
  }
}