import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/screens/DP/Create/dp_create6_page.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/color_Grid23.dart';
import 'package:domino/widgets/DP/color_Grid2.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class DPcreateColorPage extends StatefulWidget {
  final String? mainGoalId;
  final String firstColor;
  const DPcreateColorPage({
    super.key,
    required this.mainGoalId,
    required this.firstColor,
  });

  @override
  DPcreateColorPageState createState() => DPcreateColorPageState();
}

class DPcreateColorPageState extends State<DPcreateColorPage> {
  int selectIndex = 0;
  int selectColorIndex = -1;
  bool isDetailGoalEmpty = false; // 상태 추가

  Future<bool> _addSecondGoal() async {
    final mandalartId = Provider.of<SelectFinalGoalId>(context, listen: false)
        .selectedFinalGoalId;
    List<String> name =
        Provider.of<SaveInputtedDetailGoalModel>(context, listen: false)
            .inputtedDetailGoal
            .values
            .toList();
    final List<String> color = Provider.of<GoalColor>(context, listen: false)
        .selectedGoalColor
        .values
        .map((color) => '0x${color.value.toRadixString(16)}')
        .toList();

    final success = await AddSecondGoalService.addSecondGoal(
      mandalartId: mandalartId,
      name: name,
      color: color,
    );

    return success; // Return success to indicate whether the operation was successful
  }

  Future<bool> _addThirdGoal() async {
    List<int> secondGoalId = [];
    final mandalartId = Provider.of<SelectFinalGoalId>(context, listen: false)
        .selectedFinalGoalId;

    final response =
        await SecondGoalListService.secondGoalList(context, mandalartId);
    if (response != null) {
      for (var secondGoal in response.first["secondGoals"]) {
        secondGoalId.add(secondGoal["id"]);
      }
    }

    final third0 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[0]
            .values
            .toList();
    final third1 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[1]
            .values
            .toList();
    final third2 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[2]
            .values
            .toList();
    final third3 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[3]
            .values
            .toList();
    final third4 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[4]
            .values
            .toList();
    final third5 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[5]
            .values
            .toList();
    final third6 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[6]
            .values
            .toList();
    final third7 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[7]
            .values
            .toList();
    final third8 =
        Provider.of<SaveInputtedActionPlanModel>(context, listen: false)
            .inputtedActionPlan[8]
            .values
            .toList();

    final success = await AddThirdGoalService.addThirdGoal(
      secondGoalId: secondGoalId,
      third0: third0,
      third1: third1,
      third2: third2,
      third3: third3,
      third4: third4,
      third5: third5,
      third6: third6,
      third7: third7,
      third8: third8,
    );

    return success; // Return success to indicate whether the operation was successful
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    List<Color> colors = [
      const Color(0xffFF7A7A),
      const Color(0xffFFB82D),
      const Color(0xffFCFF62),
      const Color(0xff72FF5B),
      const Color(0xff5DD8FF),
      const Color(0xff929292),
      const Color(0xffFF5794),
      const Color(0xffAE7CFF),
      const Color(0xffC77B7F),
      const Color(0xff009255),
      const Color(0xff3184FF),
      const Color(0xff11D1C2),
    ];
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
                    PopupDialog.show(
                        context,
                        '지금 나가면,\n작성한 내용이 사라져!',
                        '잠깐!',
                        true, // cancel
                        false, // delete
                        false, // signout
                        true, //success
                        onCancel: () {
                      // 취소 버튼을 눌렀을 때 실행할 코드
                      Navigator.pop(context);
                    }, onSuccess: () async {
                      for (int i = 0; i < 9; i++) {
                        context
                            .read<SaveInputtedDetailGoalModel>()
                            .updateDetailGoal(i.toString(), "");
                      }

                      for (int i = 0; i < 9; i++) {
                        context
                            .read<TestInputtedDetailGoalModel>()
                            .updateTestDetailGoal(i.toString(), "");
                      }

                      for (int i = 0; i < 9; i++) {
                        context.read<GoalColor>().updateGoalColor(
                            i.toString(), const Color(0xff929292));
                      }

                      for (int i = 0; i < 9; i++) {
                        for (int j = 0; j < 9; j++) {
                          context
                              .read<SaveInputtedActionPlanModel>()
                              .updateActionPlan(i, j.toString(), "");
                        }
                      }

                      for (int i = 0; i < 9; i++) {
                        for (int j = 0; j < 9; j++) {
                          context
                              .read<TestInputtedActionPlanModel>()
                              .updateTestActionPlan(i, j.toString(), "");
                        }
                      }

                      // 팝업 닫기
                      Navigator.pop(context);

                      // DP 메인 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DPMain()),
                      );
                    });
                  },
                ).customBackButton(),
                SizedBox(width: 15),

                //페이지 타이틀
                PageTitle('색깔 입히기').pageTitle(),
                const Spacer(),

                //프로그레스 바 (from style_tutorial.dart)
                ProgressBar(3, 3).progressBar()
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
                        SizedBox(height: 10),
                        Center(
                          child: SizedBox(
                            width: currentHeight * 0.45,
                            child: GridView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                              ),
                              children: List.generate(9, (index) {
                                if (index == 4) {
                                  return SizedBox(
                                    width: 100,
                                    child: GridView.count(
                                      crossAxisCount: 3,
                                      children: [
                                        const ColorBox2(keyNumber: 0),
                                        const ColorBox2(keyNumber: 1),
                                        const ColorBox2(keyNumber: 2),
                                        const ColorBox2(keyNumber: 3),
                                        Container(
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            color: ColorTransform(
                                                    widget.firstColor)
                                                .colorTransform(),
                                          ),
                                          margin: const EdgeInsets.all(1.0),
                                          child: Center(
                                            child: AutoSizeText(
                                              maxLines: 3,
                                              minFontSize: 6,
                                              overflow: TextOverflow.ellipsis,
                                              context
                                                  .watch<SelectFinalGoalModel>()
                                                  .selectedFinalGoal,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                        const ColorBox2(keyNumber: 5),
                                        const ColorBox2(keyNumber: 6),
                                        const ColorBox2(keyNumber: 7),
                                        const ColorBox2(keyNumber: 8),
                                      ],
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectIndex = index;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: isDetailGoalEmpty
                                          ? Border.all(
                                              color: backgroundColor,
                                            )
                                          : Border.all(
                                              color: selectIndex == index
                                                  ? const Color.fromARGB(
                                                      255, 204, 204, 204)
                                                  : backgroundColor,
                                              width: 1,
                                            ),
                                      borderRadius:
                                          BorderRadius.circular(3), // 모서리 둥글게
                                    ),
                                    child: ColorBox(
                                      actionPlanId: index,
                                      goalColorId: index,
                                      detailGoalId: index,
                                      onDetailGoalEmpty: (bool isEmpty) {
                                        if (isDetailGoalEmpty) {
                                          setState(() {
                                            isDetailGoalEmpty = true;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: const Color.fromARGB(255, 39, 39, 39)),
                            height: 130,
                            width: 400,
                            child: GridView(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                              ),
                              children: List.generate(colors.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    context.read<GoalColor>().updateGoalColor(
                                        '$selectIndex', colors[index]);
                                    setState(() {
                                      selectColorIndex = index + 1;
                                    });
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: colors[index],
                                        ),
                                      ),
                                      if (selectColorIndex == index + 1)
                                        Icon(
                                          Icons.check_circle_rounded,
                                          color: backgroundColor,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                );
                              }),
                            )),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 45,
                        child: NewButton(Colors.black, Colors.white, '이전', () {
                          Navigator.pop(context);
                        }, currentWidth)
                            .newButton(),
                      ),
                      SizedBox(
                        width: 90,
                        height: 45,
                        child: NewButton(mainRed, backgroundColor, '완료',
                                () async {
                          _handleSubmitWithDialog();
                        }, currentWidth)
                            .newButton(),
                      ),
                    ]),
              ],
            )));
  }

  Future<void> _handleSubmitWithDialog() async {
    // 1. 로딩 다이얼로그 띄우기
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 눌러도 안 닫힘
      builder: (_) => AlertDialog(
        backgroundColor: backgroundColor,
        content: Row(
          children: const [
            CircularProgressIndicator(color: mainRed),
            SizedBox(width: 20),
            Text("만다라트를 만드는 중이야..!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );

    // 2. 실제 작업
    final secondGoalSuccess = await _addSecondGoal();

    if (secondGoalSuccess) {
      context
          .read<SaveMandalartCreatedGoal>()
          .updateMandalartCreatedGoal("${widget.mainGoalId}");

      final thirdGoalSuccess = await _addThirdGoal();

      if (thirdGoalSuccess) {
        for (int i = 0; i < 9; i++) {
          context
              .read<SaveInputtedDetailGoalModel>()
              .updateDetailGoal(i.toString(), "");
        }

        for (int i = 0; i < 9; i++) {
          context
              .read<GoalColor>()
              .updateGoalColor(i.toString(), const Color(0xff929292));
        }

        for (int i = 0; i < 9; i++) {
          for (int j = 0; j < 9; j++) {
            context
                .read<SaveInputtedActionPlanModel>()
                .updateActionPlan(i, j.toString(), "");
          }
        }

        // 3. 로딩 다이얼로그 닫기
        Navigator.pop(context); // 팝업 닫기

        // 4. 다음 페이지로 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CompletePage()),
        );
        return;
      }
    }

    // 작업 실패 시에도 팝업 닫기
    Navigator.pop(context);
  }
}
