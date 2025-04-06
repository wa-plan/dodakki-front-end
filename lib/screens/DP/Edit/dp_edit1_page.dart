import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/screens/DP/Edit/dp_edit4_page.dart';
import 'package:domino/screens/DP/Edit/dp_edit2_page.dart';
import 'package:domino/styles.dart';
import 'package:domino/widgets/DP/Create/dp_description1_widget.dart';
import 'package:domino/widgets/DP/Edit/dp_edit1_widget.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

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
                CustomIconButton(() {
                  PopupDialog.show(
                      context,
                      '지금 나가면,\n작성한 내용이 사라져!',
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
                }, Icons.keyboard_arrow_left_rounded, currentWidth)
                    .customIconButton(),
                const SizedBox(width: 10),
                DPTitleText('플랜 수정하기', currentWidth).dPTitleText(),
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
                        SizedBox(height: currentWidth < 600 ? 15 : 20),
                        DPGuideText('만다라트를 수정해 보아요.', currentWidth)
                            .dPGuideText(),
                        SizedBox(height: currentWidth < 600 ? 14 : 20),
                        DPMainGoal(
                                mandalart,
                                ColorTransform(firstColor).colorTransform(),
                                currentHeight,
                                currentWidth)
                            .dpMainGoal(),

                        SizedBox(height: currentWidth < 600 ? 10 : 15),

                        Center(
                          child: SizedBox(
                            width: currentHeight*0.5,
                              child: GridView(
                                shrinkWrap: true, // GridView를 자식으로 설정
                              physics:
                                  const NeverScrollableScrollPhysics(), // Grid 자체의 스크롤 비활성화
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 0.5,
                                    mainAxisSpacing: 0.5),
                            children: [
                              for (int i = 0; i < 4; i++)
                                EditSmallgridwithdata(
                                  goalId: i,
                                  mandalart: mandalart,
                                  firstColor: firstColor,
                                ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditInput1Page(
                                            mainGoalId: mandalartId.toString(),
                                            mandalart: mandalart,
                                            firstColor: firstColor),
                                      ));
                                },
                                child: Expanded(
                                  child: GridView(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 0.5,
                                      mainAxisSpacing: 0.5,
                                    ),
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
                                              12)
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
                                ),
                            ],
                          )),
                        ),
                        SizedBox(height: currentWidth < 600 ? 15 : 25),
                        Description(firstColor, currentWidth).description(),
                        SizedBox(height: currentWidth < 600 ? 15 : 25),

              
                        
                      ],
                    ),
                  ),
                ),
                Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NewButton(
                                Colors.black,
                                Colors.white,
                                '취소',
                                () {
                                  PopupDialog.show(
                                    context,
                                    '지금 취소하면,\n수정한 내용이 사라져!',
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
                                            .updateTestDetailGoal(
                                                i.toString(), "");
                                      }

                                      for (int i = 0; i < 9; i++) {
                                        context
                                            .read<GoalColor>()
                                            .updateGoalColor(i.toString(),
                                                const Color(0xff929292));
                                      }

                                      for (int i = 0; i < 9; i++) {
                                        for (int j = 0; j < 9; j++) {
                                          context
                                              .read<
                                                  SaveInputtedActionPlanModel>()
                                              .updateActionPlan(
                                                  i, j.toString(), "");
                                        }
                                      }

                                      for (int i = 0; i < 9; i++) {
                                        for (int j = 0; j < 9; j++) {
                                          context
                                              .read<
                                                  TestInputtedActionPlanModel>()
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
                                },currentWidth
                              ).newButton(),
                              
                              NewButton(Colors.black, Colors.white, '다음', () {
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
                              }, currentWidth).newButton()
                            ]),
              ],
            )));
  }
}
