import 'package:domino/screens/Tutorial/tutorial3_page.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Tutorial2 extends StatefulWidget {
  const Tutorial2({super.key});

  @override
  State<Tutorial2> createState() => Tutorial2State();
}

class Tutorial2State extends State<Tutorial2> {
  int currentSelection = 0;

  void wrongAnswer() {
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
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "1  최종 목표",
                      style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF6767),
                      ),
                    ),
                    SizedBox(height: currentWidth < 600 ? 8 : 13),
                    Text(
                      "내 최종 목표는\n뿌듯한 학교생활하기야.",
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
              Flexible(
                flex: 8,
                fit: FlexFit.tight,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Option('뿌듯한\n학교생활하기', () {
                          setState(() {
                            currentSelection = 1;
                          });
                        }, currentWidth, 1, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('알찬 방학\n보내기', () {
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
                        Option('행복한\n휴학생활하기', () {
                          wrongAnswer;
                          setState(() {
                            currentSelection = 3;
                          });
                        }, currentWidth, 3, currentSelection)
                            .option(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        Option('돈 많은\n백수되기', () {
                          wrongAnswer;
                          setState(() {
                            currentSelection = 4;
                          });
                        }, currentWidth, 4, currentSelection)
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
                          MaterialPageRoute(builder: (context) => const Tutorial3()),
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
          child: CircleAvatar(
        radius: currentWidth < 600 ? 60 : 100,
        backgroundColor: Colors.transparent, // 배경색을 투명하게 설정
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: currentSelection == index
                ? const Color(0xff563535)
                : const Color(0xff3B3B3B),
            border: Border.all(
              color: currentSelection == index
                  ? const Color(0xff9B3636)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: currentWidth < 600 ? 14 : 22,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )),
    );
  }
}
