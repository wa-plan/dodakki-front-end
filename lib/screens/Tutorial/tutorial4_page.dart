import 'package:domino/screens/Tutorial/tutorial5_page.dart';
import 'package:domino/screens/Tutorial/tutorial7_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/TT/menu_form.dart';

class Tutorial4 extends StatefulWidget {
  const Tutorial4({super.key});

  @override
  State<Tutorial4> createState() => Tutorial4State();
}

class Tutorial4State extends State<Tutorial4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,

        body: SingleChildScrollView(
          child: Stack(
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
