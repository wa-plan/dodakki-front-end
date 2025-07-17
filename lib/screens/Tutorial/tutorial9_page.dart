import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class Tutorial9 extends StatefulWidget {
  const Tutorial9({super.key});

  @override
  State<Tutorial9> createState() => Tutorial9State();
}

class Tutorial9State extends State<Tutorial9> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 22, 30, 30),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 250,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            blastDirection: -pi / 2,
            numberOfParticles: 10,
            maxBlastForce: 3,
            minBlastForce: 1,
            gravity: 0.03,
            shouldLoop: false,
            colors: [mainRed, mainBlue, mainGold, mainGreen, mainTextColor],
          ),
        ),
                      Positioned(
                        top: 80,
                        left: 0,
                        right: 0,
                        child: Column(
                          children: [
                            Text(
                              "도민호 도와주기 성공!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15),
                            Text(
                              "너도 목표를 달성해서\n너만의 도미노를 쓰러뜨려봐!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffAFAFAF),
                                height: 1.7
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Image.asset(
                  "assets/img/Complete.png",
                  height: 200,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(22, 0, 22, 22),
        child: LoginButton('시작하기!', () {
          _confettiController.play();
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TdMain()),
          );
        }).loginButton(),
      ),
    );
  }
}
