import 'package:domino/apis/services/openai_services.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class AIPopupDialog extends StatefulWidget {
  final Color firstGoalColor; // 제3목표면 회색 전달
  final String firstGoalName;
  final String secondGoalName; // 제2목표가 없으면 '없음'
  final int howMany;

  const AIPopupDialog({
    super.key,
    required this.firstGoalColor,
    required this.firstGoalName,
    required this.secondGoalName,
    required this.howMany,
  });

  @override
  State<AIPopupDialog> createState() => _AIPopupDialogState();
}

class _AIPopupDialogState extends State<AIPopupDialog> {
  late Future<List<String>> _generatedGoals;
  final Set<String> _selectedGoals = {};

  @override
  void initState() {
    super.initState();
    _generatedGoals = _fetchGoals();
  }

  Future<List<String>> _fetchGoals() async {
    return widget.secondGoalName == '없음'
        ? generateSubGoals(widget.firstGoalName)
        : generateThirdGoals(widget.firstGoalName, widget.secondGoalName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      elevation: 30,
      content: SizedBox(
        width: 350,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/img/AI.png',
                    height: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    '도민호의 ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                  const Text(
                    'AI 추천',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: mainRed,
                    ),
                  ),
                  Spacer(),

                  //❤️나가기 버튼
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.exit_to_app,
                        color: settingGrey, size: 25),
                  ),
                ],
              ),
              const SizedBox(height: 35),

              //❤️추천 목표 리스트
              FutureBuilder<List<String>>(
                future: _generatedGoals,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SizedBox(
                      height: 220,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }

                  final subGoals = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 220,
                        width: 320,
                        child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(6, (index) {
                            final goal = subGoals[index];
                            final isSelected = _selectedGoals.contains(goal);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (!_selectedGoals.add(goal)) {
                                    _selectedGoals.remove(goal);
                                  }
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF2C2C2C),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  goal,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? backgroundColor
                                        : Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      //❤️새로고침 버튼
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _generatedGoals = _fetchGoals();
                          });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh, color: settingGrey, size: 20),
                            SizedBox(width: 5),
                            Text('클릭하여 새로고침',
                                style: TextStyle(
                                    color: settingGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),

              //❤️적용하기 버튼
              SizedBox(
                width: double.infinity,
                child: NewButton(
                  mainRed,
                  backgroundColor,
                  '지금 바로 적용하기',
                  () {
                    if (_selectedGoals.length > widget.howMany) {
                      TutorialMessage(
                        '${widget.howMany}칸 밖에 자리가 없어..!',
                      ).tutorialMessage(context);
                      return;
                    }
                    Navigator.pop(context, _selectedGoals.toList());
                  },
                ).newButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
