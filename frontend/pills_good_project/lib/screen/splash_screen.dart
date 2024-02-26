import 'package:flutter/material.dart';

import 'package:pills_good_project/screen/main_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // 스플래시 화면을 2초간 보여준 후
    await Future.delayed(Duration(seconds: 5), () {});
    // 홈 화면으로 이동
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DefaultTabController(
            length: 4,
            child: Scaffold(
              body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  MainScreen(),
                  //FindScreen(),
                  //SearchScreen(),
                  //MypageScreen(),
                ],
              ),
              //bottomNavigationBar: Bottom(),
            ),
          ),
        ));
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFFF4C39),
      child: Center(
        child: Image.asset('./assets/splash.png'), // 스플래시 이미지. 경로에 맞게 변경해주세요.
      ),
    );
  }
}
