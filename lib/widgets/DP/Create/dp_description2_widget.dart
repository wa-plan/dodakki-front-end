import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class Description2 {
 final String color;
  final double currentWidth;

  Description2(this.color, this.currentWidth);


  Widget description2() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child:  ExpansionTile(
        backgroundColor: const Color(0xff2A2A2A),
        collapsedBackgroundColor: const Color(0xff2A2A2A),
        childrenPadding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        tilePadding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        iconColor: const Color(0xffAAAAAA),
        collapsedIconColor: const Color(0xffAAAAAA),
        shape: const Border(
      ),
        title:  Text(
          'SMART 기법을 참고해보세요.',
          style: TextStyle(
            color: const Color(0xffAAAAAA),
            fontSize: currentWidth < 600 ? 13 : 19,
            fontWeight: FontWeight.w400,
          ),
        ),
        children: [
          Row(
            children: [
               Text(
                'S',
                style: TextStyle(
                  color: ColorTransform(color).colorTransform(),
                  fontSize: currentWidth < 600 ? 12 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 14 : 18,
              ),
               Text(
                'Specific ',
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
                '명확하고 구체적인 목표',
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
              Text(
                'M',
                style: TextStyle(
                  color: ColorTransform(color).colorTransform(),
                  fontSize: currentWidth < 600 ? 12 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 14 : 18,
              ),
               Text(
                'Measurable',
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
                '측정 가능한 목표',
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
              Text(
                'A',
                style: TextStyle(
                  color: ColorTransform(color).colorTransform(),
                  fontSize: currentWidth < 600 ? 12 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 14 : 18,
              ),
               Text(
                'Attainable',
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
                '달성 가능한 목표',
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
              Text(
                'R',
                style: TextStyle(
                  color: ColorTransform(color).colorTransform(),
                  fontSize: currentWidth < 600 ? 12 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 14 : 18,
              ),
               Text(
                'Realistic',
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
                '현실적인 목표',
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
              Text(
                'T',
                style: TextStyle(
                  color: ColorTransform(color).colorTransform(),
                  fontSize: currentWidth < 600 ? 12 : 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: currentWidth < 600 ? 14 : 18,
              ),
               Text(
                'Timely',
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
                '마감기한이 있는 목표',
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