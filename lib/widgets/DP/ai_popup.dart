import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/DP/Create/dp_create3_page.dart';
import 'package:domino/screens/DP/Edit/dp_edit2_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AIPopup extends StatefulWidget {
  final List<String> subgoals;
  final VoidCallback onRefresh;
  final String firstColor;
  final String? mainGoalId;
  final String secondGoal;
  final String mandalart;
  final String page;
  final List<int> secondGoalIds;
  final List<Map<String, dynamic>> secondGoals;
  final int mandalartId;

  const AIPopup(
      {super.key,
      required this.subgoals,
      required this.onRefresh,
      required this.firstColor,
      required this.mainGoalId,
      required this.secondGoal,
      required this.mandalart,
      required this.page,
      required this.secondGoalIds,
      required this.secondGoals,
      required this.mandalartId});

  @override
  _AIPopupState createState() => _AIPopupState();
}

class _AIPopupState extends State<AIPopup> {
  List<String> selectedGoals = [];
  late int howMany;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    howMany = context.watch<TestInputtedDetailGoalModel>().countEmptyKeys() - 1;
  }

  void _handleApply() {
    if (selectedGoals.length > howMany) {
      TutorialMessage("$howMany칸 밖에 자리가 없어..!").tutorialMessage(context);
    } else {
      // Provider를 listen: false로 호출하여 비어있는 key 리스트를 가져오고, key '4'는 제외
      final model =
          Provider.of<TestInputtedDetailGoalModel>(context, listen: false);

      List<String> emptyKeys =
          model.getEmptyKeys().where((key) => key != '4').toList();

      // 선택된 목표를 비어있는 key에 저장
      for (int i = 0; i < selectedGoals.length; i++) {
        if (i < emptyKeys.length) {
          model.updateTestDetailGoal(emptyKeys[i], selectedGoals[i]);
        } else {
          // 비어있는 key가 부족할 경우 경고를 표시하고 중단
          Fluttertoast.showToast(
            msg: "목표를 저장할 공간이 부족합니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          break;
        }
      }

      // 모든 작업이 완료되면 팝업 닫기
      if (widget.page == '수정') {
        print(widget.page);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditInput1Page(
              mandalart: widget.mandalart,
              firstColor: widget.firstColor,
              mainGoalId: widget.mainGoalId,
              secondGoalIds: widget.secondGoalIds,
              secondGoals: widget.secondGoals,
              mandalartId: widget.mandalartId,
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DPcreateInput1Page(
              firstColor: widget.firstColor,
              mainGoalId: widget.mainGoalId,
            ),
          ),
        );
      }
    }
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (selectedGoals.contains(goal)) {
        selectedGoals.remove(goal);
      } else {
        selectedGoals.add(goal);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
      elevation: 30.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      content: SizedBox(
        width: 330,
        child: IntrinsicHeight(
          child: Container(
            padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
            decoration: const BoxDecoration(
                color: Color(0xFF303030),
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: Stack(
              children: [
                Positioned(
                  bottom: -20,
                  right: 0,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      'assets/img/emptyDominho.png',
                      height: 190,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 20),
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(7, 1, 7, 1),
                                  decoration: BoxDecoration(
                                      color: Color(0xff503333),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.secondGoal,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: mainRed,
                                        height: 1.7),
                                  ),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "를 위해",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7),
                            Text(
                              "  내가 추천하는 건..!",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 32,
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 53, 53, 53),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.close,
                              color: Color(0xff646464),
                              size: 17,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AICard(
                                    goal: widget.subgoals[0],
                                    isSelected: selectedGoals
                                        .contains(widget.subgoals[0]),
                                    onTap: _toggleGoal,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: AICard(
                                    goal: widget.subgoals[1],
                                    isSelected: selectedGoals
                                        .contains(widget.subgoals[1]),
                                    onTap: _toggleGoal,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: AICard(
                                    goal: widget.subgoals[2],
                                    isSelected: selectedGoals
                                        .contains(widget.subgoals[2]),
                                    onTap: _toggleGoal,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: AICard(
                                    goal: widget.subgoals[3],
                                    isSelected: selectedGoals
                                        .contains(widget.subgoals[3]),
                                    onTap: _toggleGoal,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: AICard(
                                    goal: widget.subgoals[4],
                                    isSelected: selectedGoals
                                        .contains(widget.subgoals[4]),
                                    onTap: _toggleGoal,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Expanded(
                                  child: AICard(
                                    goal: widget.subgoals[5],
                                    isSelected: selectedGoals
                                        .contains(widget.subgoals[5]),
                                    onTap: _toggleGoal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: widget.onRefresh,
                          child: const Row(
                            children: [
                              Icon(
                                Icons.refresh,
                                color: Color(0xFF5E5E5E),
                                size: 20,
                              ),
                              SizedBox(width: 5),
                              Text(
                                '클릭하여 새로고침',
                                style: TextStyle(
                                    color: Color(0xFF5E5E5E), fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: TextButton(
                        onPressed: _handleApply,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          backgroundColor: mainRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                        ),
                        child: Text(
                          '지금 바로 적용하기',
                          style: TextStyle(
                            color: backgroundColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AICard extends StatefulWidget {
  final String goal;
  final bool isSelected; // 부모 위젯에서 상태를 관리하도록 추가
  final Function(String) onTap;

  const AICard({
    super.key,
    required this.goal,
    required this.isSelected,
    required this.onTap,
  });

  @override
  AICardState createState() => AICardState();
}

class AICardState extends State<AICard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 95,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.isSelected ? Colors.white : const Color(0xFF282828),
        borderRadius: BorderRadius.circular(4),
      ),
      child: GestureDetector(
        onTap: () {
          widget.onTap(widget.goal);
        },
        child: AutoSizeText(
          widget.goal,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: widget.isSelected ? const Color(0xFF303030) : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14),
        ),
      ),
    );
  }
}
