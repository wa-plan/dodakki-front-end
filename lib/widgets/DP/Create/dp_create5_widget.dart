import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class Colorbox extends StatelessWidget {
  final int actionPlanid;
  final int detailGoalid;
  final int goalColorid;

  const Colorbox({
    super.key,
    required this.actionPlanid,
    required this.goalColorid,
    required this.detailGoalid,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 100,
        child: GridView.count(
            crossAxisCount: 3,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
            children: List.generate(9, (index) {
              final inputtedActionPlan = context
                  .watch<SaveInputtedActionPlanModel>()
                  .inputtedActionPlan[actionPlanid];
              final values = inputtedActionPlan.containsKey(index.toString())
                  ? inputtedActionPlan[index.toString()]
                  : '';
              final detailGoal = context
                  .watch<SaveInputtedDetailGoalModel>()
                  .inputtedDetailGoal['$detailGoalid'];
              final color1 =
                  context.watch<GoalColor>().selectedGoalColor['$goalColorid'];
              final backgroundColor1 =
                  (detailGoal == null || detailGoal.isEmpty)
                      ? const Color(0xff262626)
                      : color1;

              if (index == 4) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: backgroundColor1,
                  ),
                  margin: const EdgeInsets.all(1.0),
                  child: Center(
                      child: Text(
                    detailGoal ?? '',
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    textAlign: TextAlign.center,
                  )),
                );
              } else {
                final isValueEmpty = values == null || values.isEmpty;
                final backgroundColor2 = isValueEmpty
                    ? const Color(0xff262626)
                    : colorPalette[color1] ?? backgroundColor;

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: backgroundColor2,
                  ),
                  margin: const EdgeInsets.all(1.0),
                  child: Center(
                      child: Text(
                    values.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    textAlign: TextAlign.center,
                  )),
                );
              }
            })));
  }
}
