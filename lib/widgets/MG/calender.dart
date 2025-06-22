import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:domino/style/styles.dart';

void showCalendarPopup(
    BuildContext context, Function(DateTime?) onDateSelected) {
  final currentWidth = MediaQuery.of(context).size.width;

  showDialog(
    context: context,
    builder: (context) {
      DateTime focusedDay = DateTime.now();
      DateTime? tempSelectedDate;

      return AlertDialog(
        backgroundColor: const Color(0xff262626),
        contentPadding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 330,
                child: TableCalendar(
                  locale: 'ko_KR',
                  rowHeight: 45,
                  firstDay: DateTime(2024),
                  lastDay: DateTime(2050),
                  focusedDay: focusedDay,
                  selectedDayPredicate: (day) =>
                      isSameDay(tempSelectedDate, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      tempSelectedDate = selectedDay; // 임시 선택 날짜 업데이트
                      focusedDay = focusedDay; // 포커스된 날짜 업데이트
                    });
                  },
                  calendarFormat: CalendarFormat.month,
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
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
                ));
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 90,
                height: 45,
                child: NewButton(Colors.black, Colors.white, '취소', () {
                  Navigator.pop(context); // 팝업 닫기
                })
                    .newButton(),
              ),
              SizedBox(
                width: 90,
                height: 45,
                child: NewButton(Colors.black, Colors.white, '완료', () {
                  onDateSelected(tempSelectedDate); // 콜백 호출
                  Navigator.pop(context); // 팝업 닫기
                })
                    .newButton(),
              ),
            ],
          )
        ],
      );
    },
  );
}
