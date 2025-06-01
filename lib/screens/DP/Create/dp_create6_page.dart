import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class CompletePage extends StatefulWidget {
  const CompletePage({super.key});

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
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
                              "플랜 만들기 성공!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white, // 이미지 위에 잘 보이도록 텍스트 색상 설정
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "이제 목표를 향해\n달려볼까요?",
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
                    height: currentHeight*0.35))),
        
               
            ],
          ),
        ),
        bottomNavigationBar:
            //다음 버튼
            Padding(
          padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
          child: LoginButton('달려가기!!', () {
                  Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DPMain()),
                        );
                      
                }).loginButton()
        ));
  }
}
