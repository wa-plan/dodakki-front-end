import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/screens/DP/Create/dp_create5_page.dart';
import 'package:domino/screens/DP/Create/dp_create3_page.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Create/dp_create2_widget.dart';
import 'package:domino/widgets/DP/Create/dp_description1_widget.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class DPcreate99Page extends StatefulWidget {
  final String? mainGoalId;
  final String firstColor;
  const DPcreate99Page(
      {super.key, required this.firstColor, required this.mainGoalId});

  @override
  State<DPcreate99Page> createState() => _DPcreate99Page();
}

class _DPcreate99Page extends State<DPcreate99Page> {
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
              CustomBackButton(() {
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
                    context
                        .read<GoalColor>()
                        .updateGoalColor(i.toString(), const Color(0xff929292));
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

                  // DP 메인 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DPMain()),
                  );
                });
              }).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('만다라트 작성').pageTitle(),
              const Spacer(),

              //프로그레스 바 (from style_tutorial.dart)
              ProgressBar(2, 3).progressBar()
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
                              context
                                  .watch<SelectFinalGoalModel>()
                                  .selectedFinalGoal,
                              ColorTransform(widget.firstColor)
                                  .colorTransform(),
                              currentHeight,
                              currentWidth)
                          .dpMainGoal(),
                      SizedBox(height: 15),
                      Center(
                        child: SizedBox(
                          width: currentHeight * 0.53,
                          child: GridView(
                            shrinkWrap: true, 
                            physics:
                                const NeverScrollableScrollPhysics(), 
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1),
                            children: [
                              Smallgridwithdata(
                                goalId: 0,
                                firstColor: widget.firstColor,
                              ),
                              Smallgridwithdata(
                                  goalId: 1, firstColor: widget.firstColor),
                              Smallgridwithdata(
                                  goalId: 2, firstColor: widget.firstColor),
                              Smallgridwithdata(
                                  goalId: 3, firstColor: widget.firstColor),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DPcreateInput1Page(
                                          mainGoalId: widget.mainGoalId,
                                          firstColor: widget.firstColor,
                                        ),
                                      ));
                                },
                                child: SizedBox(
                                  width: 100,
                                  child: GridView.count(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1,
                                    children: List.generate(9, (index) {
                                      if (index == 4) {
                                        return Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              color: ColorTransform(
                                                      widget.firstColor)
                                                  .colorTransform()),
                                          margin: const EdgeInsets.all(1.0),
                                          child: Center(
                                              child: AutoSizeText(
                                            maxLines:
                                                3, 
                                            minFontSize: 7, 
                                            overflow: TextOverflow
                                                .ellipsis, 
                                            context
                                                .watch<SelectFinalGoalModel>()
                                                .selectedFinalGoal,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          )),
                                        );
                                      } else {
                                        final inputtedDetailGoals = context
                                            .watch<
                                                SaveInputtedDetailGoalModel>()
                                            .inputtedDetailGoal;
                                        final value = inputtedDetailGoals
                                                .containsKey(index.toString())
                                            ? inputtedDetailGoals[
                                                index.toString()]
                                            : '';

                                        return Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: const Color(0xff929292),
                                          ),
                                          margin: const EdgeInsets.all(1.0),
                                          child: Center(
                                              child: Text(
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            value!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
                                          )),
                                        );
                                      }
                                    }),
                                  ),
                                ),
                              ),
                              Smallgridwithdata(
                                  goalId: 5, firstColor: widget.firstColor),
                              Smallgridwithdata(
                                  goalId: 6, firstColor: widget.firstColor),
                              Smallgridwithdata(
                                  goalId: 7, firstColor: widget.firstColor),
                              Smallgridwithdata(
                                  goalId: 8, firstColor: widget.firstColor),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Description(widget.firstColor)
                          .description(),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          )),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          //취소버튼
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(Colors.black, Colors.white, '이전', () {
              PopupDialog.show(
                context,
                '지금 돌아가면,\n작성한 내용이 사라져!',
                '잠깐!',
                true, 
                false, 
                false, 
                true, 
                onCancel: () {
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
                    context
                        .read<GoalColor>()
                        .updateGoalColor(i.toString(), const Color(0xff929292));
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DPMain()),
                  );
                },
              );
            }, currentWidth)
                .newButton(),
          ),

          //다음버튼
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(Colors.black, Colors.white, '다음', () {
              // isAllEmpty 검사를 실행
              final isAllEmpty =
                  context.read<SaveInputtedActionPlanModel>().isAllEmpty();

              if (isAllEmpty) {
                // true일 경우 메시지를 띄움
                TutorialMessage('제3목표를 입력하지 않으면 루틴을 만들지 못해!').tutorialMessage(context);
              } else {
                // false일 경우 다음 페이지로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DPcreateColorPage(
                      mainGoalId: widget.mainGoalId,
                      firstColor: widget.firstColor,
                    ),
                  ),
                );
              }
            }, currentWidth)
                .newButton(),
          ),
        ]),
      ),
    );
  }
}
