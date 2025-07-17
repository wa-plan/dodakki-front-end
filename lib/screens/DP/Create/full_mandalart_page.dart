import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/DP/Create/secondGoal_input_page.dart';
import 'package:domino/screens/DP/Create/thirdGoal_input_page.dart';
import 'package:domino/screens/DP/Create/color_select_page.dart';
import 'package:domino/screens/DP/Create/mandalart_example_page.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/popup.dart';
import 'package:domino/widgets/DP/Create/Around9Grid.dart';
import 'package:domino/widgets/DP/Create/middle9Grid.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class DPcreate99Page extends StatefulWidget {
  final bool edit;
  final String mainGoalId;
  final Color firstGoalColor;
  final List<Map<String, dynamic>> secondGoals;
  final String firstGoalName;

  const DPcreate99Page({
    super.key,
    required this.edit,
    required this.firstGoalColor,
    required this.firstGoalName,
    required this.mainGoalId,
    required this.secondGoals,
  });

  @override
  State<DPcreate99Page> createState() => _DPcreate99PageState();
}

class _DPcreate99PageState extends State<DPcreate99Page> {
  @override
  void initState() {
    super.initState();
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
              //❤️뒤로가기 버튼
              CustomBackButton(
                () {
                  PopupDialog.show(context, '지금 나가면,\n작성한 내용이 사라져!', '잠깐!',
                      true, false, false, true, onCancel: () {
                    Navigator.pop(context);
                  }, onSuccess: () {
                    resetAllProviders(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DPMain(),
                      ),
                    );
                  });
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.build_rounded,
                color: mainRed,
                size: 19,
              ),
              SizedBox(width: 7),
              DPTitleText(
                      widget.edit == false ? '플랜 만들기' : '플랜 수정하기', currentWidth)
                  .dPTitleText(),
              Spacer(),

              //❤️프로그레스 바 (from style_tutorial.dart)
              widget.edit == true ? ProgressBar(0, 2) : ProgressBar(1, 3)
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    //❤️최종 목표 박스 위젯
                    DPMainGoal(widget.firstGoalName, widget.firstGoalColor, currentWidth)
                        .dpMainGoal(),
                    const SizedBox(height: 18),
                    //❤️만다라트 위젯
                    Center(
                      child: SizedBox(
                        width: currentWidth < 600 ? double.infinity : 500,
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              if (index == 4) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DPcreateInput1Page(
                                          edit: widget.edit,
                                          firstGoalColor: widget.firstGoalColor,
                                          firstGoalName: widget.firstGoalName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Middle9Grid(
                                    firstGoalName: widget.firstGoalName,
                                    firstColor: widget.firstGoalColor,
                                    needColor: false,
                                    currentWidth: currentWidth,
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            DPcreateInput2Page(
                                          edit: widget.edit,
                                          firstGoalName: widget.firstGoalName,
                                          firstGoalColor: widget.firstGoalColor,
                                          secondGoalIndex: index,
                                          secondGoalName: context.select<
                                              SaveSecondGoalModel, String>(
                                            (model) =>
                                                model.secondGoal[
                                                    index.toString()] ??
                                                '',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Around9Grid(
                                    secondGoalIndex: index,
                                    needColor: false,
                                    currentWidth: currentWidth,
                                  ),
                                );
                              }
                            }),
                      ),
                    ),
                    //❤️만다라트 예시 버튼
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManadaEx(),
                              ),
                            );
                          },
                          
                          child: Container(
                            width: 150,
                            padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  '만다라트 예시',
                                  style: TextStyle(
                                    color: settingGrey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Icon(Icons.tips_and_updates_rounded, color: mainRed, size: 20)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //❤️이전/취소 버튼
            Expanded(
              flex: 1,
              child: NewButton(
                Color(0xff2C2C2C),
                settingGrey,
                widget.edit == true ? "취소" : '이전',
                () {
                  PopupDialog.show(
                    context,
                    '지금 나가면,\n작성한 내용이 사라져!',
                    '잠깐!',
                    true,
                    false,
                    false,
                    true,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSuccess: () {
                      resetAllProviders(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                },
              ).newButton(),
            ),
            SizedBox(width: 15),
            //❤️다음 버튼
            Expanded(
              flex: currentWidth < 330 ? 2 : 3,
              child: NewButton(
                mainRed,
                backgroundColor,
                '다음',
                () {
                  final isSecondGoalAllEmpty =
                      context.read<SaveSecondGoalModel>().isAllEmpty();

                  final isThirdGoalAllEmpty =
                      context.read<SaveThirdGoalModel>().isAllEmpty();

                  if (isSecondGoalAllEmpty) {
                    TutorialMessage('세부 목표를 하나라도 채워줘!')
                        .tutorialMessage(context);
                  } else if (isThirdGoalAllEmpty) {
                    TutorialMessage('루틴이나 일정은 실행계획으로만 만들 수 있어!')
                        .tutorialMessage(context);
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DPcreateColorPage(
                          edit: widget.edit,
                          mainGoalId: widget.mainGoalId,
                          firstGoalColor: widget.firstGoalColor,
                          firstGoalName: widget.firstGoalName,
                          secondGoals: widget.secondGoals,
                        ),
                      ),
                    );
                  }
                },
              ).newButton(),
            ),
          ],
        ),
      ),
    );
  }
}
