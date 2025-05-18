// DP 메인 페이지에 들어가는 만다라트
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class MandalartGrid extends StatelessWidget {
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final int mandalartId;
  final String firstColor;
  final double currentHeight;

  const MandalartGrid(
      {super.key,
      required this.mandalart,
      required this.secondGoals,
      required this.mandalartId,
      required this.firstColor,
      required this.currentHeight});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: currentHeight * 0.35,
      child: GridView(
        shrinkWrap: true, // GridView will be wrapped in the available space
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: List.generate(9, (j) {
          if (j == 4) {
            return SizedBox(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 0.5,
                mainAxisSpacing: 0.5,
                children: [
                  for (int i = 0; i < 9; i++)
                    if (i == 4)
                      DPGrid1(mandalart,
                              ColorTransform(firstColor).colorTransform(), 8)
                          .dpGrid1()
                    else
                      DPGrid2(i, mandalart, secondGoals, 8, null).dpGrid2()
                ],
              ),
            );
          } else {
            return SizedBox(
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 0.5,
                mainAxisSpacing: 0.5,
                children: List.generate(9, (i) {
                  if (i == 4) {
                    return DPGrid2(j, mandalart, secondGoals, 8, null)
                        .dpGrid2();
                  } else {
                    return DPGrid3(j, i, mandalart, secondGoals, 8, null)
                        .dpGrid3();
                  }
                }),
              ),
            );
          }
        }),
      ),
    );
  }
}
