import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class Description {
  final String color;

  Description(this.color);

  Widget description() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: ExpansionTile(
        backgroundColor: const Color(0xff2A2A2A),
        collapsedBackgroundColor: const Color(0xff2A2A2A),
        childrenPadding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        tilePadding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        iconColor: const Color(0xffAAAAAA),
        collapsedIconColor: const Color(0xffAAAAAA),
        shape: const Border(
      ),
        title: Text(
          '만다라트의 구조를 알아봐요!',
          style: TextStyle(
            color: const Color(0xffAAAAAA),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Row(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: ColorTransform(color).colorTransform()),
              ),
              SizedBox(
                width: 13,
              ),
              Text(
                '제1목표 ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '이루고자 하는 최종목표에요.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(
                height: 15,
              ),
          Row(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xff929292),
                ),
              ),
              SizedBox(
                width: 13,
              ),
               Text(
                '제2목표',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 20,
              ),
               Text(
                '최종목표를 위한 세부목표에요.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(
                height: 15,
              ),
          Row(
            children: [
              Container(
                height: 16,
                width: 16,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xff5C5C5C),
                ),
              ),
              SizedBox(
                width: 13,
              ),
               Text(
                '제3목표',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 20,
              ),
               Text(
                '세부목표를 위한 구체적인 계획이에요.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}