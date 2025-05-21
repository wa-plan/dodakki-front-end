import 'package:flutter/material.dart';


// 디데이 태그
class DdayTag {
  final int dday;

  const DdayTag(this.dday);

  Widget ddayTag(){
    return Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 9.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 51, 51, 51),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05), // 검은색 10% 투명도
                        offset: const Offset(0, 0), // X, Y 위치 (0,0)
                        blurRadius: 7, // 블러 7
                        spreadRadius: 0, // 스프레드 0
                      ),
                    ],
                  ),
                  child: Text(
                    dday < 0 ? 'D+${dday * -1}' : 'D-$dday',
                    style: TextStyle(
                      color: Color.fromARGB(255, 105, 105, 105),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
  }
}


// 아이콘 버튼
class DPIconButton {
  final Function function;
  final IconData icon;

  const DPIconButton(
      this.function, this.icon);

  Widget dPIconButton() {
    return Container(
      width: 40,
      height: 27,
      decoration: BoxDecoration(
        color: Color(0xff303030),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02), 
            offset: const Offset(0, 0), 
            blurRadius: 15, 
            spreadRadius: 0, 
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          function(); // 함수 호출
        },
        child: Icon(
          icon,
          color: const Color(0xff646464),
          size: 25,
        ),
      ),
    );
  }
}

// 페이지 타이틀
class DPTitleText {
  final String text;
  final double currentWidth;

  DPTitleText(this.text, this.currentWidth);

  Widget dPTitleText() {
    return Text(text,
        style: TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.w600));
  }
}