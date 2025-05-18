import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/provider/TD/date_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:domino/widgets/TD/repeat_settings.dart';

class AddCalendar extends StatefulWidget {
  const AddCalendar({super.key});
  @override
  State<AddCalendar> createState() => AddCalendarState();
}

class AddCalendarState extends State<AddCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late DateTime pickedDate = DateTime.now(); //도미노로 저장할 때, 해당 페이지로 넘길 날짜 변수
  RepeatSettingsState repeatSettings =
      RepeatSettingsState(); // RepeatSettingsState 인스턴스 생성
  final GlobalKey<RepeatSettingsState> repeatSettingsKey = GlobalKey();
  Map pickDates = {};

  @override
  void initState() {
    super.initState();
    pickedDate = _focusedDay; // 초기에는 현재 날짜로 설정
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return TableCalendar(
      rowHeight: 35,
      locale: 'ko-KR',
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          // Call `setState()` when updating the selected day
          //bool everyDay = repeatSettingsKey.currentState!.everyDay;
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            pickedDate = selectedDay;
          });
          // DateProvider를 통해 상태 업데이트
          Provider.of<DateProvider>(context, listen: false)
              .setPickedDate(selectedDay);
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarFormat: CalendarFormat.month,
      calendarStyle: CalendarStyle(
        
            markerSize: 0.0,
              isTodayHighlighted: true,
              todayDecoration: const BoxDecoration(
                  color: Color.fromARGB(255, 56, 56, 56), shape: BoxShape.circle),
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
              titleTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
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
          
      firstDay: DateTime.utc(2014, 1, 1),
      lastDay: DateTime.utc(2034, 12, 31),
    );
  }
}
