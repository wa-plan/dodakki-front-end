import 'package:domino/screens/Tutorial/tutorial7_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial6 extends StatelessWidget {
  const Tutorial6({super.key});

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Stack(
          children: [
            //비주얼
            Positioned(top: 40, left: 5, child: PlanVisual(currentWidth).planVisual()),
            //그라데이션
            Positioned(
                top: 0,
                child: Container(
                  width: currentWidth < 600 ? 400 : 630,
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        backgroundColor, // 시작 색
                        backgroundColor.withOpacity(0.95),
                        backgroundColor.withOpacity(0.9),
                        backgroundColor.withOpacity(0.7),
                        backgroundColor.withOpacity(0) // 끝은 완전 투명
                      ],
                    ),
                  ),
                )),

            Padding(
              padding: EdgeInsets.fromLTRB(36, 55, 36, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //프로그레스 타이틀
                  ProgressTitle('플랜 완성!').progressTitle(),
                  SizedBox(height: 17),

                  //질문
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      '고마워! 이렇게만 하면\n목표를 달성할 수 있겠어!',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.5),
                    ),
                  ),
                  Spacer(),
                  //TO-DO 스텝
                  Text(
                  'TO-DO',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),),
                  SizedBox(height: 5),                  //TO-DO 박스
                  Container(
                    height: 55,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '🔎',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '동아리 지원요강 확인하기',
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            //버튼
            Padding(
          padding: tutorialPadding,
          child: TutorialButton('다음', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Tutorial7()),
            );
          }).tutorialButton(),
        ));
  }
}
