import 'package:domino/screens/Tutorial/tutorial7_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';

class Tutorial6 extends StatefulWidget {
  const Tutorial6({super.key});

  @override
  State<Tutorial6> createState() => Tutorial6State();
}

class Tutorial6State extends State<Tutorial6> {
  @override
  Widget build(BuildContext context) {
    int selectedIndex = 100;
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: tutorialPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    //❤️메뉴 아이콘
                    Row(
                      children: [
                        Image.asset(
                          'assets/img/dp_icon.png',
                          height: currentWidth < 600 ? 17 : 26,
                          width: currentWidth < 600 ? 17 : 26,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 8),
                        //❤️메뉴 텍스트
                        Text(
                          '도미노 플랜',
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
                            text: '슈퍼 인싸 되기',
                            style: TextStyle(color: mainGreen),
                          ),
                          TextSpan(
                            text: '를 위해\n',
                          ),
                          TextSpan(text: '달성해야 할 실행 계획은?'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    //❤️선택지
                    MandalartOption(
                middleText: '슈퍼 인싸\n되기',
                texts: [
                  '',
                  '침대 밖으로\n안 나오기',
                  '동아리\n들어가기',
                  '',
                  '',
                  '비둘기와\n친해지기',
                  '침묵 챌린지\n30일 하기',
                  '인성파탄자\n되기',
                  ''
                ],
                color: 'green',
                onItemSelected: (index) {
                  selectedIndex = index;
                },
                currentWidth: currentWidth,
              ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
        bottomNavigationBar:
            //버튼
            Padding(
          padding: EdgeInsets.fromLTRB(40, 0, 40, 20),
          child: TutorialButton('다음', () {
            if (selectedIndex == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Tutorial7()),
              );
            } else if (selectedIndex == 0 ||
                selectedIndex == 3 ||
                selectedIndex == 6) {
              TutorialMessage("어떤 계획을 세워야할 지 선택해줘!").tutorialMessage(context);
            } else {
              TutorialMessage("아닌데...다시 한번 잘 생각해봐!").tutorialMessage(context);
            }
          }).tutorialButton(),
        ));
  }
}
