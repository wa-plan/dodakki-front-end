//DP 만다라트 9X9 상세 페이지
import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/DP/Create/full_mandalart_page.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/mainPage_mandalart.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class DPdetailPage extends StatelessWidget {
  final String firstGoalName;
  final int mandalartId;
  final List<Map<String, dynamic>> secondGoals;
  final Color firstGoalColor;
  final String dday;

  const DPdetailPage(
      {super.key,
      required this.firstGoalName,
      required this.mandalartId,
      required this.secondGoals,
      required this.firstGoalColor,
      required this.dday});

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: SpeedDial(
        buttonSize: Size(45, 45),
        gradient: LinearGradient(colors: gradientColor),
        icon: Icons.edit,
        overlayColor: Colors.black,
        foregroundColor: backgroundColor,
        gradientBoxShape: BoxShape.circle,
        spacing: 20,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
              child: const Icon(Icons.delete, color: Colors.white, size: 20),
              backgroundColor: backgroundColor,
              labelBackgroundColor: Colors.white,
              elevation: 0,
              labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: backgroundColor,
                  fontSize: 15),
              label: '삭제하기',
              shape: CircleBorder(),
              onTap: () async {
                PopupDialog.show(
                  context,
                  '멋진 계획이었는데,\n이대로 보낼꺼야..?',
                  '헐..!',
                  true,
                  true,
                  false,
                  false,
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onDelete: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => AlertDialog(
                        backgroundColor: backgroundColor,
                        content: Container(
                          height: 130,
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const DominoLoading(),
                              SizedBox(height: 20),
                              Text(
                                "만다라트 삭제 중! 🪦",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );

                    final List<int> secondGoalIds = secondGoals
                        .map<int>(
                            (sg) => (sg['id'] ?? 0) as int) // 각 secondGoal id
                        .where((id) => id != 0) // 0 제외
                        .toSet() // 중복 제거
                        .toList();
                    print(secondGoalIds);

                    final List<int> thirdGoalIds = secondGoals
                        .expand<int>((sg) => // 각 secondGoal 안의 thirdGoals
                            (sg['thirdGoals'] as List<dynamic>? ?? [])
                                .map<int>((tg) => (tg['id'] ?? 0) as int))
                        .where((id) => id != 0) // 0 제외
                        .toSet() // 중복 제거
                        .toList();
                    print(thirdGoalIds);

                    bool allSecondDeleted = true;
                    for (final id in secondGoalIds) {
                      final ok = await DeleteMandalartService.deleteMandalart(
                          context, id);
                      if (!ok) allSecondDeleted = false;
                    }

                    bool allThirdDeleted = true;
                    if (allSecondDeleted) {
                      for (final id in thirdGoalIds) {
                        final ok = await DeleteThirdGoalService.deleteThirdGoal(
                            context, id);
                        if (!ok) {
                          allThirdDeleted = false;
                          break;
                        }
                      }
                    }
                    if (allThirdDeleted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DPMain(),
                        ),
                      );
                    }
                  },
                );
              }),
          SpeedDialChild(
            child: const Icon(Icons.edit, color: Colors.white, size: 20),
            backgroundColor: backgroundColor,
            labelBackgroundColor: Colors.white,
            elevation: 0,
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                color: backgroundColor,
                fontSize: 15),
            label: '수정하기',
            shape: CircleBorder(),
            onTap: () {
              // 1. Provider 가져오기
              final secondGoalProvider = context.read<SaveSecondGoalModel>();
              final thirdGoalProvider = context.read<SaveThirdGoalModel>();
              final goalColorProvider = context.read<SaveGoalColor>();

              // 2. 초기화
              secondGoalProvider.resetAllValues();
              thirdGoalProvider.resetAllValues();
              goalColorProvider.resetAllValues();

              // 3. 값 저장
              for (int i = 0; i < secondGoals.length; i++) {
                final secondGoalText = secondGoals[i]['secondGoal'] ?? '';
                secondGoalProvider.updateSecondGoal(
                    i.toString(), secondGoalText);

                // ⭐️ 컬러 변환 후 저장
                final colorHex = secondGoals[i]['color'];
                final color = ColorTransform(colorHex).colorTransform();
                goalColorProvider.updateGoalColor(i.toString(), color);

                // 제3목표 저장
                final thirdGoals =
                    secondGoals[i]['thirdGoals'] as List<dynamic>? ?? [];
                for (int j = 0; j < thirdGoals.length && j < 9; j++) {
                  final thirdGoalText = thirdGoals[j]['thirdGoal'] ?? '';
                  thirdGoalProvider.updatethirdGoal(
                      i, j.toString(), thirdGoalText);
                }
              }

              // 4. 페이지 이동
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DPcreate99Page(
                    edit: true,
                    firstGoalName: firstGoalName,
                    mainGoalId: mandalartId.toString(),
                    firstGoalColor: firstGoalColor,
                    secondGoals: secondGoals,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: CustomBackButton(
            () {
              Navigator.of(context).pop();
            },
          ).customBackButton(),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            //❤️디데이 태그
            DdayTag(int.parse(dday)).ddayTag(),
            SizedBox(height: 20),
            //❤️만다라트 타이틀
            Text(
              firstGoalName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 30),
            //❤️만다라트
            Center(
                child: InteractiveViewer(
                    onInteractionUpdate: (details) {},
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: MainMandalart(
                      firstGoalName: firstGoalName,
                      secondGoals: secondGoals,
                      mandalartId: mandalartId,
                      firstGoalColor: firstGoalColor,
                      size: currentWidth < 600 ? 320 : 500,
                      detail: true,
                      currentWidth: currentWidth,
                    ))),

            SizedBox(height: 100),
            //❤️안내 문구
            Text(
              "확대 및 클릭해서 자세히 볼 수 있어요",
              style: TextStyle(
                  color: settingGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
