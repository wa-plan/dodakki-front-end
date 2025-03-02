import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text(
              "도닦기",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // Text 사이에 간격을 추가
            const Text(
              "목표를 이루려면\n도를 닦아야 한다.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40), // Text와 이미지 사이에 간격을 추가
            Image.asset(
              "assets/img/Dominho.png",
              height: 200, // 이미지 크기 조정
            ),
          ],
        ),
      ),
    );
  }
}
