import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/style/style_tutorial.dart';

class TTmenuForm extends StatelessWidget {
  final String icon;
  final String title;
  final String description1;
  final String description2;
  final String description3;
  final String imageUrl;
  final String color;

  const TTmenuForm({
    super.key,
    required this.icon,
    required this.title,
    required this.description1,
    required this.description2,
    required this.description3,
    required this.imageUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Stack(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              //❤️메뉴 아이콘
              Image.asset(
                icon,
                height: currentWidth < 600 ? 17 : 26,
                width: currentWidth < 600 ? 17 : 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              //❤️메뉴 텍스트
              Text(
                title,
                style: TextStyle(
                  fontSize: currentWidth < 600 ? 18 : 29,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          //❤️메뉴 설명
          TutorialQuestion(
                  description1, description2, "를 위한", description3, color)
              .tutorialQuestion(),
          SizedBox(
            height: 30,
          ),

          Center(
            child: Image.asset(
              imageUrl,
              height: currentWidth < 600 ? 400 : 500,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                backgroundColor,
                backgroundColor.withOpacity(0.8),
                backgroundColor.withOpacity(0.0),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
