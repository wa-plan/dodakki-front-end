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
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                NewCustomIconButton(() {
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
                        .editDetailGoalId(i.toString(),
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
            const Spacer(),
            NewButton(
              const Color.fromARGB(255, 133, 24, 17),
              Colors.white,
              '삭제',
              () {
                // 1. secondGoal ID 리스트 만들기
                List<int> secondGoalIds = [];
                for (var goal in secondGoals) {
                  secondGoalIds.add(goal['id']);
                }
                print('Second Goal IDs: $secondGoalIds');

                // 2. thirdGoal ID 리스트 만들고 중복 제거
                Set<int> thirdGoalIds = {}; // Set으로 중복 제거
                for (var goal in secondGoals) {
                  for (var third in goal['thirdGoals']) {
                    thirdGoalIds.add(third['id']);
                  }
                }
                print('Third Goal IDs: $thirdGoalIds');

                // 3. 삭제 다이얼로그 띄우기
                PopupDialog.show(
                  context,
                  '멋진 계획이었는데,\n이대로 보낼꺼야..?',
                  true, // cancel
                  true, // delete
                  false, // signout
                  false, // success
                  onCancel: () {
                    Navigator.of(context).pop(); // 닫기
                  },
                  onDelete: () async {
                    // 1) secondGoal 먼저 삭제
                    bool allSecondDeleted = true;
                    for (int secondGoalId in secondGoalIds) {
                      bool success =
                          await DeleteMandalartService.deleteMandalart(
                        context,
                        secondGoalId,
                      );
                      if (!success) {
                        allSecondDeleted = false;
                        Fluttertoast.showToast(
                          msg: '목표 삭제 실패: $secondGoalId',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    }

                    // 2) secondGoal이 모두 성공했을 때만 thirdGoal 삭제
                    if (allSecondDeleted) {
                      bool allThirdDeleted = true;
                      for (int thirdGoalId in thirdGoalIds) {
                        bool thirdDeleted =
                            await DeleteThirdGoalService.deleteThirdGoal(
                          context,
                          thirdGoalId,
                        );
                        if (!thirdDeleted) {
                          allThirdDeleted = false;
                          Fluttertoast.showToast(
                            msg: '세부 목표 삭제 실패: $thirdGoalId',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                          );
                          break;
                        }
                      }

                      // 3) 모두 성공하면 메인으로 이동
                      if (allThirdDeleted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DPMain(),
                          ),
                        );
                      }
                    }
                  },
                );
              },
              currentWidth,
            ).newButton(),
          ],
        ),
      ),
    );
  }
}
