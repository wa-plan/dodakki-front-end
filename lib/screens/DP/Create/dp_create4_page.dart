import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/screens/DP/Create/dp_create2_page.dart';
import 'package:domino/styles.dart';
import 'package:domino/widgets/DP/Create/dp_create4_widget.dart';
import 'package:domino/widgets/DP/Create/dp_description2_widget.dart';
import 'package:domino/widgets/DP/ai_popup2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/apis/services/openai_services.dart';

class DPcreateInput2Page extends StatefulWidget {
  final String firstColor;
  final String? mainGoalId;

  const DPcreateInput2Page(
      {super.key, required this.firstColor, required this.mainGoalId});

  @override
  State<DPcreateInput2Page> createState() => _DPcreateInput2PageState();
}

class _DPcreateInput2PageState extends State<DPcreateInput2Page> {
  List<String> _subGoals = [];
  bool _isLoading = false;
  String secondGoal = "";
  String coreGoal = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context.watch를 통해 goal 업데이트
    final selectedDetailGoalString =
        context.watch<SelectDetailGoal>().selectedDetailGoal;
    final selectedDetailGoal = int.tryParse(selectedDetailGoalString) ?? 0;
    final updatedSecondGoal = context
        .watch<SaveInputtedDetailGoalModel>()
        .inputtedDetailGoal[selectedDetailGoal.toString()];

    final updatedCoreGoal = context
        .watch<SelectFinalGoalModel>()
        .selectedFinalGoal; // coreGoal 업데이트

    //print("Updated Goal: $updatedSecondGoal");

    if (secondGoal != updatedSecondGoal) {
      setState(() {
        secondGoal = updatedSecondGoal ?? ""; // goal 값을 업데이트
      });
    }

    if (coreGoal != updatedCoreGoal) {
      setState(() {
        coreGoal = updatedCoreGoal; // goal 값을 업데이트
      });
    }
  }

  Future<void> _fetchSubGoals() async {
    setState(() {
      _isLoading = true; // 로딩 상태로 설정
    });

    try {
      List<String> subGoals =
          await generateThirdGoals(coreGoal, secondGoal); // 변수 prompt 사용
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

  Future<void> _showAIPopup(
      BuildContext context, int selectedDetailGoal) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) => AIPopup2(
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
              DPTitleText('플랜 만들기', currentWidth).dPTitleText(),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  setState(() {
                    int howMany = Provider.of<TestInputtedActionPlanModel>(
                                context,
                                listen: false)
                            .countEmptyValues(selectedDetailGoal) -
                        1;
                    print(howMany);
                    _isLoading = true; // 로딩 시작
                  });
                  await _fetchSubGoals();
                  setState(() {
                    _isLoading = false; // 로딩 종료
                  });
                  _showAIPopup(context, selectedDetailGoal);
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
                          Image.asset('assets/img/AIIcon.png', height: currentWidth < 600 ? 15 : 18),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: currentWidth < 600 ? 15 : 20),
                    DPGuideText("세부 목표를 위한 구체적인 계획이에요.", currentWidth)
                        .dPGuideText(),
                    SizedBox(height: currentWidth < 600 ? 14 : 20),
                    DPMainGoal(
                            context
                                .watch<SelectFinalGoalModel>()
                                .selectedFinalGoal,
                            ColorTransform(widget.firstColor).colorTransform(),
                            currentHeight,
                            currentWidth)
                        .dpMainGoal(),
                    SizedBox(height: currentWidth < 600 ? 10 : 15),
                    
                        Center(
                          child: SizedBox(
                            width: currentHeight*0.4,
                            child: GridView.builder(
                              shrinkWrap: true, // GridView를 자식으로 설정
                              physics:
                                  const NeverScrollableScrollPhysics(), 
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                              ),
                              itemCount: 9,
                              itemBuilder: (context, index) {
                                if (index == 4) {
                                  // 안전한 null 처리
                                  final inputtedDetailGoal = context
                                              .watch<SaveInputtedDetailGoalModel>()
                                              .inputtedDetailGoal[
                                          '$selectedDetailGoal'] ??
                                      '';

                                  return Container(
                                    width: 80,
                                    margin: const EdgeInsets.all(1.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: const Color(0xff929292),
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                            maxLines:
                                                3, // 최대 줄 수 (필요에 따라 변경 가능)
                                            minFontSize: 6,
                                            maxFontSize: 16, // 최소 글씨 크기
                                            overflow: TextOverflow
                                                .ellipsis, // 내용이 너무 길 경우 생략 표시
                                            inputtedDetailGoal,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                            )),
                                    ),
                                  );
                                } else {
                                  return Input2(
                                    actionPlanId: index,
                                    selectedDetailGoalId: selectedDetailGoal,
                                  );
                                }
                              },
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DPcreate99Page(
                              firstColor: widget.firstColor,
                              mainGoalId: widget.mainGoalId,
                            )),
                  );
                },currentWidth
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

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DPcreate99Page(
                              firstColor: widget.firstColor,
                              mainGoalId: widget.mainGoalId,
                            )),
                  );
                },currentWidth
              ).newButton(),
            ]),
          ],
        ),
      ),
    );
  }
}
