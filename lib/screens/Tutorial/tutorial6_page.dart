import 'package:domino/screens/Tutorial/tutorial7_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:domino/styles.dart';

class Tutorial6 extends StatefulWidget {
  const Tutorial6({super.key});

  @override
  State<Tutorial6> createState() => Tutorial6State();
}

class Tutorial6State extends State<Tutorial6> {
  int currentSelection = 0;

  final int correctIndex = 1; // 정답 위치 (두 번째 그리드)

  void wrongAnswer(int index) {
    Fluttertoast.showToast(
      msg: "틀렸어!",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 22, 30, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //스텝 및 내용
              Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "5  완성",
                      style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF6767),
                      ),
                    ),
                    SizedBox(height: currentWidth < 600 ? 8 : 13),
                    Text(
                      "고마워! 덕분에 완벽한 플랜을\n세울 수 있었어.",
                      style: TextStyle(
                        fontSize: currentWidth < 600 ? 15 : 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // 선택지 영역
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Option2('뿌듯한\n학교생활하기', currentWidth).option2(),
                    ),
                    SizedBox(height: currentWidth < 600 ? 10 : 15),
                    Center(
                      child: Option3('스펙왕\n되기', currentWidth, const Color(0xffFCFF62)).option3(),
                    ),
                    SizedBox(height: currentWidth < 600 ? 10 : 15),
                    Center(
                      child: Option3('"도닦기"\n동아리\n들어가기', currentWidth, const Color(0xff72FF5B)).option3(),
                    ),
                    SizedBox(height: currentWidth < 600 ? 10 : 15),
                    Center(
                      child: Option('동아리 지원요강 확인하기', currentWidth).option(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar:
            //다음 버튼
            Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
          child: SizedBox(
            width: double.infinity,
            child: TextButton(
                onPressed: () {
                  currentSelection == 0
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Tutorial7()),
                        )
                      : null;
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  backgroundColor: mainRed,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(currentWidth < 600 ? 6 : 8),
                  ),
                ),
                child: Text(
                  '다음',
                  style: TextStyle(
                      color: backgroundColor,
                      fontSize: currentWidth < 600 ? 15 : 21,
                      fontWeight: FontWeight.w700),
                )),
          ),
        ));
  }
}

//직사각형 박스
class Option {
  final String text;
  final double currentWidth;

  const Option(this.text, this.currentWidth);

  Widget option() {
    return Container(
        width: currentWidth < 600 ? 190 : 400,
        height: currentWidth < 600 ? 40 : 63,
        padding: EdgeInsets.all(currentWidth < 600 ? 5 : 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(currentWidth < 600 ? 6 : 8)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: backgroundColor,
              fontSize: currentWidth < 600 ? 12 : 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    
  }
}

//원형 박스
class Option2 {
  final String text;
  final double currentWidth;

  const Option2(this.text, this.currentWidth);

  Widget option2() {
    return Container(
          child: CircleAvatar(
        radius: currentWidth < 600 ? 45 : 55,
        backgroundColor: Colors.transparent, // 배경색을 투명하게 설정
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: mainRed,
            ),
      
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: backgroundColor,
                fontSize: currentWidth < 600 ? 12 : 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ));
  }
}

//정사각형 박스
class Option3 {
  final String text;
  final double currentWidth;
  final Color color;

  const Option3(this.text, this.currentWidth, this.color);

  Widget option3() {
    return Container(
      width: currentWidth < 600 ? 90 : 110,
      height: currentWidth < 600 ? 90 : 110,
      padding: EdgeInsets.all(currentWidth < 600 ? 7 : 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(currentWidth < 600 ? 6 : 8),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: backgroundColor,
            fontSize: currentWidth < 600 ? 12 : 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
