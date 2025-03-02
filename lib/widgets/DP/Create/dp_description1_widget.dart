import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class Description {
  final String color;
  final double currentWidth;

  Description(this.color, this.currentWidth);

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
          '만다라트 작성 꿀팁',
          style: TextStyle(
            color: const Color(0xffAAAAAA),
            fontSize: currentWidth < 600 ? 13 : 19,
            fontWeight: FontWeight.w400,
          ),
        ),
        children: [
          Row(
            children: [
              Container(
                height: currentWidth < 600 ? 14 : 18,
                width: currentWidth < 600 ? 14 : 18,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: ColorTransform(color).colorTransform()),
              ),
              SizedBox(
                width: currentWidth < 600 ? 13 : 18,
              ),
              Text(
                '제1목표 ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: currentWidth < 600 ? 12 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 14 : 18,
              ),
              Text(
                currentWidth < 600 ? '이루고자 하는 최종목표':'이루고자 하는 최종목표에요.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: currentWidth < 600 ? 10 : 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(
                height: currentWidth < 600 ? 15 : 18,
              ),
          Row(
            children: [
              Container(
                height: currentWidth < 600 ? 14 : 18,
                width: currentWidth < 600 ? 14 : 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xff929292),
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 13 : 18,
              ),
               Text(
                '제2목표',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: currentWidth < 600 ? 12 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 14 : 18,
              ),
               Text(
                currentWidth < 600 ? '최종목표를 위한 세부목표':'최종목표를 위한 세부목표에요.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: currentWidth < 600 ? 10 : 16,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(
                height: currentWidth < 600 ? 15 : 18,
              ),
          Row(
            children: [
              Container(
                height: currentWidth < 600 ? 14 : 18,
                width: currentWidth < 600 ? 14 : 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: const Color(0xff5C5C5C),
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 13 : 18,
              ),
               Text(
                '제3목표',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: currentWidth < 600 ? 12 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 14 : 18,
              ),
               Text(
                currentWidth < 600 ? '세부목표를 위한 실행계획' : '세부목표를 위한 구체적인 계획이에요.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: currentWidth < 600 ? 10 : 16,
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