import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/screens/DP/Create/dp_create2_page.dart';
import 'package:domino/styles.dart';
import 'package:domino/widgets/DP/Create/dp_create3_widget.dart';
import 'package:domino/widgets/DP/Create/dp_description2_widget.dart';
import 'package:domino/widgets/DP/ai_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/apis/services/openai_services.dart';

class DPcreateInput1Page extends StatefulWidget {
  final String firstColor;
  final String? mainGoalId;

  const DPcreateInput1Page(
      {super.key, required this.firstColor, required this.mainGoalId});

  @override
  State<DPcreateInput1Page> createState() => _DPcreateInput1Page();
}

class _DPcreateInput1Page extends State<DPcreateInput1Page> {
  //String Clicked = 'no';
  List<String> _subGoals = [];
  bool _isLoading = false;
  String goal = "";
  int howMany = 9;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // context.watch를 통해 goal 업데이트
    final updatedGoal = context.watch<SelectFinalGoalModel>().selectedFinalGoal;


    if (goal != updatedGoal) {
      setState(() {
        goal = updatedGoal; // goal 값을 업데이트
      });
    }
  }

  Future<void> _fetchSubGoals() async {
    setState(() {
      _isLoading = true; // 로딩 상태로 설정
    });

    try {
      List<String> subGoals = await generateSubGoals(goal); // 변수 prompt 사용
      setState(() {
        _subGoals = subGoals; // 새로운 세부 목표로 업데이트
        print('_subGoals=$_subGoals');
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
    if (_subGoals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('세부 목표가 없습니다.')),
      );
      return;
    }
    await showDialog(
      context: context,
      builder: (BuildContext context) => AIPopup(
        firstColor: widget.firstColor,
        mainGoalId: widget.mainGoalId,
        subgoals: _subGoals,
        onRefresh: () async {
          await _fetchSubGoals();
          Navigator.pop(context);
          _showAIPopup(context); // 새 팝업 표시
        },
      ),
    );
  }

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
                context.read<TestInputtedDetailGoalModel>().resetDetailGoals();
                Navigator.pop(context);
              }, Icons.keyboard_arrow_left_rounded, currentWidth)
                  .customIconButton(),
              const SizedBox(width: 10),
              DPTitleText('플랜 만들기', currentWidth).dPTitleText(),
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
                  //_aiPopup(context, _subGoals);
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
                      DPGuideText("최종 목표를 이루기 위한 세부 목표에요.", currentWidth)
                          .dPGuideText(),
                      SizedBox(height: currentWidth < 600 ? 14 : 20),
                      DPMainGoal(
                              context
                                  .watch<SelectFinalGoalModel>()
                                  .selectedFinalGoal,
                              ColorTransform(widget.firstColor)
                                  .colorTransform(),
                              currentHeight,
                              currentWidth)
                          .dpMainGoal(),
                      SizedBox(height: currentWidth < 600 ? 10 : 15),
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
                                          mainAxisSpacing: 5),
                                  children: [
                                    const Input1(selectedDetailGoalId: 0),
                                    const Input1(selectedDetailGoalId: 1),
                                    const Input1(selectedDetailGoalId: 2),
                                    const Input1(selectedDetailGoalId: 3),
                                    Container(
                                      width: 80,
                                      margin: const EdgeInsets.all(1.0),
                                      padding: const EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3),
                                        color: ColorTransform(widget.firstColor)
                                            .colorTransform(),
                                      ),
                                      child: Center(
                                        child: AutoSizeText(
                                            maxLines:
                                                3, // 최대 줄 수 (필요에 따라 변경 가능)
                                            minFontSize: 6,
                                            maxFontSize: 16, // 최소 글씨 크기
                                            overflow: TextOverflow
                                                .ellipsis, // 내용이 너무 길 경우 생략 표시
                                            context
                                                .watch<SelectFinalGoalModel>()
                                                .selectedFinalGoal,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                    ),
                                    const Input1(selectedDetailGoalId: 5),
                                    const Input1(selectedDetailGoalId: 6),
                                    const Input1(selectedDetailGoalId: 7),
                                    const Input1(selectedDetailGoalId: 8),
                                  ]))),
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
                    // TestInputtedDetailGoalModel만 초기화
                    context
                        .read<TestInputtedDetailGoalModel>()
                        .resetDetailGoals();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DPcreate99Page(
                                firstColor: widget.firstColor,
                                mainGoalId: widget.mainGoalId,
                              )),
                    );
                  },
                  currentWidth,
                ).newButton(),
                NewButton(Colors.black, Colors.white, '저장', () {
                  // 현재 context를 통해 두 모델에 접근
                  final testModel = context.read<TestInputtedDetailGoalModel>();
                  final saveModel = context.read<SaveInputtedDetailGoalModel>();
                  // TestInputtedDetailGoalModel의 데이터를 SaveInputtedDetailGoalModel로 복사
                  testModel.testinputtedDetailGoal.forEach((key, value) {
                    saveModel.updateDetailGoal(key, value); // Save 모델에 값 저장
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DPcreate99Page(
                              firstColor: widget.firstColor,
                              mainGoalId: widget.mainGoalId,
                            )),
                  );
                }, currentWidth)
                    .newButton()
              ])
            ],
          )),
    );
  }
}
