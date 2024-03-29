
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pills_good_project/screen/manual_search_disease.dart';
//import 'package:pills_good_project/screen/result_page.dart';
import 'package:pills_good_project/screen/result_page2.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: Material(
          child: ManualSearchDisease(selectedPill: '약_기본값'),
        ),
      ),
    );
  }
}

class ManualSearchDisease extends StatefulWidget {
  final String selectedPill;

  ManualSearchDisease({required this.selectedPill});

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
  bool _isSearchPerformed=false; //검색이 수행되었는지 여부를 추적하는 변수

  @override
  void initState() {
    super.initState();
    _resultList = _result.split('\n');
  }

  void makePostRequest() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('https://73f1-124-51-164-190.ngrok-free.app/api/v1/disease-research'));
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
            _isSearchPerformed=true; //검색이 수행되었다고 상태 업데이트
            _result = data.join('\n');
            _resultList = _result.split('\n'); // 여기에서 초기화
          });
        } else {
          print('The key "data" does not exist in the response'); // data 키가 없는 경우 출력
        }
      } else {
        setState(() {
          _result = 'Error: ${response.reasonPhrase}';
          _isSearchPerformed=false; //에러 발생시 검색 수행 상태를 false로 업데이트
        });
      }
    } catch (e) {
      print('Exception occured: $e'); // 예외 발생 시 출력
      _isSearchPerformed=false; //예외 발생 시 검색 수행 상태를 false로 업데이트
    }
  }



  @override
  Widget build(BuildContext context) {
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
                top: 769,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(color: Color(0xFFFF599E)),
                ),
              ),

              Positioned(
                left: 380,
                top: 825,
                child: Transform(
                  transform: Matrix4.identity()..translate(0.0, 0.0)..rotateZ(-3.14),
                  child: Container(
                    width: 380,
                    height: 825,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, -1.00),
                        end: Alignment(0, 1),
                        colors: [Color(0xFFFCE3A7), Color(0xFFFFFAEE)],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 71,
                top: 353,
                child: Text(
                  '기저질환이 있다면 알려주세요.',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 18,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
              ),
              Positioned(
                left: 71,
                top: 376,
                child: Text(
                  '필스 굿이 동시 복용이 가능한지 알아볼게요.',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 10,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),


              Positioned(
                left: 66,
                top: 401,
                child: Container(
                  width: 209,
                  height: 31,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1.30, color: Color(0xFFFF4C39)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Material(
                    color: Colors.transparent, // Material의 배경색을 투명하게 설정
                    child: TextField(
                      controller: _controller,
                      textAlign: TextAlign.center, // hintText를 가운데 정렬
                      style: TextStyle(color: Colors.black), // 사용자 입력 텍스트의 색상을 검은색으로 설정
                      decoration: InputDecoration(
                        hintText: 'Enter disease name',
                        hintStyle: TextStyle(color: Colors.grey), // hintText의 스타일을 연회색으로 설정
                        border: InputBorder.none, // TextField의 테두리를 제거하여 Container의 테두리를 사용
                        contentPadding: EdgeInsets.fromLTRB(0, 10, 0, 6),
                      ),
                    ),
                  ),
                ),
              ),

              Positioned(
                left: 278,
                top: 400,
                child: GestureDetector(
                  onTap: () {
                    makePostRequest(); // 여기에 makePostRequest 함수 호출
                  },

                  child: Container(
                    width: 37,
                    height: 32,
                    child: Image.asset('./assets/searchButton.png',
                        fit: BoxFit.fill),
                  ),
                ),
              ),


              Positioned(
                left: 60,
                top: 440,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 90,
                    child: Visibility( // Visibility 위젯을 검색 결과 목록에만 적용
                      visible: _isSearchPerformed && _resultList.isNotEmpty,
                      child: ListView.builder(
                        itemCount: _resultList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedDisease = _resultList[index];
                              });
                            },
                            child: Container(
                              width: 252,
                              height: 34,
                              margin: EdgeInsets.symmetric(vertical: 4),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(21),
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
                              child: Center(
                                  child:Padding(
                                    padding:EdgeInsets.all(8.0),
                                    child: Text(
                                      _resultList[index],
                                      textAlign:TextAlign.center, //텍스트 가운데 정렬
                                      style: TextStyle(
                                        color: Colors.grey[850],
                                        fontSize: 12,

                                      ),
                                    ),

                                  )

                              ),
                            ),
                          );
                        },
                      ),
                      replacement: SizedBox.shrink(), // 검색 결과가 없을 때는 아무것도 표시하지 않음
                    ),
                  ),
                ),
              ),


              //Text('나의 알약목록: ${widget.selectedPill}'),


              Positioned(
                left: 63,
                top: 66,
                child: Text(
                  '어떤 약을 복용하실건가요?',
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
                left: 64,
                top: 93,
                child: Text(
                  '필스 굿의 검색 기능을 통해 알아보실 수 있어요.',
                  style: TextStyle(
                    color: Color(0xFF3F3F3F),
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
              ),

              //제출하기


              Positioned(
                left: 56,
                top: 135,
                child: Container(
                  width: 268,
                  height: 181,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 268,
                          height: 181,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
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
                        left: 25,
                        top: 24,
                        child: Text(
                          '나의 알약 목록',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            height: 0,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 43,
                        child: Container(
                          width: 79,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 3,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFFF4C39),
                              ),
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),

              Positioned(
                left: 85,
                top: 210,
                child: Container(
                  width: 220,
                  height: 100,
                  child: Text(
                    //'${widget.selectedPill.split(RegExp(r',|\(')).join('\n')}',
                    '${widget.selectedPill.split(',').join('\n')}', // 쉼표를 기준으로 분리하고, 각 분리된 문자열을 개행 문자로 연결합니다.
                    textAlign: TextAlign.center, // 텍스트를 가운데 정렬합니다.
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12, // fontSize를 조정합니다.
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              /*
              Positioned(
                left: 95,
                top: 213,
                child: Container(
                  width: 180,
                  height: 100,
                  child: Text(
                    ' ${widget.selectedPill}', // 올바르게 표시될 것입니다.
                    textAlign: TextAlign.center, // 텍스트를 가운데 정렬합니다.
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16, // fontSize를 조정합니다.
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),*/


              Positioned(
                left: 56,
                top: 547,
                child: Container(
                  width: 268,
                  height: 110,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 268,
                          height: 110,
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(19),
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
                        left: 25,
                        top: 20,
                        child: SizedBox(
                          width: 80,
                          child: Text(
                            '나의 기저질환',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 20,
                        top: 40,
                        child: Container(
                          width: 79,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 3,
                                strokeAlign: BorderSide.strokeAlignCenter,
                                color: Color(0xFFFF4C39),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),


              Positioned(
                left: 95,
                top: 600,
                child: Container(
                  width: 180,
                  height: 100,
                  child: Text(
                    selectedDisease ?? ' ', // 올바르게 표시될 것입니다.
                    textAlign: TextAlign.center, // 텍스트를 가운데 정렬합니다.
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14, // fontSize를 조정합니다.
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

//테스트 화면
              Positioned(
                left: 64,
                top: 673,
                child: ElevatedButton(
                  onPressed: () {
                    // 버튼 클릭 시 실행될 함수
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage2(selectedDisease: selectedDisease ?? '', selectedPill: widget.selectedPill??'레보록신정(레보플록사신)(수출명:UniloxinTabs , 명인할로페리돌정1.5밀리그램'),
                        //builder: (context) => ResultPage2(selectedPill: widget.selectedPill ?? "타이레놀",selectedDisease: selectedDisease ?? ''),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFFF4C39), // 버튼 배경색
                    onPrimary: Color(0xFFFFFAEE), // 버튼 텍스트 색상
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(21), // 버튼 모서리 둥글기
                    ),
                    minimumSize: Size(252, 42), // 버튼 크기
                    elevation: 4, // 버튼 그림자
                  ),
                  child: Text('제출하기'),
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
