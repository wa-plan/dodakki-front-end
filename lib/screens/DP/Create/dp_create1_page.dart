import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/DP/Create/dp_create2_page.dart';
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
    final currentHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: currentWidth < 600
              ? const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20)
              : const EdgeInsets.fromLTRB(25.0, 40, 25.0, 20),
          child: Row(
            children: [
              CustomIconButton(() {
                Navigator.of(context).pop();
              }, Icons.keyboard_arrow_left_rounded, currentWidth)
                  .customIconButton(),
              SizedBox(width: currentWidth < 600 ? 10 : 14),
              Text('플랜 만들기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 27,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffD9D9D9), // 첫 번째 색상
                      borderRadius:
                          BorderRadius.circular(currentWidth < 600 ? 2 : 3),
                    ),
                    width: currentWidth < 600 ? 8 : 12,
                    height: currentWidth < 600 ? 8 : 12,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff515151), // 첫 번째 색상
                      borderRadius:
                          BorderRadius.circular(currentWidth < 600 ? 2 : 3),
                    ),
                    width: currentWidth < 600 ? 8 : 12,
                    height: currentWidth < 600 ? 8 : 12,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff515151), // 첫 번째 색상
                      borderRadius:
                          BorderRadius.circular(currentWidth < 600 ? 2 : 3),
                    ),
                    width: currentWidth < 600 ? 8 : 12,
                    height: currentWidth < 600 ? 8 : 12,
                  ),
                ],
              ),
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
            SizedBox(height: currentWidth < 600 ? 10 : 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "어떤 목표를 이루고 싶나요?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: currentWidth < 600 ? 16 : 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: currentWidth < 600 ? 15 : 25),
            Container(
              padding: const EdgeInsets.fromLTRB(17, 0, 17, 0),
              height: currentWidth < 600 ? 40 : 53,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // 검은색 10% 투명도
                    offset: const Offset(0, 0), // X, Y 위치 (0,0)
                    blurRadius: 7, // 블러 7
                    spreadRadius: 0, // 스프레드 0
                  ),
                ],
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
                                fontWeight: FontWeight.w300,
                                fontSize: currentWidth < 600 ? 13 : 17),
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
                      style: const TextStyle(color: Colors.white),
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded, // 원하는 아이콘으로 변경 가능
                        color: const Color(0xff888888),
                        size: currentWidth < 600 ? 22 : 25, // 아이콘 크기 조절
                      ),
                      underline: Container(),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(7),
                    ),
            ),
            SizedBox(height: currentWidth < 600 ? 70 : 130),
            if (showGrid)
              Center(
                child: Container(
                  height: currentHeight*0.17,
                  width: currentHeight*0.17,
                    padding:  EdgeInsets.all(currentWidth < 600 ? 3 : 5),
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(currentWidth < 600 ? 3 : 6),
                        color: ColorTransform(firstColor).colorTransform()),
                    alignment: Alignment.center,
                    child: Center(
                        child: AutoSizeText(
                            maxLines: 3, // 최대 줄 수 (필요에 따라 변경 가능)
                            minFontSize: currentWidth < 600 ? 8 : 10,
                            maxFontSize: currentWidth < 600 ? 15 : 20, 
                            overflow: TextOverflow.ellipsis, // 내용이 너무 길 경우 생략 표시
                            selectedGoalName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: backgroundColor,
                              fontWeight: FontWeight.w600,
                            )))),
              )
            else
              const Expanded(child: SizedBox.shrink()),
            
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: currentWidth < 600
              ? const EdgeInsets.fromLTRB(25.0, 0, 25, 20)
              : const EdgeInsets.fromLTRB(25.0, 0, 25, 20),
        child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NewButton(Colors.black, Colors.white, '취소', () {
                    Navigator.pop(context);
                  }, currentWidth)
                      .newButton(),
                  NewButton(Colors.black, Colors.white, '다음', () {
                    if (selectedGoalName != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DPcreate99Page(
                              mainGoalId: selectedGoalId, firstColor: firstColor),
                        ),
                      );
                    } else {
                      Message('목표를 선택해 주세요.', const Color(0xffFF6767),
                              const Color(0xff412C2C),
                              borderColor: const Color(0xffFF6767),
                              icon: Icons.priority_high)
                          .message(context);
                    }
                  }, currentWidth)
                      .newButton(),
                ],
              ),
      ),
    );
  }
}
