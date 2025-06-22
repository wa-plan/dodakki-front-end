import 'package:domino/screens/DP/Detail/dp_detail2_page.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

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

class MainMandalart extends StatelessWidget {
  final String firstGoalName;
  final List<Map<String, dynamic>> secondGoals;
  final int mandalartId;
  final Color firstGoalColor;
  final double size;
  final bool detail;

  const MainMandalart({
    super.key,
    required this.firstGoalName,
    required this.secondGoals,
    required this.mandalartId,
    required this.firstGoalColor,
    required this.size,
    required this.detail
  });

  static const List<int> centerSecondGoalOrder = [0, 1, 2, 3, 5, 6, 7, 8];

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
      width: size,
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
            return GestureDetector(
              onTap: (){
                detail ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DPdetail3Page(
                      firstGoalName: firstGoalName,
                      firstGoalColor: firstGoalColor,
                      secondGoalIndex: 0,
                      thirdGoal: false,
                      secondGoals: secondGoals,
                    ),
                  ),
                ) : true;
              },
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(9, (innerIndex) {
                  if (innerIndex == 4) {
                    return FreeGrid(firstGoalName, firstGoalColor, 15).freeGrid();
                  } else {
                    final secondIndex = centerSecondGoalOrder[innerIndex > 4 ? innerIndex - 1 : innerIndex];
                    final secondGoal = secondGoals[secondIndex];
                    final secondText = secondGoal['secondGoal'] ?? '';
                    final secondColor = ColorTransform(secondGoal['color']).colorTransform();
                    return FreeGrid(secondText, secondColorDefiner(secondText, secondColor), 15).freeGrid();
                  }
                }),
              ),
            );
          } else {
            // 외곽 그리드
            if (secondGoals.length <= outerIndex) {
              return const SizedBox();
            }

            final secondGoal = secondGoals[outerIndex];
            final secondText = secondGoal['secondGoal'] ?? '';
            final secondColor = ColorTransform(secondGoal['color']).colorTransform();
            final thirdGoals = secondGoal['thirdGoals'] as List<dynamic>? ?? [];

            return GestureDetector(
              onTap: (){
                detail ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DPdetail3Page(
                      firstGoalName: firstGoalName,
                      firstGoalColor: firstGoalColor,
                      secondGoalIndex: outerIndex,
                      thirdGoal: true,
                      secondGoals: secondGoals,
                    ),
                  ),
                ) : true;
              },
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                mainAxisSpacing: 1,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(9, (index) {
                  if (index == 4) {
                    return FreeGrid(
                      secondText,
                      secondColorDefiner(secondText, secondColor),
                      15,
                    ).freeGrid();
                  } else {
                    final adjustedIndex = index > 4 ? index - 1 : index;
                    final thirdText = thirdGoals.length > adjustedIndex
                        ? thirdGoals[adjustedIndex]['thirdGoal'] ?? ''
                        : '';
                    final thirdColor = thirdColorDefiner(thirdText, secondColor, secondText);
                    return FreeGrid(thirdText, thirdColor, 15).freeGrid();
                  }
                }),
              ),
            );
          }
        },
      ),
    );
  }
}
