import 'package:domino/provider/DP/model.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Map<Color, Color> colorPalette = {
  Color(0xffFF7A7A): Color(0xffFFC2C2),
  Color(0xffFFB82D): Color(0xffFFD19B),
  Color(0xffFCFF62): Color(0xffFEFFCD),
  Color(0xff72FF5B): Color(0xffC1FFB7),
  Color(0xff5DD8FF): Color(0xff94E5FF),
  Color(0xff929292): Color(0xff5C5C5C),
  Color(0xffFF5794): Color(0xffFF8EB7),
  Color(0xffAE7CFF): Color(0xffD0B4FF),
  Color(0xffC77B7F): Color(0xffEBB6B9),
  Color(0xff009255): Color(0xff6DE1B0),
  Color(0xff3184FF): Color(0xff8CBAFF),
  Color(0xff11D1C2): Color(0xffAAF4EF),
};

class TDMandalart extends StatefulWidget {
  final String firstGoalName;
  final List<Map<String, dynamic>> secondGoals;
  final Color firstGoalColor;

  const TDMandalart({
    super.key,
    required this.firstGoalName,
    required this.secondGoals,
    required this.firstGoalColor,
  });

  @override
  TDMandalartState createState() => TDMandalartState();
}

class TDMandalartState extends State<TDMandalart> {
  static const List<int> centerSecondGoalOrder = [0, 1, 2, 3, 5, 6, 7, 8];
  int selected = 0;

  Color secondColorDefiner(String secondText, Color secondColor) {
    if (secondText.isEmpty) return Colors.transparent;
    return secondColor;
  }

  Color thirdColorDefiner(String thirdText, Color secondColor, String secondText) {
    if (secondText.isEmpty || thirdText.isEmpty) return Colors.transparent;
    return colorPalette[secondColor] ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 9,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, outerIndex) {
          if (outerIndex == 4) {
            // 중앙 그리드
            return GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(9, (innerIndex) {
                if (innerIndex == 4) {
                  return FreeGrid(widget.firstGoalName, widget.firstGoalColor, 15).freeGrid();
                } else {
                  final safeIndex = innerIndex > 4 ? innerIndex - 1 : innerIndex;

                  if (safeIndex >= centerSecondGoalOrder.length) return const SizedBox();
                  final secondIndex = centerSecondGoalOrder[safeIndex];
                  if (secondIndex >= widget.secondGoals.length) return const SizedBox();

                  final secondGoal = widget.secondGoals[secondIndex];
                  final secondText = secondGoal['secondGoal'] ?? '';
                  final secondColor = ColorTransform(secondGoal['color']).colorTransform();

                  return FreeGrid(
                    secondText,
                    secondColorDefiner(secondText, secondColor.withOpacity(0.3)),
                    15,
                  ).freeGrid();
                }
              }),
            );
          } else {
            if (widget.secondGoals.length <= outerIndex) {
              return const SizedBox();
            }

            final secondGoal = widget.secondGoals[outerIndex];
            final secondText = secondGoal['secondGoal'] ?? '';
            final secondColor = ColorTransform(secondGoal['color']).colorTransform();
            final thirdGoals = secondGoal['thirdGoals'] as List<dynamic>? ?? [];

            return GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(9, (index) {
                if (index == 4) {
                  return FreeGrid(
                    secondText,
                    secondColorDefiner(secondText, secondColor.withOpacity(0.3)),
                    15,
                  ).freeGrid();
                } else {
                  final adjustedIndex = index > 4 ? index - 1 : index;
                  final thirdText = thirdGoals.length > adjustedIndex ? thirdGoals[adjustedIndex]['thirdGoal'] ?? '' : '';
                  final thirdId = thirdGoals.length > adjustedIndex ? thirdGoals[adjustedIndex]['id'] ?? '' : '';
                  final thirdColor = thirdColorDefiner(thirdText, secondColor, secondText);

                  return GestureDetector(
                    onTap: () {
                      context.read<SelectAPModel>().selectAP(thirdText, thirdId);
                      setState(() {
                        selected = thirdId;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected == thirdId  && thirdText != "" ? Colors.white : Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: FreeGrid(thirdText, thirdColor, 15).freeGrid(),
                    ),
                  );
                }
              }),
            );
          }
        },
      ),
    );
  }
}
