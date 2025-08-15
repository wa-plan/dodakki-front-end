import 'package:domino/screens/Tutorial/tutorial2_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({super.key});

  @override
  State<Tutorial1> createState() => Tutorial1State();
}

class Tutorial1State extends State<Tutorial1> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Padding(
              padding: tutorialPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:90),
                  //소개글
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "안녕, 나는 도민호야 :)",
                          style: TextStyle(
                            fontSize: currentWidth < 600 ? 20 : 25,
                            fontWeight: FontWeight.w700,
                            color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "내가 목표를 달성할 수 있도록\n도와줄 수 있겠니?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: currentWidth < 600 ? 16 : 21,
                            fontWeight: FontWeight.w600,
                            height: 1.7,
                            color: const Color(
                                0xffD9D9D9), // 이미지 위에 잘 보이도록 텍스트 색상 설정
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //도민호 이미지
            Positioned(
              top: 270,
              right: 0,
              child: Image.asset(
                "assets/img/tr_1.png",
                height: currentWidth < 600 ? 400 : 500,
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            //버튼
            Padding(
          padding: tutorialPadding,
          child: TutorialButton('도와줄게!', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Tutorial2()),
            );
          }).tutorialButton(),
        ));
  }
}
