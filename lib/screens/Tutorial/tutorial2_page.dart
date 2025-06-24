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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //프로그레스 바
                  ProgressBar(1, 4),
                  SizedBox(height: 10),

                  //프로그레스 타이틀
                  ProgressTitle('제1목표 만들기').progressTitle(),
                  SizedBox(height: 17),

                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '새내기',
                          style: TextStyle(
                            color: Color(0xFFFF7D7D), // 강조 색상
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '로 대학에 입학하는\n도민호를 위한 제1목표는?',
                          style: TextStyle(
                            color: Colors.white, // 기본 색상
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),
                ],
              ),

              //선택지
              Center(
                child: SizedBox(
                  width: currentWidth < 600 ? 270 : 350,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 13,
                      mainAxisSpacing: 13,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Color(0xff503333)
                                : Color(0xff3B3B3B),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: selectedIndex == index
                                  ? mainRed
                                  : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: 18,
                                    color: selectedIndex == index
                                        ? mainRed
                                        : Color(0xff3B3B3B),
                                  ),
                                ],
                              ),
                              Text(
                                texts[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: selectedIndex == index
                                      ? mainRed
                                      : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: selectedIndex == index
                                    ? Color(0xff503333)
                                    : Color(0xff3B3B3B),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

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
