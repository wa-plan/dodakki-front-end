import 'dart:convert';
import 'package:domino/apis/services/td_services.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:domino/screens/TD/edit_page.dart';
import 'package:intl/intl.dart';
import 'package:domino/style/styles.dart';

class EventCalendar extends StatefulWidget {
  const EventCalendar({super.key});

  @override
  State<EventCalendar> createState() => _EventCalendarState();
}

class _EventCalendarState extends State<EventCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late final ValueNotifier<List<Event>> _selectedEvents;
  bool _isExpanded = false; // 달력 확장 상태

  Future<int?> getThirdGoalId(int mandalartId, String targetThirdGoal) async {
    Map<String, dynamic>? mandalartData =
        await MandalartInfoService.mandalartInfo(mandalartId: mandalartId);

    // ✅ 1. 응답 데이터 전체 출력

    if (mandalartData == null) {
      return null;
    }

    final secondGoals = mandalartData['secondGoals'] as List<dynamic>?;

    if (secondGoals == null) {
      return null;
    }

    // 🔧 문자열 비교 정규화 함수
    String normalize(String input) =>
        input.replaceAll(RegExp(r'\s+'), '').trim().toLowerCase();

    for (var secondGoal in secondGoals) {
      final thirdGoals = secondGoal['thirdGoals'] as List<dynamic>?;

      if (thirdGoals == null) continue;

      for (var thirdGoal in thirdGoals) {
        final String currentGoal =
            (thirdGoal['thirdGoal'] ?? '').toString().trim();

        // ✅ 3. 비교 결과 출력
        if (normalize(currentGoal) == normalize(targetThirdGoal)) {
          final thirdGoalId = thirdGoal['id'] as int;
          return thirdGoalId;
        }

        // 부분 매칭일 경우에도 알려줌
        if (currentGoal.contains(targetThirdGoal.trim())) {}
      }
    }

    return null;
  }

  Future<void> dominoInfo(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final events =
        await DominoInfoService.dominoInfo(context, date: formattedDate);

    if (!mounted) return;

if (events != null) {
  setState(() {
    _selectedEvents.value = events;
  });
} else {
  setState(() {
    _selectedEvents.value = [];
  });
}

  }

  void dominoStatus(int goalId, String attainment, String date) async {
    await DominoStatusService.dominoStatus(
        goalId: goalId, attainment: attainment, date: date);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      dominoInfo(selectedDay);
    }
  }

  // 캘린더 형식을 토글하는 함수
  void _toggleCalendarFormat() {
    setState(() {
      if (_calendarFormat == CalendarFormat.week) {
        _calendarFormat = CalendarFormat.month;
        _isExpanded = true;
      } else {
        _calendarFormat = CalendarFormat.week;
        _isExpanded = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier([]);
    dominoInfo(_selectedDay!);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TableCalendar<Event>(
                  rowHeight: 45,
                  firstDay: DateTime.utc(2014, 1, 1),
                  lastDay: DateTime.utc(2034, 12, 31),
                  focusedDay: _focusedDay,
                  eventLoader: (day) {
                    if (isSameDay(day, _selectedDay)) {
                      return _selectedEvents.value;
                    }
                    return [];
                  },
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: _onDaySelected,
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                      _selectedDay = focusedDay;
                    });
                    dominoInfo(focusedDay);
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  availableCalendarFormats: const {
                    CalendarFormat.month: '열기',
                    CalendarFormat.week: '닫기',
                  },
                  locale: 'ko-KR',
                  calendarStyle: CalendarStyle(
                    markerSize: 0.0,
                    isTodayHighlighted: true,
                    todayDecoration: const BoxDecoration(
                        color: mainGrey, shape: BoxShape.circle),
                    selectedDecoration: const BoxDecoration(
                      color: mainRed,
                      shape: BoxShape.circle,
                    ),
                    //선택된 날짜
                    selectedTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: backgroundColor,
                    ),
                    //오늘 날짜
                    todayTextStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    outsideTextStyle: TextStyle(
                      color: mainGrey,
                      fontSize: 14,
                    ),
                    //보통 날짜
                    defaultTextStyle: TextStyle(
                      color: mainTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    //주말 날짜
                    weekendTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: settingGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: TextStyle(
                      color: settingGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                    leftChevronIcon: Icon(
                      Icons.arrow_circle_left_rounded,
                      color: settingGrey,
                      size: 22,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_circle_right_rounded,
                      color: settingGrey,
                      size: 22,
                    ),
                    formatButtonVisible: false,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _toggleCalendarFormat,
                      padding: EdgeInsets.zero, 
                      constraints: const BoxConstraints(), 
                      icon: Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up_rounded
                            : Icons.arrow_drop_down_rounded,
                        color: settingGrey,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    if (value.isEmpty) {
                      //❤️오늘의 도미노 없을 때 나오는 위젯
                      return Container(
                        height: 240,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                        decoration: BoxDecoration(
                          color: const Color(0xff2C2C2C),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          children: [
                            Text(
                                  '엇!\n오늘은 도미노가 없어요!\n푹 쉬어가는 날이네요 :)',
                                  style: TextStyle(
                                    color: settingGrey,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    height: 1.7,
                                  ),
                                ),
                              
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.asset(
                                'assets/img/emptyDominho.png',
                                height: currentWidth < 375 ? 160 : 180,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () async {
                              // 롱 프레스 이벤트 처리
                              if (value[index].repetition != 'NONE') {
                                value[index].switchValue = true;
                                if (value[index].repetition == 'EVERYDAY') {
                                  value[index].interval = 1;
                                }
                                if (value[index].repetition == 'EVERYWEEK') {
                                  value[index].interval = 7;
                                }
                                if (value[index].repetition == 'BIWEEKLY') {
                                  value[index].interval = 14;
                                }
                                if (value[index].repetition == 'EVERYMONTH') {
                                  value[index].interval = 31;
                                }
                              } else {
                                value[index].switchValue = false;
                                value[index].interval = 0;
                              }

                              editDialog(
                                  context,
                                  _focusedDay,
                                  value[index].goalName,
                                  value[index].thirdGoal,
                                  value[index].switchValue,
                                  value[index].interval,
                                  value[index].id,
                                  value[index].thirdGoalId,
                                  value[index].color,
                                  currentWidth);
                            },
                            //❤️오늘의 도미노 위젯
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 12),
                              padding: EdgeInsets.fromLTRB(15,15,20,15),
                              decoration: BoxDecoration(
                                color: const Color(0xff2C2C2C),
                                borderRadius: BorderRadius.circular(6),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.02), 
                                    offset: const Offset(0, 0), 
                                    blurRadius: 15, 
                                    spreadRadius: 0, 
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 13,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(
                                            value[index]
                                                .color
                                                .replaceAll('Color(', '')
                                                .replaceAll(')', ''),
                                          )),
                                          borderRadius:
                                              BorderRadius.circular(3),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width:
                                                currentWidth < 600 ? 100 : 200,
                                            child: Text(
                                              value[index].thirdGoal,
                                              overflow: TextOverflow
                                                  .ellipsis, 
                                              maxLines: 1, 
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      settingGrey),
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  2),
                                          SizedBox(
                                            width:
                                                currentWidth < 600 ? 100 : 200,
                                            child: Text(
                                              value[index].goalName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  //상태 선택 도형들
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            value[index].didZero =
                                                !value[index].didZero;
                                            value[index].didHalf = false;
                                            value[index].didAll = false;
                                          });
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(_selectedDay!);
                                          dominoStatus(value[index].id, "FAIL",
                                              formattedDate);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(currentWidth < 365 ? 8 : 15),
                                          color: const Color(0xff2A2A2A),
                                          child: Icon(
                                            Icons.clear_outlined,
                                            size: 23,
                                            color: value[index].didZero
                                                ? mainGold
                                                : settingGrey,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            value[index].didHalf =
                                                !value[index].didHalf;
                                            value[index].didZero = false;
                                            value[index].didAll = false;
                                          });
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(_selectedDay!);
                                          dominoStatus(value[index].id,
                                              "IN_PROGRESS", formattedDate);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(currentWidth < 365 ? 8 : 15),
                                          color: const Color(0xff2A2A2A),
                                          child: Icon(
                                            Icons.change_history_outlined,
                                            size: 23,
                                            color: value[index].didHalf
                                                ? mainGold
                                                : settingGrey,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            value[index].didAll =
                                                !value[index].didAll;
                                            value[index].didZero = false;
                                            value[index].didHalf = false;
                                          });
                                          String formattedDate =
                                              DateFormat('yyyy-MM-dd')
                                                  .format(_selectedDay!);
                                          dominoStatus(value[index].id,
                                              "SUCCESS", formattedDate);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(currentWidth < 365 ? 8 : 15),
                                          color: const Color(0xff2A2A2A),
                                          child: Icon(
                                            Icons.circle_outlined,
                                            size: 23,
                                            color: value[index].didAll
                                                ? mainGold
                                                : settingGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//오늘의 도미노 상세 팝업
void editDialog(
    BuildContext context,
    DateTime date,
    String title,
    String content,
    bool switchvalue,
    int interval,
    int mandalartId,
    int thirdGoalId,
    String color,
    double currentWidth) {
  String getIntervalText() {
    if (!switchvalue) {
      return '';
    }

    String weekday = DateFormat('EEEE', 'ko_KR').format(date);
    String dayOfMonth = date.day.toString();

    if (interval == 1) {
      return '매일';
    } else if (interval == 7) {
      return '매주 $weekday';
    } else if (interval == 14) {
      return '격주 $weekday';
    } else if (interval > 14) {
      return '매월 $dayOfMonth일';
    }

    return '';
  }

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        child: SizedBox(
          height: 200,
          width: currentWidth < 370 ? 290 : 340,
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(11))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 16,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(int.parse(
                            color
                                .replaceAll('Color(', '')
                                .replaceAll(')', '')
                                .replaceAll('0x', ''),
                            radix: 16) +
                        0xFF000000),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content,
                      style: TextStyle(
                          color: settingGrey,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 160,
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    SizedBox(height: 25),
                    if (switchvalue)
                      Text(
                        '반복',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      getIntervalText(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPage(date, content, title,
                          switchvalue, interval, mandalartId, thirdGoalId),
                    ),
                  );
                },
                child: Icon(Icons.edit, color: settingGrey,),
                )
                
              ],
            ),
          ),
        ),
      );
    },
  );
}
