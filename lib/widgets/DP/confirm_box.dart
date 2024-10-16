import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class ConfirmBox extends StatelessWidget {
  final int actionPlanid;
  final int detailGoalid;

  const ConfirmBox({
    super.key, // key 파라미터를 추가해야 함
    required this.actionPlanid,
    required this.detailGoalid,
  }); // super 호출 부분에서 key 파라미터를 올바르게 사용해야 함

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: GridView.count(
        crossAxisCount: 3,
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
          final backgroundColor1 = detailGoal.isEmpty
              ? const Color(0xff262626)
              : const Color(0xff929292);

          if (index == 4) {
            return Container(
              color: backgroundColor1,
              margin: const EdgeInsets.all(1.0),
              child: Text(
                detailGoal,
                style: const TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            final isValueEmpty = values.isEmpty;
            final backgroundColor2 = isValueEmpty
                ? const Color(0xff262626)
                : const Color(0xff5C5C5C);

            return Container(
              color: backgroundColor2,
              margin: const EdgeInsets.all(1.0),
              child: Text(
                values.toString(),
                style: const TextStyle(color: Colors.black, fontSize: 15),
                textAlign: TextAlign.center,
              ),
            );
          }
        }),
      ),
    );
  }
}
