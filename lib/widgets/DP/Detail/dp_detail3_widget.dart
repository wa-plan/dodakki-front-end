// 3X3 만다라트 세부 화면
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class MandalartGrid4 extends StatefulWidget {
  
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final int selectedSecondGoal;
  final String firstColor;

  const MandalartGrid4({
    super.key,
    required this.mandalart,
    required this.secondGoals,
    required this.selectedSecondGoal,
    required this.firstColor
  });

  @override
  State<MandalartGrid4> createState() => _MandalartGrid4();
}

  class _MandalartGrid4 extends State<MandalartGrid4> {


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
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5),
        children: [
            for (int i = 0; i < 4; i++)
              DPGrid3(widget.selectedSecondGoal, i, widget.mandalart, widget.secondGoals, 15, null).dpGrid3(),

            DPGrid2(widget.selectedSecondGoal, widget.mandalart, widget.secondGoals, 15, null).dpGrid2(),

            for (int i = 4; i < 8; i++)
              DPGrid3(widget.selectedSecondGoal, i, widget.mandalart, widget.secondGoals, 15, null).dpGrid3(),
        ],              
        ),
    );
  }

}