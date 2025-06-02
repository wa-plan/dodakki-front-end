//DP 만다라트 9X9 상세 페이지
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/DP/Edit/dp_edit1_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Detail/dp_detail1_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DPdetailPage extends StatelessWidget {
  final String mandalart;
  final int mandalartId;
  final List<Map<String, dynamic>> secondGoals;
  final String firstColor;

  const DPdetailPage(
      {super.key,
      required this.mandalart,
      required this.mandalartId,
      required this.secondGoals,
      required this.firstColor});

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    List<int> secondGoalIds2 = [];
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              CustomBackButton(() {
                Navigator.of(context).pop();
              },)
                  .customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle(mandalart).pageTitle(),
              const Spacer(),
              NewCustomIconButton(() {
                for (int i = 0; i < 9; i++) {
                  context.read<SaveInputtedDetailGoalModel>().updateDetailGoal(
                      i.toString(),
                      secondGoals.isNotEmpty &&
                              secondGoals[i]['secondGoal'] != ""
                          ? secondGoals[i]['secondGoal']
                          : "");
                }

                for (int i = 0; i < 9; i++) {
                  context.read<SaveEditedDetailGoalIdModel>().editDetailGoalId(
                      i.toString(),
                      secondGoals.isNotEmpty ? secondGoals[i]['id'] : 0);
                }

                for (int i = 0; i < 9; i++) {
                  context.read<GoalColor>().updateGoalColor(
                      i.toString(),
                      secondGoals.isNotEmpty &&
                              secondGoals[i]['secondGoal'] != ""
                          ? Color(int.parse(secondGoals[i]['color']
                              .replaceAll('Color(', '')
                              .replaceAll(')', '')))
                          : Colors.transparent);
                }

                for (int i = 0; i < 9; i++) {
                  for (int j = 0; j < 9; j++) {
                    context
                        .read<SaveInputtedActionPlanModel>()
                        .updateActionPlan(
                            i,
                            j.toString(),
                            secondGoals.isNotEmpty &&
                                    secondGoals[i]['thirdGoals'].isNotEmpty &&
                                    secondGoals[i]['thirdGoals']
                                        .asMap()
                                        .containsKey(j)
                                ? secondGoals[i]['thirdGoals'][j]['thirdGoal']
                                : "");
                  }
                }

                for (int i = 0; i < 9; i++) {
                  for (int j = 0; j < 9; j++) {
                    context
                        .read<SaveEditedActionPlanIdModel>()
                        .editActionPlanId(
                            i,
                            j.toString(),
                            secondGoals.isNotEmpty &&
                                    secondGoals[i]['thirdGoals'].isNotEmpty &&
                                    secondGoals[i]['thirdGoals']
                                        .asMap()
                                        .containsKey(j)
                                ? secondGoals[i]['thirdGoals'][j]['id']
                                : 0);
                  }
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Edit99Page(
                      mandalart: mandalart,
                      mandalartId: mandalartId,
                      firstColor: firstColor,
                      secondGoalIds: secondGoalIds2,
                      secondGoals: secondGoals,
                    ),
                  ),
                ); // 함수 호출
              }, Icons.edit, currentWidth, 18)
                  .newCustomIconButton()
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
                child: MandalartGrid3(
                  mandalart: mandalart,
                  secondGoals: secondGoals,
                  mandalartId: mandalartId,
                  firstColor: firstColor,
                  currentHeight: currentHeight,
                ),
              ),
            ),
            SizedBox(height: currentWidth < 600 ? 20 : 23),
            Text(
              "확대 및 클릭하여 자세히 볼 수 있어요.",
              style: TextStyle(
                  color: const Color(0xff717171),
                  fontSize: currentWidth < 600 ? 13 : 15,
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
