import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class TestImageSlider extends StatefulWidget {
  @override
  _TestImageSliderState createState() => _TestImageSliderState();
}

class _TestImageSliderState extends State<TestImageSlider> {
  int activeIndex = 0; // 현재 활성화된 이미지의 인덱스를 추적합니다.

  final List<String> images = [
    'assets/Rifampin2.png',
    'assets/kk.png',
    'assets/pill.png',
    // 추가 이미지 경로를 여기에 넣으세요.
  ];

  Widget imageSlider(String path, int index) => Container(
    width: double.infinity,
    height: 240,
    color: Colors.grey,
    child: Image.asset(path, fit: BoxFit.cover),
  );

  Widget indicator() => Container(
    margin: const EdgeInsets.only(bottom: 20.0),
    alignment: Alignment.bottomCenter,
    child: AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: images.length,
      effect: JumpingDotEffect(
          dotHeight: 6,
          dotWidth: 6,
          activeDotColor: Colors.orange,
          dotColor: Colors.white.withOpacity(0.6)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Slider with Indicator'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CarouselSlider.builder(
            options: CarouselOptions(
              height: 300,
              initialPage: 0,
              viewportFraction: 1,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) => setState(() {
                activeIndex = index;
              }),
            ),
            itemCount: images.length,
            itemBuilder: (context, index, realIndex) {
              final path = images[index];
              return imageSlider(path, index);
            },
          ),
          indicator(),
        ],
      ),
    );
  }
}












/*
import 'package:flutter/material.dart';


class TestImageSlider extends StatefulWidget {
  @override
  _TestImageSliderState createState() => _TestImageSliderState();
}

class _TestImageSliderState extends State<TestImageSlider> {
  // 이미지 리스트를 정의합니다.
  // 실제 사용 시에는 네트워크 이미지 URL이나 로컬 에셋의 경로를 사용할 수 있습니다.
  final List<String> images = [
    'assets/musical.jpeg',
    'assets/musical2.jpg',
    //'assets/image3.jpg',
    // 추가 이미지 경로를 여기에 넣으세요.
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Slider Test'),
      ),
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Image.asset(
            images[index],
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
*/