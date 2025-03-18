import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:domino/provider/TD/date_provider.dart';
import 'package:domino/apis/services/td_services.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/TD/edit_calendar.dart';
import 'package:domino/widgets/TD/edit_repeat_settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditPage extends StatefulWidget {
  final DateTime date;
  final String title;
  final String content;
  final bool switchValue;
  final int interval;
  final int goalId;
  final int thirdGoalId;

  const EditPage(this.date, this.title, this.content, this.switchValue,
      this.interval, this.goalId, this.thirdGoalId,
      {super.key});
  @override
  State<EditPage> createState() => EditPageState();
}

class EditPageState extends State<EditPage> {
  bool switchValue = false;
  int interval = 0;
  bool everyDay = false;
  bool everyWeek = false;
  bool everyTwoWeek = false;
  bool everyMonth = false;
  final formKey = GlobalKey<FormState>();
  String dominoValue = '';
  late TextEditingController dominoController; //텍스트폼필드에 기본으로 들어갈 초기 텍스트 값

  /*void editDomino(int goalId, String newGoal) async {
    final success =
        await EditDominoService.editDomino(goalId: goalId, newGoal: newGoal);

    if (success) {
      // 성공적으로 서버에 전송된 경우에 처리할 코드
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노가 삭제되었습니다.')),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TdMain(),
          ));
    } else {
      // 실패한 경우에 처리할 코드
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노 삭제에 실패했습니다.')),
      );
    }
  }*/

  void editDominoNew(int thirdGoalId, String name, List<DateTime> dates,
      String repetition) async {
    final success = await EditDominoNewService.editDomino(
        thirdGoalId: thirdGoalId,
        name: name,
        dates: dates,
        repetition: repetition);

    if (success) {
      // 성공적으로 서버에 전송된 경우에 처리할 코드
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노가 삭제되었습니다.')),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TdMain(),
          ));
    } else {
      // 실패한 경우에 처리할 코드
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노 삭제에 실패했습니다.')),
      );
    }
  }

  //텍스트폼필드 함수 만들기
  renderTextFormField(
      {required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      required double currentWidth}) {
    return TextFormField(
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
                icon: Icon(
                  Icons.cancel,
                  size: currentWidth < 600 ? 14 : 16,
                  color: const Color.fromARGB(255, 98, 98, 98),
                ),
              )
            : null,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    dominoController = TextEditingController(text: widget.content);
    switchValue = widget.switchValue;
    interval = widget.interval;
    context.read<DateListProvider>().updateRepeatSettings(interval);
    everyDay = context.read<DateListProvider>().everyDay;
    everyWeek = context.read<DateListProvider>().everyWeek;
    everyTwoWeek = context.read<DateListProvider>().everyTwoWeek;
    everyMonth = context.read<DateListProvider>().everyMonth;
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
          child: DPTitleText('도미노 수정하기', currentWidth).dPTitleText(),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(children: [
          const SizedBox(height: 5),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: currentWidth < 600 ? 15 : 25),
                  DPGuideText('더 구체적으로 바꿀 수 있어요.', currentWidth).dPGuideText(),
                  SizedBox(height: currentWidth < 600 ? 15 : 25),
                  Form(
                    key: formKey,
                    child: renderTextFormField(
                      currentWidth: currentWidth,
                      onSaved: (value) {
                        setState(() {
                          dominoValue = value;
                        });
                      },
                      validator: (value) {
                        if (value.length < 1) {
                          return '한 글자 이상 써주세요';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: currentWidth < 600 ? 15 : 25),
                  DPGuideText('언제 실행하고 싶나요?', currentWidth).dPGuideText(),
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
                          child: EditCalendar(widget.date))), //추가할 때 달력

                  SizedBox(height: 25),

                  //반복하기 기능
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end, //오른쪽 정렬
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

                  if (switchValue)
                    EditRepeatSettings(
                        everyDay, everyWeek, everyTwoWeek, everyMonth),

                  SizedBox(
                    height: 20,
                  ),

                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0xff131313),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0))),
                          child: const Text(
                            '이전',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ), //취소 버튼
                        TextButton(
                          onPressed: () {
                            DateTime? pickedDate =
                                context.read<DateProvider>().pickedDate;
                            context
                                .read<DateListProvider>()
                                .setInterval(switchValue, pickedDate!);
                            List<DateTime> dateList =
                                context.read<DateListProvider>().dateList;
                            String repeatInfo =
                                context.read<DateListProvider>().repeatInfo();
                            print('dateList=$dateList');
                            print('repeatInfo=$repeatInfo');
                            print('골아이디 확인 ${widget.goalId}, ${widget.date}');
                            howDeleteDialog(
                                context, widget.goalId, widget.date);
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFFF6767),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0))),
                          child: const Text(
                            '삭제',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              formKey.currentState!.save();

                              DateTime? pickedDate =
                                  context.read<DateProvider>().pickedDate;

                              if (pickedDate == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('날짜를 선택해 주세요.')),
                                );
                              } else {
                                // 🔹 반복 설정을 적용
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  if (mounted) {
                                    context
                                        .read<DateListProvider>()
                                        .setInterval(switchValue, pickedDate);
                                  }
                                });

                                // 🔹 반복 정보 가져오기
                                String repetition = context
                                    .read<DateListProvider>()
                                    .repeatInfo();
                                List<DateTime> dateList =
                                    context.read<DateListProvider>().dateList;

                                // 🔹 날짜 리스트가 비어 있으면 기본값 설정
                                if (dateList.isEmpty) {
                                  dateList = [pickedDate];
                                }

                                print('전송값 테스트!!');
                                print(widget.goalId);
                                print(dominoController.text);
                                print(dateList);
                                print(repetition);

                                // 🔹 수정 요청 후 성공 여부 확인
                                bool success =
                                    await EditDominoNewService.editDomino(
                                  thirdGoalId: widget.goalId,
                                  name: dominoController.text,
                                  dates: dateList,
                                  repetition: repetition,
                                );

                                if (success) {
                                  // 성공 메시지 출력 후 페이지 이동
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('도미노가 수정되었습니다.')),
                                  );
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TdMain(),
                                    ),
                                  );
                                } else {
                                  // 실패 메시지 출력
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('도미노 수정에 실패했습니다.')),
                                  );
                                }
                              }
                            }
                          },
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0xff131313),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0))),
                          child: const Text(
                            '완료',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ]),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

void howDeleteDialog(BuildContext context, int goalId, DateTime date) {
  void deleteDomino(int goalId) async {
    final success = await DeleteDominoService.deleteDomino(goalId: goalId);

    if (success) {
      // 성공적으로 서버에 전송된 경우에 처리할 코드
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노가 삭제되었습니다.')),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TdMain(),
          ));
    } else {
      // 실패한 경우에 처리할 코드
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노 삭제에 실패했습니다.')),
      );
    }
  }

  void deleteTodayDomino(int goalId, String goalDate) async {
    final success = await DeleteTodayDominoService.deleteTodayDomino(
        goalId: goalId, goalDate: goalDate);

    if (success) {
      // 성공적으로 서버에 전송된 경우에 처리할 코드
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노가 삭제되었습니다.')),
      );

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TdMain(),
          ));
    } else {
      // 실패한 경우에 처리할 코드
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노 삭제에 실패했습니다.')),
      );
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    deleteDomino(goalId);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TdMain(),
                        ));
                  },
                  child: const Text(
                    '앞으로의 도미노 모두 삭제',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(date);
                    print(formattedDate);
                    //date.toIso8601String()
                    deleteTodayDomino(goalId, formattedDate);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TdMain(),
                        ));
                  },
                  child: const Text(
                    '오늘의 도미노만 삭제',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      );
    },
  );
}
