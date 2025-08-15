//주변 9개 그리드 (입력X 고정O)
import 'package:domino/provider/DP/model.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

 Map<Color, Color> colorPalette = {
  Color(0xffFF7A7A): Color(0xffFFC2C2),
  Color(0xffFFB82D): Color(0xffFFD19B),
  Color(0xffFCFF62): Color(0xffFEFFCD),
  Color(0xff72FF5B): Color(0xffC1FFB7),
  Color(0xff5DD8FF): Color(0xff94E5FF),
  Color(0xff919191): Color(0xff505050),
  Color(0xffFF5794): Color(0xffFF8EB7),
  Color(0xffAE7CFF): Color(0xffD0B4FF),
  Color(0xffC77B7F): Color(0xffEBB6B9),
  Color(0xff009255): Color(0xff6DE1B0),
  Color(0xff3184FF): Color(0xff8CBAFF),
  Color(0xff11D1C2): Color(0xffAAF4EF),
};

class Around9Grid extends StatelessWidget {
  final int secondGoalIndex;
  final bool needColor;
  final double currentWidth;

  const Around9Grid({
    super.key,
    required this.secondGoalIndex,
    required this.needColor,
    required this.currentWidth
  });

  Color secondColorDefiner(String secondText, Color secondColor) {
    if (!needColor) return secondGoalColor;
    if (secondText.isEmpty) return Colors.transparent;
    return secondColor;
  }

  Color thirdColorDefiner(String thirdText, Color secondColor) {
    if (!needColor) return thirdGoalColor;
    if (thirdText.isEmpty) return Colors.transparent;
    return colorPalette[secondColor] ?? thirdGoalColor;
  }

  @override
  Widget build(BuildContext context) {
    final secondText = context.select<SaveSecondGoalModel, String>(
        (model) => model.secondGoal[secondGoalIndex.toString()] ?? '');
    final secondColor = context.select<SaveGoalColor, Color>(
        (model) => model.selectedGoalColor[secondGoalIndex.toString()] ?? Colors.transparent);

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 1,
      mainAxisSpacing: 1,
      shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
      children: List.generate(9, (index) {
        if (index == 4) {
          //제2목표 그리드
          return FreeGrid(
            secondText,
            secondColorDefiner(secondText, secondColor),
            15, currentWidth
          ).freeGrid();
        } else {
          //제3목표 그리드
          final thirdText = context.select<SaveThirdGoalModel, String>((model) {
            return model.thirdGoal[secondGoalIndex][index.toString()] ?? '';
          });

          return FreeGrid(
            thirdText,
            thirdColorDefiner(thirdText, secondColor),
            15, currentWidth
          ).freeGrid();
        }
      }),
    );
  }
}
