import 'package:domino/screens/Tutorial/tutorial7_page.dart';
import 'package:domino/screens/Tutorial/tutorial6_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial6 extends StatefulWidget {
  const Tutorial6({super.key});

  @override
  State<Tutorial6> createState() => Tutorial6State();
}

class Tutorial6State extends State<Tutorial6> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = 100;
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: tutorialPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    //프로그레스 바
                    ProgressBar(2, 4),
                    SizedBox(height: 10),

                    //프로그레스 타이틀
                    ProgressTitle('제3목표 만들기').progressTitle(),
                    SizedBox(height: 10),

                    //질문
                    TutorialQuestion(
                            "", '대학교 최강인싸되기', "를 위한", '달성해야 할 제3목표는?', 'green')
                        .tutorialQuestion(),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              //선택지
              MandalartOption(
                middleText: '대학교\n최강인싸되기',
                texts: [
                  '',
                  '혼밥 100회\n도전하기',
                  '동아리\n들어가기',
                  '',
                  '',
                  '비둘기와\n친해지기',
                  '침묵 챌린지\n30일 하기',
                  '인성파탄자 되기',
                  ''
                ],
                color: 'green',
                onItemSelected: (index) {
                  selectedIndex = index;
                },
                currentWidth: currentWidth,
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            //버튼
            Padding(
          padding: tutorialPadding,
          child: TutorialButton('다음', () {
            if (selectedIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tutorial7()),
              );
            } else if (selectedIndex == 0 ||
                selectedIndex == 3 ||
                selectedIndex == 6) {
              TutorialMessage("어떤 계획을 세워야할 지 선택해줘!").tutorialMessage(context);
            } else {
              TutorialMessage("아닌데...다시 한번 잘 생각해봐!").tutorialMessage(context);
            }
          }).tutorialButton(),
        ));
  }
}
