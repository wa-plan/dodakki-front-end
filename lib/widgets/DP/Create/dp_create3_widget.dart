import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class Input1 extends StatefulWidget {
  final int selectedDetailGoalId;

  const Input1({super.key, required this.selectedDetailGoalId});

  @override
  _Input1State createState() => _Input1State();
}

class _Input1State extends State<Input1> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();

    // Test 모델에서 초기 값을 가져옴
    final testModel = context.read<TestInputtedDetailGoalModel>();

    // TextEditingController를 초기화하여 Test 모델의 값을 표시
    controller = TextEditingController(
      text: testModel.testinputtedDetailGoal['${widget.selectedDetailGoalId}'] ?? '',
    );

    // 위젯이 빌드를 완료한 후 초기 값 반영
    WidgetsBinding.instance.addPostFrameCallback((_) {
      testModel.updateTestDetailGoal(
        '${widget.selectedDetailGoalId}',
        testModel.testinputtedDetailGoal['${widget.selectedDetailGoalId}'] ?? '',
      );
    });

    // TextEditingController에 listener 추가
    controller.addListener(() {
      // 입력값이 변경되면 Test 모델에 바로 저장
      testModel.updateTestDetailGoal(
        '${widget.selectedDetailGoalId}',
        controller.text,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testModel = context.watch<TestInputtedDetailGoalModel>();

    return DPInput2(
      testModel.testinputtedDetailGoal['${widget.selectedDetailGoalId}'] == null ||
              testModel.testinputtedDetailGoal['${widget.selectedDetailGoalId}']!
                  .isEmpty
          ? const Color(0xff929292)
          : context
              .watch<GoalColor>()
              .selectedGoalColor['${widget.selectedDetailGoalId}'],
      controller,
      (value) {
        // 입력값 변경 시 콜백 (이미 controller.addListener에서 처리 중이므로 여기는 생략 가능)
        testModel.updateTestDetailGoal('${widget.selectedDetailGoalId}', value);
      },
    ).dpInput2();
  }
}
