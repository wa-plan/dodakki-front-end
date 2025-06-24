import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Create/Around9Grid.dart';
import 'package:flutter/material.dart';

class DPdetail3Page extends StatelessWidget {
  final String firstGoalName;
  final Color firstGoalColor;
  final int secondGoalIndex;
  final bool thirdGoal;
  final List<Map<String, dynamic>> secondGoals;

  const DPdetail3Page(
      {super.key,
      required this.firstGoalName,
      required this.firstGoalColor,
      required this.secondGoals,
      required this.secondGoalIndex,
      required this.thirdGoal});
  static const List<int> centerSecondGoalOrder = [0, 1, 2, 3, 5, 6, 7, 8];

  Color secondColorDefiner(String secondText, Color secondColor) {
    if (secondText.isEmpty) return Colors.transparent;
    return secondColor;
  }

  Color thirdColorDefiner(
      String thirdText, Color secondColor, String secondText) {
    if (secondText.isEmpty || thirdText.isEmpty) return Colors.transparent;
    return colorPalette[secondColor] ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Padding(
            padding: appBarPadding,
            child: CustomBackButton(() {
              Navigator.of(context).pop();
            }).customBackButton(),
          ),
          backgroundColor: backgroundColor),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
           
           
            SizedBox(
              height: 40,
            ),
            Center(
              child: SizedBox(
                  width: 300,
                  child: thirdGoal == false
                      ?
                      //중앙 그리드일 경우,
                      GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(9, (innerIndex) {
                            if (innerIndex == 4) {
                              return FreeGrid(firstGoalName, firstGoalColor, 15)
                                  .freeGrid();
                            } else {
                              final secondIndex = centerSecondGoalOrder[
                                  innerIndex > 4 ? innerIndex - 1 : innerIndex];
                              final secondGoal = secondGoals[secondIndex];
                              final secondText = secondGoal['secondGoal'] ?? '';
                              final secondColor =
                                  ColorTransform(secondGoal['color'])
                                      .colorTransform();
                              return FreeGrid(
                                      secondText,
                                      secondColorDefiner(
                                          secondText, secondColor),
                                      15)
                                  .freeGrid();
                            }
                          }),
                        )

                      //외곽 그리드일 경우,
                      : GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(9, (index) {
                            final secondGoal = secondGoals[secondGoalIndex];
                            final secondText = secondGoal['secondGoal'] ?? '';
                            final secondColor =
                                ColorTransform(secondGoal['color'])
                                    .colorTransform();
                            final thirdGoals =
                                secondGoal['thirdGoals'] as List<dynamic>? ??
                                    [];
                            if (index == 4) {
                              if (secondGoals.length <= index) {
                                return const SizedBox();
                              }

                              return FreeGrid(
                                secondText,
                                secondColorDefiner(secondText, secondColor),
                                15,
                              ).freeGrid();
                            } else {
                              final adjustedIndex =
                                  index > 4 ? index - 1 : index;
                              final thirdText = thirdGoals.length >
                                      adjustedIndex
                                  ? thirdGoals[adjustedIndex]['thirdGoal'] ?? ''
                                  : '';
                              final thirdColor = thirdColorDefiner(
                                  thirdText, secondColor, secondText);
                              return FreeGrid(thirdText, thirdColor, 15)
                                  .freeGrid();
                            }
                          }),
                        )),
            ),
          ],
        ),
      ),
    );
  }
}
