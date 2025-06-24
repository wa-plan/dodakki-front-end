import 'package:domino/provider/DP/model.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/Create/dp_description2_widget.dart';
import 'package:domino/widgets/DP/ai_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class DPcreateInput1Page extends StatefulWidget {
  final String firstGoalName;
  final Color firstGoalColor;
  final bool edit;

  const DPcreateInput1Page(
      {super.key,
      required this.firstGoalName,
      required this.firstGoalColor,
      required this.edit});

  @override
  State<DPcreateInput1Page> createState() => _DPcreateInput1Page();
}

class _DPcreateInput1Page extends State<DPcreateInput1Page> {
  late List<TextEditingController> controllers;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final secondGoalValues =
        context.read<SaveSecondGoalModel>().secondGoal; // 초기 데이터
    final List<String> keys = ['0', '1', '2', '3', '5', '6', '7', '8'];

    controllers = List.generate(
      9,
      (i) => TextEditingController(
        text: (i == 4) ? '' : secondGoalValues[keys[i < 4 ? i : i - 1]] ?? '',
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              CustomBackButton(() {
                Navigator.pop(
                  context,
                );
              }).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle(widget.edit == false ? '제2목표 작성' : '제2목표 수정')
                  .pageTitle(),
              const Spacer(),

              //AI 버튼
              Container(
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff313131),
                      Color(0xff573434), 
                    ],
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: TextButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = false;
                    });

                    final result = await showDialog(
                      context: context,
                      builder: (context) => AIPopupDialog(
                        firstGoalColor: widget.firstGoalColor,
                        firstGoalName: widget.firstGoalName,
                        secondGoalName: '없음',
                        howMany: controllers
                            .where((controller) => controller.text.isEmpty)
                            .length,
                      ),
                    );

                    // 팝업에서 전달된 결과가 있다면 처리
                    if (result != null && result is List<String>) {
                      final selectedGoals = result;

                      int goalIndex = 0;
                      for (int i = 0; i < controllers.length; i++) {
                        if (controllers[i].text.isEmpty &&
                            goalIndex < selectedGoals.length) {
                          controllers[i].text = selectedGoals[goalIndex];
                          goalIndex++;
                        }
                        if (goalIndex >= selectedGoals.length) break;
                      }

                      setState(() {});
                    }
                  },
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                    backgroundColor: Colors.transparent,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/img/AI.png',
                        height: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
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
                      SizedBox(height: 30),
                      SizedBox(
                          width: double.infinity,
                          child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5),
                              itemCount: 9,
                              itemBuilder: (context, index) {
                                if (index == 4) {
                                  //제1목표 그리드
                                  return FreeGrid(widget.firstGoalName,
                                          widget.firstGoalColor, 15)
                                      .freeGrid();
                                } else {
                                  //제2목표 그리드
                                  return Container(
                                    width: 80,
                                    margin: const EdgeInsets.all(1.0),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: const Color(0xff929292),
                                    ),
                                    child: Center(
                                      child: TextFormField(
                                        controller: controllers[index],
                                        style: const TextStyle(
                                            color: backgroundColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600),
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
                                                color: Color.fromARGB(
                                                    255, 104, 104, 104))),
                                      ),
                                    ),
                                  );
                                }
                              })),
                      SizedBox(height: 30),
                      Description2(widget.firstGoalColor),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          )),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          //취소버튼
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(
              Colors.black,
              Colors.white,
              '취소',
              () {
                Navigator.pop(
                  context,
                );
              },
            ).newButton(),
          ),
          //저장버튼
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(Colors.black, Colors.white, '저장', () {
              final model = context.read<SaveSecondGoalModel>();
              for (int i = 0; i < controllers.length; i++) {
                model.updateSecondGoal('$i', controllers[i].text);
              }
              Navigator.pop(context);
            }).newButton(),
          )
        ]),
      ),
    );
  }
}
