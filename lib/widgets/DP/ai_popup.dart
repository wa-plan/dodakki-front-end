import 'package:domino/apis/services/openai_services.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_tutorial.dart';
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
            color: const Color(0xFF303030),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/img/AI.png',
                          height: 22,
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              widget.secondGoalName == '없음'
                                  ? widget.firstGoalName
                                  : widget.secondGoalName,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: widget.firstGoalColor,
                                height: 1,
                              ),
                            ),
                            const Text(
                              '를 위해',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '내가 추천하는 건..!',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.exit_to_app,
                        color: Color(0xff8E8E8E), size: 27),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ───── 추천 목표 리스트 ─────
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
                                      : const Color(0xFF282828),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  goal,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? const Color(0xFF303030)
                                        : Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                      // 새로고침 버튼
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _generatedGoals = _fetchGoals();
                          });
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh,
                                color: Color(0xFF5E5E5E), size: 20),
                            SizedBox(width: 5),
                            Text('클릭하여 새로고침',
                                style: TextStyle(
                                    color: Color(0xFF5E5E5E), fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 40),

              // ───── 적용 버튼 ─────
              SizedBox(
                width: double.infinity,
                height: 45,
                child: LoginButton(
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
                ).loginButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
