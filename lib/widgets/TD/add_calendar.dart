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
    return TableCalendar(
      rowHeight: 45,
      locale: 'ko-KR',
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            pickedDate = selectedDay;
          });
          Provider.of<DateProvider>(context, listen: false)
              .setPickedDate(selectedDay);
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
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
          color:  Color.fromARGB(255, 170, 170, 170),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ), 
        weekendStyle: TextStyle(
          color:  Color.fromARGB(255, 201, 110, 110),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      headerStyle: HeaderStyle(
        titleCentered: true,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
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
      firstDay: DateTime.utc(2014, 1, 1),
      lastDay: DateTime.utc(2034, 12, 31),
    );
  }
}
