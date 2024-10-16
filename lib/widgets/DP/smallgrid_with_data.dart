import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/DP/create_input2_page.dart';

class SmallgridWithData extends StatelessWidget {
  final int goalId;

  const SmallgridWithData({super.key, required this.goalId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<SelectDetailGoal>().selectDetailGoal('$goalId');
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DPcreateInput2Page(),
            ));
      },
      child: SizedBox(
        width: 100,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(9, (index) {
            final inputtedActionPlan = context
                .watch<SaveInputtedActionPlanModel>()
                .inputtedActionPlan[goalId];
            final values = inputtedActionPlan.containsKey(index.toString())
                ? inputtedActionPlan[index.toString()]
                : '';

            if (index == 4) {
              return Container(
                color: const Color(0xff929292),
                margin: const EdgeInsets.all(1.0),
                child: Text(
                  context
                          .watch<SaveInputtedDetailGoalModel>()
                          .inputtedDetailGoal['$goalId'] ??
                      '',
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Container(
                color: const Color(0xff5C5C5C),
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
      ),
    );
  }
}
