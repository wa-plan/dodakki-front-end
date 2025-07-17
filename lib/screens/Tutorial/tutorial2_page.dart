import 'package:domino/screens/Tutorial/tutorial3_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/TT/menu_form.dart';

class Tutorial2 extends StatefulWidget {
  const Tutorial2({super.key});

  @override
  State<Tutorial2> createState() => Tutorial2State();
}

class Tutorial2State extends State<Tutorial2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
              padding: tutorialPadding,
              child: TTmenuForm(
                icon: 'assets/img/mg_icon.png',
                title: '나의 목표',
                description1: "첫번째 단계는 목표 세우기!\n목표를 구체적으로 상상해보자!",
                description2: "",
                description3: '',
                imageUrl: 'assets/img/menu_screen1.png',
                color: "x",
              )),
        ),
        bottomNavigationBar:
            //❤️다음 버튼
            Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: TutorialButton('다음', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Tutorial3()),
            );
          }).tutorialButton(),
        ));
  }
}
