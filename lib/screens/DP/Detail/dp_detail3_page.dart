import 'package:domino/styles.dart';
import 'package:domino/widgets/DP/Detail/dp_detail3_widget.dart';
import 'package:flutter/material.dart';

class DPdetail2Page extends StatelessWidget {
  final String mandalart;
  final int mandalartId;
  final List<Map<String, dynamic>> secondGoals;
  final int selectedSecondGoal;
  final String firstColor;

  const DPdetail2Page({
    super.key,
    required this.mandalart,
    required this.mandalartId,
    required this.secondGoals,
    required this.selectedSecondGoal,
    required this.firstColor,
  });

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: currentWidth < 600
              ? const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20)
              : const EdgeInsets.fromLTRB(25.0, 40, 25.0, 20),
          child: Row(
            children: [
              CustomIconButton(() {
                Navigator.of(context).pop();
              }, Icons.keyboard_arrow_left_rounded, currentWidth)
                  .customIconButton(),
              SizedBox(width: currentWidth < 600 ? 10 : 14),
              Text(mandalart,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 27,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Stack(
        children: [
          // 화면 전체의 클릭 이벤트 감지를 위한 투명 GestureDetector
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // 빈 영역 클릭 시 팝업 닫기
            },
            child: Container(
              color: Colors.transparent, // 투명 배경으로 클릭 이벤트만 전달
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: currentWidth < 600 ? 40 : 100,
                ),

                // MandalartGrid4가 상호작용 가능한 영역
                Center(
                  child: GestureDetector(
                    onTap: () {
                      // MandalartGrid4 내부는 아무 동작도 하지 않음
                    },
                    child: MandalartGrid4(
                      mandalart: mandalart,
                      secondGoals: secondGoals,
                      selectedSecondGoal: selectedSecondGoal,
                      firstColor: firstColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
