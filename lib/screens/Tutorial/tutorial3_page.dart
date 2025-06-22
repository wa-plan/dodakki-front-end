import 'package:domino/screens/Tutorial/tutorial4_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial3 extends StatefulWidget {
  const Tutorial3({super.key});

  @override
  State<Tutorial3> createState() => Tutorial3State();
}

class Tutorial3State extends State<Tutorial3> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    int selectedIndex = 100;

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
                  ProgressBar(2, 4),
                  SizedBox(height: 10),

                  //프로그레스 타이틀
                  ProgressTitle('제2목표 만들기').progressTitle(),
                  SizedBox(height: 17),

                  //질문
                  TutorialQuestion(
                          "", '뿌듯한 학교생활하기', "를 위한", '달성해야 할 제2목표는?', 'red')
                      .tutorialQuestion(),
                  SizedBox(height: 20),
                ],
              ),
            ),
            //선택지
            Positioned(
              left: -80,
              top: currentWidth < 600 ? 180 : 190,
              child: MandalartOption(
                middleText: '뿌듯한\n학교생활하기',
                texts: [
                  '',
                  '침대 밖으로\n안 나오기',
                  '대학교\n최강인싸되기',
                  '',
                  '',
                  '도서관 가서\n낮잠 자기',
                  '',
                  '삭발하기',
                  'F학점\n받아보기'
                ],
                color: 'red',
                onItemSelected: (index) {
                  selectedIndex = index;
                },
                currentWidth: currentWidth,
              ),
            ),
          ],
        ),
        bottomNavigationBar:
            //버튼
            Padding(
          padding: tutorialPadding,
          child: TutorialButton('다음', () {
            if (selectedIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tutorial4()),
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
