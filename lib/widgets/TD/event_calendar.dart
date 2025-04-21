import 'dart:convert';

import 'package:domino/apis/services/td_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:domino/screens/TD/td_create1_page.dart';
import 'package:domino/screens/TD/edit_page.dart';
import 'package:intl/intl.dart';
import 'package:domino/styles.dart';

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

  /*void mandalartInfo(context, int mandalartId) async {
    final data =
        await MandalartInfoService.mandalartInfo(mandalartId: mandalartId);
    if (data != null) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('만다라트 조회에 실패했습니다.')),
      );
    }
  }*/

  /*Future<void> mandaColor(String mandalartId) async {
// 중복 방지
    if (colorList.any((item) => item['id'] == mandalartId)) return;

    try {
      // 서버에서 데이터 가져오기
      final data = await MandalartInfoService.mandalartInfo(
          mandalartId: int.parse(mandalartId));
      if (data != null) {
        // 반환된 데이터를 colorList에 추가
        setState(() {
          colorList.add({"id": mandalartId, "color": data["color"]});
        });
        print('colorList=$colorList');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('만다라트 조회에 실패했습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }*/

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
                  rowHeight: 35,
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
                        color: Color.fromARGB(255, 56, 56, 56),
                        shape: BoxShape.circle),
                    selectedDecoration: const BoxDecoration(
                      color: mainRed,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      fontSize: 12, // 선택된 날짜의 폰트 크기 고정
                      fontWeight: FontWeight.w700,
                      color: Colors.white, // 선택된 날짜의 텍스트 색상
                    ),
                    todayTextStyle: TextStyle(
                      fontSize: 12, // 오늘 날짜 폰트 크기
                      fontWeight: FontWeight.w700, // 오늘 날짜 폰트 굵기
                      color: Colors.white, // 오늘 날짜 텍스트 색상
                    ),
                    outsideTextStyle: TextStyle(
                      color: const Color.fromARGB(255, 125, 125, 125),
                      fontSize: currentWidth < 600 ? 12 : 16,
                    ),
                    defaultTextStyle: TextStyle(
                      color: mainTextColor,
                      fontSize: currentWidth < 600 ? 12 : 16,
                    ),
                    weekendTextStyle: TextStyle(
                      color: mainTextColor,
                      fontSize: currentWidth < 600 ? 12 : 16,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Color(0xffD4D4D4)), // 평일 색상
                    weekendStyle: TextStyle(color: Color(0xffD4D4D4)), // 주말 색상
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextStyle:
                        const TextStyle(color: Colors.white, fontSize: 15),
                    leftChevronIcon: Icon(
                      Icons.arrow_back_ios,
                      color: const Color.fromARGB(255, 170, 170, 170),
                      size: currentWidth < 600 ? 17 : 20,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: const Color.fromARGB(255, 170, 170, 170),
                      size: currentWidth < 600 ? 17 : 20,
                    ),
                    formatButtonVisible:
                        false, //원래 달력 열고 닫는 버튼. 지금은 화살표 아이콘이 역할을 대신하고 있음.
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
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down,
                        color: const Color(0xffD4D4D4),
                        size: 25,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: currentWidth < 600 ? 0 : 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    NewCustomIconButton(() {
                      context
                          .read<SelectAPModel>()
                          .selectAP("제3목표를 클릭하여 선택해주세요.", null);

                      context
                          .read<SelectRepeatModel>()
                          .selectRepeat(false, false, false, false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddPage1(),
                          ));
                    }, Icons.add, currentWidth, 21)
                        .newCustomIconButton(),
                  ],
                ),
                SizedBox(
                  height: currentWidth < 600 ? 14 : 20,
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
                                  '오늘은 쓰러뜨릴 도미노가 없어요.\n여유로운 하루를 보내세요:)',
                                  style: TextStyle(
                                    color: const Color(0xff464646),
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
                                    opacity: 0.2,
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

                              print('만달달아이디: ${value[index].id}');

                              int? thirdGoalId = await getThirdGoalId(
                                  value[index].id, value[index].thirdGoal);
                              print('thirdGoalId=$thirdGoalId');

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
    barrierDismissible: true, // 바깥 영역 터치시 닫을지 여부
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(0),
        child: SizedBox(
          height: currentWidth < 600 ? 210 : 250,
          width: currentWidth < 600 ? 300 : 480,
          child: Container(
            padding: EdgeInsets.all(currentWidth < 600 ? 25 : 30),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(
                    Radius.circular(currentWidth < 600 ? 10 : 13))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: currentWidth < 600 ? 16 : 18,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color: Color(int.parse(
                                  color
                                      .replaceAll('Color(', '')
                                      .replaceAll(')', '')
                                      .replaceAll('0x', ''),
                                  radix: 16) +
                              0xFF000000),
                          borderRadius: BorderRadius.all(
                              Radius.circular(currentWidth < 600 ? 3 : 5)),
                        ),
                      ),
                      SizedBox(width: currentWidth < 600 ? 16 : 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    content,
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                        fontSize: currentWidth < 600 ? 13 : 17),
                                  ),
                                  SizedBox(height: currentWidth < 600 ? 5 : 7),
                                  SizedBox(
                                    width: 140,
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize:
                                              currentWidth < 600 ? 17 : 19,
                                          fontWeight: FontWeight.w600),
                                      maxLines: 1, // 👉 최대 2줄까지만 표시
                                      overflow: TextOverflow
                                          .ellipsis, // 👉 2줄 이상일 경우 "..."으로 표시
                                      softWrap: true, // 👉 자동 줄바꿈 허용
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: currentWidth < 600 ? 20 : 25),
                          Container(
                            height: 82,
                            width: currentWidth < 600 ? 170 : 250,
                            padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Color(0xff292929)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '반복',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: currentWidth < 600 ? 13 : 14,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  getIntervalText(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: currentWidth < 600 ? 15 : 17,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
              ],
            ),
          ),
        ),
      );
    },
  );
}
