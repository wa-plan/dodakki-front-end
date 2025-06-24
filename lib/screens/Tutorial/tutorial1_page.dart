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
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            Padding(
              padding: tutorialPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //프로그레스 바
                  ProgressBar(0, 4).progressBar(),
                  SizedBox(height: 10),

                  //프로그레스 타이틀
                  ProgressTitle('튜토리얼 시작').progressTitle(),
                  SizedBox(height: 35),

                  //소개글
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "안녕, 나는 도민호야 :)",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "내가 목표를 달성할 수 있도록\n도와줄 수 있겠니?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
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
              top: 215,
              right: 0,
              child: Image.asset(
                "assets/img/tr_1.png",
                height: 400,
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
