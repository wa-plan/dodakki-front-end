import 'package:domino/screens/TR/tr_2.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class TR_1 extends StatefulWidget {
  const TR_1({super.key});

  @override
  State<TR_1> createState() => _TR_1State();
}

class _TR_1State extends State<TR_1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 20),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text(
                "안녕, 난 도민호야!",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "내가 목표를 달성할 수 있도록\n플랜 짜는걸 도와줄래?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xffD9D9D9), // 이미지 위에 잘 보이도록 텍스트 색상 설정
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset("assets/img/tr_1.png", height: 390),
                ],
              ),
              const Spacer(),
              SizedBox(
                    width: 350,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const TR_2()),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding:
                              const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                          backgroundColor: const Color(0xffFF6767),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '도와줄게!',
                          style: TextStyle(
                            color: Color(0xff262626),
                            fontWeight: FontWeight.w700),
                        )),
                  ),
               
            ],
          ),
        ));
  }
}
