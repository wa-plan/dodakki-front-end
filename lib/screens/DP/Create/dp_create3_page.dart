import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/screens/DP/Create/dp_create2_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
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
        secondGoal: context.watch<SelectFinalGoalModel>().selectedFinalGoal,
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
              //나가기 버튼
              CustomBackButton(() {
                context.read<TestInputtedDetailGoalModel>().resetDetailGoals();
                Navigator.pop(context);
              }).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('제2목표 작성').pageTitle(),
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
                  _showAIPopup(context);
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
                          Image.asset('assets/img/AIIcon.png', height: 20),
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
                                        borderRadius: BorderRadius.circular(6),
                                        color: ColorTransform(widget.firstColor)
                                            .colorTransform(),
                                      ),
                                      child: Center(
                                        child: AutoSizeText(
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            context
                                                .watch<SelectFinalGoalModel>()
                                                .selectedFinalGoal,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: backgroundColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15
                                            )),
                                      ),
                                    ),
                                    const Input1(selectedDetailGoalId: 5),
                                    const Input1(selectedDetailGoalId: 6),
                                    const Input1(selectedDetailGoalId: 7),
                                    const Input1(selectedDetailGoalId: 8),
                                  ]))),
                      SizedBox(height: 30),
                      Description2(widget.firstColor).description2(),
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
          //취소
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(
              Colors.black,
              Colors.white,
              '취소',
              () {
                context.read<TestInputtedDetailGoalModel>().resetDetailGoals();
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
          ),
          //저장
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(Colors.black, Colors.white, '저장', () {
              final testModel = context.read<TestInputtedDetailGoalModel>();
              final saveModel = context.read<SaveInputtedDetailGoalModel>();
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
                .newButton(),
          )
        ]),
      ),
    );
  }
}
