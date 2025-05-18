import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Create/dp_description2_widget.dart';
import 'package:domino/widgets/DP/Edit/dp_edit3_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/apis/services/openai_services.dart';
import 'package:domino/widgets/DP/ai_popup.dart';

class EditInput2Page extends StatefulWidget {
  final String mandalart;
  final String firstColor;
  final String? mainGoalId;

  const EditInput2Page(
      {super.key,
      required this.firstColor,
      required this.mandalart,
      required this.mainGoalId});

  @override
  State<EditInput2Page> createState() => _EditInput2PageState();
}

class _EditInput2PageState extends State<EditInput2Page> {
  List<String> _subGoals = [];
  bool _isLoading = false;
  String goal = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context.watch를 통해 goal 업데이트
    final selectedDetailGoalString =
        context.watch<SelectDetailGoal>().selectedDetailGoal;
    final selectedDetailGoal = int.tryParse(selectedDetailGoalString) ?? 0;
    final updatedGoal = context
        .watch<SaveInputtedDetailGoalModel>()
        .inputtedDetailGoal[selectedDetailGoal.toString()];

    print("Updated Goal: $updatedGoal");

    if (goal != updatedGoal) {
      setState(() {
        goal = updatedGoal ?? ""; // goal 값을 업데이트
      });
    }
  }

  Future<void> _fetchSubGoals() async {
    setState(() {
      _isLoading = true; // 로딩 상태로 설정
    });

    try {
      final coreGoal = widget.mandalart; // coreGoal 업데이트
      List<String> subGoals =
          await generateThirdGoals(coreGoal, goal); // 변수 prompt 사용
      setState(() {
        _subGoals = subGoals; // 새로운 세부 목표로 업데이트
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // 로딩 상태 해제
      });
    }
  }

  Future<void> _showAIPopup(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AIPopup(
        mainGoalId: widget.mainGoalId,
        firstColor: widget.firstColor,
        subgoals: _subGoals,
        onRefresh: () async {
          await _fetchSubGoals();
          if (_subGoals.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('데이터를 가져오지 못했습니다.')),
            );
          } else {
            Navigator.pop(context);
            _showAIPopup(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    // selectedDetailGoal을 안전하게 파싱
    final selectedDetailGoalString =
        context.watch<SelectDetailGoal>().selectedDetailGoal;
    final selectedDetailGoal = int.tryParse(selectedDetailGoalString) ?? 0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: backgroundColor,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              CustomIconButton(() {
                context.read<TestInputtedActionPlanModel>().resetActionPlans();
                Navigator.pop(context);
              }, Icons.keyboard_arrow_left_rounded, currentWidth)
                  .customIconButton(),
              const SizedBox(width: 10),
              DPTitleText('플랜 수정하기', currentWidth).dPTitleText(),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true; // 로딩 시작
                  });
                  await _fetchSubGoals();
                  setState(() {
                    _isLoading = false; // 로딩 종료
                  });
                  _showAIPopup(context);
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                  backgroundColor: const Color(0xff303030),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator() // 로딩 중일 때 로딩 인디케이터 표시
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/img/AIIcon.png',
                              height: currentWidth < 600 ? 15 : 18),
                          SizedBox(width: currentWidth < 600 ? 4 : 7),
                          Text(
                            'Ask AI',
                            style: TextStyle(
                              fontSize: currentWidth < 600 ? 13 : 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: currentWidth < 600 ? 10 : 20),
                    DPGuideText("세부 목표를 위한 구체적인 계획이에요.", currentWidth)
                        .dPGuideText(),
                    SizedBox(height: currentWidth < 600 ? 14 : 20),
                    DPMainGoal(
                            widget.mandalart,
                            ColorTransform(widget.firstColor).colorTransform(),
                            currentHeight,
                            currentWidth)
                        .dpMainGoal(),
                    SizedBox(height: currentWidth < 600 ? 20 : 15),
                    Center(
                      child: SizedBox(
                        width: currentHeight * 0.4,
                        child: GridView(
                          shrinkWrap: true, // GridView를 자식으로 설정
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          children: [
                            // Index 0
                            EditInput2(
                              actionPlanId: 0,
                              selectedDetailGoalId: selectedDetailGoal,
                            ),
                            // Index 1
                            EditInput2(
                              actionPlanId: 1,
                              selectedDetailGoalId: selectedDetailGoal,
                            ),
                            // Index 2
                            EditInput2(
                              actionPlanId: 2,
                              selectedDetailGoalId: selectedDetailGoal,
                            ),
                            // Index 3
                            EditInput2(
                              actionPlanId: 3,
                              selectedDetailGoalId: selectedDetailGoal,
                            ),
                            // Index 4 (Special handling)
                            Container(
                              width: 80,
                              color: const Color(0xff929292),
                              margin: const EdgeInsets.all(1.0),
                              child: Center(
                                child: AutoSizeText(
                                    maxLines: 3, // 최대 줄 수 (필요에 따라 변경 가능)
                                    minFontSize: 6,
                                    maxFontSize: 16, // 최소 글씨 크기
                                    overflow: TextOverflow
                                        .ellipsis, // 내용이 너무 길 경우 생략 표시
                                    context
                                                .watch<
                                                    SaveInputtedDetailGoalModel>()
                                                .inputtedDetailGoal[
                                            selectedDetailGoal.toString()] ??
                                        '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: backgroundColor,
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ),
                            // Index 5
                            EditInput2(
                              actionPlanId: 5,
                              selectedDetailGoalId: selectedDetailGoal,
                            ),
                            // Index 6
                            EditInput2(
                              actionPlanId: 6,
                              selectedDetailGoalId: selectedDetailGoal,
                            ),
                            // Index 7
                            EditInput2(
                              actionPlanId: 7,
                              selectedDetailGoalId: selectedDetailGoal,
                            ),
                            // Index 8
                            EditInput2(
                              actionPlanId: 8,
                              selectedDetailGoalId: selectedDetailGoal,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: currentWidth < 600 ? 15 : 25),
                      Description2(widget.firstColor, currentWidth)
                          .description2(),
                      SizedBox(height: currentWidth < 600 ? 15 : 25),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: Padding(padding: fullPadding, child: 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              NewButton(
                Colors.black,
                Colors.white,
                '취소',
                () {
                  // TestInputtedActionPlanModel 초기화
                  context
                      .read<TestInputtedActionPlanModel>()
                      .resetActionPlans();
                  Navigator.pop(context);
                }, currentWidth
              ).newButton(),
              NewButton(
                Colors.black,
                Colors.white,
                '완료',
                () {
                  // 모델 가져오기
                  final testModel = context.read<TestInputtedActionPlanModel>();
                  final saveModel = context.read<SaveInputtedActionPlanModel>();

                  // TestInputtedActionPlanModel의 데이터를 SaveInputtedActionPlanModel로 복사
                  for (int goalId = 0;
                      goalId < testModel.inputtedActionPlan.length;
                      goalId++) {
                    testModel.inputtedActionPlan[goalId].forEach((key, value) {
                      saveModel.updateActionPlan(goalId, key, value);
                    });
                  }

                  Navigator.pop(context);
                },currentWidth
              ).newButton(),
            ]),),
    );
  }
}
