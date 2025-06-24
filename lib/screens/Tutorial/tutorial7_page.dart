import 'package:domino/screens/Tutorial/tutorial8_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/TT/menu_form.dart';

class Tutorial7 extends StatefulWidget {
  const Tutorial7({super.key});

  @override
  State<Tutorial7> createState() => Tutorial7State();
}

class Tutorial7State extends State<Tutorial7> {
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
        ),
        bottomNavigationBar:
            //버튼
            Padding(
          padding: tutorialPadding,
          child: TutorialButton('다음!', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Tutorial8()),
            );
          }).tutorialButton(),
        ));
  }
}
