import 'package:domino/screens/Tutorial/tutorial2_3page.dart';
import 'package:domino/screens/Tutorial/tutorial6_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial2_2 extends StatefulWidget {
  const Tutorial2_2({super.key});

  @override
  State<Tutorial2_2> createState() => Tutorial2_2State();
}

class Tutorial2_2State extends State<Tutorial2_2> {
  int selectedIndex = 100;

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: tutorialPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //프로그레스 바
                ProgressBar(1, 4).progressBar(),
                SizedBox(height: 10),

                //프로그레스 타이틀
                ProgressTitle('제1목표 만들기').progressTitle(),
                SizedBox(height: 17),

                //질문
                TutorialQuestion(
                        "", '새내기', "로 대학에 입학하는", '도민호를 위한 제1목표는?', 'red')
                    .tutorialQuestion(),
                SizedBox(height: 15),
                ImageOption(
                  imageUrls: [
                    'assets/img/option1.png',
                    'assets/img/option2.png'
                  ],
                  color: 'red',
                  onItemSelected: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                ),
              ],
            ),
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
                MaterialPageRoute(builder: (context) => const Tutorial2_3()),
              );
            } else if (selectedIndex == 1) {
              TutorialMessage("아닌데...다시 한번 잘 생각해봐!").tutorialMessage(context);
            } else {
              TutorialMessage("어떤 계획을 세워야할 지 선택해줘!").tutorialMessage(context);
            }
          }).tutorialButton(),
        ));
  }
}
