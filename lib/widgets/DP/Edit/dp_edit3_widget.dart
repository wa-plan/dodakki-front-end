import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class EditInput2 extends StatefulWidget {
  final int actionPlanId;
  final int selectedDetailGoalId;

  const EditInput2({
    super.key,
    required this.actionPlanId,
    required this.selectedDetailGoalId,
  });

  @override
  State<EditInput2> createState() => _EditInput2State();
}

class _EditInput2State extends State<EditInput2> {
  late String initialValue;

  @override
  void initState() {
    super.initState();

    final saveModel = context.read<SaveInputtedActionPlanModel>();
    final testModel = context.read<TestInputtedActionPlanModel>();

    final detailGoalId = widget.selectedDetailGoalId;
    final actionPlanIdStr = widget.actionPlanId.toString();

    // TestModel에서 값이 있는지 확인
    final existingValue =
        testModel.inputtedActionPlan[detailGoalId][actionPlanIdStr];

    if (existingValue != null && existingValue.isNotEmpty) {
      initialValue = existingValue;
    } else {
      // SaveModel에서 초기화
      initialValue = saveModel.inputtedActionPlan[detailGoalId][actionPlanIdStr] ?? '';
      // TestModel에도 반영
      WidgetsBinding.instance.addPostFrameCallback((_) {
        testModel.updateTestActionPlan(
          detailGoalId,
          actionPlanIdStr,
          initialValue,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DPInput3(
      const Color(0xff5C5C5C),
      (value) {
        context.read<TestInputtedActionPlanModel>().updateTestActionPlan(
              widget.selectedDetailGoalId,
              widget.actionPlanId.toString(),
              value.isEmpty ? "" : value,
            );
      },
      initialValue,
    ).dpInput3();
  }
}
