import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class Tutorial7 extends StatefulWidget {
  const Tutorial7({super.key});

  @override
  State<Tutorial7> createState() => Tutorial7State();
}

class Tutorial7State extends State<Tutorial7> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: backgroundColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(30, 22, 30, 30),
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/img/confetti.png",
                        height: currentWidth < 600 ? 210 : 310,
                        fit: BoxFit.cover, 
                      ),
                  
                  
                      Positioned(
                        top: currentWidth < 600 ? 60 : 110,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              "이제 함께 시작해볼까?",
                              style: TextStyle(
                                fontSize: currentWidth < 600 ? 18 : 25,
                                fontWeight: FontWeight.w600,
                                color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "상상도 못할 만큼 큰\n도미노를 쓰러뜨려봐!",
                              style: TextStyle(
                                fontSize: currentWidth < 600 ? 15 : 23,
                                fontWeight: FontWeight.w400,
                                height: 1.7,
                                color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              Expanded(
                flex: 2,
                child: Center(
                  child: Image.asset(
                    "assets/img/Complete.png", 
                    height: currentWidth < 600 ? 180 : 300))),
        
               
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
                          MaterialPageRoute(builder: (context) => const DPMain()),
                        );
                      
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
                  '시작하기',
                  style: TextStyle(
                      color: backgroundColor,
                      fontSize: currentWidth < 600 ? 15 : 21,
                      fontWeight: FontWeight.w700),
                )),
          ),
        ));
  }
}
