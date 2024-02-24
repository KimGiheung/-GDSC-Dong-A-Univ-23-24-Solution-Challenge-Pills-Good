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
          //child: ImageSearchDisease(),
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
      body: Column(
        children: [
          Container(
            width: 380,
            height: 825,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              gradient: SweepGradient(
                center: Alignment(0, 1),
                startAngle: 0,
                endAngle: 1,
                colors: [Color(0xFFFFFAEE), Color(0xFFFCE3A7), Color(0xFFFFFAEE), Color(0xFFFFE292)],
              ),
            ),
            child: Stack(
              children: [

                //큰 네모
                Positioned(
                  left: 55,
                  top: 132,
                  child: Container(
                    width: 271,
                    height: 565,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(23),
                      ),
                      shadows: [
                        BoxShadow(
                          color: Color(0x7F000000),
                          blurRadius: 4,
                          offset: Offset(0, 0),
                          spreadRadius: 0,
                        )
                      ],
                    ),

                  ),

                ),

                Positioned(
                  left: 62,
                  top: 62,
                  child: Text(
                    '복용할 수 있어요.',
                    style: TextStyle(
                      color: Color(0xFF3F3F3F),
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  left: 63,
                  top: 92,
                  child: Text(
                    '말씀해주신 약을 분석해본 결과는 아래와 같아요.',
                    style: TextStyle(
                      color: Color(0xFF3F3F3F),
                      fontSize: 13,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),


                Positioned(
                  left: 119,
                  top: 723,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 13,
                        child: Text(
                          '당신의 안전하고 편리한 건강을 응원하며',
                          style: TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontSize: 9,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                            height: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 49,
                        top: 0,
                        child: Text(
                          'Pill’s Good',
                          style: TextStyle(
                            color: Color(0xFF3F3F3F),
                            fontSize: 9,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),







/*
                //실제 값들
                Positioned(
                  left: 163,
                  top: 107,
                  child: Text(
                    '기저질환: ${widget.selectedDisease}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),*/

                Text('기저질환: ${widget.selectedDisease}'),
                Text('나의 알약목록 : ${widget.selectedPill}'),
                Text('상호작용 결과: $_interactionResult'),
                if (_constitutionResult.isNotEmpty) Text('기저질환 유무: $_constitutionResult'),// interactionResult 값을 출력합니다.

                Positioned(
                  left:10,
                  top:500,
                  child: Image.asset('./assets/pill_icon.png'),
                ),

                Image.asset('assets/pill_icon.png'),
                Positioned(
                  // 이미지를 배치하고 싶은 위치를 조정하세요.
                  left: 156,
                  top: 217,
                  child: Image.asset('./assets/pill_icon.png', width: 100, height: 100),
                ),




                // 추가된 UI 요소들...
                // 이하 생략된 UI 요소들 (Positioned 위젯을 사용하여 다른 요소들을 배치)
              ],
            ),
          ),
        ],
      ),
    );
  }
/*
  @override
  Widget build(BuildContext context) {

    return Scaffold(

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

  */
}


////////////////////////////////////////////////


/*
class _ResultPageState extends State<ResultPage> {
  final _controller = TextEditingController();
  String _result = '';
  bool _isTaking = false;
  List<String> _resultList = [];

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
    var request = http.Request('POST', Uri.parse('https://ab94-124-51-164-190.ngrok-free.app/api/v3/patient'));
    request.body = json.encode({
      "constitution": [
        "폐색증",
        "심장기능저하",
        "무좀"
      ],
      "pills": [
        642100410,
        641801140,
        665507731,
        643300600,
        643502200
      ]
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseString = await response.stream.bytesToString();
      //print(await response.stream.bytesToString());
      setState(() {
        _result = responseString;

      });
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('선택된 값: ${widget.selectedValue}'),
            Text('약 번호 : ${widget.di_edi_code}'),
            Text(_result),
          ],
        ),
      ),
    );
  }
}
*/


/*
class _ResultPageState extends State<ResultPage> {
  final _controller = TextEditingController();
  String _result = ''; // 결과를 저장할 변수
  List<String> _resultList = [];  // 여기를 수정했습니다.

  @override
  void initState() {
    super.initState();
    makePostRequest(); // 화면이 로딩될 때 makePostRequest 함수가 자동으로 호출됩니다.
    _resultList = _result.split('\n');

  }

  void makePostRequest() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://ab94-124-51-164-190.ngrok-free.app/api/v3/patient'));
    request.body = json.encode({
      "constitution": widget.selectedValue,
      "pills": widget.di_edi_code,
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('선택된 값: ${widget.selectedValue}'),
            Text('약 번호 : ${widget.di_edi_code}'),
            Text(_result), // _result를 화면에 표시
          ],
        ),
      ),
    );
  }
}

*/


/*
class ResultPage extends StatelessWidget {

  @override
  _ResultPageState createState() => _ResultPageState();

}

class _ResultPageState extends State<ResultPage> {
  final String selectedValue;
  final int di_edi_code; // 멤버 변수로 선언


    ResultPage({Key? key, required this.selectedValue, required this.di_edi_code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('선택된 값: $selectedValue'),
              Text('약 번호 : $di_edi_code'),
        ],
      ),
      ),
    );
  }
}
*/




/*
class ResultPage extends StatelessWidget {
  final String selectedValue;

  ResultPage({Key key, @required this.selectedValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Result Page'),
      ),
      body: Center(
        child: Text('선택된 값: $selectedValue'),
      ),
    );
  }
}
*/

/*

class ResultPage extends StatefulWidget {
  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final _controller = TextEditingController();
  String _result = ''; // 결과를 저장할 변수
  List<String> _resultList = [];  // 여기를 수정했습니다.

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
      "drugName": _controller.text
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

          ElevatedButton(
            child: Text('Search'),
            onPressed:(){}
          ),
          //Text(_result), // _result를 화면에 표시




        ],
      ),
    );
  }
}

*/