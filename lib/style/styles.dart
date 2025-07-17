import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

//color
const backgroundColor = Color(0xff222222);
const mainRed = Color(0xffFF6767);
const mainGrey = Color(0xff444444);
const mainTextColor = Colors.white;
const mainGold = Color.fromARGB(255, 255, 217, 79);
const mainGreen = Color(0xff72FF5B);
const mainBlue = Color(0xff5DD8FF);
const settingGrey = Color(0xff808080);
const gradientColor = [
              mainRed, 
              Color(0xffFF4C4C), 
            ];

//padding
const appBarPadding = EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20);
const tabletPadding1 = EdgeInsets.fromLTRB(30.0, 50.0, 30.0, 20);
const fullPadding = EdgeInsets.fromLTRB(20.0, 10, 20.0, 20.0);
const tabletPadding2 = EdgeInsets.fromLTRB(30.0, 15, 30.0, 30.0);


class NewButton {
  final Color buttonColor;
  final Color textColor;
  final String text;
  final Function function;


  NewButton(
    this.buttonColor,
    this.textColor,
    this.text,
    this.function,
  );

  Widget newButton() {
    return TextButton(
      onPressed: () => function(),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}


class Message {
  final String text;
  final Color textColor;
  final Color bgColor;
  final Color borderColor; // 테두리 색상 추가
  final IconData? icon; // 아이콘 추가

  Message(
    this.text,
    this.textColor,
    this.bgColor, {
    required this.borderColor, // 기본 테두리 색상
    required this.icon,
  });

  Future<bool?> message(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    Completer<bool?> completer = Completer<bool?>();

    // 커스텀 토스트 위젯
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor, width: 1.5), // 테두리 색상
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: textColor), // 아이콘 추가
          if (icon != null) const SizedBox(width: 8.0), // 아이콘과 텍스트 간격
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                  color: textColor, fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );

    // FToast를 통해 토스트를 표시
    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );

    // 반환 값을 임의로 완료
    Future.delayed(const Duration(seconds: 2), () {
      completer.complete(true); // 표시 완료 후 true 반환
    });

    return completer.future;
  }
}


//도미노 페이지 인디케이터
class PageIndicator extends StatelessWidget {
  final List<Map<String, dynamic>> goals;
  final PageController controller;

  const PageIndicator(this.controller, this.goals, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        int currentPage = controller.hasClients
            ? controller.page?.round() ?? controller.initialPage
            : 0;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(goals.length, (index) {
            bool isPast = index < currentPage;
            bool isCurrent = index == currentPage;

            return AnimatedContainer(
              duration: Duration(milliseconds: 400),
              margin: EdgeInsets.symmetric(horizontal: 6),
              width: 7,
              height: 16,
              decoration: BoxDecoration(
                color: isCurrent
                    ? mainRed
                    : mainGrey,
                borderRadius: BorderRadius.circular(2),
              ),
              transform: isPast
                  ? Matrix4.rotationZ(0.5) // 쓰러진 효과
                  : Matrix4.identity(),
              transformAlignment: Alignment.center,
            );
          }),
        );
      },

    );
  }
}

class FreeGrid {
  final String text;
  final Color color;
  final double maxFontSize;
  final double currentWidth;

  const FreeGrid(this.text, this.color, this.maxFontSize, this.currentWidth);

  Widget freeGrid() {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(currentWidth < 600 ? 4 : 6),
        color: color,
      ),
      child: Center(
        child: AutoSizeText(
          text,
          maxLines: 3,
          minFontSize: 3,
          maxFontSize: maxFontSize,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: backgroundColor,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}


class ColorTransform {
  final String color;

  const ColorTransform(this.color);

  Color colorTransform() {
    String processedColor = color.replaceAll('Color(', '').replaceAll(')', '');

    if (processedColor.startsWith('#')) {
      // #RRGGBB 또는 #AARRGGBB를 0x 형식으로 변환
      processedColor = processedColor.replaceFirst('#', '0x');
    }

    return Color(int.parse(processedColor));
  }
}

class NewCustomTextField {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String?> validator;
  final bool obscureText;
  final int maxLines;
  final double currentWidth;

  const NewCustomTextField(this.hintText, this.controller, this.validator,
      this.obscureText, this.maxLines, this.currentWidth);

  Widget newtextField({
    bool obscureText = false,
    void Function()? onClear,
  }) {
    return TextFormField(
      cursorColor: mainRed,
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50), // 👈 글자 수 제한
      ],
      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        focusedErrorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        errorStyle: TextStyle(
            color: mainRed, fontSize: 12, fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: settingGrey)),
        filled: true,
        fillColor: const Color(0xff2C2C2C),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
        hintStyle: TextStyle(
            color: settingGrey,
            fontSize: 15,
            fontWeight: FontWeight.w600),
        suffixIcon: controller.text.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  GestureDetector(
                    onTap: onClear ??
                        () {
                          controller.clear();
                        },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                      child: const Icon(
                        Icons.cancel,
                        size: 17,
                        color: settingGrey,
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
      validator: validator,
    );
  }
}

class ColorOption2 extends StatelessWidget {
  final Color colorCode;
  final bool isSelected;
  final VoidCallback onTap;

  const ColorOption2({
    super.key,
    required this.colorCode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(currentWidth < 600 ? 5 : 10),
        child: Container(
          width: currentWidth < 600 ? 30 : 50,
          height: currentWidth < 600 ? 30 : 50,
          decoration: BoxDecoration(
            color: colorCode,
            borderRadius: BorderRadius.circular(6),
          ),
          child: isSelected
              ? Icon(
                  Icons.check_circle_rounded,
                  color: const Color(0xff303030),
                  size: currentWidth < 600 ? 20 : 22,
                )
              : null,
        ),
      ),
    );
  }
}

class Tag {
  final Color bgColor;
  final String text;

  const Tag(
    this.bgColor,
    this.text,
  );

  Widget tag() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          text,
          style: const TextStyle(
              color: mainRed,
              fontSize: 11,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600),
        ));
  }
}



class NewCustomIconButton {
  final Function function;
  final IconData icon;
  final double currentWidth;
  final double size;

  const NewCustomIconButton(
      this.function, this.icon, this.currentWidth, this.size);

  Widget newCustomIconButton() {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(

        color: Color(0xff303030),
        borderRadius: BorderRadius.circular(25),
      ),
      child: GestureDetector(
        onTap: () {
          function(); 
        },
        child: Icon(
          icon,
          color: const Color(0xff646464),
          size: size,
        ),
      ),
    );
  }
}
