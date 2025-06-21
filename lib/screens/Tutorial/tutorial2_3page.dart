import 'package:domino/screens/Tutorial/tutorial2_page.dart';
import 'package:domino/screens/Tutorial/tutorial3_page.dart';
import 'package:domino/screens/Tutorial/tutorial4_2page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/TT/menu_form.dart';

class Tutorial2_3 extends StatefulWidget {
  const Tutorial2_3({super.key});

  @override
  State<Tutorial2_3> createState() => Tutorial2_3State();
}

class Tutorial2_3State extends State<Tutorial2_3> {
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
                    icon: 'assets/img/tt_menu_icon2.png',
                    title: '도미노 플랜',
                    description1: '이제 두번째 단계야!',
                    description2: '뿌듯한 학교생활 하기',
                    description3: '계획을 세워보자!',
                    imageUrl: 'assets/img/menu_screen2.png',
                    color: 'red',
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
              MaterialPageRoute(builder: (context) => const Tutorial3()),
            );
          }).tutorialButton(),
        ));
  }
}
