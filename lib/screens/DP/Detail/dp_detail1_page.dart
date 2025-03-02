//DP 만다라트 9X9 상세 페이지
import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/DP/Edit/dp_edit1_page.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/styles.dart';
import 'package:domino/widgets/DP/Detail/dp_detail1_widget.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
              CustomIconButton(() {
                Navigator.of(context).pop();
              }, Icons.keyboard_arrow_left_rounded, currentWidth)
                  .customIconButton(),
              const SizedBox(width: 10),
              DPTitleText(mandalart, currentWidth).dPTitleText()
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CustomIconButton(() {
                      for (int i = 0; i < 9; i++) {
                        context
                            .read<SaveInputtedDetailGoalModel>()
                            .updateDetailGoal(
                                i.toString(),
                                secondGoals.isNotEmpty &&
                                        secondGoals[i]['secondGoal'] != ""
                                    ? secondGoals[i]['secondGoal']
                                    : "");
                      }

                      for (int i = 0; i < 9; i++) {
                        context
                            .read<SaveEditedDetailGoalIdModel>()
                            .editDetailGoalId(
                                i.toString(),
                                secondGoals.isNotEmpty
                                    ? secondGoals[i]['id']
                                    : 0);
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
                                          secondGoals[i]['thirdGoals']
                                              .isNotEmpty &&
                                          secondGoals[i]['thirdGoals']
                                              .asMap()
                                              .containsKey(j)
                                      ? secondGoals[i]['thirdGoals'][j]
                                          ['thirdGoal']
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
                                          secondGoals[i]['thirdGoals']
                                              .isNotEmpty &&
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
                          ),
                        ),
                      ); // 함수 호출
                    }, Icons.edit, currentWidth)
                        .customIconButton()
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xff2B2B2B),
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
                  fontSize: currentWidth < 600 ? 12 : 15,
                  fontWeight: FontWeight.w300),
            ),
            const Spacer(),
            NewButton(const Color.fromARGB(255, 133, 24, 17), Colors.white, '삭제',
                () {
              // Create a list to store the second goal ids
              List<int> secondGoalIds = [];
              print(secondGoalIds);

              // Extract the id values from secondGoals
              for (var goal in secondGoals) {
                secondGoalIds.add(goal['id']);
              }

              // Debug: Print the extracted second goal ids
              print(secondGoalIds);
              PopupDialog.show(
                context,
                '멋진 계획이었는데,\n이대로 보낼꺼야..?',
                true, // cancel
                true, // delete
                false, // signout
                false, //success
                onCancel: () {
                  // 취소 버튼을 눌렀을 때 실행할 코드
                  Navigator.of(context).pop();
                },

                onDelete: () async {
                  // Iterate through the secondGoalIds list and delete each goal
                  for (int secondGoalId in secondGoalIds) {
                    bool success = await DeleteMandalartService.deleteMandalart(
                      context,
                      secondGoalId,
                    );

                    if (success) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DPMain(),
                        ),
                      ); // 함수 호출
                    } else {
                      Fluttertoast.showToast(
                        msg: '목표 삭제 실패: $secondGoalId',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                      );
                    }
                  }
                },
              );
            }, currentWidth).newButton(),
          ],
        ),
      ),
    );
  }
}
