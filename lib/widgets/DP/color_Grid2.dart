import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class ColorBox2 extends StatelessWidget {
  final int keyNumber;

  const ColorBox2({super.key, required this.keyNumber});
  

  @override
  Widget build(BuildContext context) {

    Color fallbackColor = const Color(0xff929292); // 기본 색상

    final selectedColor =
    context.watch<GoalColor>().selectedGoalColor['$keyNumber'];

    Color color1 = context
                    .watch<SaveInputtedDetailGoalModel>()
                    .inputtedDetailGoal['$keyNumber']!
                    .isEmpty
    ? backgroundColor
    : (selectedColor == null || selectedColor == Colors.transparent
        ? fallbackColor
        : selectedColor);
    
    return DPCreateGrid(
            context
                .watch<SaveInputtedDetailGoalModel>()
                .inputtedDetailGoal['$keyNumber']!,
            color1,
                null)
        .dPCreateGrid();
  }
}
