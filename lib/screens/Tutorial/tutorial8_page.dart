import 'package:domino/screens/Tutorial/tutorial9_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial8 extends StatefulWidget {
  const Tutorial8({super.key});

  @override
  State<Tutorial8> createState() => Tutorial8State();
}

class Tutorial8State extends State<Tutorial8> {
  int selectedIndex = 100;

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: tutorialPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
                    //❤️메뉴 아이콘
                    Row(
                      children: [
                        Image.asset(
                          'assets/img/td_icon.png',
                          height: currentWidth < 600 ? 17 : 26,
                          width: currentWidth < 600 ? 17 : 26,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        //❤️메뉴 텍스트
                        Text(
                          '오늘의 도미노',
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
                            height: 1.8),
                        children: [
                          TextSpan(
                            text: '동아리 들어가기',
                            style: TextStyle(color: mainBlue),
                          ),
                          TextSpan(
                            text: '를 위해\n',
                          ),
                          TextSpan(text: '실천으로 옮길 수 있는 TO-DO는?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    //❤️선택지
              ImageOption(
                imageUrls: [
                  'assets/img/option3.png',
                  'assets/img/option4.png',
                  'assets/img/option5.png'
                ],
                color: 'blue',
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
        bottomNavigationBar:
            //버튼
            Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: TutorialButton('다음', () {
            if (selectedIndex == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tutorial9()),
              );
            } else if (selectedIndex == 1 || selectedIndex == 2) {
              TutorialMessage("아닌데...다시 한번 잘 생각해봐!").tutorialMessage(context);
            } else {
              TutorialMessage("어떤 계획을 세워야할 지 선택해줘!").tutorialMessage(context);
            }
          }).tutorialButton(),
        ));
  }
}
