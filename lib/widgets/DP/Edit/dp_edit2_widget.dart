import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class EditInput1 extends StatefulWidget {
  final int selectedDetailGoalId;

  const EditInput1({super.key, required this.selectedDetailGoalId});

  @override
  _EditInput1State createState() => _EditInput1State();
}

class _EditInput1State extends State<EditInput1> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    final saveModel = context.read<SaveInputtedDetailGoalModel>();
    final testModel = context.read<TestInputtedDetailGoalModel>();
    final goalId = '${widget.selectedDetailGoalId}';

    // TestModel에 값이 있으면 그걸 사용하고, 없으면 SaveModel에서 초기화
    String? existingValue = testModel.testinputtedDetailGoal[goalId];
    String initialValue;

    if (existingValue != null && existingValue.isNotEmpty) {
      initialValue = existingValue;
    } else {
      initialValue = saveModel.inputtedDetailGoal[goalId] ?? '';
      // TestModel에도 초기화
      WidgetsBinding.instance.addPostFrameCallback((_) {
        testModel.updateTestDetailGoal(goalId, initialValue);
      });
    }

    controller = TextEditingController(text: initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DPInput2(
      const Color(0xff929292),
      controller,
      (value) {
        context.read<TestInputtedDetailGoalModel>().updateTestDetailGoal(
              '${widget.selectedDetailGoalId}',
              value,
            );
      },
    ).dpInput2();
  }
}
