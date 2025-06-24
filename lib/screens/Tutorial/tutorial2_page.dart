import 'package:domino/screens/Tutorial/tutorial2_page.dart';
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
          child: Stack(
            children: [
              Padding(
                padding: tutorialPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TTmenuForm(
                      icon: 'assets/img/tt_menu_icon1.png',
                      title: '나의 목표',
                      description1: "우리의 첫번째 메뉴야! \n여기서 목표를 상상해보자!",
                      description2: "",
                      description3: '',
                      imageUrl: 'assets/img/menu_screen1.png',
                      color: "x",
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
              MaterialPageRoute(builder: (context) => const Tutorial3()),
            );
          }).tutorialButton(),
        ));
  }
}
