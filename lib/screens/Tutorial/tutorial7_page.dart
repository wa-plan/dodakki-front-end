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
          child: Padding(
                  padding: tutorialPadding,
                  child: TTmenuForm(
                        icon: 'assets/img/td_icon.png',
                        title: '오늘의 도미노',
                        description1: '마지막 단계는 실천으로 옮기기!\n계획을 구체적인 TO-DO로 만들어보자.',
                        description2: '',
                        description3: '',
                        imageUrl: 'assets/img/menu_screen3.png',
                        color: 'x',
                      )
                   
                ),
        ),
              
        bottomNavigationBar:
            //버튼
            Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: TutorialButton('다음', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Tutorial8()),
            );
          }).tutorialButton(),
        ));
  }
}
