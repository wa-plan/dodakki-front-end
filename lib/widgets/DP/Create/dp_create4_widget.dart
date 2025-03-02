import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class Input2 extends StatefulWidget {
  final int actionPlanId;
  final int selectedDetailGoalId;

  const Input2({
    super.key,
    required this.actionPlanId,
    required this.selectedDetailGoalId,
  });

  @override
  State<Input2> createState() => _Input2State();
}

class _Input2State extends State<Input2> {
  TextEditingController? controller; // 초기 null 허용
  late Color initialColor;

  @override
  void initState() {
    super.initState();

    // Test 모델에서 초기값 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final testModel = context.read<TestInputtedActionPlanModel>();
      setState(() {
        controller = TextEditingController(
          text: testModel.inputtedActionPlan[widget.selectedDetailGoalId]
                  [widget.actionPlanId.toString()] ??
              '', // 초기 값이 없으면 빈 문자열로 설정
        );
      });
    });

    // 초기 색상 가져오기
    initialColor = context
            .read<GoalColor>()
            .selectedGoalColor['${widget.selectedDetailGoalId}'] ??
        Colors.transparent;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final testModel = context.watch<TestInputtedActionPlanModel>();

    // controller가 초기화되기 전에는 로딩 위젯 표시
    if (controller == null) {
      return const CircularProgressIndicator();
    }

    return DPInput3(
      colorPalette[initialColor] ?? colorPalette[Colors.transparent],
      (value) {
        // 입력값 변경 시 Test 모델에 바로 반영
        testModel.updateTestActionPlan(
          widget.selectedDetailGoalId,
          widget.actionPlanId.toString(),
          value.isEmpty ? '' : value,
        );
      },
      controller!.text,
    ).dpInput3();
  }
}
