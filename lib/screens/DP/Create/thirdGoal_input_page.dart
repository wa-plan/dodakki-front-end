import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Create/dp_description2_widget.dart';
import 'package:domino/widgets/DP/ai_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class DPcreateInput2Page extends StatefulWidget {
  final Color firstGoalColor;
  final String secondGoalName;
  final String firstGoalName;
  final int secondGoalIndex;
  final bool edit;

  const DPcreateInput2Page({
    super.key,
    required this.firstGoalColor,
    required this.secondGoalName,
    required this.firstGoalName,
    required this.secondGoalIndex,
    required this.edit,
  });

  @override
  State<DPcreateInput2Page> createState() => _DPcreateInput2PageState();
}

class _DPcreateInput2PageState extends State<DPcreateInput2Page> {
  late List<TextEditingController> controllers;
  final List<String> keys = ['0', '1', '2', '3', '4', '5', '6', '7', '8'];

  @override
  void initState() {
    super.initState();
    final thirdGoal = context.read<SaveThirdGoalModel>().thirdGoal;

    controllers = List.generate(
      9,
      (i) => TextEditingController(
        text: thirdGoal[widget.secondGoalIndex][keys[i]] ?? '',
      ),
    );
  }

  @override
  void dispose() {
    for (final c in controllers) c.dispose();
    super.dispose();
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

              //❤️AI 버튼
              Container(
                height: 35,
                decoration: BoxDecoration(
                  color: Color(0xff2C2C2C),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: TextButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (context) => AIPopupDialog(
                        firstGoalColor: secondGoalColor,
                        firstGoalName: widget.firstGoalName,
                        secondGoalName: widget.secondGoalName,
                        howMany:
                            controllers.where((c) => c.text.isEmpty).length,
                      ),
                    );

                    if (result is List<String>) {
                      int gi = 0;
                      for (int i = 0; i < controllers.length; i++) {
                        if (controllers[i].text.isEmpty && gi < result.length) {
                          controllers[i].text = result[gi++];
                        }
                      }
                    }
                  },
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/img/AI.png',
                        height: 15,
                      ),
                      SizedBox(width: 5),
                      const Text(
                        'Ask 도민호',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                    //❤️설명 문구
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.7,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Pretendard',
                          color: Colors.white,
                        ),
                        children: [
                          const TextSpan(text: '세부 목표를 달성할 수 있는\n'),
                          TextSpan(
                            text: '실행 계획',
                            style: TextStyle(
                              color: mainRed,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Pretendard',
                              fontSize: 15,
                            ),
                          ),
                          const TextSpan(text: '을 만들어봐요!'),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),
                    //❤️만다라트
                    Center(
                      child: SizedBox(
                        width: currentWidth < 600 ? double.infinity : 500,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            if (index == 4) {
                              //제2목표 그리드
                              return FreeGrid(
                                widget.secondGoalName,
                                secondGoalColor,
                                15, currentWidth
                              ).freeGrid();
                            } else {
                              //제3목표 그리드 (입력)
                              return Container(
                                width: 80,
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: thirdGoalColor,
                                ),
                                child: Center(
                                  child: TextFormField(
                                    controller: controllers[index],
                                    style: const TextStyle(
                                      color: backgroundColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLength: 15,
                                    maxLines: null,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(15),
                                    ],
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      counterStyle: TextStyle(
                                        fontSize: 12,
                                        color: Color.fromARGB(255, 99, 99, 99),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    //❤️Smart 기법 드롭다운
                    Description2(widget.firstGoalColor),
                    const SizedBox(height: 20),
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
                "취소",
                () {
                  Navigator.pop(
                    context,
                  );
                },
              ).newButton(),
            ),
            SizedBox(width: 15),
            //❤️완료 버튼
            Expanded(
              flex: currentWidth < 330 ? 2 : 3,
              child: NewButton(
                mainRed,
                backgroundColor,
                '완료',
                () {
                  final model = context.read<SaveThirdGoalModel>();
                  for (int i = 0; i < controllers.length; i++) {
                    model.updatethirdGoal(
                      widget.secondGoalIndex,
                      keys[i],
                      controllers[i].text,
                    );
                  }
                  Navigator.pop(context);
                },
              ).newButton(),
            ),
          ],
        ),
      ),
    );
  }
}
