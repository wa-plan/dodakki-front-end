import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class CompletePage extends StatefulWidget {
  final edit;

  const CompletePage({super.key, required this.edit});

  @override
  State<CompletePage> createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
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
                              widget.edit ? "플랜 수정하기 성공!" : "플랜 만들기 성공!",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.edit
                                  ? "새로운 계획과 함께\n달려볼까요?"
                                  : "이제 목표를 향해\n달려볼까요?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
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
        child: LoginButton('달려가기!!', () {
          _confettiController.play();
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DPMain()),
          );
        }).loginButton(),
      ),
    );
  }
}
