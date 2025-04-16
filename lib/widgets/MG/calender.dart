import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:domino/styles.dart';




void showCalendarPopup(BuildContext context, Function(DateTime?) onDateSelected) {
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
                  rowHeight: 40,
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
                  calendarStyle:  CalendarStyle(
                    markerSize: 0.0,

                    selectedTextStyle: TextStyle(
                    fontSize: 12, // 선택된 날짜의 폰트 크기 고정
                    fontWeight: FontWeight.w700,
                    color: Colors.white, // 선택된 날짜의 텍스트 색상
                  ),

                     selectedDecoration: const BoxDecoration(
                    color: mainRed,
                    shape: BoxShape.circle,
                  ),

                     todayTextStyle: TextStyle(
                    fontSize: 12, // 오늘 날짜 폰트 크기
                    fontWeight: FontWeight.w700, // 오늘 날짜 폰트 굵기
                    color: Colors.white, // 오늘 날짜 텍스트 색상
                  ),
                    outsideTextStyle: TextStyle(
                    color:  Color.fromARGB(255, 125, 125, 125),
                    fontSize: currentWidth < 600 ? 12 : 16,
                  ),
                   defaultTextStyle: TextStyle(
                    color: mainTextColor,
                    fontSize: currentWidth < 600 ? 13 : 16,
                  ),



                     todayDecoration: BoxDecoration(
                      color: Color(0xff575757), shape: BoxShape.circle),

                     weekendTextStyle: TextStyle(
                    color: mainTextColor,
                    fontSize: currentWidth < 600 ? 12 : 16,
                  ),
// 주말 텍스트 색상
                  ),
                  headerStyle: const HeaderStyle(
                    formatButtonVisible: false, // 주/월 변경 버튼 숨기기
                    titleCentered: true, // 헤더의 날짜 중앙 정렬
                    leftChevronIcon: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromARGB(255, 150, 150, 150),
                      size: 17,
                    ),
                    rightChevronIcon: Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromARGB(255, 150, 150, 150),
                      size: 17,
                    ),
                    titleTextStyle: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey),
                    weekendStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NewButton(Colors.black, Colors.white, '취소', () {
                  Navigator.pop(context); // 팝업 닫기
                }, currentWidth).newButton(),
                NewButton(
                  Colors.black,
                  Colors.white,
                  '완료',
                  () {
                  onDateSelected(tempSelectedDate); // 콜백 호출
                  Navigator.pop(context); // 팝업 닫기
                },currentWidth
                ).newButton(),
              ],
            )
          ],
        );
      },
    );
  }