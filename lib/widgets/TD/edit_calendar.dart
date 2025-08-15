import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/provider/TD/date_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class EditCalendar extends StatefulWidget {
  final DateTime date;
  const EditCalendar(this.date, {super.key});
  @override
  State<EditCalendar> createState() => EditCalendarState();
}

class EditCalendarState extends State<EditCalendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late DateTime pickedDate = DateTime.now(); 
  Map pickDates = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.date;
    _selectedDay = widget.date;
    pickedDate = widget.date; 

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DateProvider>(context, listen: false)
          .setPickedDate(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
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
                  .setPickedDate(pickedDate);
            }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          calendarFormat: CalendarFormat.month,
          calendarStyle: CalendarStyle(
            markerSize: 0.0,
            outsideDaysVisible: false,
            isTodayHighlighted: true,
            todayDecoration:
                const BoxDecoration(color: mainGrey, shape: BoxShape.circle),
            selectedDecoration:
                const BoxDecoration(color: mainRed, shape: BoxShape.circle),
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
          headerStyle: HeaderStyle(
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
          firstDay: DateTime.utc(2014, 1, 1),
          lastDay: DateTime.utc(2034, 12, 31),
        ),
      ],
    );
  }
}
