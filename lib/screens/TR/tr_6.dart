import 'package:domino/screens/TR/tr_7.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class TR_6 extends StatefulWidget {
  const TR_6({super.key});

  @override
  State<TR_6> createState() => _TR_6State();
}

class _TR_6State extends State<TR_6> {
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
                "5  완성",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xffFF6767),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "고마워! 덕분에 완벽한 플랜을\n세울 수 있었어.",
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xffFF6767),
                  borderRadius: BorderRadius.circular(3),
                ),

                child: const Text(

                  '뿌듯한 학교생활하기',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xffFCFF62),
                  borderRadius: BorderRadius.circular(3),
                ),

                child: const Text(

                  '스펙왕 되기',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xff72FF5B),
                  borderRadius: BorderRadius.circular(3),
                ),

                child: const Text(

                  '"도닦기" 동아리/학회',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),

              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),

                child: const Text(

                  '동아리 지원요강 확인하기',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 350,
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TR_7()),
                      );
                    },
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
                          fontWeight: FontWeight.w700),
                    )),
              ),
            ],
          ),
        ));
  }
}
