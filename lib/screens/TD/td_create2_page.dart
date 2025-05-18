import 'package:domino/provider/DP/model.dart';
import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/provider/TD/date_provider.dart';
import 'package:domino/widgets/TD/add_calendar.dart';
import 'package:domino/widgets/TD/repeat_settings.dart';
import 'package:provider/provider.dart';
import 'package:domino/apis/services/td_services.dart';

class AddPage2 extends StatefulWidget {
  final int thirdGoalId;
  final String thirdGoalName;

  const AddPage2({
    super.key,
    required this.thirdGoalId,
    required this.thirdGoalName,
  });

  @override
  State<AddPage2> createState() => AddPage2State();
}

class AddPage2State extends State<AddPage2> {
  late int thirdGoalId;

  final formKey = GlobalKey<FormState>();
  late TextEditingController dominoController; // 'late'로 나중에 초기화될 것을 명시
  bool switchValue = false;

  String dominoValue = '';
  String repeatInfo = '';

  RepeatSettingsState repeatSettings =
      RepeatSettingsState(); // RepeatSettingsState 인스턴스 생성

  @override
  void dispose() {
    dominoController.dispose(); // 컨트롤러는 사용이 끝난 후 dispose로 메모리 정리
    super.dispose();
  }

  // 도미노 추가 함수
  void addDomino(int thirdGoalId, String name, List<DateTime> dateList,
      String repetition) async {
    final success = await AddDominoService.addDomino(
        thirdGoalId: thirdGoalId,
        name: name,
        dates: dateList,
        repetition: repetition);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TdMain(),
        ),
      );
    }
  }

  // 텍스트폼필드 함수
  Widget renderTextFormField(
      {required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      required double currentWidth}) {
    return SizedBox(
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        controller: dominoController,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w400, fontSize: 14),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(17, 10, 17, 10),
          filled: true,
          fillColor: const Color(0xff2A2A2A),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
          ),
          errorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
          focusedErrorBorder:
              OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xffAAAAAA))),
          errorStyle: TextStyle(
              color: mainRed, fontSize: 12, fontWeight: FontWeight.w400),
          suffixIcon: dominoController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    dominoController.clear();
                  },
                  icon: Icon(
                    Icons.cancel,
                    size: currentWidth < 600 ? 14 : 16,
                    color: const Color.fromARGB(255, 98, 98, 98),
                  ),
                )
              : null,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    dominoController = TextEditingController(
        text: widget.thirdGoalName); // initState에서 widget에 접근하여 초기화
    context.read<DateProvider>().clearPickedDate();
    thirdGoalId = widget.thirdGoalId;
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
              CustomIconButton(() {
                context
                    .read<SelectAPModel>()
                    .selectAP("제3목표를 클릭하여 선택해주세요.", null);
                context
                    .read<SelectRepeatModel>()
                    .selectRepeat(false, false, false, false);
                Navigator.pop(context);
                Navigator.pop(context);
              }, Icons.keyboard_arrow_left_rounded, currentWidth)
                  .customIconButton(),
              SizedBox(width: currentWidth < 600 ? 10 : 14),
              Text('도미노 만들기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 27,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff515151), // 첫 번째 색상
                      borderRadius:
                          BorderRadius.circular(currentWidth < 600 ? 2 : 3),
                    ),
                    width: currentWidth < 600 ? 8 : 12,
                    height: currentWidth < 600 ? 8 : 12,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffD9D9D9), // 첫 번째 색상
                      borderRadius:
                          BorderRadius.circular(currentWidth < 600 ? 2 : 3),
                    ),
                    width: currentWidth < 600 ? 8 : 12,
                    height: currentWidth < 600 ? 8 : 12,
                  ),
                ],
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
                    SizedBox(height: currentWidth < 600 ? 15 : 25),
                    DPGuideText('더 구체적으로 바꿔보세요.', currentWidth).dPGuideText(),
                    SizedBox(height: currentWidth < 600 ? 15 : 25),

                    Form(
                      key: formKey,
                      child: renderTextFormField(
                        currentWidth: currentWidth,
                        onSaved: (value) {
                          setState(() {
                            dominoValue = value!;
                          });
                        },
                        validator: (value) {
                          if (value!.length < 1) {
                            return '한 글자 이상 써주세요';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: currentWidth < 600 ? 40 : 40),
                    DPGuideText('언제 실행하고 싶나요?', currentWidth).dPGuideText(),
                    SizedBox(height: currentWidth < 600 ? 15 : 25),
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Color(0xff2A2A2A)),
                          padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                          width: currentWidth < 600 ? 400 : 500,
                          child: const AddCalendar()),
                    ),
                    SizedBox(height: currentWidth < 600 ? 15 : 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '반복하기',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: currentWidth < 600 ? 13 : 16),
                        ),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        SizedBox(
                          height: currentWidth < 600 ? 35 : 45,
                          width: currentWidth < 600 ? 45 : 55,
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: Switch(
                              activeColor: Colors.white,
                              activeTrackColor: const Color(0xff00C300),
                              inactiveTrackColor: const Color(0xff474747),
                              inactiveThumbColor: Colors.white,
                              trackOutlineColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                (Set<WidgetState> states) {
                                  if (true) {
                                    return Colors.transparent;
                                  }
                                },
                              ),
                              value: switchValue,
                              onChanged: (value) {
                                setState(() {
                                  switchValue = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (switchValue) const RepeatSettings() // 반복 설정 위젯 추가
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          NewButton(Colors.black, Colors.white, '이전', () {
            Navigator.of(context).pop();
            context
                .read<SelectRepeatModel>()
                .selectRepeat(false, false, false, false);
          }, currentWidth)
              .newButton(),
          NewButton(Colors.black, Colors.white, '저장', () {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();

              DateTime? pickedDate = context.read<DateProvider>().pickedDate;
              repeatInfo = context.read<DateListProvider>().repeatInfo();

              if (pickedDate == null) {
                Message(
                        "실행날짜를 선택해주세요.",
                        const Color(0xffFF6767), // 텍스트 색상
                        const Color(0xff412C2C), // 배경 색상
                        borderColor: const Color(0xffFF6767), // 테두리 색상
                        icon: Icons.block)
                    .message(context);
              } else if (switchValue == true && repeatInfo == "NONE") {
                Message(
                        "반복 종류를 선택해주세요.",
                        const Color(0xffFF6767), // 텍스트 색상
                        const Color(0xff412C2C), // 배경 색상
                        borderColor: const Color(0xffFF6767), // 테두리 색상
                        icon: Icons.block)
                    .message(context);
              } else {
                context
                    .read<DateListProvider>()
                    .setInterval(switchValue, pickedDate);
                List<DateTime> dateList =
                    context.read<DateListProvider>().dateList;
                addDomino(widget.thirdGoalId, dominoController.text, dateList,
                    repeatInfo);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TdMain(),
                  ),
                );
              }
            }
          }, currentWidth)
              .newButton(),
        ]),
      ),
    );
  }
}
