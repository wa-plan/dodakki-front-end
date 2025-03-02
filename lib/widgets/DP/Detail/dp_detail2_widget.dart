// 3X3 만다라트 세부 화면
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class MandalartGrid5 extends StatefulWidget {
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final int selectedSecondGoal;
  final String firstColor;

  const MandalartGrid5(
      {super.key,
      required this.mandalart,
      required this.secondGoals,
      required this.selectedSecondGoal,
      required this.firstColor});

  @override
  State<MandalartGrid5> createState() => _MandalartGrid5();
}

class _MandalartGrid5 extends State<MandalartGrid5> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: currentHeight * 0.4,
      child: GridView(
        shrinkWrap: true, // GridView를 자식으로 설정
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
        children: [
          for (int i = 0; i < 4; i++)
            DPGrid2(i, widget.mandalart, widget.secondGoals, 15, null)
                .dpGrid2(),
          DPGrid1(widget.mandalart,
                  ColorTransform(widget.firstColor).colorTransform(), 15)
              .dpGrid1(),
          for (int i = 4; i < 8; i++)
            DPGrid2(i, widget.mandalart, widget.secondGoals, 15, null)
                .dpGrid2(),
        ],
      ),
    );
  }
}
