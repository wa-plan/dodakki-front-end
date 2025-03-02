import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/DP/Create/dp_create4_page.dart';

class Smallgridwithdata extends StatelessWidget {
  final int goalId;
  final String firstColor;

  const Smallgridwithdata({
    super.key,
    required this.goalId,
    required this.firstColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
  final isDetailAllEmpty =
      context.read<SaveInputtedDetailGoalModel>().isAllEmpty();
  final emptyKeys = context.read<SaveInputtedDetailGoalModel>().getEmptyKeys();

  if (isDetailAllEmpty) {
    // 모든 값이 ''이면 메시지 표시
    Message('중간의 세부목표를 먼저 입력해 주세요.', const Color(0xffFF6767),
                            const Color(0xff412C2C),
                            borderColor: const Color(0xffFF6767),
                            icon: Icons.priority_high).message(context);
  } else {
    // 비어있는 키가 goalId와 1을 뺀 값이 일치하는지 확인
    final emptyKeyMinusOne = emptyKeys
        .map((key) => int.parse(key)).toList();
    for(int i=0; i < emptyKeyMinusOne.length; i++){
    }
    
    if (emptyKeyMinusOne.contains(goalId)) {
      
      // goalId와 비어있는 key + 1이 일치하면 네비게이션 하지 않음
      Message('중간의 세부목표를 먼저 입력해 주세요.', const Color(0xffFF6767),
                            const Color(0xff412C2C),
                            borderColor: const Color(0xffFF6767),
                            icon: Icons.priority_high).message(context);
    } else {
      for(int i=0; i < emptyKeyMinusOne.length; i++){
    }
      // 조건을 만족하면 SelectDetailGoal 동작 후 페이지 이동
      context.read<SelectDetailGoal>().selectDetailGoal('$goalId');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DPcreateInput2Page(
            mainGoalId: goalId.toString(),
            firstColor: firstColor,
          ),
        ),
      );
    }
  }
},

      child: SizedBox(
        width: 100,
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
          children: List.generate(9, (index) {
            final inputtedActionPlan = context
                .watch<SaveInputtedActionPlanModel>()
                .inputtedActionPlan[goalId];
            final values = inputtedActionPlan.containsKey(index.toString())
                ? inputtedActionPlan[index.toString()]
                : '';

            if (index == 4) {
              return DPCreateGrid(
                context.watch<SaveInputtedDetailGoalModel>().inputtedDetailGoal['$goalId'] ??'', 
                const Color(0xff929292), 
                null).dPCreateGrid();
            } else {
              return DPCreateGrid(values.toString(), const Color(0xff5C5C5C), null).dPCreateGrid();
            }
          }),
        ),
      ),
    );
  }
}
