import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/DP/Create/dp_create2_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_todaysDomino.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/apis/services/dp_services.dart';

class DPcreateSelectPage extends StatefulWidget {
  final List<Map<String, dynamic>> emptyMainGoals;
  const DPcreateSelectPage({super.key, required this.emptyMainGoals});

  @override
  State<DPcreateSelectPage> createState() => _DPcreateSelectPageState();
}

class _DPcreateSelectPageState extends State<DPcreateSelectPage> {
  String selectedGoalId = "";
  String selectedGoalName = '';
  List<Map<String, dynamic>> mainGoals = [];
  List<Map<String, dynamic>> emptyMainGoals = [];
  List<Map<String, dynamic>> secondGoals = [];
  String firstColor = "0xff000000";
  bool showGrid = false; // 그리드 표시 여부를 결정하는 변수
  bool isLoading = true; // 로딩 상태 관리
  String guide = "클릭해서 목표를 선택해 주세요.";

  @override
  void initState() {
    super.initState();
    _mainGoalList(); // 데이터 로딩 함수 호출
  }

  void _mainGoalList() async {
    List<Map<String, dynamic>>? goals =
        await MainGoalListService.mainGoalList(context);
    if (goals != null) {
      List<Map<String, dynamic>> filteredGoals = [];
      List<Map<String, dynamic>> emptySecondGoals = [];

      for (var goal in goals) {
        final mandalartId = goal['id'].toString();
        final data = await _fetchSecondGoals(mandalartId);
        if (data != null) {
          final secondGoals =
              data[0]['secondGoals'] as List<Map<String, dynamic>>?;

          // UserMandaInfoService를 호출하여 추가 조건 검사
          final userMandaInfo = await UserMandaInfoService.userMandaInfo(
              context,
              mandalartId: int.parse(mandalartId));

          if (secondGoals != null &&
              secondGoals.every((goal) => goal.isEmpty) &&
              userMandaInfo != null &&
              userMandaInfo['status'] == "IN_PROGRESS") {
            emptySecondGoals.add(goal);
          } else {
            filteredGoals.add(goal);
          }
        }
      }

      setState(() {
        mainGoals = filteredGoals;
        emptyMainGoals = emptySecondGoals;
        isLoading = false; // 데이터 로딩 완료 후 로딩 상태 해제
      });
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchSecondGoals(
      String mandalartId) async {
    List<Map<String, dynamic>>? result =
        await SecondGoalListService.secondGoalList(context, mandalartId);

    if (result != null && result.isNotEmpty) {
      setState(() {
        secondGoals = result[0]['secondGoals'];
        firstColor = result[0]['color'];
      });
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
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
                  Navigator.of(context).pop();
                },
              ).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('제1목표 선택').pageTitle(),
              const Spacer(),

              //프로그레스 바 (from style_tutorial.dart)
              ProgressBar(1, 3).progressBar()
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
     
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xff2A2A2A),
              ),
              child: isLoading // 로딩 상태에 따라 표시 변경
                  ? const Center(
                      child: CircularProgressIndicator(
                      color: mainRed,
                      strokeWidth: 4,
                      backgroundColor: Color.fromARGB(255, 79, 79, 79),
                      strokeCap: StrokeCap.round,
                    ))
                  : DropdownButton<String>(
                      value: isLoading || selectedGoalId.isEmpty
                          ? '0'
                          : selectedGoalId,
                      items: [
                        {'id': '0', 'name': guide},
                        ...emptyMainGoals,
                      ].map<DropdownMenuItem<String>>((goal) {
                        final goalName = goal['name'] ?? 'Unknown Goal';
                        final isGuideText = goalName == '클릭해서 목표를 선택해 주세요.';
                        return DropdownMenuItem<String>(
                          value: goal['id'].toString(),
                          child: Text(
                            goalName,
                            style: TextStyle(
                                color: isGuideText
                                    ? const Color(0xff888888)
                                    : Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 15),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) async {
                        if (value != null) {
                          setState(() {
                            selectedGoalId = value;
                            showGrid = value != '0'; // 기본 옵션 선택 시 그리드 숨기기
                            if (value == '0') {
                              selectedGoalName = '';
                            }
                          });

                          if (value != '0') {
                            final selectedGoal = [
                              {'id': '0', 'name': '클릭해서 목표를 선택해 주세요.'},
                              ...emptyMainGoals
                            ].firstWhere(
                              (goal) => goal['id'].toString() == value,
                            );
                            selectedGoalName = selectedGoal['name'] ?? '';
                            context
                                .read<SelectFinalGoalModel>()
                                .selectFinalGoal(selectedGoalName);
                            context
                                .read<SelectFinalGoalId>()
                                .selectFinalGoalId(selectedGoalId);

                            await _fetchSecondGoals(selectedGoalId);
                          }
                        } else {}
                      },
                      isExpanded: true,
                      dropdownColor: const Color(0xff2A2A2A),
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      icon: Icon(
                        Icons.arrow_drop_down_rounded, // 원하는 아이콘으로 변경 가능
                        color: const Color(0xff888888),
                        size: 30, // 아이콘 크기 조절
                      ),
                      underline: Container(),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(6),
                    ),
            ),
            SizedBox(height: 80),
            if (showGrid)
              Center(
                child: Container(
                    height: 150,
                    width: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(8),
                        color: ColorTransform(firstColor).colorTransform()),
                    child: Center(
                        child: AutoSizeText(
                            maxLines: 3, 
                            overflow:
                                TextOverflow.ellipsis, 
                            selectedGoalName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: backgroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            )))),
              )
            else
              const Expanded(child: SizedBox.shrink()),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //취소버튼
            SizedBox(
              width: 90,
              height: 45,
              child: NewButton(Colors.black, Colors.white, '취소', () {
                Navigator.pop(context);
              }, currentWidth)
                  .newButton(),
            ),

            //다음버튼
            SizedBox(
              width: 90,
              height: 45,
              child: NewButton(Colors.black, Colors.white, '다음', () {
                if (selectedGoalName != '') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DPcreate99Page(
                          mainGoalId: selectedGoalId, firstColor: firstColor),
                    ),
                  );
                } else {
                  TutorialMessage(
                        "드롭다운에서 목표를 선택해 주세요.",
                      ).tutorialMessage(context);
                }
              }, currentWidth)
                  .newButton(),
            ),
          ],
        ),
      ),
    );
  }
}
