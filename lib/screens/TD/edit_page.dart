import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:domino/provider/TD/date_provider.dart';
import 'package:domino/apis/services/td_services.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/style/styles.dart';
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

  Future<bool> deleteDominoToEdit(int thirdGoalId) async {
    final success = await DeleteDominoService.deleteDomino(goalId: thirdGoalId);
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노 삭제에 실패했습니다.')),
      );
    }
    return success;
  }

  Future<bool> addDomino(int thirdGoalId, String name, List<DateTime> dateList,
      String repetition) async {
    final success = await AddDominoService.addDomino(
      thirdGoalId: thirdGoalId,
      name: name,
      dates: dateList,
      repetition: repetition,
    );
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('도미노 추가에 실패했습니다.')),
      );
    }
    return success;
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<DateListProvider>(context, listen: false);
      provider.updateRepeatSettings(interval);

      setState(() {
        everyDay = provider.everyDay;
        everyWeek = provider.everyWeek;
        everyTwoWeek = provider.everyTwoWeek;
        everyMonth = provider.everyMonth;
      });

      print(
          '[EditPage] 초기 반복 값: $everyDay, $everyWeek, $everyTwoWeek, $everyMonth');
    });
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
                Navigator.pop(context);
              }, Icons.keyboard_arrow_left_rounded, currentWidth)
                  .customIconButton(),
              SizedBox(width: currentWidth < 600 ? 10 : 14),
              Text('도미노 수정하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 27,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: currentWidth < 600 ? 15 : 25),
                  DPGuideText('더 구체적으로 바꿔보세요.', currentWidth).dPGuideText(),
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
                          child: EditCalendar(widget.date))), //추가할 때 달력

                  SizedBox(height: currentWidth < 600 ? 15 : 25),

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
                        height: currentWidth < 600 ? 35 : 45,
                        width: currentWidth < 600 ? 45 : 55,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Switch(
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
                                print(
                                    '전달할 값 $everyDay, $everyWeek, $everyTwoWeek, $everyMonth)');
                                switchValue = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (switchValue)
                    EditRepeatSettings(
                      everyDay,
                      everyWeek,
                      everyTwoWeek,
                      everyMonth,
                      key: ValueKey(
                          '$everyDay-$everyWeek-$everyTwoWeek-$everyMonth'), // 👈 추가!
                    ),
                ],
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          NewButton(Colors.black, Colors.white, '이전', () {
            Navigator.pop(context);
          }, currentWidth)
              .newButton(),
          NewButton(Color(0xff6A1B1B), Colors.white, '삭제', () {
            DateTime? pickedDate = context.read<DateProvider>().pickedDate;
            context
                .read<DateListProvider>()
                .setInterval(switchValue, pickedDate!);
            howDeleteDialog(context, widget.goalId, widget.date);
          }, currentWidth)
              .newButton(),
          NewButton(Colors.black, Colors.white, '완료', () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();

              DateTime? pickedDate = context.read<DateProvider>().pickedDate;

              if (pickedDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('날짜를 선택해 주세요.')),
                );
              } else {
                // 🔹 반복 설정을 적용
                context
                    .read<DateListProvider>()
                    .setInterval(switchValue, pickedDate);
                // 🔹 반복 정보 가져오기
                String repetition =
                    context.read<DateListProvider>().repeatInfo();
                List<DateTime> dateList =
                    context.read<DateListProvider>().dateList;

                // 🔹 날짜 리스트가 비어 있으면 기본값 설정
                if (dateList.isEmpty) {
                  dateList = [pickedDate];
                }

                final deleted = await deleteDominoToEdit(widget.goalId);
                if (!deleted) return;

                final added = await addDomino(
                  widget.thirdGoalId,
                  dominoController.text,
                  dateList,
                  repetition,
                );
                if (!added) return;

                // 성공 메시지 출력 후 페이지 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('도미노가 수정되었습니다.')),
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TdMain(),
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

void howDeleteDialog(BuildContext context, int thirdGoalId, DateTime date) {
  void deleteDomino(int thirdGoalId) async {
    final success = await DeleteDominoService.deleteDomino(goalId: thirdGoalId);

    if (success) {
      // 성공적으로 서버에 전송된 경우에 처리할 코드

      Message(
              "도미노가 삭제되었어!.",
              const Color(0xffFF6767), // 텍스트 색상
              const Color(0xff412C2C), // 배경 색상
              borderColor: const Color(0xffFF6767), // 테두리 색상
              icon: Icons.block)
          .message(context);

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

  void deleteTodayDomino(int thirdGoalId, String goalDate) async {
    final success = await DeleteTodayDominoService.deleteTodayDomino(
        goalId: thirdGoalId, goalDate: goalDate);

    if (success) {
      // 성공적으로 서버에 전송된 경우에 처리할 코드
      Message(
              "도미노가 삭제되었어!.",
              const Color(0xffFF6767), // 텍스트 색상
              const Color(0xff412C2C), // 배경 색상
              borderColor: const Color(0xffFF6767), // 테두리 색상
              icon: Icons.block)
          .message(context);

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
                    deleteDomino(thirdGoalId);
                  },
                  child: const Text(
                    '오늘 이후 도미노 모두 삭제',
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
                    deleteTodayDomino(thirdGoalId, formattedDate);
                  },
                  child: const Text(
                    '선택한 날짜의 도미노만 삭제',
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
