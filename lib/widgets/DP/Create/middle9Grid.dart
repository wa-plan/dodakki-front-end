//가운데 9개 그리드 (입력X 고정O)
import 'package:domino/provider/DP/model.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Middle9Grid extends StatelessWidget {
  final Color firstColor;
  final String firstGoalName;
  final bool needColor;

  const Middle9Grid(
      {super.key, required this.firstColor, required this.needColor, required this.firstGoalName});


  Color secondColorDefiner(BuildContext context, int index) {
  final String secondText = context.select<SaveSecondGoalModel, String>(
    (model) => model.secondGoal[index.toString()] ?? '',
  );
   final Color secondColor = context.select<SaveGoalColor, Color>((model) =>
        model.selectedGoalColor[index.toString()] ??
        Colors.transparent);

  if (needColor == false) {
    return secondGoalColor;
  } else if (secondText == "") {
    return Colors.transparent; 
  } else {
    return secondColor;
  }
}


  @override
  Widget build(BuildContext context) {

    return GridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 1,
      mainAxisSpacing: 1,
      shrinkWrap: true,
  physics: NeverScrollableScrollPhysics(),
      children: List.generate(9, (index) {
        if (index == 4) {
          //첫 번째 목표 그리드
          return FreeGrid(firstGoalName, firstColor, 15).freeGrid();
        } else {
          //두 번째 목표 그리드
          return FreeGrid(
                  context.select<SaveSecondGoalModel, String>(
                      (model) => model.secondGoal[index.toString()] ?? ''),
                  secondColorDefiner(context, index),
                  15)
              .freeGrid();
        }
      }),
    );
  }
}
