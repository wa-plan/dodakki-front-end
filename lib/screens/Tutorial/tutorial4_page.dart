import 'package:domino/screens/Tutorial/tutorial5_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:domino/styles.dart';

class Tutorial4 extends StatefulWidget {
  const Tutorial4({super.key});

  @override
  State<Tutorial4> createState() => Tutorial4State();
}

class Tutorial4State extends State<Tutorial4> {
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
          padding: const EdgeInsets.fromLTRB(30, 22, 30, 30),
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
                      "3  실행 계획",
                      style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF6767),
                      ),
                    ),
                    SizedBox(height: currentWidth < 600 ? 8 : 13),
                    Text(
                      "동아리나 학회는 어떨까?",
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Option('인턴하기', () {
                          setState(() {
                            currentSelection = 0;
                          });
                        }, currentWidth, 0, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('해외유학\n가기', () {
                          setState(() {
                            currentSelection = 1;
                          });
                        }, currentWidth, 1, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('"도닦기"\n동아리\n들어가기', () {
                          wrongAnswer;
                          setState(() {
                            currentSelection = 2;
                          });
                        }, currentWidth, 2, currentSelection)
                            .option(),
                      ],
                    ),
                    SizedBox(height: currentWidth < 600 ? 10 : 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Option('서포터즈\n하기', () {
                          setState(() {
                            currentSelection = 3;
                          });
                        }, currentWidth, 3, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option2('스펙왕 되기', currentWidth).option2(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('공모전\n우승하기', () {
                          wrongAnswer;
                          setState(() {
                            currentSelection = 5;
                          });
                        }, currentWidth, 5, currentSelection)
                            .option(),
                      ],
                    ),
                    SizedBox(height: currentWidth < 600 ? 10 : 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Option('자격증 따기', () {
                          setState(() {
                            currentSelection = 6;
                          });
                        }, currentWidth, 6, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('포트폴리오 만들기', () {
                          wrongAnswer;
                          setState(() {
                            currentSelection = 7;
                          });
                        }, currentWidth, 7, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('장학생 되기', () {
                          wrongAnswer;
                          setState(() {
                            currentSelection = 8;
                          });
                        }, currentWidth, 8, currentSelection)
                            .option(),
                      ],
                    )
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
                  currentSelection == 2
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Tutorial5()),
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

class Option {
  final String text;
  final Function function;
  final double currentWidth;
  final int currentSelection;
  final int index;

  const Option(this.text, this.function, this.currentWidth, this.index,
      this.currentSelection);

  Widget option() {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        width: currentWidth < 600 ? 75 : 125,
        height: currentWidth < 600 ? 75 : 125,
        padding: EdgeInsets.all(currentWidth < 600 ? 7 : 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: currentSelection == index
                ? const Color(0xff355130)
                : const Color(0xff3B3B3B),
            border: Border.all(
              color: currentSelection == index
                  ? const Color(0xff36B222)
                  : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(currentWidth < 600 ? 6 : 8)),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: currentWidth < 600 ? 11 : 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class Option2 {
  final String text;
  final double currentWidth;

  const Option2(this.text, this.currentWidth);

  Widget option2() {
    return Container(
      width: currentWidth < 600 ? 75 : 125,
      height: currentWidth < 600 ? 75 : 125,
      padding: EdgeInsets.all(currentWidth < 600 ? 7 : 20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffFCFF62),
        borderRadius: BorderRadius.circular(currentWidth < 600 ? 6 : 8),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: backgroundColor,
            fontSize: currentWidth < 600 ? 10 : 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
