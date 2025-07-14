import 'dart:async';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//패딩
const tutorialPadding = EdgeInsets.fromLTRB(36, 55, 36, 20);

//프로그레스바
class ProgressBar extends StatelessWidget {
  final int current;
  final int total;

  const ProgressBar(this.current, this.total, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(total, (index) {
        bool isPast = index < current;
        bool isCurrent = index == current;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 7,
          height: 16,
          decoration: BoxDecoration(
            gradient: isCurrent
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xffFF6767), // mainRed
                      Color(0xffFF4C4C), // gradientRed
                    ],
                  )
                : null,
            color: isCurrent ? null : const Color(0xff515151),
            borderRadius: BorderRadius.circular(2),
          ),
          transform: isPast
              ? Matrix4.rotationZ(0.5) // 기울기 (도미노 쓰러짐)
              : Matrix4.identity(),
          transformAlignment: Alignment.center,
        );
      }),
    );
  }
}

//프로그레스 타이틀
class ProgressTitle {
  final String title;

  const ProgressTitle(this.title);

  Widget progressTitle() {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: const Color(0xffB9B9B9),
      ),
    );
  }
}

//질문
class TutorialQuestion {
  final String text0;
  final String text1;
  final String text2;
  final String text3;
  final String color;

  const TutorialQuestion(
      this.text0, this.text1, this.text2, this.text3, this.color);

  Color textColorDefiner(String color) {
    late Color textColor;

    if (color == 'green') {
      textColor = const Color(0xff72FF5B);
    } else if (color == 'red') {
      textColor = mainRed;
    } else {
      textColor = const Color(0xff5DD8FF);
    }

    return textColor;
  }

  Color backColorDefiner(String color) {
    late Color backColor;

    if (color == 'green') {
      backColor = const Color(0xff24541D);
    } else if (color == 'red') {
      backColor = const Color(0xff503333);
    } else if (color == 'blue') {
      backColor = const Color(0xff265362);
    } else {
      backColor = const Color(0xff222222);
    }

    return backColor;
  }

  Widget tutorialQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text0,
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.7),
        ),
        if (color != 'x') ...[
          Row(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(7, 1, 7, 1),
                decoration: BoxDecoration(
                    color: backColorDefiner(color),
                    borderRadius: BorderRadius.circular(5)),
                child: Text(
                  text1,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColorDefiner(color),
                      height: 1.7),
                ),
              ),
              SizedBox(width: 4),
              Text(
                text2,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.7,
                ),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(
            text3,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.7),
          ),
        ]
      ],
    );
  }
}

//버튼
class TutorialButton {
  final String text;
  final Function function;

  TutorialButton(this.text, this.function);

  Widget tutorialButton() {
    return TextButton(
      onPressed: () => function(),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        backgroundColor: mainRed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: backgroundColor,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

//만다라트 선택지
class MandalartOption extends StatefulWidget {
  final String middleText;
  final List<String> texts;
  final String color;
  final void Function(int index)? onItemSelected;
  final double currentWidth;

  const MandalartOption({
    super.key,
    required this.middleText,
    required this.texts,
    required this.color,
    required this.currentWidth,
    this.onItemSelected,
  });

  @override
  _MandalartOptionState createState() => _MandalartOptionState();
}

class _MandalartOptionState extends State<MandalartOption> {
  int selectedIndex = 100;

  Color textColorDefiner(String color) {
    late Color textColor;

    if (color == 'green') {
      textColor = mainGreen;
    } else if (color == 'red') {
      textColor = mainRed;
    } else {
      textColor = mainBlue;
    }

    return textColor;
  }

  Color backColorDefiner(String color) {
    late Color backColor;

    if (color == 'green') {
      backColor = const Color(0xff24541D);
    } else if (color == 'red') {
      backColor = const Color(0xff513333);
    } else {
      backColor = const Color(0xff265362);
    }

    return backColor;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.currentWidth < 600 ? 370 : 600,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 13,
          mainAxisSpacing: 13,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          if (index == 4) {
            return Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: widget.color == 'red' ? mainRed : mainGreen,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  widget.middleText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: backgroundColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (index == 0 || index == 3 || index == 6) {
                    selectedIndex = 100;
                  } else {
                    selectedIndex = index;
                  }
                });
                widget.onItemSelected?.call(index);
              },
              child: Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? backColorDefiner(widget.color)
                      : Color(0xff3B3B3B),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: selectedIndex == index
                        ? textColorDefiner(widget.color)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: selectedIndex == index
                              ? textColorDefiner(widget.color)
                              : Color(0xff3B3B3B),
                        ),
                      ],
                    ),
                    Text(
                      widget.texts[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selectedIndex == index
                            ? textColorDefiner(widget.color)
                            : Colors.white,
                        fontSize: widget.currentWidth < 600 ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: selectedIndex == index
                          ? backColorDefiner(widget.color)
                          : Color(0xff3B3B3B),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

//오답or미선택 메시지
class TutorialMessage {
  final String text;

  TutorialMessage(this.text);

  Future<bool?> tutorialMessage(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    Completer<bool?> completer = Completer<bool?>();

    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff412C2C),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: mainRed, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.block, color: mainRed),
          SizedBox(width: 8.0),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                  color: mainRed, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );

    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(true);
    });

    return completer.future;
  }
}

//TO-DO 선택지
class TodoOption extends StatefulWidget {
  final List<String> texts;
  final List<String> icons;
  final void Function(int index)? onItemSelected;

  const TodoOption({
    super.key,
    required this.texts,
    required this.icons,
    this.onItemSelected,
  });

  @override
  _TodoOptionState createState() => _TodoOptionState();
}

class _TodoOptionState extends State<TodoOption> {
  int selectedIndex = 100;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                widget.onItemSelected?.call(index);
              },
              child: Container(
                height: 65,
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: selectedIndex == index
                      ? Color(0xff4D4D4D)
                      : Color(0xff3C3C3C),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: selectedIndex == index
                        ? Colors.white
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          widget.icons[index],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.texts[index],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: selectedIndex == index
                          ? Colors.white
                          : Color(0xff3C3C3C),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class ImageOption extends StatefulWidget {
  final List<String> imageUrls;
  final String color; // 예: "red"
  final void Function(int index)? onItemSelected;

  const ImageOption({
    super.key,
    required this.imageUrls,
    required this.color,
    this.onItemSelected,
  });

  @override
  _ImageOptionState createState() => _ImageOptionState();
}

class _ImageOptionState extends State<ImageOption> {
  int selectedIndex = 100;

  /// 문자열 컬러 → 실제 색상 매핑 함수
  Color getSelectedColor(String name) {
    switch (name.toLowerCase()) {
      case 'red':
        return const Color(0xFFFF6767);
      case 'blue':
        return Color(0xff5DD8FF);
      default:
        return Colors.white; // 기본값
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color selectedIconColor = getSelectedColor(widget.color);

    return SizedBox(
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  widget.onItemSelected?.call(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8.68),
                    border: Border.all(
                      color:
                          isSelected ? selectedIconColor : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Stack(
                    //fit: StackFit.expand,
                    children: [
                      // 배경 이미지
                      AspectRatio(
                        aspectRatio:
                            widget.color == 'red' ? 696 / 452 : 722 / 202,
                        child: Image.asset(
                          widget.imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      ),

                      // 체크 아이콘 (오른쪽 상단)
                      Positioned(
                        top: 15,
                        right: 15,
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 18,
                          color: isSelected
                              ? selectedIconColor
                              : const Color(0xFF3C3C3C),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              )
            ],
          );
        },
      ),
    );
  }
}

//플랜 완성 비주얼 (전체)
class PlanVisual {
  final double currentWidth;

  PlanVisual(this.currentWidth);

  Widget planVisual() {
    List<int> secondGoalIndex = [6, 8, 12, 16, 18, 19, 31];

    return SizedBox(
      width: currentWidth < 600 ? 370 : 600,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        itemCount: 42,
        itemBuilder: (context, index) {
          if (index == 13) {
            return PlanVisualBox1('씐나는\n학교생활', mainRed).planVisualBox1();
          } else if (index == 20 || index == 34) {
            return PlanVisualBox1('대학교\n최강인싸', mainGreen).planVisualBox1();
          } else if (index == 27) {
            return PlanVisualBox1('동아리\n들어가기', mainBlue).planVisualBox1();
          } else if (secondGoalIndex.contains(index)) {
            return PlanVisualBox1('', Color(0xff5C5C5C)).planVisualBox1();
          } else if (index == 7) {
            return PlanVisualBox2('제1목표', mainRed, Color(0xff5C5C5C))
                .planVisualBox2();
          } else if (index == 14) {
            return PlanVisualBox2('제2목표', mainGreen, Color(0xff5C5C5C))
                .planVisualBox2();
          } else if (index == 21) {
            return PlanVisualBox2('제3목표', mainBlue, Color(0xff3B3B3B))
                .planVisualBox2();
          } else {
            return PlanVisualBox1('', Color(0xff3B3B3B)).planVisualBox1();
          }
        },
      ),
    );
  }
}

//플랜 완성 비주얼 (박스1)
class PlanVisualBox1 {
  final String text;
  final Color color;

  const PlanVisualBox1(this.text, this.color);

  Widget planVisualBox1() {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: backgroundColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

//플랜 완성 비주얼 (박스2)
class PlanVisualBox2 {
  final String text;
  final Color backcolor;
  final Color textcolor;

  const PlanVisualBox2(this.text, this.textcolor, this.backcolor);

  Widget planVisualBox2() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: backcolor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textcolor,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
