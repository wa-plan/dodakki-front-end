import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:domino/provider/TD/date_provider.dart';
import 'package:domino/apis/services/td_services.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/TD/edit_calendar.dart';
import 'package:domino/widgets/TD/edit_repeat_settings.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:domino/style/style_todaysDomino.dart';

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
  late TextEditingController dominoController;
  DateTime today = DateTime.now();

  Future<bool> deleteDominoToEdit(int thirdGoalId) async {
    final success = await DeleteDominoService.deleteDomino(goalId: thirdGoalId);
    return success;
  }

  void deleteTodayDominoToEdit(int goalId, String goalDate) async {
    final success = await DeleteTodayDominoService.deleteTodayDomino(
        goalId: goalId, goalDate: goalDate);

    if (success) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TdMain(),
          ));
    }
  }

  Future<bool> addDomino(int thirdGoalId, String name, List<DateTime> dateList,
      String repetition) async {
    final success = await AddDominoService.addDomino(
      thirdGoalId: thirdGoalId,
      name: name,
      dates: dateList,
      repetition: repetition,
    );
    return success;
  }

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
                  size: 18,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy-MM-dd').format(today);
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
                  PopupDialog.show(context, '지금 나가면,\n수정한 내용이 사라져!', '잠깐!',
                      true, false, false, true, onCancel: () {
                    Navigator.pop(context);
                  }, onSuccess: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
              ).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('도미노 수정하기').pageTitle(),
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
                  children: <Widget>[
                    SizedBox(height: 20),
                    TDQuestion('더 구체적으로 바꿔보세요.', currentWidth).tDQuestion(),
                    SizedBox(height: 15),
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
                    SizedBox(height: 40),
                    TDQuestion('언제 실행하고 싶나요?', currentWidth).tDQuestion(),
                    SizedBox(height: 15),
                
                     Container(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                    width: double.infinity,
                            child: EditCalendar(widget.date)), 
                
                
                    //반복하기 기능
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '반복하기',
                          style: TextStyle(color: Colors.white, fontSize: 15),
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
                
                    if (switchValue)
                      EditRepeatSettings(
                        everyDay,
                        everyWeek,
                        everyTwoWeek,
                        everyMonth,
                        key: ValueKey(
                            '$everyDay-$everyWeek-$everyTwoWeek-$everyMonth'),
                      ),
                  ],
                ),
              ),
            ),
        
       
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(Colors.black, Colors.white, '취소', () {
              //주의 팝업
              PopupDialog.show(context, '지금 나가면,\n수정한 내용이 사라져!', '잠깐!', true,
                  false, false, true, onCancel: () {
                Navigator.pop(context);
              }, onSuccess: () {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              });
            }).newButton(),
          ),
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(Color(0xff6A1B1B), Colors.white, '삭제', () {
              DateTime? pickedDate = context.read<DateProvider>().pickedDate;
              context
                  .read<DateListProvider>()
                  .setInterval(switchValue, pickedDate!);
              howDeleteDialog(context, widget.goalId, widget.date);
            }).newButton(),
          ),
          SizedBox(
            width: 90,
            height: 45,
            child: NewButton(Colors.black, Colors.white, '완료', () async {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();

                DateTime? pickedDate = context.read<DateProvider>().pickedDate;

                if (pickedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('날짜를 선택해 주세요.')),
                  );
                } else {
                  context
                      .read<DateListProvider>()
                      .setInterval(switchValue, pickedDate);
                  String repetition =
                      context.read<DateListProvider>().repeatInfo();
                  List<DateTime> dateList =
                      context.read<DateListProvider>().dateList;

                  if (dateList.isEmpty) {
                    dateList = [pickedDate];
                  }

                  final dominoDeleted = await deleteDominoToEdit(widget.goalId);
                  if (!dominoDeleted) return;

                  final todayDeleted =
                      await DeleteTodayDominoService.deleteTodayDomino(
                    goalId: widget.goalId,
                    goalDate: todayDate,
                  );
                  if (!todayDeleted) return;

                  final added = await addDomino(
                    widget.thirdGoalId,
                    dominoController.text,
                    dateList,
                    repetition,
                  );
                  if (!added) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TdMain(),
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

void howDeleteDialog(BuildContext context, int goalId, DateTime date) {
  DateTime today = DateTime.now();
  String todayDate = DateFormat('yyyy-MM-dd').format(today);

  void deleteDomino(int goalId) async {
    final success = await DeleteDominoService.deleteDomino(goalId: goalId);

    if (success) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TdMain(),
          ));
    }
  }

  void deleteTodayDomino(int goalId, String goalDate) async {
    final success = await DeleteTodayDominoService.deleteTodayDomino(
        goalId: goalId, goalDate: goalDate);

    if (success) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const TdMain(),
          ));
    }
  }

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: Container(
          padding: const EdgeInsets.fromLTRB(5, 25, 5, 25),
          decoration: BoxDecoration(
              color: backgroundColor, borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    deleteDomino(goalId);
                    deleteTodayDomino(goalId, todayDate);
                  },
                  child: const Text(
                    '오늘 이후 도미노 모두 삭제',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(date);
                    deleteTodayDomino(goalId, formattedDate);
                  },
                  child: const Text(
                    '선택한 날짜의 도미노만 삭제',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      );
    },
  );
}
