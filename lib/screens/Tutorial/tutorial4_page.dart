import 'package:domino/screens/Tutorial/tutorial5_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial4 extends StatefulWidget {
  const Tutorial4({super.key});

  @override
  State<Tutorial4> createState() => Tutorial4State();
}

class Tutorial4State extends State<Tutorial4> {

  @override
  Widget build(BuildContext context) {
    int selectedIndex = 100;
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
                  //프로그레스 바
                  ProgressBar(3, 4).progressBar(),
                  SizedBox(height: 10),

                  //프로그레스 타이틀
                  ProgressTitle('제3목표 만들기').progressTitle(),
                  SizedBox(height: 17),

                  //질문
                  TutorialQuestion('스펙왕 되기', '달성해야 할 제3목표는?', 'green')
                      .tutorialQuestion(),
                  SizedBox(height: 20),
                ],
              ),
            ),
            //선택지
            Positioned(
              left: -80,
              top: currentWidth < 600 ? 170 : 190,
              child: MandalartOption(
                  middleText: '스펙왕\n되기',
                  texts: [
                    '',
                    '해외여행\n가기',
                    '동아리\n들어가기',
                    '',
                    '',
                    '요리\n배우기',
                    '',
                    '자취\n시작하기',
                    '헬스장\n등록하기'
                  ],
                  color: 'green',
                  onItemSelected: (index) {
                      selectedIndex = index;
              }, currentWidth: currentWidth,),
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
                MaterialPageRoute(builder: (context) => const Tutorial5()),
              );
            } else if (selectedIndex == 0 || selectedIndex == 3 || selectedIndex == 6) {
               TutorialMessage("어떤 계획을 세워야할 지 선택해줘!").tutorialMessage(context);
            } else {
              TutorialMessage("아닌데...다시 한번 잘 생각해봐!").tutorialMessage(context);
            }
          })
              .tutorialButton(),
        ));
  }
}
