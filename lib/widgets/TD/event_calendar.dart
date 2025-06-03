import 'dart:convert';
import 'package:domino/apis/services/td_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:domino/screens/TD/td_create1_page.dart';
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
    print('📥 요청된 mandalartId=$mandalartId');
    print('🎯 targetThirdGoal: "$targetThirdGoal"');

    Map<String, dynamic>? mandalartData =
        await MandalartInfoService.mandalartInfo(mandalartId: mandalartId);

    // ✅ 1. 응답 데이터 전체 출력
    print('🔍 전체 mandalartData 응답: ${jsonEncode(mandalartData)}');

    if (mandalartData == null) {
      print('⛔ mandalartData is null');
      return null;
    }

    final secondGoals = mandalartData['secondGoals'] as List<dynamic>?;

    if (secondGoals == null) {
      print('⛔ secondGoals is null');
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

        // ✅ 2. 각 thirdGoal 값과 길이 출력
        print('🔹 currentGoal: "$currentGoal" (length: ${currentGoal.length})');
        print(
            '🔸 targetGoal : "${targetThirdGoal.trim()}" (length: ${targetThirdGoal.trim().length})');

        // ✅ 3. 비교 결과 출력
        if (normalize(currentGoal) == normalize(targetThirdGoal)) {
          final thirdGoalId = thirdGoal['id'] as int;
          print('✅ 일치하는 thirdGoalId: $thirdGoalId');
          return thirdGoalId;
        }

        // 부분 매칭일 경우에도 알려줌
        if (currentGoal.contains(targetThirdGoal.trim())) {
          print('⚠️ 부분 포함됨: "$currentGoal"');
        }
      }
    }

    print('❌ thirdGoalId를 찾을 수 없습니다.');
    return null;
  }

  Future<void> dominoInfo(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    final events =
        await DominoInfoService.dominoInfo(context, date: formattedDate);

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
    final success = await DominoStatusService.dominoStatus(
        goalId: goalId, attainment: attainment, date: date);

    if (success) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('업데이트에 실패했습니다.')),
      );
    }
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
                      color: const Color.fromARGB(255, 125, 125, 125),
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
                      color: Color.fromARGB(255, 201, 110, 110),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Color.fromARGB(255, 170, 170, 170),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    weekendStyle: TextStyle(
                      color: Color.fromARGB(255, 201, 110, 110),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 15),
                    leftChevronIcon: Icon(
                      Icons.arrow_back_rounded,
                      color: const Color.fromARGB(255, 170, 170, 170),
                      size: 17,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_rounded,
                      color: const Color.fromARGB(255, 170, 170, 170),
                      size: 17,
                    ),
                    formatButtonVisible: false,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _toggleCalendarFormat,
                      padding: EdgeInsets.zero, // 패딩 설정
                      constraints: const BoxConstraints(), // constraints
                      icon: Icon(
                        _isExpanded
                            ? Icons.arrow_drop_up_rounded
                            : Icons.arrow_drop_down_rounded,
                        color: const Color(0xffD4D4D4),
                        size: 28,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    if (value.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                        decoration: BoxDecoration(
                          color: const Color(0xff2D2D2D),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '오늘은 쓰러뜨릴 도미노가 없어요.\n여유로운 하루를 보내세요 :)',
                                  style: TextStyle(
                                    color: Color(0xff595959),
                                    fontSize: currentWidth < 600 ? 15 : 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.7,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Opacity(
                                    opacity: 0.3,
                                    child: Image.asset(
                                      'assets/img/emptyDominho.png',
                                      height: currentWidth < 600 ? 150 : 300,
                                    ),
                                  ),
                                ),
                              ],
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

                              print('thirdgoalID: ${value[index].thirdGoalId}');

                              //int? thirdGoalId = await getThirdGoalId(
                              //    value[index].id, value[index].thirdGoal);
                              //print('thirdGoalId=$thirdGoalId');

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
                            child: Container(
                              margin: EdgeInsets.fromLTRB(
                                  0, 0, 0, currentWidth < 600 ? 10 : 14),
                              padding: currentWidth < 600
                                  ? EdgeInsets.fromLTRB(15, 15, 30, 15)
                                  : EdgeInsets.fromLTRB(20, 25, 35, 25),
                              decoration: BoxDecoration(
                                color: const Color(0xff2A2A2A),
                                borderRadius: BorderRadius.circular(
                                    currentWidth < 600 ? 5 : 8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withOpacity(0.02), // 검은색 10% 투명도
                                    offset: const Offset(0, 0), // X, Y 위치 (0,0)
                                    blurRadius: 15, // 블러 7
                                    spreadRadius: 0, // 스프레드 0
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
                                        width: currentWidth < 600 ? 13 : 14,
                                        height: currentWidth < 600 ? 60 : 55,
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
                                        width: currentWidth < 600 ? 10 : 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width:
                                                currentWidth < 600 ? 100 : 200,
                                            child: Text(
                                              value[index].thirdGoal,
                                              overflow: TextOverflow
                                                  .ellipsis, // 길면 ...으로 생략
                                              maxLines: 1, // 한 줄로 제한
                                              style: TextStyle(
                                                  fontSize: currentWidth < 600
                                                      ? 11.5
                                                      : 14,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xffAAAAAA)),
                                            ),
                                          ),
                                          SizedBox(
                                              height:
                                                  currentWidth < 600 ? 2 : 5),
                                          SizedBox(
                                            width:
                                                currentWidth < 600 ? 100 : 200,
                                            child: Text(
                                              value[index].goalName,
                                              overflow: TextOverflow
                                                  .ellipsis, // 길면 ...으로 생략
                                              maxLines: 2, // 한 줄로 제한
                                              style: TextStyle(
                                                  fontSize: currentWidth < 600
                                                      ? 14
                                                      : 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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
                                          padding: EdgeInsets.zero, // 패딩 최소화
                                          constraints:
                                              BoxConstraints(), // 기본 제약 조건 제거 (필요 시)
                                          child: Icon(
                                            Icons.clear_outlined,
                                            size: currentWidth < 600 ? 21 : 25,
                                            color: value[index].didZero
                                                ? mainGold
                                                : const Color(0xff646464),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: currentWidth < 600 ? 28 : 30),
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
                                          padding: EdgeInsets.zero, // 패딩 최소화
                                          constraints:
                                              BoxConstraints(), // 기본 제약 조건 제거 (필요 시)
                                          child: Icon(
                                            Icons.change_history_outlined,
                                            size: currentWidth < 600 ? 21 : 25,
                                            color: value[index].didHalf
                                                ? mainGold
                                                : const Color(0xff646464),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: currentWidth < 600 ? 28 : 30),
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
                                          padding: EdgeInsets.zero, // 패딩 최소화
                                          constraints:
                                              BoxConstraints(), // 기본 제약 조건 제거 (필요 시)
                                          child: Icon(
                                            Icons.circle_outlined,
                                            size: currentWidth < 600 ? 21 : 25,
                                            color: value[index].didAll
                                                ? mainGold
                                                : const Color(0xff646464),
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
      return 'X';
    }

    String weekday = DateFormat('EEEE', 'ko_KR').format(date); // 요일을 한국어로 변환
    String dayOfMonth = date.day.toString(); // 날짜 가져오기

    if (interval == 1) {
      return '매일';
    } else if (interval == 7) {
      return '매주 $weekday';
    } else if (interval == 14) {
      return '격주 $weekday';
    } else if (interval > 14) {
      return '매월 $dayOfMonth일';
    }

    return 'X'; // 기본값
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
          width: 340,
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(13))),
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
                              color: Colors.grey,
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
                              maxLines: 2, // 👉 최대 2줄까지만 표시
                              overflow: TextOverflow
                                  .ellipsis, // 👉 2줄 이상일 경우 "..."으로 표시
                              softWrap: true, // 👉 자동 줄바꿈 허용
                            ),
                        ),
                       
                        SizedBox(height: 15),
                        
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
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                        
                       
                      ],
                    ),
                    Spacer(),
                 
                 NewCustomIconButton(() {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditPage(
                                date,
                                content,
                                title,
                                switchvalue,
                                interval,
                                mandalartId,
                                thirdGoalId),
                          ),
                        );
                      }, Icons.edit, currentWidth, 19)
                          .newCustomIconButton(),
                 
               
              ],
            ),
          ),
        ),
      );
    },
  );
}
