import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

//color
const backgroundColor = Color(0xff262626);
const mainRed = Color(0xffFF7A7A);
const mainTextColor = Colors.white;
const mainGold = Color.fromARGB(255, 255, 217, 79);

//padding
const appBarPadding = EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 20);
const fullPadding = EdgeInsets.fromLTRB(20.0, 10, 20.0, 20.0);

//colorPalette
Map<Color, Color> colorPalette = {
  const Color(0xffFF7A7A): const Color(0xffFFC2C2),
  const Color(0xffFFB82D): const Color(0xffFFD19B),
  const Color(0xffFCFF62): const Color(0xffFEFFCD),
  const Color(0xff72FF5B): const Color(0xffC1FFB7),
  const Color(0xff5DD8FF): const Color(0xff94E5FF),
  const Color(0xff929292): const Color(0xff5C5C5C),
  const Color(0xffFF5794): const Color(0xffFF8EB7),
  const Color(0xffAE7CFF): const Color(0xffD0B4FF),
  const Color(0xffC77B7F): const Color(0xffEBB6B9),
  const Color(0xff009255): const Color(0xff6DE1B0),
  const Color(0xff3184FF): const Color(0xff8CBAFF),
  const Color(0xff11D1C2): const Color(0xffAAF4EF),
  Colors.transparent: const Color(0xff5C5C5C),
};

//DP_create_titleText
class DPTitleText {
  final String text;
  final double currentWidth;

  DPTitleText(this.text, this.currentWidth);

  Widget dPTitleText() {
    return Text(text,
        style: TextStyle(
            color: Colors.white,
            fontSize: currentWidth < 600 ? 18 : 23,
            fontWeight: FontWeight.w600));
  }
}

//DP_create_guideText
class DPGuideText {
  final String text;
  final double currentWidth;

  DPGuideText(this.text, this.currentWidth);

  Widget dPGuideText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: currentWidth < 600 ? 15 : 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

//Button
class Button {
  final Color buttonColor;
  final Color textColor;
  final String text;
  final Function function;

  Button(this.buttonColor, this.textColor, this.text, this.function);

  Widget button() {
    return TextButton(
      onPressed: () => function(),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

//NewButton
class NewButton {
  final Color buttonColor;
  final Color textColor;
  final String text;
  final Function function;
  final double currentWidth;

  NewButton(this.buttonColor, this.textColor, this.text, this.function,
      this.currentWidth);

  Widget newButton() {
    return TextButton(
      onPressed: () => function(),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: currentWidth < 600 ? 13 : 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

//MG Sub Title
class MGSubTitle {
  final String text;
  final double currentWidth;

  MGSubTitle(this.text, this.currentWidth);

  Widget mgSubTitle(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: const Color.fromARGB(255, 178, 178, 178),
        fontSize: currentWidth < 600 ? 14 : 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

//Fluttertoast
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
    this.borderColor = Colors.transparent, // 기본 테두리 색상
    this.icon,
  });

  Future<bool?> message(BuildContext context) {
    FToast fToast = FToast();
    fToast.init(context);

    Completer<bool?> completer = Completer<bool?>();

    // 커스텀 토스트 위젯
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: borderColor, width: 0.8), // 테두리 색상
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
                  color: textColor, fontSize: 14, fontWeight: FontWeight.w400),
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

//DPMainGoal
class DPMainGoal {
  final String text;
  final Color color;
  final double currentHeight;
  final double currentWidth;

  DPMainGoal(this.text, this.color, this.currentHeight, this.currentWidth);

  Widget dpMainGoal() {
    return Container(
        height: currentHeight * 0.05,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(3),
          color: color,
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
            textAlign: TextAlign.center,
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: currentWidth < 600 ? 11 : 15,
              fontWeight: FontWeight.bold,
            )));
  }
}

//ThirdGoalInput
class DPInput3 {
  final Color? color;
  final Function(String value) onChangedFunction;
  final String initialValue;

  DPInput3(this.color, this.onChangedFunction, this.initialValue);

  Widget dpInput3() {
    return Container(
      width: 80,
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(5),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(4), color: color),
      child: Center(
        child: TextFormField(
          initialValue: initialValue,
          onChanged: onChangedFunction,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.newline,
          maxLength: 15,
          maxLines: null,
          inputFormatters: [
            LengthLimitingTextInputFormatter(15), // 최대 15글자로 제한
          ],
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          decoration: const InputDecoration(
              border: InputBorder.none,
              counterStyle: TextStyle(
                  height: 0.01,
                  fontSize: 10,
                  color: Color.fromARGB(255, 120, 120, 120))),
        ),
      ),
    );
  }
}

//SecondGoalInput
class DPInput2 {
  final Color? color;
  final TextEditingController controller;
  final Function(String value) onChangedFunction;

  DPInput2(this.color, this.controller, this.onChangedFunction);

  Widget dpInput2() {
    return Container(
      width: 80,
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color,
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          onChanged: onChangedFunction,
          style: const TextStyle(
              color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
          maxLength: 15,
          maxLines: null,
          inputFormatters: [
            LengthLimitingTextInputFormatter(15), // 최대 15글자로 제한
          ],
          decoration: const InputDecoration(
              border: InputBorder.none,
              counterStyle: TextStyle(
                  height: 0.01,
                  fontSize: 10,
                  color: Color.fromARGB(255, 104, 104, 104))),
        ),
      ),
    );
  }
}

//SecondGoalGrid
class DPGrid2 {
  final int hintNum;
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final Border? border;
  final double maxFontSize;

  const DPGrid2(this.hintNum, this.mandalart, this.secondGoals,
      this.maxFontSize, this.border);

  Widget dpGrid2() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color:
            secondGoals.isNotEmpty && secondGoals[hintNum]['secondGoal'] != ""
                ? NewColorTransform(secondGoals[hintNum]['color'])
                    .newcolorTransform()
                : Colors.transparent,
        border: border,
      ),
      margin: const EdgeInsets.all(1.0),
      child: Center(
        child: AutoSizeText(
          secondGoals.isNotEmpty && secondGoals[hintNum]['secondGoal'] != ""
              ? secondGoals[hintNum]['secondGoal']
              : "",
          maxLines: 3,
          minFontSize: 6,
          maxFontSize: maxFontSize,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//TDGrid2
class TDGrid2 {
  final int hintNum;
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final Border? border;
  final double maxFontSize;

  const TDGrid2(this.hintNum, this.mandalart, this.secondGoals,
      this.maxFontSize, this.border);

  Widget tdGrid2() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color:
            secondGoals.isNotEmpty && secondGoals[hintNum]['secondGoal'] != ""
                ? ColorTransform(secondGoals[hintNum]['color']).colorTransform()
                : Colors.transparent,
        border: border,
      ),
      margin: const EdgeInsets.all(1.0),
      child: Center(
        child: AutoSizeText(
          secondGoals.isNotEmpty && secondGoals[hintNum]['secondGoal'] != ""
              ? secondGoals[hintNum]['secondGoal']
              : "",
          maxLines: 3,
          minFontSize: 6,
          maxFontSize: maxFontSize,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//Grid for Creating
class DPCreateGrid {
  final String text;
  final Color? color;
  final Border? border;

  const DPCreateGrid(this.text, this.color, this.border);

  Widget dPCreateGrid() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color,
        border: border,
      ),
      margin: const EdgeInsets.all(1.0),
      child: Center(
        child: AutoSizeText(
          maxLines: 3,
          minFontSize: 6,
          maxFontSize: 10,
          overflow: TextOverflow.ellipsis,
          text,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//ThirdGoalGrid
class DPGrid3 {
  final int hintNum2;
  final int hintNum3;
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final Border? border;
  final double maxFontSize;

  const DPGrid3(this.hintNum2, this.hintNum3, this.mandalart, this.secondGoals,
      this.maxFontSize, this.border);

  Widget dpGrid3() {
    final color = secondGoals.isNotEmpty &&
            secondGoals[hintNum2]['thirdGoals'].asMap().containsKey(hintNum3)
        ? Color(int.parse(secondGoals[hintNum2]['color']
            .replaceAll('Color(', '')
            .replaceAll(')', '')))
        : Colors.transparent;

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: secondGoals.isNotEmpty &&
                secondGoals[hintNum2]['thirdGoals'].isNotEmpty &&
                secondGoals[hintNum2]['thirdGoals']
                    .asMap()
                    .containsKey(hintNum3) &&
                secondGoals[hintNum2]['thirdGoals'][hintNum3]['thirdGoal'] == ""
            ? Colors.transparent
            : colorPalette[color],
        border: border,
      ),
      margin: const EdgeInsets.all(1.0),
      child: Center(
        child: AutoSizeText(
          secondGoals.isNotEmpty &&
                  secondGoals[hintNum2]['thirdGoals'].isNotEmpty &&
                  secondGoals[hintNum2]['thirdGoals']
                      .asMap()
                      .containsKey(hintNum3)
              ? secondGoals[hintNum2]['thirdGoals'][hintNum3]['thirdGoal']
              : "",
          maxLines: 3,
          minFontSize: 6,
          maxFontSize: maxFontSize,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

//ThirdGoalGrid for TD
class TDGrid3 {
  final int hintNum2;
  final int hintNum3;
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final bool isSelected;
  final VoidCallback onSelect;
  final BuildContext context; // Pass context explicitly

  const TDGrid3(
    this.hintNum2,
    this.hintNum3,
    this.mandalart,
    this.secondGoals,
    this.isSelected,
    this.onSelect,
    this.context, // Add context as a parameter
  );

  Widget tdGrid3() {
    // Determine the cell color
    final color = secondGoals.isNotEmpty &&
            secondGoals[hintNum2]['thirdGoals'].asMap().containsKey(hintNum3)
        ? Color(int.parse(secondGoals[hintNum2]['color']
            .replaceAll('Color(', '')
            .replaceAll(')', '')))
        : Colors.transparent;

    // Define the GestureDetector widget
    return GestureDetector(
      onTap: () {
        onSelect();
        if (secondGoals.isNotEmpty &&
            secondGoals[hintNum2]['thirdGoals'].isNotEmpty &&
            secondGoals[hintNum2]['thirdGoals'].asMap().containsKey(hintNum3)) {
          final thirdGoal =
              secondGoals[hintNum2]['thirdGoals'][hintNum3]['thirdGoal'] ?? "";
          final id = secondGoals[hintNum2]['thirdGoals'][hintNum3]['id'];
          context
              .read<SelectAPModel>()
              .selectAP(thirdGoal.isEmpty ? "플랜선택없음" : thirdGoal, id);
        } else {
          context.read<SelectAPModel>().selectAP("플랜선택없음", null);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: secondGoals.isNotEmpty &&
                  secondGoals[hintNum2]['thirdGoals'].isNotEmpty &&
                  secondGoals[hintNum2]['thirdGoals']
                      .asMap()
                      .containsKey(hintNum3) &&
                  secondGoals[hintNum2]['thirdGoals'][hintNum3]['thirdGoal'] ==
                      ""
              ? Colors.transparent
              : colorPalette[color],
          border: isSelected &&
                  secondGoals.isNotEmpty &&
                  secondGoals[hintNum2]['thirdGoals'].isNotEmpty &&
                  secondGoals[hintNum2]['thirdGoals']
                      .asMap()
                      .containsKey(hintNum3) &&
                  secondGoals[hintNum2]['thirdGoals'][hintNum3]['thirdGoal'] !=
                      ""
              ? Border.all(color: Colors.white, width: 5)
              : null,
        ),
        margin: const EdgeInsets.all(1.0),
        child: Center(
          child: AutoSizeText(
            secondGoals.isNotEmpty &&
                    secondGoals[hintNum2]['thirdGoals'].isNotEmpty &&
                    secondGoals[hintNum2]['thirdGoals']
                        .asMap()
                        .containsKey(hintNum3)
                ? secondGoals[hintNum2]['thirdGoals'][hintNum3]['thirdGoal']
                : "",
            maxLines: 3,
            minFontSize: 6,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

//FirstGoalGrid
class DPGrid1 {
  final String text;
  final Color color;
  final double maxFontSize;

  const DPGrid1(this.text, this.color, this.maxFontSize);

  Widget dpGrid1() {
    return Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(1.0),
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(3), color: color),
        child: Center(
          child: AutoSizeText(
              maxLines: 3, // 최대 줄 수 (필요에 따라 변경 가능)
              minFontSize: 6,
              maxFontSize: maxFontSize, // 최소 글씨 크기
              overflow: TextOverflow.ellipsis, // 내용이 너무 길 경우 생략 표시
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: backgroundColor,
                fontWeight: FontWeight.w600,
              )),
        ));
  }
}

//ColorTransformer(String>Color)
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

class NewColorTransform {
  final String color;

  const NewColorTransform(this.color);

  Color newcolorTransform() {
    Color newColor =
        Color(int.parse(color.replaceAll('Color(', '').replaceAll(')', '')));
    return newColor;
  }
}

//TextFormField
class CustomTextField {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String?> validator;
  final bool obscureText;
  final int maxLines;

  const CustomTextField(this.hintText, this.controller, this.validator,
      this.obscureText, this.maxLines);

  Widget textField({
    bool obscureText = false,
    void Function()? onClear,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xff2A2A2A),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
        hintStyle: const TextStyle(
            color: Color(0xffAAAAAA),
            fontSize: 12,
            fontWeight: FontWeight.w400),
        suffixIcon: controller.text.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start, // 아이콘 상단 정렬
                children: [
                  GestureDetector(
                    onTap: onClear ??
                        () {
                          controller.clear();
                        },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 13, 10, 10),
                      child: const Icon(
                        Icons.cancel,
                        size: 14,
                        color: Color.fromARGB(255, 98, 98, 98),
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

//NewTextFormField
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
      cursorColor: Color(0xffAAAAAA),
      controller: controller,
      obscureText: obscureText,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        focusedErrorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        errorStyle: TextStyle(
            color: mainRed, fontSize: 12, fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffAAAAAA))),
        isDense: true,
        filled: true,
        fillColor: const Color(0xff2A2A2A),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(15, 12, 15, 12),
        hintStyle: TextStyle(
            color: Color(0xffAAAAAA),
            fontSize: currentWidth < 600 ? 13 : 14,
            fontWeight: FontWeight.w400),
        suffixIcon: controller.text.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start, // 아이콘 상단 정렬
                children: [
                  GestureDetector(
                    onTap: onClear ??
                        () {
                          controller.clear();
                        },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: const Icon(
                        Icons.cancel,
                        size: 16,
                        color: Color.fromARGB(255, 98, 98, 98),
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

class Question extends StatelessWidget {
  final String question;

  const Question({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Text(question,
        style: const TextStyle(
            fontFamily: "Pretendard",
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14));
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
              ? const Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 24,
                )
              : null,
        ),
      ),
    );
  }
}

class Tag {
  final Color bgColor;
  final Color borderColor;
  final String text;

  const Tag(
    this.bgColor,
    this.borderColor,
    this.text,
  );

  Widget tag() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
        decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: borderColor)),
        child: Text(
          text,
          style: const TextStyle(
              color: Color(0xffFF7E7E),
              fontSize: 9,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600),
        ));
  }
}

//Grid for Editing
class DPGrid3_E {
  final String text;
  final Color? color;
  final double maxFontSize;

  const DPGrid3_E(this.text, this.color, this.maxFontSize);

  Widget dpGrid3_E() {
    return Container(
      padding: const EdgeInsets.all(3),
      margin: const EdgeInsets.all(1.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: color,
      ),
      child: Center(
        child: AutoSizeText(
            maxLines: 3, // 최대 줄 수 (필요에 따라 변경 가능)
            minFontSize: 6,
            maxFontSize: maxFontSize, // 최소 글씨 크기
            overflow: TextOverflow.ellipsis, // 내용이 너무 길 경우 생략 표시
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: backgroundColor,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}

//Grid for Editing
class PageIndicator {
  final List<Map<String, dynamic>> goals;
  final PageController controller;

  const PageIndicator(this.controller, this.goals);

  Widget pageIndicator() {
    return SmoothPageIndicator(
      controller: controller,
      count: goals.length,
      effect: const SlideEffect(
        dotHeight: 8.0,
        radius: 2.0,
        dotWidth: 8.0,
        activeDotColor: Colors.white,
        dotColor: Color(0xff3C3C3C),
      ),
    );
  }
}

//icon button
class CustomIconButton {
  final Function function;
  final IconData icon;
  final double currentWidth;

  const CustomIconButton(this.function, this.icon, this.currentWidth);

  Widget customIconButton() {
    return Container(
      width: currentWidth < 600 ? 33 : 50,
      height: currentWidth < 600 ? 22 : 35,
      decoration: BoxDecoration(
        color: const Color(0xff303030),
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
      child: GestureDetector(
        onTap: () {
          function(); // 함수 호출
        },
        child: Icon(
          icon,
          color: const Color(0xff646464),
          size: currentWidth < 600 ? 18 : 25,
        ),
      ),
    );
  }
}

//icon button
class NewCustomIconButton {
  final Function function;
  final IconData icon;
  final double currentWidth;
  final double size;

  const NewCustomIconButton(
      this.function, this.icon, this.currentWidth, this.size);

  Widget newCustomIconButton() {
    return Container(
      width: currentWidth < 600 ? 35 : 50,
      height: currentWidth < 600 ? 24 : 35,
      decoration: BoxDecoration(
        color: Color(0xff303030),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02), // 검은색 10% 투명도
            offset: const Offset(0, 0), // X, Y 위치 (0,0)
            blurRadius: 15, // 블러 7
            spreadRadius: 0, // 스프레드 0
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
          size: currentWidth < 600 ? size : size + 7,
        ),
      ),
    );
  }
}
