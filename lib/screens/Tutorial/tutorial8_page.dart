import 'package:domino/screens/Tutorial/tutorial9_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial8 extends StatefulWidget {
  const Tutorial8({super.key});

  @override
  State<Tutorial8> createState() => Tutorial8State();
}

class Tutorial8State extends State<Tutorial8> {
  int selectedIndex = 100;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: tutorialPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              //프로그레스 바
              ProgressBar(3, 4),
              SizedBox(height: 10),

              //프로그레스 타이틀
              ProgressTitle('TO-DO 만들기').progressTitle(),
              SizedBox(height: 10),

              //질문
              TutorialQuestion(
                      "", '동아리 들어가기', "를 위해", '실천으로 옮길 수 있는 TO-DO는?', 'blue')
                  .tutorialQuestion(),
                  SizedBox(height: 30), 

              // 선택지
              ImageOption(
                imageUrls: [
                  'assets/img/option3.png',
                  'assets/img/option4.png',
                  'assets/img/option5.png'
                ],
                color: 'blue',
                onItemSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            //버튼
            Padding(
          padding: tutorialPadding,
          child: TutorialButton('다음', () {
            if (selectedIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tutorial9()),
              );
            } else if (selectedIndex == 1 || selectedIndex == 2) {
              TutorialMessage("아닌데...다시 한번 잘 생각해봐!").tutorialMessage(context);
            } else {
              TutorialMessage("어떤 계획을 세워야할 지 선택해줘!").tutorialMessage(context);
            }
          }).tutorialButton(),
        ));
  }
}
