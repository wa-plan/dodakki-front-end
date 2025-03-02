import 'package:domino/screens/Tutorial/tutorial6_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:domino/styles.dart';

class Tutorial5 extends StatefulWidget {
  const Tutorial5({super.key});

  @override
  State<Tutorial5> createState() => Tutorial5State();
}

class Tutorial5State extends State<Tutorial5> {
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
                      "4  루틴/투두",
                      style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffFF6767),
                      ),
                    ),
                    SizedBox(height: currentWidth < 600 ? 8 : 13),
                    Text(
                      "동아리에 들어갈래!\n어떤 것부터 준비하지?",
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
                      child: Option('동아리 지원요강 확인하기', () {
                        setState(() {
                          currentSelection = 0;
                        });
                      }, currentWidth, 0, currentSelection)
                          .option(),
                    ),
                    SizedBox(height: currentWidth < 600 ? 10 : 15),
                    Center(
                      child: Option('동아리 지원서 작성하기', () {
                        setState(() {
                          currentSelection = 1;
                        });
                      }, currentWidth, 1, currentSelection)
                          .option(),
                    ),
                    SizedBox(height: currentWidth < 600 ? 10 : 15),
                    Center(
                      child: Option('면접 준비하기', () {
                        wrongAnswer;
                        setState(() {
                          currentSelection = 2;
                        });
                      }, currentWidth, 2, currentSelection)
                          .option(),
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
                          MaterialPageRoute(builder: (context) => const Tutorial6()),
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
        width: currentWidth < 600 ? double.infinity : 500,
        height: currentWidth < 600 ? 70 : 100,
        padding: EdgeInsets.all(currentWidth < 600 ? 5 : 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: currentSelection == index
                ? const Color(0xff515151)
                : const Color(0xff3B3B3B),
            border: Border.all(
              color: currentSelection == index
                  ? Colors.white
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
              fontSize: currentWidth < 600 ? 12 : 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}