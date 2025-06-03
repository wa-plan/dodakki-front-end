import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/screens/DP/Edit/dp_edit4_page.dart';
import 'package:domino/screens/DP/Edit/dp_edit2_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Create/dp_description1_widget.dart';
import 'package:domino/widgets/DP/Edit/dp_edit1_widget.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

import '../../../style/style_tutorial.dart';

class Edit99Page extends StatelessWidget {
  final String mandalart;
  final int mandalartId;
  final String firstColor;
  final List<int> secondGoalIds;
  final List<Map<String, dynamic>> secondGoals;

  const Edit99Page(
      {super.key,
      required this.mandalart,
      required this.mandalartId,
      required this.firstColor,
      required this.secondGoalIds,
      required this.secondGoals});

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Padding(
            padding: appBarPadding,
            child: Row(
              children: [
                //나가기 버튼
                CustomBackButton(
                  () {
                    PopupDialog.show(
                        context,
                        '지금 나가면,\n작성한 내용이 사라져!',
                        '잠깐!',
                        true, // cancel
                        false, // delete
                        false, // signout
                        true, //success
                        onCancel: () {
                      // 취소 버튼을 눌렀을 때 실행할 코드
                      Navigator.pop(context);
                    }, onSuccess: () async {
                      for (int i = 0; i < 9; i++) {
                        context
                            .read<SaveInputtedDetailGoalModel>()
                            .updateDetailGoal(i.toString(), "");
                      }

                      for (int i = 0; i < 9; i++) {
                        context
                            .read<TestInputtedDetailGoalModel>()
                            .updateTestDetailGoal(i.toString(), "");
                      }

                      for (int i = 0; i < 9; i++) {
                        context.read<GoalColor>().updateGoalColor(
                            i.toString(), const Color(0xff929292));
                      }

                      for (int i = 0; i < 9; i++) {
                        for (int j = 0; j < 9; j++) {
                          context
                              .read<SaveInputtedActionPlanModel>()
                              .updateActionPlan(i, j.toString(), "");
                        }
                      }

                      for (int i = 0; i < 9; i++) {
                        for (int j = 0; j < 9; j++) {
                          context
                              .read<TestInputtedActionPlanModel>()
                              .updateTestActionPlan(i, j.toString(), "");
                        }
                      }

                      // 팝업 닫기
                      Navigator.pop(context);

                      // 이전 페이지로 이동
                      Navigator.pop(context);

                      Navigator.pop(context);
                    });
                  },
                ).customBackButton(),
                SizedBox(width: 15),

                //페이지 타이틀
                PageTitle('만다라트 수정').pageTitle(),
                const Spacer(),

                //프로그레스 바 (from style_tutorial.dart)
                ProgressBar(1, 2).progressBar()
              ],
            ),
          ),
          backgroundColor: backgroundColor,
        ),
        body: Padding(
            padding: fullPadding,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        DPMainGoal(
                                mandalart,
                                ColorTransform(firstColor).colorTransform(),
                                currentHeight,
                                currentWidth)
                            .dpMainGoal(),
                        SizedBox(height: 15),
                        Center(
                          child: SizedBox(
                              width: currentHeight * 0.53,
                              child: GridView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 1,
                                        mainAxisSpacing: 1),
                                children: [
                                  for (int i = 0; i < 4; i++)
                                    EditSmallgridwithdata(
                                      goalId: i,
                                      mandalart: mandalart,
                                      firstColor: firstColor,
                                      secondGoalIds: secondGoalIds,
                                      secondGoals: secondGoals,
                                      mandalartId: mandalartId,
                                    ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditInput1Page(
                                              mainGoalId:
                                                  mandalartId.toString(),
                                              mandalart: mandalart,
                                              firstColor: firstColor,
                                              mandalartId: mandalartId,
                                              secondGoalIds: secondGoalIds,
                                              secondGoals: secondGoals,
                                            ),
                                          ));
                                    },
                                    child: SizedBox(
                                      width: 100,
                                      child: GridView.count(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 0.5,
                                        mainAxisSpacing: 0.5,
                                        children: [
                                          for (int i = 0; i < 4; i++)
                                            DPGrid3_E(
                                                    context
                                                            .watch<
                                                                SaveInputtedDetailGoalModel>()
                                                            .inputtedDetailGoal
                                                            .containsKey('$i')
                                                        ? context
                                                                .watch<
                                                                    SaveInputtedDetailGoalModel>()
                                                                .inputtedDetailGoal['$i'] ??
                                                            ''
                                                        : '',
                                                    const Color(0xff929292),
                                                    10)
                                                .dpGrid3_E(),

                                          // 제1목표 그리드
                                          DPGrid1(
                                                  mandalart,
                                                  ColorTransform(firstColor)
                                                      .colorTransform(),
                                                  10)
                                              .dpGrid1(),

                                          for (int i = 5; i < 9; i++)
                                            DPGrid3_E(
                                                    context
                                                            .watch<
                                                                SaveInputtedDetailGoalModel>()
                                                            .inputtedDetailGoal
                                                            .containsKey('$i')
                                                        ? context
                                                                .watch<
                                                                    SaveInputtedDetailGoalModel>()
                                                                .inputtedDetailGoal['$i'] ??
                                                            ''
                                                        : '',
                                                    const Color(0xff929292),
                                                    10)
                                                .dpGrid3_E(),
                                        ],
                                      ),
                                    ),
                                  ),
                                  for (int i = 5; i < 9; i++)
                                    EditSmallgridwithdata(
                                      goalId: i,
                                      mandalart: mandalart,
                                      firstColor: firstColor,
                                      secondGoalIds: secondGoalIds,
                                      secondGoals: secondGoals,
                                      mandalartId: mandalartId,
                                    ),
                                ],
                              )),
                        ),
                        SizedBox(height: 20),
                        Description(firstColor).description(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 45,
                        child: NewButton(Colors.black, Colors.white, '취소', () {
                          PopupDialog.show(
                            context,
                            '지금 취소하면,\n수정한 내용이 사라져!',
                            '잠깐!',
                            true, // cancel
                            false, // delete
                            false, // signout
                            true, //success
                            onCancel: () {
                              // 취소 버튼을 눌렀을 때 실행할 코드
                              Navigator.pop(context);
                            },

                            onSuccess: () async {
                              for (int i = 0; i < 9; i++) {
                                context
                                    .read<SaveInputtedDetailGoalModel>()
                                    .updateDetailGoal(i.toString(), "");
                              }

                              for (int i = 0; i < 9; i++) {
                                context
                                    .read<TestInputtedDetailGoalModel>()
                                    .updateTestDetailGoal(i.toString(), "");
                              }

                              for (int i = 0; i < 9; i++) {
                                context.read<GoalColor>().updateGoalColor(
                                    i.toString(), const Color(0xff929292));
                              }

                              for (int i = 0; i < 9; i++) {
                                for (int j = 0; j < 9; j++) {
                                  context
                                      .read<SaveInputtedActionPlanModel>()
                                      .updateActionPlan(i, j.toString(), "");
                                }
                              }

                              for (int i = 0; i < 9; i++) {
                                for (int j = 0; j < 9; j++) {
                                  context
                                      .read<TestInputtedActionPlanModel>()
                                      .updateTestActionPlan(
                                          i, j.toString(), "");
                                }
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DPMain(),
                                ),
                              );
                            },
                          );
                        }, currentWidth)
                            .newButton(),
                      ),
                      Builder(builder: (context) {
                        return SizedBox(
                          width: 90,
                          height: 45,
                          child: NewButton(
                            Color.fromARGB(255, 155, 51, 51),
                            Colors.white,
                            '삭제',
                            () {
                              // 1. secondGoal ID 리스트 만들기
                              List<int> secondGoalIds = [];
                              for (var goal in secondGoals) {
                                secondGoalIds.add(goal['id']);
                              }

                              // 2. thirdGoal ID 리스트 만들고 중복 제거
                              Set<int> thirdGoalIds = {}; // Set으로 중복 제거
                              for (var goal in secondGoals) {
                                for (var third in goal['thirdGoals']) {
                                  thirdGoalIds.add(third['id']);
                                }
                              }

                              // 3. 삭제 다이얼로그 띄우기
                              PopupDialog.show(
                                context,
                                '멋진 계획이었는데,\n이대로 보낼꺼야..?',
                                '헐..!',
                                true, // cancel
                                true, // delete
                                false, // signout
                                false, // success
                                onCancel: () {
                                  Navigator.of(context).pop(); // 닫기
                                },
                                onDelete: () async {
                                  // 👉 로딩 팝업 띄우기
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => AlertDialog(
                                      backgroundColor: backgroundColor,
                                      content: Row(
                                        children: const [
                                          CircularProgressIndicator(
                                              color: mainRed),
                                          SizedBox(width: 20),
                                          Text("만다라트를 삭제하는 중이야..!",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600)),
                                        ],
                                      ),
                                    ),
                                  );

                                  // 1) secondGoal 먼저 삭제
                                  bool allSecondDeleted = true;
                                  for (int secondGoalId in secondGoalIds) {
                                    bool success = await DeleteMandalartService
                                        .deleteMandalart(
                                      context,
                                      secondGoalId,
                                    );
                                    if (!success) {
                                      allSecondDeleted = false;
                                    }
                                  }

                                  // 2) secondGoal이 모두 성공했을 때만 thirdGoal 삭제
                                  if (allSecondDeleted) {
                                    bool allThirdDeleted = true;
                                    for (int thirdGoalId in thirdGoalIds) {
                                      bool thirdDeleted =
                                          await DeleteThirdGoalService
                                              .deleteThirdGoal(
                                        context,
                                        thirdGoalId,
                                      );
                                      if (!thirdDeleted) {
                                        allThirdDeleted = false;

                                        break;
                                      }
                                    }

                                    // ✅ 3) 성공 시 팝업 닫고 메인 이동
                                    if (allThirdDeleted) {
                                      Navigator.pop(context); // 로딩 팝업 닫기
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DPMain()),
                                      );
                                      return;
                                    }
                                  }

                                  // ❌ 실패했을 경우에도 로딩 팝업 닫기
                                  Navigator.pop(context); // 로딩 팝업 닫기
                                },
                              );
                            },
                            currentWidth,
                          ).newButton(),
                        );
                      }),
                      SizedBox(
                        width: 90,
                        height: 45,
                        child: NewButton(Colors.black, Colors.white, '다음', () {
                          // isAllEmpty 검사를 실행
                          final isAllEmpty = context
                              .read<SaveInputtedActionPlanModel>()
                              .isAllEmpty();

                          if (isAllEmpty) {
                            // true일 경우 메시지를 띄움
                            Fluttertoast.showToast(
                              msg: '제3목표를 입력하지 않으면\n루틴을 만들 수 없어요.',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                            );
                          } else {
                            // false일 경우 다음 페이지로 이동
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditColorPage(
                                  mandalart: mandalart,
                                  firstColor: firstColor,
                                ),
                              ),
                            );
                          }
                        }, currentWidth)
                            .newButton(),
                      )
                    ]),
              ],
            )));
  }
}
