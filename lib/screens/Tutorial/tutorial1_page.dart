import 'package:domino/screens/Tutorial/tutorial2_page.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class Tutorial1 extends StatefulWidget {
  const Tutorial1({super.key});

  @override
  State<Tutorial1> createState() => Tutorial1State();
}

class Tutorial1State extends State<Tutorial1> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(0, 22, 0, 22),
          child: Column(
              children: [
                
          
                //튜토리얼 소개글
                Expanded(
                  flex: 2,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "안녕, 난 도민호야!",
                          style: TextStyle(
                            fontSize: currentWidth < 600 ? 16 : 22,
                            fontWeight: FontWeight.w700,
                            color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                          ),
                        ),
                        SizedBox(height: currentWidth < 600 ? 8 : 13),
                        Text(
                          "내가 목표를 달성할 수 있도록\n플랜 짜는걸 도와줄래?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: currentWidth < 600 ? 13 : 19,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffD9D9D9), // 이미지 위에 잘 보이도록 텍스트 색상 설정
                          ),
                        ),
                      ],
                    ),
                  
                ),
          
          
              
                //도민호 이미지
                Expanded(
                  flex: 3,
                  child:  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          "assets/img/tr_1.png", 
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Tutorial2()),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        backgroundColor: mainRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(currentWidth < 600 ? 6 : 8),
                        ),
                      ),
                      child: Text(
                        '도와줄게!',
                        style: TextStyle(
                            color: backgroundColor,
                            fontSize: currentWidth < 600 ? 15 : 21,
                            fontWeight: FontWeight.w700),
                      )),
                ),
              ));
  }
}
