import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class TR_7 extends StatefulWidget {
  const TR_7({super.key});

  @override
  State<TR_7> createState() => _TR_7State();
}

class _TR_7State extends State<TR_7> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
          child: Column(
            children: [
              const SizedBox(height: 80),
              Stack(
                children: [
                  // 이미지가 뒤에 배치됨
                  Image.asset(
                    "assets/img/confetti.png",
                    height: 230,
                    fit: BoxFit.cover, // 이미지가 Stack의 크기를 덮도록 설정
                  ),

                  // 텍스트는 Positioned로 위치 조정
                  const Positioned(
                    top: 80, // 이미지와 텍스트 사이의 간격 조정
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        Text(
                          "이제 함께 시작해볼까?",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "상상도 못할 만큼 큰\n도미노를 쓰러뜨려봐!",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 45,
              ),
              Image.asset("assets/img/Complete.png", height: 220),
              const Spacer(),
              SizedBox(
                    width: 350,
                    child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DPMain()),
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
                          '시작하기',
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
