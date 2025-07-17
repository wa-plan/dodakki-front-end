import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

//서브메뉴 타이틀
class STSubTitle {
  final String text;
  final IconData icon;
  final double size;

  STSubTitle(this.text, this.icon, this.size);

  Widget sTSubTitle(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: settingGrey, size: size),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            color: settingGrey,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

