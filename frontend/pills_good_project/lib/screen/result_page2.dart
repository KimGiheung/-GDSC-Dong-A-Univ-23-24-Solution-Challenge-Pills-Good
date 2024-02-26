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


  /*
  @override
  Widget build(BuildContext context) {
    // 여기에 UI 구성을 추가합니다.
    return Scaffold(

      body: Center(
        child:Text('isTaking : ${_isTaking}, selectedPill: ${widget.selectedPill}, selectedDisease : ${widget.selectedDisease} '),
        _isTaking ? Text('약 복용 가능 ${_isTaking}, selectedPill: ${widget.selectedPill}, selectedDisease : ${widget.selectedDisease}') : Text('약 복용 불가 ${_isTaking}'),

      ),

    );
  }
}*/





/*
import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

// Generated by: https://www.figma.com/community/plugin/842128343887142055/
class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          ResultPage2(),
        ]),
      ),
    );
  }
}

class ResultPage2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 380,
          height: 825,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: SweepGradient(
              center: Alignment(0, 1),
              startAngle: -0,
              endAngle: -1,
              colors: [Color(0xFFFFFAEE), Color(0xFFFCE3A7), Color(0xFFFFFAEE), Color(0xFFFFE292)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 62,
                top: 62,
                child: Text(
                  '복용할수 있어요.',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 24,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 0,
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
                    height: 0,
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
                left: 132,
                top: 159,
                child: Container(
                  width: 108,
                  height: 24,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 108,
                          height: 24,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFF4C39),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 17,
                        top: 5,
                        child: Text(
                          '나의 알약 목록',
                          style: TextStyle(
                            color: Color(0xFFFFFAEE),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 130,
                top: 365,
                child: Container(
                  width: 108,
                  height: 24,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 108,
                          height: 24,
                          decoration: ShapeDecoration(
                            color: Color(0xFFFF4C39),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Color(0x3F000000),
                                blurRadius: 4,
                                offset: Offset(0, 0),
                                spreadRadius: 0,
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 17,
                        top: 5,
                        child: Text(
                          '나의 기저 질환',
                          style: TextStyle(
                            color: Color(0xFFFFFAEE),
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 128,
                top: 296,
                child: Text(
                  '복용해도 됩니다',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 135,
                top: 511,
                child: Text(
                  '복용해도 됩니다',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 158,
                top: 197,
                child: Text(
                  '리팜핀정',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 167,
                top: 409,
                child: Text(
                  '폐색증',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 157,
                top: 428,
                child: Container(
                  width: 51,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 6.45, vertical: 6.33),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 156,
                top: 217,
                child: Container(
                  width: 51,
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 6.45, vertical: 6.33),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 121,
                top: 493,
                child: Text(
                  '기저질환과 관계없이',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

*/