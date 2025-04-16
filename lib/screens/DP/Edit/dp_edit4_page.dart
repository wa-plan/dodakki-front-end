import 'package:auto_size_text/auto_size_text.dart';
import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/screens/DP/Edit/dp_edit5_page.dart';
import 'package:domino/styles.dart';
import 'package:domino/widgets/DP/color_Grid23.dart';
import 'package:domino/widgets/DP/color_Grid2.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class EditColorPage extends StatefulWidget {
  final String mandalart;
  final String firstColor;

  const EditColorPage(
      {super.key, required this.firstColor, required this.mandalart});

  @override
  EditColorPageState createState() => EditColorPageState();
}

class EditColorPageState extends State<EditColorPage> {
  int selectIndex = 0;
  bool isDetailGoalEmpty = false; // 상태 추가
  int selectColorIndex = -1;

  Future<bool> _editSecondGoal() async {
    List<int> secondGoalId =
        Provider.of<SaveEditedDetailGoalIdModel>(context, listen: false)
            .editedDetailGoalId
            .values
            .toList();
    List<String> newSecondGoal =
        Provider.of<SaveInputtedDetailGoalModel>(context, listen: false)
            .inputtedDetailGoal
            .values
            .toList();

    final success = await EditSecondGoalService.editSecondGoal(
      secondGoalId: secondGoalId,
      newSecondGoal: newSecondGoal,
    );

    return success; // Return success to indicate whether the operation was successful
  }

  Future<bool> _editColor() async {
    final List<String> color = Provider.of<GoalColor>(context, listen: false)
        .selectedGoalColor
        .values
        .map((color) => color.toString())
        .toList();

    List<int> secondGoalId =
        Provider.of<SaveEditedDetailGoalIdModel>(context, listen: false)
            .editedDetailGoalId
            .values
            .toList();

    final success = await EditGoalColorService.editGoalColor(
      secondGoalId: secondGoalId,
      color: color,
    );

    return success; // Return success to indicate whether the operation was successful
  }

  Future<bool> _editThirdGoal() async {
    //제3목표 id 가져오기

    final third0id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[0]
            .values
            .toList();

    final third1id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[1]
            .values
            .toList();

    final third2id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[2]
            .values
            .toList();

    final third3id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[3]
            .values
            .toList();

    final third4id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[4]
            .values
            .toList();

    final third5id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[5]
            .values
            .toList();

    final third6id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[6]
            .values
            .toList();

    final third7id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[7]
            .values
            .toList();

    final third8id =
        Provider.of<SaveEditedActionPlanIdModel>(context, listen: false)
            .editedActionPlanId[8]
            .values
            .toList();

    //제3목표 가져오기

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

    final success = await EditThirdGoalService.editThirdGoal(
      third0id: third0id,
      third1id: third1id,
      third2id: third2id,
      third3id: third3id,
      third4id: third4id,
      third5id: third5id,
      third6id: third6id,
      third7id: third7id,
      third8id: third8id,
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
                CustomIconButton(() {
                  PopupDialog.show(
                      context,
                      '지금 나가면,\n작성한 내용이 사라져!',
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

                    // 이전 페이지로 이동
                    Navigator.pop(context);

                    Navigator.pop(context);
                  });
                }, Icons.keyboard_arrow_left_rounded, currentWidth)
                    .customIconButton(),
                const SizedBox(width: 10),
                DPTitleText('플랜 수정하기', currentWidth).dPTitleText(),
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
                        SizedBox(height: currentWidth < 600 ? 15 : 20),
                        DPGuideText('나만의 스타일로 만다라트를 꾸며요.', currentWidth)
                            .dPGuideText(),
                        SizedBox(height: currentWidth < 600 ? 14 : 20),
                        Center(
                          child: Container(
                            width: currentHeight * 0.4,
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: GridView(
                              shrinkWrap: true, // GridView를 자식으로 설정
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
                                              widget.mandalart,
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
                                              color: selectIndex == index
                                                  ? Colors.red
                                                  : backgroundColor,
                                              width: 1,
                                            )
                                          : Border.all(
                                              color: selectIndex == index
                                                  ? const Color.fromARGB(
                                                      255, 125, 125, 125)
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
                          height: 10,
                        ),
                        Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: const Color(0xff2A2A2A)),
                              height: 130,
                              width: 400,
                              child: GridView(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 6,
                                  crossAxisSpacing:
                                      currentWidth < 600 ? 20 : 23,
                                  mainAxisSpacing: currentWidth < 600 ? 20 : 23,
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
                                                BorderRadius.circular(3),
                                            color: colors[index],
                                          ),
                                        ),
                                        if (selectColorIndex == index + 1)
                                          Icon(
                                            Icons.check_circle_rounded,
                                            color: const Color(0xff303030),
                                            size: currentWidth < 600 ? 20 : 22,
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              )),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NewButton(Colors.black, Colors.white, '이전', () {
                        Navigator.pop(context);
                      }, currentWidth)
                          .newButton(),
                      NewButton(Colors.black, Colors.white, '완료', () async {
                        // 👉 로딩 팝업 띄우기
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => AlertDialog(
                            backgroundColor: backgroundColor,
                            content: Row(
                              children: const [
                                CircularProgressIndicator(color: mainRed),
                                SizedBox(width: 20),
                                Text("만다라트를 수정하는 중이야..!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        );

                        // 1. Second Goal 수정
                        final secondGoalSuccess = await _editSecondGoal();

                        if (secondGoalSuccess) {
                          // 2. Goal Color 수정
                          final goalColorSuccess = await _editColor();

                          if (goalColorSuccess) {
                            // 3. Third Goal 수정
                            final thirdGoalSuccess = await _editThirdGoal();

                            if (thirdGoalSuccess) {
                              // 4. 상태 초기화
                              for (int i = 0; i < 9; i++) {
                                context
                                    .read<SaveInputtedDetailGoalModel>()
                                    .updateDetailGoal(i.toString(), "");
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

                              // ✅ 로딩 팝업 닫기 후 페이지 이동
                              Navigator.pop(context); // 로딩 팝업 닫기
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const EditCompletePage(),
                                ),
                              );
                              return;
                            }
                          }
                        }

                        // ❌ 실패했을 경우에도 팝업 닫기
                        Navigator.pop(context);
                      }, currentWidth)
                          .newButton(),
                    ]),
              ],
            )));
  }
}
