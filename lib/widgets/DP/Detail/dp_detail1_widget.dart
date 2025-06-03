// DP 디테일 페이지에 들어가는 9x9 만다라트 (3x3 만다라트 선택 가능)
import 'package:domino/screens/DP/Detail/dp_detail3_page.dart';
import 'package:domino/screens/DP/Detail/dp_detail2_page.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class MandalartGrid3 extends StatefulWidget {
  final String firstColor;
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final int mandalartId;
  final double currentHeight;

  const MandalartGrid3({
    super.key,
    required this.mandalart,
    required this.secondGoals,
    required this.mandalartId,
    required this.firstColor,
    required this.currentHeight
  });

  @override
  State<MandalartGrid3> createState() => _MandalartGrid3();
}

class _MandalartGrid3 extends State<MandalartGrid3> {
  int selectedSecondGoal = 0;

  void navigateToDetail(int selectedGoal) {
    setState(() {
      selectedSecondGoal = selectedGoal;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DPdetail2Page(
          mandalart: widget.mandalart,
          secondGoals: widget.secondGoals,
          mandalartId: widget.mandalartId,
          selectedSecondGoal: selectedSecondGoal,
          firstColor: widget.firstColor,
        ),
      ),
    );
  }

  Widget buildGridCell(int hintNum2, double currentWidth) {
  // 체크: 모든 그리드 박스 컬러가 투명한지 확인
  bool isAllTransparent = widget.secondGoals.isNotEmpty &&
      widget.secondGoals[hintNum2]['thirdGoals'].every((goal) => goal['thirdGoal'] == "");

  return GestureDetector(
    onTap: isAllTransparent 
        ? null // 투명하면 아무 동작도 하지 않음
        : () => navigateToDetail(hintNum2),
    child: SizedBox(
      width: 100,
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        children: [
          for (int i = 0; i < 4; i++)
            DPGrid3(hintNum2, i, widget.mandalart, widget.secondGoals, 8, null).dpGrid3(),
          DPGrid2(hintNum2, widget.mandalart, widget.secondGoals, 8, null, currentWidth).dpGrid2(),
          for (int i = 5; i < 9; i++)
            DPGrid3(hintNum2, i, widget.mandalart, widget.secondGoals, 8, null).dpGrid3(),
        ],
      ),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return InteractiveViewer(
      onInteractionUpdate: (details) {
    print('Scale: ${details.scale}, Focal Point: ${details.focalPoint}');
  },
      panEnabled: true, // Allow panning (dragging)
        scaleEnabled: true, // Allow zooming
        minScale: 0.5, // Minimum zoom scale (50%)
        maxScale: 3.0, // Maximum zoom scale (300%)
      child: SizedBox(
        width: widget.currentHeight*0.53,
        height: widget.currentHeight * 0.53,
        child: GridView(
          shrinkWrap: true, 
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          children: List.generate(9, (index) {
            if (index == 4) {
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DPdetail3Page(
                      mandalart: widget.mandalart,
                      secondGoals: widget.secondGoals,
                      mandalartId: widget.mandalartId,
                      selectedSecondGoal: selectedSecondGoal,
                      firstColor: widget.firstColor,
                    ),
                  ),
                ),
                child: SizedBox(
                  width: 100,
                  child: GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    children: [
                      for (int i = 0; i < 4; i++)
                        DPGrid2(i, widget.mandalart, widget.secondGoals, 8, null, currentWidth).dpGrid2(),
                      DPGrid1(widget.mandalart,
                                  ColorTransform(widget.firstColor).colorTransform(), 8)
                              .dpGrid1(),
                      for (int i = 5; i < 9; i++)
                        DPGrid2(i, widget.mandalart, widget.secondGoals, 8, null, currentWidth).dpGrid2(),
                    ],
                  ),
                ),
              );
            }
            return buildGridCell(index, currentWidth);
          },
        ),
      ),
    ));
  }
}
