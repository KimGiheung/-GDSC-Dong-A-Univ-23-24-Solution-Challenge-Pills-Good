import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



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


class ResultPageTrue extends StatefulWidget {
  final String selectedDisease;
  final String? selectedPill;

  ResultPageTrue({Key? key, required this.selectedDisease, required this.selectedPill}) : super(key: key);

  @override
  _ResultPageTrueState createState() => _ResultPageTrueState();

}


class _ResultPageTrueState extends State<ResultPageTrue> {

  File? _image; /////
  final _controller = TextEditingController();
  String _result = '';
  bool _isTaking = false;
  List<String> _resultList = [];
  String _interactionResult = '';
  String _constitutionResult = '';

  String formatPillText(String? pill) {
    if (pill == null) return "선택된 알약이 없습니다";

    // `,`와 `( `를 기준으로 문자열 분리
    var parts = pill.split(RegExp(r',|\( '));
    // 분리된 문자열을 개행 문자로 연결
    return parts.join('\n');
  }

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
    var request = http.Request('POST', Uri.parse('https://73f1-124-51-164-190.ngrok-free.app/api/v3/manual/patient'));
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
    List<Widget> conditionallyRenderedWidgets = [];

    // selectedDisease 값이 빈 문자열이 아닐 경우에만 위젯들을 리스트에 추가
    if (widget.selectedDisease?.isNotEmpty ?? false) {
      conditionallyRenderedWidgets.addAll([
        Positioned(
          left: 132,
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
          left: 158,
          top: 409,
          child: Text(
            widget.selectedDisease ?? "기본값",
            style: TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
              height: 1, // 0이 아닌 값으로 수정
            ),
          ),
        ),
        Positioned(
          left: 165,
          top: 429,
          child: GestureDetector(
            child: Container(
              width: 39,
              height: 40,
              child: Image.asset('./assets/disease_icon.png', fit: BoxFit.fill),
            ),
          ),
        ),
        Positioned(
          left: 121,
          top: 493,
          child: Text(
            '',
            style: TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1, // 0이 아닌 값으로 수정
            ),
          ),
        ),
        Positioned(
          left: 121,
          top: 493,
          child: Text(
            '기저질환과 관계없이',
            style: TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1, // 0이 아닌 값으로 수정
            ),
          ),
        ),
        Positioned(
          left: 135,
          top: 511,
          child: Text(
            '${_constitutionResult}',
            style: TextStyle(
              color: Color(0xFF3F3F3F),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              height: 1, // 0이 아닌 값으로 수정
            ),
          ),
        ),
      ]);
    }

    return Scaffold(
        body: Material(
        child:Column(
        children: [
        Container(
          width: 380,
          height: 825,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 380,
                  height: 825,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.00, -1.00),
                      end: Alignment(0, 1),
                      colors: [Color(0xFFFFFAEE), Color(0xFFFFE292)],
                    ),
                  ),
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

              //나의 알약 정보

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

              //알약 이름
              /*
              Positioned(
                left: 120,
                top: 197,
                child: Container(
                  width: 200, // 원하는 너비 지정
                  height: 500, // 원하는 높이 지정
                  child: Text(
                    widget.selectedPill == null
                        ? "선택된 알약이 없습니다"
                        : widget.selectedPill!.split(RegExp(r',|\( ')).join('\n'), // 여기에서 직접 처리
                    style: TextStyle(
                      color: Color(0xFF3F3F3F),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.5, // 텍스트 라인 간격 조정
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트가 영역을 넘어갈 경우 처리
                    softWrap: true, // 텍스트가 영역에 맞게 줄바꿈 되도록 설정
                  ),
                ),
              ),*/

              Positioned(
                left: 128,
                top: 195,
                child: Container(
                  width: 200, // 원하는 너비 지정
                  height: 500, // 원하는 높이 지정
                  child: Text(
                  '타이레놀정500밀리그람', // 여기에서 직접 처리
                    style: TextStyle(
                      color: Color(0xFF3F3F3F),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.5, // 텍스트 라인 간격 조정
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트가 영역을 넘어갈 경우 처리
                    softWrap: true, // 텍스트가 영역에 맞게 줄바꿈 되도록 설정
                  ),
                ),
              ),
              Positioned(
                left: 139,
                top: 211,
                child: Container(
                  width: 200, // 원하는 너비 지정
                  height: 500, // 원하는 높이 지정
                  child: Text(
                    '(아세트아미노펜)', // 여기에서 직접 처리
                    style: TextStyle(
                      color: Color(0xFF3F3F3F),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.5, // 텍스트 라인 간격 조정
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트가 영역을 넘어갈 경우 처리
                    softWrap: true, // 텍스트가 영역에 맞게 줄바꿈 되도록 설정
                  ),
                ),
              ),

              Positioned(
                left: 88,
                top: 226,
                child: Container(
                  width: 200, // 원하는 너비 지정
                  height: 500, // 원하는 높이 지정
                  child: Text(
                    '(수출명:TylenolExtraStrengthCaplets)', // 여기에서 직접 처리
                    style: TextStyle(
                      color: Color(0xFF3F3F3F),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      height: 1.5, // 텍스트 라인 간격 조정
                    ),
                    overflow: TextOverflow.ellipsis, // 텍스트가 영역을 넘어갈 경우 처리
                    softWrap: true, // 텍스트가 영역에 맞게 줄바꿈 되도록 설정
                  ),
                ),
              ),

              /*
              Positioned(
                left: 158,
                top: 197,
                child: Text(
                  widget.selectedPill == null
                      ? "선택된 알약이 없습니다"
                      : widget.selectedPill!.split(RegExp(r',|\( ')).join('\n'), // 여기에서 직접 처리
                  //formatPillText(widget.selectedPill), // 수정된 부분
                  //'${widget.selectedPill?? "선택된 알약이 없습니다"}',
                  style: TextStyle(

                    color: Color(0xFF3F3F3F),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w700,
                    height: 0.0,
                  ),
                ),
              ),*/

              //알약 아이콘
              Positioned(
                left: 156,
                top: 250,
                child: GestureDetector(
                  child: Container(
                    width: 50,
                    height: 51,
                    child: Image.asset('./assets/pill_icon.png',
                        fit: BoxFit.fill),
                  ),
                ),
              ),


              //약

              Positioned(
                left: 128,
                top: 296,
                child: Text(
                  '',
                  //'${_interactionResult}',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),
              //나의 기저질환
              ...conditionallyRenderedWidgets,

              _image == null
                  ? Container()
                  : Image.file(_image!), // 선택한 이미지를 화면에 표시합니다.


//title 글
              Positioned(
                left: 62,
                top: 62,
                child: Text(
                  '복용할수 있어요.',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 23,
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
            ],
          ),
        ),
      ],
    ),
    ),
    );
  }
}

/*
import 'package:flutter/material.dart';

class ResultPageTrue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('결과 페이지'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '약과 질병이 호환됩니다!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '약을 안전하게 복용하실 수 있습니다.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // 사용자가 다른 페이지로 돌아갈 수 있도록 Navigator를 사용합니다.
                Navigator.pop(context);
              },
              child: Text('돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
*/