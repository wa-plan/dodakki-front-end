import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class ColorBox extends StatelessWidget {
  final int actionPlanId;
  final int detailGoalId;
  final int goalColorId;
  final Function(bool isEmpty) onDetailGoalEmpty; // 추가된 콜백

  const ColorBox({
    super.key,
    required this.actionPlanId,
    required this.goalColorId,
    required this.detailGoalId,
    required this.onDetailGoalEmpty, // 콜백 받기
  });

  @override
  Widget build(BuildContext context) {
    final inputtedActionPlan = context
        .watch<SaveInputtedActionPlanModel>()
        .inputtedActionPlan[actionPlanId];

    final detailGoal = context
            .watch<SaveInputtedDetailGoalModel>()
            .inputtedDetailGoal['$detailGoalId'] ??
        '';

    // ✅ detailGoal이 ""인지 확인 (디버깅용 print 추가)
    bool isDetailGoalEmpty = detailGoal.isEmpty;

    print('$detailGoal + $isDetailGoalEmpty');

    // ✅ 부모 위젯으로 값 전달
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onDetailGoalEmpty(isDetailGoalEmpty);
    });

    final selectedColor =
        context.watch<GoalColor>().selectedGoalColor['$goalColorId'];

    Color fallbackColor = const Color(0xff929292); // 기본 색상

    Color color1 = detailGoal.isEmpty
        ? backgroundColor
        : (selectedColor == null || selectedColor == Colors.transparent
            ? fallbackColor
            : selectedColor);

    List<Widget> buildGridItems() {
      return List.generate(9, (index) {
        if (index == 4) {
          return DPCreateGrid(detailGoal, color1, null).dPCreateGrid();
        }

        return DPCreateGrid(
                inputtedActionPlan['$index'] ?? '',
                inputtedActionPlan['$index']?.isEmpty == true
                    ? backgroundColor
                    : colorPalette[color1] ?? Colors.transparent,
                null)
            .dPCreateGrid();
      });
    }

    return SizedBox(
      width: 100,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        children: buildGridItems(),
      ),
    );
  }
}
