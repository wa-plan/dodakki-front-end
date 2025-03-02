import 'package:domino/provider/DP/model.dart';
import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:domino/screens/TD/td_main.dart';
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Text(
            '도미노 만들기',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 5),
            Expanded(
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '더 자세하게 바꿀 수 있어요.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Text(
                        '영어 공부를 영단어 5개 암기로!',
                        style: TextStyle(
                            color: mainGold,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.1),
                      ),
                      const SizedBox(height: 13),
                      Form(
                        key: formKey,
                        child: CustomTextField(
                          "",
                          dominoController,
                          (value) {
                            if (value == null || value.isEmpty) {
                              return '한 글자 이상 써주세요';
                            }
                            return null;
                          },
                          false,
                          1,
                        ).textField(),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        '언제 실행하고 싶나요?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xff2A2A2A),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            height: 350,
                            width: 350,
                            child: const AddCalendar()),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '반복하기',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 10,
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
                ],
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
