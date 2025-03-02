import 'package:flutter/material.dart';

class DateListProvider extends ChangeNotifier {
  bool _everyDay = false;
  bool _everyWeek = false;
  bool _everyTwoWeek = false;
  bool _everyMonth = false;
  int _interval = 0;

  bool get everyDay => _everyDay;
  bool get everyWeek => _everyWeek;
  bool get everyTwoWeek => _everyTwoWeek;
  bool get everyMonth => _everyMonth;
  int get interval => _interval;

  final List<DateTime> _dateList = [];
  List<DateTime> get dateList => _dateList;

  String repeatInfo() {
    if (_everyDay) {
      return "EVERYDAY";
    }
    if (_everyWeek) {
      return "EVERYWEEK";
    }
    if (_everyTwoWeek) {
      return "BIWEEKLY";
    }
    if (_everyMonth) {
      return "EVERYMONTH";
    }
    return "NONE";
  }

  void setEveryday(bool everyDay) {
    _everyDay = everyDay;
    _everyWeek = false;
    _everyTwoWeek = false;
    _everyMonth = false;
    notifyListeners();
  }

  void setEveryweek(bool everyWeek) {
    _everyWeek = everyWeek;
    _everyDay = false;
    _everyTwoWeek = false;
    _everyMonth = false;
    notifyListeners();
  }

  void setEverytwoweek(bool everyTwoWeek) {
    _everyTwoWeek = everyTwoWeek;
    _everyDay = false;
    _everyWeek = false;
    _everyMonth = false;
    notifyListeners();
  }

  void setEverymonth(bool everyMonth) {
    _everyMonth = everyMonth;
    _everyDay = false;
    _everyWeek = false;
    _everyTwoWeek = false;
    notifyListeners();
  }

  void setInterval(bool switchValue, DateTime date) {
    _interval = 0;
    _dateList.clear();

    if (switchValue) {
      // Add null check here
      if (_everyDay) {
        _interval = 1;
      }
      if (_everyWeek) {
        _interval = 7;
      }
      if (_everyTwoWeek) {
        _interval = 14;
      }
      if (_everyMonth) {
        _interval = 30;
      }
      _generateDateList(date);
    } else {
      _dateList.add(date);
    }

    notifyListeners();
  }

  void _generateDateList(DateTime startDate) {
    _dateList.clear();
    DateTime currentDate = startDate;
    DateTime endDate = startDate.add(const Duration(days: 365)); // 1년 후까지 반복

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      _dateList.add(currentDate); // 🔹 날짜 추가

      if (_everyDay) {
        currentDate = currentDate.add(const Duration(days: 1));
      } else if (_everyWeek) {
        currentDate = currentDate.add(const Duration(days: 7));
      } else if (_everyTwoWeek) {
        currentDate = currentDate.add(const Duration(days: 14));
      } else if (_everyMonth) {
        // 🔹 다음 달의 같은 날짜로 설정
        int nextMonth = currentDate.month + 1;
        int nextYear = currentDate.year;

        // 연도 변경 처리 (12월 → 1월)
        if (nextMonth > 12) {
          nextMonth = 1;
          nextYear++;
        }

        // 🔹 현재 날짜의 day가 다음 달에 없는 경우, 마지막 날짜로 설정
        int lastDayOfNextMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        int newDay = currentDate.day > lastDayOfNextMonth
            ? lastDayOfNextMonth
            : currentDate.day;

        // 새로운 날짜 설정
        currentDate = DateTime(nextYear, nextMonth, newDay);
      }
    }

    notifyListeners();
  }

  void updateRepeatSettings(int interval) {
    if (interval == 1) {
      _everyDay = true;
      _everyWeek = false;
      _everyTwoWeek = false;
      _everyMonth = false;
    } else if (interval == 7) {
      _everyDay = false;
      _everyWeek = true;
      _everyTwoWeek = false;
      _everyMonth = false;
    } else if (interval == 14) {
      _everyDay = false;
      _everyWeek = false;
      _everyTwoWeek = true;
      _everyMonth = false;
    } else if (interval > 14) {
      _everyDay = false;
      _everyWeek = false;
      _everyTwoWeek = false;
      _everyMonth = true;
    } else {
      _everyDay = false;
      _everyWeek = false;
      _everyTwoWeek = false;
      _everyMonth = false;
    }
    notifyListeners();
  }
}
