import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:domino/style/styles.dart';

void showCalendarPopup(
    BuildContext context, Function(DateTime?) onDateSelected) {

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
                  headerStyle:  HeaderStyle(
        titleCentered: true,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
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
                ));
          },
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Expanded(
            flex: 1,
            child: NewButton(Color(0xff2C2C2C), settingGrey, '취소', () {
              Navigator.pop(context);
            }).newButton(),
          ),
          SizedBox(width: 15),
          //완료 버튼
          Expanded(
            flex: 2,
            child: 
                NewButton(mainRed, backgroundColor, '선택 완료!', () {
                  onDateSelected(tempSelectedDate); // 콜백 호출
                  Navigator.pop(context); // 팝업 닫기
                }).newButton(),)
            


             
            ],
          )
        ],
      );
    },
  );
}
