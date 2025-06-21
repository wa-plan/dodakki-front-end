import 'package:domino/screens/Tutorial/tutorial2_page.dart';
import 'package:domino/screens/Tutorial/tutorial5_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/TT/menu_form.dart';

class Tutorial4_2 extends StatefulWidget {
  const Tutorial4_2({super.key});

  @override
  State<Tutorial4_2> createState() => Tutorial4_2State();
}

class Tutorial4_2State extends State<Tutorial4_2> {
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
                  TTmenuForm(
                    icon: 'assets/img/tt_menu_icon3.png',
                    title: '오늘의 도미노',
                    description1: '이제 마지막 단계야!',
                    description2: '동아리 들어가기',
                    description3: '구체적인 TO-DO를 만들어보자!',
                    imageUrl: 'assets/img/menu_screen3.png',
                    color: 'blue',
                  )
                ],
              ),
            ),
            //도민호 이미지
          ],
        ),
        bottomNavigationBar:
            //버튼
            Padding(
          padding: tutorialPadding,
          child: TutorialButton('다음!', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Tutorial5()),
            );
          }).tutorialButton(),
        ));
  }
}
