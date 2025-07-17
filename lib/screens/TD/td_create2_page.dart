import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_todaysDomino.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/popup.dart';
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
  late TextEditingController dominoController;
  bool switchValue = false;

  String dominoValue = '';
  String repeatInfo = '';

  RepeatSettingsState repeatSettings = RepeatSettingsState();

  @override
  void dispose() {
    dominoController.dispose();
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
    return TextFormField(
      onSaved: onSaved,
      validator: validator,
      controller: dominoController,
      style: const TextStyle(
          color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        focusedErrorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        errorStyle: TextStyle(
            color: mainRed, fontSize: 12, fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: settingGrey, width: 2)),
        filled: true,
        fillColor: const Color(0xff2A2A2A).withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: const EdgeInsets.fromLTRB(22, 17, 22, 17),
        hintStyle: TextStyle(
            color: settingGrey, fontSize: 15, fontWeight: FontWeight.w600),
        suffixIcon: dominoController.text.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      dominoController.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                      child: const Icon(
                        Icons.cancel,
                        size: 17,
                        color: settingGrey,
                      ),
                    ),
                  ),
                ],
              )
            : null,
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
              //뒤로가기 버튼
              CustomBackButton(
                () {
                  PopupDialog.show(context, '지금 나가면,\n만들었던 내용이 사라져!', '잠깐!', true,
                    false, false, true, onCancel: () {
                  Navigator.pop(context);
                }, onSuccess: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TdMain(),
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
              DPTitleText('도미노 만들기', currentWidth).dPTitleText(),
              Spacer(),

              //프로그레스 바 (from style_tutorial.dart)
              ProgressBar(1, 2)
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              //❤️목표 구체화 카테고리
              TDQuestion('더 구체적으로 바꿔보세요.', currentWidth).tDQuestion(),
              SizedBox(height: 15),
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

              //❤️날짜 설정 카테고리
              SizedBox(height: 40),
              TDQuestion('언제 실행하고 싶나요?', currentWidth).tDQuestion(),
              SizedBox(height: 15),
              const AddCalendar(),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '반복하기',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 42,
                    width: 52,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Switch(
                        activeColor: Colors.white,
                        activeTrackColor: mainRed,
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
              SizedBox(height: 7),
              //반복 옵션 위젯
              if (switchValue) const RepeatSettings() 
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          //이전 버튼
          Expanded(
            flex: 1,
            child: NewButton(Color(0xff2C2C2C), settingGrey, '이전', () {
              Navigator.pop(context);
            }).newButton(),
          ),
          SizedBox(width: 15),
          //완료 버튼
          Expanded(
            flex: currentWidth < 330 ? 2 : 3,
            child: NewButton(mainRed, backgroundColor, '만들기 완료!', () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                DateTime? pickedDate = context.read<DateProvider>().pickedDate;
                repeatInfo = context.read<DateListProvider>().repeatInfo();

                if (pickedDate == null) {
                  TutorialMessage("실행날짜를 선택해주세요.").tutorialMessage(context);
                } else if (switchValue == true && repeatInfo == "NONE") {
                  TutorialMessage("반복 종류를 선택해주세요.").tutorialMessage(context);
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
            }).newButton(),
          ),
        ]),
      ),
    );
  }
}
