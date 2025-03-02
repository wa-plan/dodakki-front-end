import 'package:domino/provider/DP/model.dart';
import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/styles.dart';
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
  Widget renderTextFormField({
    required FormFieldSetter onSaved,
    required FormFieldValidator validator,
    required double currentWidth
  }) {
    return SizedBox(
      height: currentWidth < 600 ? 45 : 50,
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        controller: dominoController,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          filled: true,
        fillColor: const Color(0xff2A2A2A),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
         contentPadding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
          
          suffixIcon: dominoController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    dominoController.clear();
                  },
                  icon:  Icon(
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
          child: DPTitleText('도미노 만들기', currentWidth).dPTitleText(),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: currentWidth < 600 ? 15 : 25),
                    DPGuideText('더 구체적으로 바꿀 수 있어요.', currentWidth).dPGuideText(),
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
                    SizedBox(height: currentWidth < 600 ? 15 : 25),
                    DPGuideText('더 구체적으로 바꿀 수 있어요.', currentWidth).dPGuideText(),
                    SizedBox(height: currentWidth < 600 ? 15 : 25),
                    Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xff2A2A2A),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          width: currentWidth < 600 ? 300 : 500,
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
                        SizedBox(height: currentWidth < 600 ? 10 : 15),
                        SizedBox(
                          height: currentWidth < 600 ? 7 : 10,
                          child: Switch(
                            activeColor: Colors.white,
                            activeTrackColor: const Color(0xff18AD00),
                            inactiveTrackColor: const Color(0xff5D5D5D),
                            inactiveThumbColor: Colors.white,
                            value: switchValue,
                            onChanged: (value) {
                              setState(() {
                                switchValue = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    if (switchValue) const RepeatSettings() // 반복 설정 위젯 추가
                  ],
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xff131313),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                child: const Text(
                  '이전',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();

                    DateTime? pickedDate =
                        context.read<DateProvider>().pickedDate;

                    if (pickedDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('날짜를 선택해 주세요.')),
                      );
                    } else {
                      context
                          .read<DateListProvider>()
                          .setInterval(switchValue, pickedDate);
                      List<DateTime> dateList =
                          context.read<DateListProvider>().dateList;
                      repeatInfo =
                          context.read<DateListProvider>().repeatInfo();
                      print('repeatInfo=$repeatInfo');
                      addDomino(widget.thirdGoalId, dominoController.text,
                          dateList, repeatInfo);
                      context.read<SelectAPModel>().selectAP("", null);
                    }
                    context.read<SelectAPModel>().selectAP("플랜선택없음", null);
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                ),
                child: const Text(
                  '완료',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
