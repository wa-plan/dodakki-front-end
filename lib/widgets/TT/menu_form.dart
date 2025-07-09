import 'package:flutter/material.dart';
import 'package:domino/style/styles.dart';
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: 20,),
          Row(
            children: [
              Image.asset(
                icon,
                height: 28,
                width: 28,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TutorialQuestion(
                  description1, description2, "를 위한", description3, color)
              .tutorialQuestion(),
          const SizedBox(height: 50),
          AspectRatio(
            aspectRatio: 795 / 1143,
            child: Image.asset(
              imageUrl,
              width: double.infinity,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ],
      ),
    );
  }
}
