import 'package:domino/screens/Tutorial/tutorial5_page.dart';
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
          child: Padding(
              padding: tutorialPadding,
              child: TTmenuForm(
                icon: 'assets/img/dp_icon.png',
                title: '도미노 플랜',
                description1: '두번째 단계는 계획 짜기!\n만다라트를 이용해 계획을 짜보자!',
                description2: '',
                description3: '',
                imageUrl: 'assets/img/menu_screen2.png',
                color: 'x',
              )),
        ),
        bottomNavigationBar:
            //❤️다음 버튼
            Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: TutorialButton('다음', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Tutorial5()),
            );
          }).tutorialButton(),
        ));
  }
}
