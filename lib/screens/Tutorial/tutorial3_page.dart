import 'package:domino/screens/Tutorial/tutorial4_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial3 extends StatefulWidget {
  const Tutorial3({super.key});

  @override
  State<Tutorial3> createState() => Tutorial3State();
}

class Tutorial3State extends State<Tutorial3> {
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
                SizedBox(height: 20),
                //❤️메뉴 아이콘
                Row(
                  children: [
                    Image.asset(
                      'assets/img/mg_icon.png',
                      height: currentWidth < 600 ? 17 : 26,
                      width: currentWidth < 600 ? 17 : 26,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 8),
                    //❤️메뉴 텍스트
                    Text(
                      '나의 목표',
                      style: TextStyle(
                        fontSize: currentWidth < 600 ? 18 : 29,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),
                //❤️질문
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Pretendard',
                      color: Colors.white,
                      height: 1.8
                    ),
                    children: [
                      TextSpan(
                        text: '새내기',
                        style: TextStyle(color: mainRed),
                      ),
                      TextSpan(
                        text: '로 대학에 입학하는\n',
                      ),
                      TextSpan(text: '도민호를 위한 최종 목표는?'),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                
                //❤️옵션
                ImageOption(
                  imageUrls: [
                    'assets/img/option1.png',
                    'assets/img/option2.png'
                  ],
                  color: 'red',
                  currentWidth: currentWidth,
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
            //❤️다음 버튼
            Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: TutorialButton('다음', () {
            if (selectedIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tutorial4()),
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
