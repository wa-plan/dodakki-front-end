import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class EditCompletePage extends StatefulWidget {
  const EditCompletePage({super.key});

  @override
  State<EditCompletePage> createState() => _EditCompletePageState();
}

class _EditCompletePageState extends State<EditCompletePage> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
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
                        height: currentWidth < 600 ? 200 : 310,
                        fit: BoxFit.cover, 
                      ),
                  
                  
                      Positioned(
                        top: currentWidth < 600 ? 60 : 110,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              "플랜 수정하기 성공!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "새로운 플랜으로 다시\n달려볼까요?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
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
                    height: currentHeight*0.4))),
        
               
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
                  '네!',
                  style: TextStyle(
                      color: backgroundColor,
                      fontSize: currentWidth < 600 ? 15 : 21,
                      fontWeight: FontWeight.w700),
                )),
          ),
        ));
  }
}
