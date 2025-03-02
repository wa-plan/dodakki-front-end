import 'package:domino/screens/TR/tr_3.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TR_2 extends StatefulWidget {
  const TR_2({super.key});

  @override
  State<TR_2> createState() => _TR_2State();
}

class _TR_2State extends State<TR_2> {
  String selectedOption = ""; // 선택된 옵션 저장

  void handleSelection(String option) {
    if (option == "뿌듯한 학교생활하기") {
      setState(() {
        selectedOption = option; // 정답 선택 시 저장
      });
    } else {
      Fluttertoast.showToast(
        msg: "틀렸어!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  void handleNext() {
    if (selectedOption == "뿌듯한 학교생활하기") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TR_3()),
      );
    } else {
      Fluttertoast.showToast(
        msg: "정답을 선택해야 해!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 10, 40, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 80),
            const Text(
              "1  최종 목표",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xffFF6767),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "내 최종 목표는\n뿌듯한 학교생활하기야.",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25),

            // 선택지 영역
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1,
              ),
              children: [
                _buildOption("뿌듯한 학교생활하기"), // 정답
                _buildOption("알찬 방학 보내기"),
                _buildOption("행복한 휴학생활하기"),
                _buildOption("돈 많은 백수되기"),
              ],
            ),

            const Spacer(),

            Center(
              child: SizedBox(
                width: 350,
                child: TextButton(
                  onPressed: handleNext,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                    backgroundColor: const Color(0xffFF6767),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text(
                    '다음',
                    style: TextStyle(
                      color: Color(0xff262626),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 선택지 버튼 위젯
  Widget _buildOption(String option) {
    return GestureDetector(
      onTap: () => handleSelection(option),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selectedOption == option
              ? const Color(0xff563535) // 선택 시 배경 색 변경
              : const Color(0xff3B3B3B), // 기본 배경 색
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: selectedOption == option
                ? const Color(0xff9B3636) // 선택 시 테두리 색 변경
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          option,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

