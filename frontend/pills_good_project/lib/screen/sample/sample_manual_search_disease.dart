import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pills_good_project/screen/manual_search_disease.dart';
import 'package:pills_good_project/screen/result_page.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('수동 검색')),
        body: Material(
          child: ManualSearchDisease(selectedPill: '약_기본값'),
          //child: ManualSearchDisease(selectedPill: '약_기본값', selectedDisease: '기저질환_기본값'),
          //child: ManualSearchDisease(),
        ),
      ),
    );
  }
}

class ManualSearchDisease extends StatefulWidget {
  final String selectedPill;
  //final String selectedDisease;
  //final int di_edi_code; // 예시로 int 타입을 사용했습니다. 실제 타입에 맞게 조정하세요.

  // 생성자에서 selectedPill과 di_edi_code를 받도록 정의
  ManualSearchDisease({required this.selectedPill});

  //, required this.di_edi_code


  @override
  _ManualSearchDiseaseState createState() => _ManualSearchDiseaseState();
}



class _ManualSearchDiseaseState extends State<ManualSearchDisease> {
  final _controller = TextEditingController();
  String _result = ''; // 결과를 저장할 변수
  List<String> _resultList = [];  // 여기를 수정했습니다.
  //late String selectedValue; // 클래스 변수로 selectedValue 선언
  String? selectedPill; // late를 제거하고 nullable로 선언
  String? selectedDisease; // late를 제거하고 nullable로 선언


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
              decoration: InputDecoration(labelText: '기저질환을 입력해주세요'),
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
                    setState(() {
                      selectedDisease = _resultList[index]; // 클래스 변수 업데이트
                      print('선택한 기저질환: $selectedDisease');
                    });

                  },
                );
              },
            ),
          ),


          Text('나의 알약목록: ${widget.selectedPill}'),
          //Text(selectedValue),
          //Text(selectedValue ?? '기본값'),



          ElevatedButton(
              child: Text('submit'),
              onPressed: ()  {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultPage(selectedDisease: selectedDisease ?? '', selectedPill: widget.selectedPill),
                    //builder: (context) => ResultPage(selectedValue: selectedValue, di_edi_code: 642100410),
                  ),
                );


              }),

        ],
      ),
    );
  }
}