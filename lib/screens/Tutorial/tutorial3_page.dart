import 'package:domino/screens/Tutorial/tutorial4_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:domino/styles.dart';

class Tutorial3 extends StatefulWidget {
  const Tutorial3({super.key});

  @override
  State<Tutorial3> createState() => Tutorial3State();
}

class Tutorial3State extends State<Tutorial3> {
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
                      "2  세부 목표",
                      style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF6767),
                      ),
                    ),
                    SizedBox(height: currentWidth < 600 ? 8 : 13),
                    Text(
                      "나는 이번 학기에\n스펙을 많이 쌓고 싶어!",
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
                        Option('여행 많이\n다니기', () {
                          setState(() {
                            currentSelection = 0;
                          });
                        }, currentWidth, 0, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('스펙왕\n되기', () {
                          setState(() {
                            currentSelection = 1;
                          });
                        }, currentWidth, 1, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('나 자신을\n찾아가기', () {
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
                        Option('맛있는거\n많이 먹기', () {
                          setState(() {
                            currentSelection = 3;
                          });
                        }, currentWidth, 3, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option2('뿌듯한\n학교생활하기', currentWidth)
                            .option2(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('완벽하게\n자기관리하기', () {
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
                        Option('친구들이랑\n좋은추억 쌓기', () {
                          setState(() {
                            currentSelection = 6;
                          });
                        }, currentWidth, 6, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('다양한 사람\n만나보기', () {
                          wrongAnswer;
                          setState(() {
                            currentSelection = 7;
                          });
                        }, currentWidth, 7, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('돈 많이\n모으기', () {
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
                  currentSelection == 1
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Tutorial4()),
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
              ? const Color(0xff555634)
              : const Color(0xff3B3B3B),
          border: Border.all(
            color: currentSelection == index
                ? const Color(0xff949B36)
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(currentWidth < 600 ? 6 : 8)
        ),
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
          child: CircleAvatar(
        radius: currentWidth < 600 ? 32.5 : 62.5,
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
                fontSize: currentWidth < 600 ? 10 : 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ));
  }
}
