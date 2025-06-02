import 'package:flutter/material.dart';


//질문
class TDQuestion {
  final String text;
  final double currentWidth;

  TDQuestion(this.text, this.currentWidth);

  Widget tDQuestion() {
    return Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        );
  }
}
