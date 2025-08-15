import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/screens/DP/Create/complete_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Create/Around9Grid.dart';
import 'package:domino/widgets/DP/Create/middle9Grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class DPcreateColorPage extends StatefulWidget {
  final String mainGoalId;
  final Color firstGoalColor;
  final String firstGoalName;
  final bool edit;
  final List<Map<String, dynamic>> secondGoals;

  const DPcreateColorPage(
      {super.key,
      required this.mainGoalId,
      required this.firstGoalColor,
      required this.firstGoalName,
      required this.edit,
      required this.secondGoals});

  @override
  DPcreateColorPageState createState() => DPcreateColorPageState();
}

class DPcreateColorPageState extends State<DPcreateColorPage> {
  int selectedIndex = 0;
  int selectColorIndex = -1;

  Future<bool> addSecondGoal() async {
    final success = await AddSecondGoalService.addSecondGoal(
      mandalartId: widget.mainGoalId,
      name: Provider.of<SaveSecondGoalModel>(context, listen: false)
          .secondGoal
          .values
          .toList(),
      color: Provider.of<SaveGoalColor>(context, listen: false)
          .selectedGoalColor
          .values
          .map((color) => '0x${color.value.toRadixString(16)}')
          .toList(),
    );
    return success;
  }

  Future<bool> addThirdGoal() async {
    final saveThirdGoalModel = context.read<SaveThirdGoalModel>();
    final List<List<String>> thirdGoalsValues =
        saveThirdGoalModel.thirdGoal.map((map) {
      return List.generate(9, (i) => map[i.toString()] ?? '');
    }).toList();
    List<int> secondGoalId = [];
    final response =
        await SecondGoalListService.secondGoalList(context, widget.mainGoalId);
    if (response != null) {
      for (var secondGoal in response.first["secondGoals"]) {
        secondGoalId.add(secondGoal["id"]);
      }
    }

    final success = await AddThirdGoalService.addThirdGoal(
      secondGoalId: secondGoalId,
      thirdValues: thirdGoalsValues,
    );

    return success;
  }

  Future<bool> editSecondGoal() async {
    List<int> secondGoalId = [];
    final response =
        await SecondGoalListService.secondGoalList(context, widget.mainGoalId);
    if (response != null) {
      for (var secondGoal in response.first["secondGoals"]) {
        secondGoalId.add(secondGoal["id"]);
      }
    }

    final success = await EditSecondGoalService.editSecondGoal(
        secondGoalId: secondGoalId,
        newSecondGoal: Provider.of<SaveSecondGoalModel>(context, listen: false)
            .secondGoal
            .values
            .toList());
    return success;
  }

  Future<bool> editGoalColor() async {
    final List<String> color =
        Provider.of<SaveGoalColor>(context, listen: false)
            .selectedGoalColor
            .values
            .map((color) => '0x${color.value.toRadixString(16)}')
            .toList();
    List<int> secondGoalId = [];
    final response =
        await SecondGoalListService.secondGoalList(context, widget.mainGoalId);
    if (response != null) {
      final ids = <int>[];
      for (var sg in response.first['secondGoals']) {
        ids.add(sg['id'] as int);
      }
      setState(() {
        secondGoalId = ids;
      });
    } else {}

    final success = await EditGoalColorService.editGoalColor(
      secondGoalId: secondGoalId,
      color: color,
    );

    return success;
  }

  Future<bool> editThirdGoal() async {
    const innerKeys = ['0', '1', '2', '3', '5', '6', '7', '8'];

    final saveThirdGoalModel = context.read<SaveThirdGoalModel>();
    final List<List<String>> thirdGoals = saveThirdGoalModel.thirdGoal
        .map((map) => innerKeys.map((k) => map[k] ?? '').toList())
        .toList();

    final List<Map<String, dynamic>> secondGoals = widget.secondGoals;

    final List<List<int>> thirdGoalIds = secondGoals.map((sg) {
      final tgList = sg['thirdGoals'] as List<dynamic>? ?? [];
      return tgList.map<int>((tg) => tg['id'] as int).toList();
    }).toList();

    final success = await EditThirdGoalService.editThirdGoal(
      thirdGoalIds: thirdGoalIds,
      thirdGoals: thirdGoals,
    );

    return success;
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
                  Navigator.pop(
                    context,
                  );
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
              widget.edit == false ? ProgressBar(2, 3) : ProgressBar(1, 2)
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            //❤️만다라트
            SizedBox(
              width: 269,
              child: GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                children: List.generate(9, (index) {
                  if (index == 4) {
                    //가운데 그리드
                    return Middle9Grid(
                        firstGoalName: widget.firstGoalName,
                        firstColor: widget.firstGoalColor,
                        needColor: true,
                        currentWidth: currentWidth,);
                  }
                  //주변 그리드
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedIndex == index
                              ? Colors.white
                              : backgroundColor,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Around9Grid(
                        secondGoalIndex: index,
                        needColor: true,
                        currentWidth: currentWidth,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Spacer(),

            //❤️색깔 옵션
            Center(
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Color(0xff2C2C2C)),
                  width: 400,
                  child: Center(
                    child: GridView(
                      shrinkWrap: true, // ✅ 중요: 내용 높이만큼만 그리드가 차지함
      physics: NeverScrollableScrollPhysics(), // ✅ 부모 스크롤 안에 있다면 스크롤 제거
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      children: List.generate(colors.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<SaveGoalColor>()
                                .updateGoalColor('$selectedIndex', colors[index]);
                            setState(() {
                              selectColorIndex = index + 1;
                            });
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
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
                    ),
                  )),
            ),
            SizedBox(height: 80)
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          //❤️이전 버튼
          Expanded(
            flex: 1,
            child: NewButton(Color(0xff2C2C2C), settingGrey, '이전', () {
              Navigator.pop(context);
            }).newButton(),
          ),
          SizedBox(width: 15),
          //❤️완료 버튼
          Expanded(
            flex: currentWidth < 330 ? 2 : 3,
            child: NewButton(mainRed, backgroundColor, widget.edit == true ? '플랜 수정 완료!' : '플랜 만들기 완료!', () async {
              _loadingPopup();
            }).newButton(),
          ),
        ]),
      ),
    );
  }

  Future<void> _loadingPopup() async {
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
                      widget.edit == true ? "만다라트 수정 중! 🛠️" : "만다라트 생성 중! 🪄",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ));

    try {
      final secondGoalSuccess =
          widget.edit == false ? await addSecondGoal() : await editSecondGoal();
      if (!secondGoalSuccess) throw Exception('Second goal 저장 실패');

      final thirdGoalSuccess =
          widget.edit == false ? await addThirdGoal() : await editThirdGoal();
      if (!thirdGoalSuccess) throw Exception('Third goal 저장 실패');

      if (widget.edit == true) {
        final colorSuccess = await editGoalColor();
        if (!colorSuccess) throw Exception('색상 저장 실패');
      }

      final mandalartProvider = context.read<MandalartProvider>();
await mandalartProvider.reloadData(context); // ✅ 올바른 호출


      if (mounted) Navigator.pop(context); // 성공 시 팝업 닫기
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CompletePage(
                  edit: widget.edit,
                )),
      );
    } catch (e) {
      if (mounted) Navigator.pop(context); // 실패라도 팝업 닫기

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('저장 중 문제가 발생했습니다.\n오류: $e')),
      );
    }
  }
}
