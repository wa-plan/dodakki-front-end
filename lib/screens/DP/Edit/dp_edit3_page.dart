import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/screens/DP/Edit/dp_edit1_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Create/dp_description2_widget.dart';
import 'package:domino/widgets/DP/Edit/dp_edit3_widget.dart';
import 'package:domino/widgets/DP/ai_popup2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/apis/services/openai_services.dart';

class EditInput2Page extends StatefulWidget {
  final String mandalart;
  final String firstColor;
  final String? mainGoalId;
  final List<int> secondGoalIds;
  final List<Map<String, dynamic>> secondGoals;
  final int mandalartId;

  const EditInput2Page(
      {super.key,
      required this.firstColor,
      required this.mandalart,
      required this.mainGoalId,
      required this.secondGoalIds,
      required this.secondGoals,
      required this.mandalartId});

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

  Future<void> _showAIPopup(BuildContext context, int selectedDetailGoal) async {
    await showDialog(
      context: context,
      builder: (BuildContext context,) => AIPopup2(
        selectedDetailGoal: selectedDetailGoal,
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
            _showAIPopup(context, selectedDetailGoal);
          }
        },
        thirdGoal: context
                                                .watch<
                                                    SaveInputtedDetailGoalModel>()
                                                .inputtedDetailGoal[
                                            context.watch<SelectDetailGoal>().selectedDetailGoal.toString()] ??
                                        '',
                                        page: "수정",
        mandalart: widget.mandalart,
        secondGoalIds: widget.secondGoalIds,
        secondGoals: widget.secondGoals,
        mandalartId: widget.mandalartId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
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
              //나가기 버튼
              CustomBackButton(() {
                context.read<TestInputtedActionPlanModel>().resetActionPlans();
                Navigator.pop(context);
              }, )
                  .customBackButton(),
              const SizedBox(width: 15),
              //페이지 타이틀
              PageTitle('제3목표 수정').pageTitle(),
              const Spacer(),
              //AI 버튼
              TextButton(
                onPressed: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  await _fetchSubGoals();
                  setState(() {
                    _isLoading = false;
                  });
                  _showAIPopup(context, selectedDetailGoal);
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                  backgroundColor: const Color.fromARGB(255, 31, 31, 31),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                      color: mainRed,
                    ) 
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset('assets/img/AIIcon.png',
                              height: 20),
                          SizedBox(width: 5),
                          Text(
                            'Ask 도민호',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
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
                    SizedBox(height: 30),
                    Center(
                      child: SizedBox(
                        width: currentHeight * 0.53,
                        child: GridView(
                          shrinkWrap: true, 
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
                                    maxLines: 3, 
                                   
                                    overflow: TextOverflow
                                        .ellipsis,
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
                                      fontSize: 15
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
                    SizedBox(height: 30),
                    Description2(widget.firstColor).description2(),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: Padding(padding: fullPadding, child: 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              SizedBox(
                width: 90,
            height: 45,
                child: NewButton(
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
              ),
              SizedBox(
                width: 90,
            height: 45,
                child: NewButton(
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
                
                    Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Edit99Page(
                          firstColor: widget.firstColor,
                          mandalart: widget.mandalart,
                          mandalartId:widget.mandalartId,
                          secondGoalIds: widget.secondGoalIds,
                          secondGoals: widget.secondGoals,
                        )),

              );
                  },currentWidth
                ).newButton(),
              ),
            ]),),
    );
  }
}
