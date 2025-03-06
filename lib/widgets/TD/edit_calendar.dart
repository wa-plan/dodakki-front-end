import 'package:domino/styles.dart';
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
  late DateTime pickedDate = DateTime.now(); //도미노로 저장할 때, 해당 페이지로 넘길 날짜 변수
  Map pickDates = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.date;
    _selectedDay = widget.date;
    pickedDate = widget.date; // 초기에는 전달된 날짜로 설정
    Provider.of<DateProvider>(context, listen: false).setPickedDate(pickedDate);
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        TableCalendar(
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
              todayDecoration: const BoxDecoration(
                  color: Color(0xFF5B5B5B), shape: BoxShape.circle),
              selectedDecoration: const BoxDecoration(
                  color: mainRed, shape: BoxShape.circle),
              defaultTextStyle: TextStyle(
              color: mainTextColor,
              fontSize: currentWidth < 600 ? 12 : 16,
            ),
            weekendTextStyle: TextStyle(
              color: mainTextColor,
              fontSize: currentWidth < 600 ? 12 : 16,
            ),),
          headerStyle: HeaderStyle(
            titleCentered: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontSize: 15),
            leftChevronIcon: Icon(
              Icons.arrow_back_ios,
              color: const Color(0xffD4D4D4),
              size: currentWidth < 600 ? 17 : 20,
            ),
            rightChevronIcon: Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xffD4D4D4),
              size: currentWidth < 600 ? 17 : 20,
            ),
            formatButtonVisible:
                false, //원래 달력 열고 닫는 버튼. 지금은 화살표 아이콘이 역할을 대신하고 있음.
          ),
          firstDay: DateTime.utc(2014, 1, 1),
          lastDay: DateTime.utc(2034, 12, 31),
        ),
      ],
    );
  }
}
