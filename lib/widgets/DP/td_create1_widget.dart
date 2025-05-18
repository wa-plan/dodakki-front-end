// TD 도미노 추가 페이지에 들어가는 만다라트
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class MandalartGrid2 extends StatefulWidget {
  final String mandalart;
  final List<Map<String, dynamic>> secondGoals;
  final String firstColor;

  const MandalartGrid2(
      {super.key,
      required this.mandalart,
      required this.secondGoals,
      required this.firstColor});

  @override
  State<MandalartGrid2> createState() => _MandalartGrid2();
}

class _MandalartGrid2 extends State<MandalartGrid2> {
  int? _selectedBoxHintNum2;
  int? _selectedBoxHintNum3;

  void _selectBox(int hintNum2, int hintNum3) {
    setState(() {
      _selectedBoxHintNum2 = hintNum2;
      _selectedBoxHintNum3 = hintNum3;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    return SizedBox(
      width: currentHeight * 0.5,
      child: GridView(
        shrinkWrap: true, // GridView를 자식으로 설정
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        children: List.generate(9, (j) {
          if (j == 4) {
            // Middle 3x3 Grid
            return SizedBox(
              width: 100,
              child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(9, (i) {
                    if (i == 4) {
                      return Opacity(
                        opacity: 0.3,
                        child: DPGrid1(
                                widget.mandalart,
                                ColorTransform(widget.firstColor)
                                    .colorTransform(),
                                8)
                            .dpGrid1(),
                      );
                    } else {
                      return Opacity(
                        opacity: 0.3,
                        child: DPGrid2(
                                i, widget.mandalart, widget.secondGoals, 8, null)
                            .dpGrid2(),
                      );
                    }
                  })),
            );
          } else {
            // Other 3x3 Grids
            return SizedBox(
              width: 100,
              child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                  children: List.generate(9, (i) {
                    if (i == 4) {
                      //Second Goal Grid
                      return Opacity(
                        opacity: 0.3,
                        child: TDGrid2(
                                j, widget.mandalart, widget.secondGoals, 8, null)
                            .tdGrid2(),
                      );
                    } else {
                      //Third Goal Grid
                      return TDGrid3(
                              j,
                              i,
                              widget.mandalart,
                              widget.secondGoals,
                              _selectedBoxHintNum2 == j &&
                                  _selectedBoxHintNum3 == i, () {
                        _selectBox(j, i);
                      }, context)
                          .tdGrid3();
                    }
                  })),
            );
          }
        }),
      ),
    );
  }
}
