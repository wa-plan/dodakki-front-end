import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/screens/DP/Create/full_mandalart_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_todaysDomino.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/apis/services/dp_services.dart';

class DPcreateSelectPage extends StatefulWidget {
  final List<Map<String, dynamic>> emptyMainGoals;
  final List<Map<String, dynamic>> secondGoals;
  const DPcreateSelectPage(
      {super.key, required this.emptyMainGoals, required this.secondGoals});

  @override
  State<DPcreateSelectPage> createState() => _DPcreateSelectPageState();
}

class _DPcreateSelectPageState extends State<DPcreateSelectPage> {
  String selectedGoalId = "";
  String selectedGoalName = '';
  List<Map<String, dynamic>> mainGoals = [];
  List<Map<String, dynamic>> emptyMainGoals = [];
  List<Map<String, dynamic>> secondGoals = [];
  String firstGoalColor = "0xff000000";
  bool showGrid = false;
  String guide = "클릭해서 목표를 선택해 주세요.";

  @override
  void initState() {
    super.initState();
    _mainGoalList();
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
        firstGoalColor = result[0]['color'];
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
              //뒤로가기 버튼
              CustomBackButton(
                () {
                  Navigator.pop(context);
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.build_rounded,
                color: mainRed,
                size: 19,
              ),
              SizedBox(width: 7),
              DPTitleText('플랜 만들기', currentWidth).dPTitleText(),
              Spacer(),

              //프로그레스 바 (from style_tutorial.dart)
              ProgressBar(0, 3)
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
            //❤️목표 선택 카테고리
            TDQuestion('어떤 목표와 관련됐나요?', currentWidth).tDQuestion(),
            SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.fromLTRB(22, 0, 22, 0),
              alignment: Alignment.centerLeft,
              height: 61,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xff2C2C2C),
              ),
              child: DropdownButton<String>(
                value: selectedGoalId.isEmpty ? '0' : selectedGoalId,
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
                          color: isGuideText ? settingGrey : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Pretendard',
                          fontSize: 15),
                    ),
                  );
                }).toList(),
                onChanged: (String? value) async {
                  if (value != null) {
                    setState(() {
                      selectedGoalId = value;
                      showGrid = value != '0';
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

                      await _fetchSecondGoals(value);
                    }
                  } else {}
                },
                isExpanded: true,
                dropdownColor: const Color(0xff2C2C2C),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: settingGrey,
                  size: 30,
                ),
                underline: Container(),
                elevation: 0,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            SizedBox(height: 80),
            //❤️선택한 목표 박스 위젯
            if (showGrid)
              Center(
                child: Container(
                    height: 150,
                    width: 150,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: ColorTransform(firstGoalColor).colorTransform()),
                    child: Center(
                        child: AutoSizeText(
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            selectedGoalName,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: backgroundColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            )))),
              )
            else
              const SizedBox.shrink(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //취소 버튼
            Expanded(
              flex: 1,
              child: NewButton(Color(0xff2C2C2C), settingGrey, '취소', () {
                Navigator.pop(context);
              }).newButton(),
            ),
            SizedBox(width: 15),
            //다음 버튼
            Expanded(
              flex: currentWidth < 330 ? 2 : 3,
              child: NewButton(mainRed, backgroundColor, '다음', () {
                if (selectedGoalName != '') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DPcreate99Page(
                        edit: false,
                        mainGoalId: selectedGoalId,
                        firstGoalColor:
                            ColorTransform(firstGoalColor).colorTransform(),
                        firstGoalName: selectedGoalName,
                        secondGoals: widget.secondGoals,
                      ),
                    ),
                  );
                } else {
                  TutorialMessage(
                    "드롭다운에서 목표를 선택해 주세요.",
                  ).tutorialMessage(context);
                }
              }).newButton(),
            ),
          ],
        ),
      ),
    );
  }
}
