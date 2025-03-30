import 'package:flutter/material.dart';

class SelectFinalGoalModel with ChangeNotifier {
  String _selectedFinalGoal = "선택 안됨!"; // 초기값 설정
  String get selectedFinalGoal => _selectedFinalGoal;

  void selectFinalGoal(String value) {
    _selectedFinalGoal = value;
    notifyListeners();
  }
}

class SelectFinalGoalId with ChangeNotifier {
  String _selectedFinalGoalId = "선택 안됨!"; // 초기값 설정
  String get selectedFinalGoalId => _selectedFinalGoalId;

  void selectFinalGoalId(String value) {
    _selectedFinalGoalId = value;
    notifyListeners();
  }
}

class GoalOrder with ChangeNotifier {
  List<Map<String, String>> _goalOrder = []; // 초기값 설정
  List<Map<String, String>> get goalOrder => _goalOrder;

  void saveGoalOrder(List<Map<String, String>> value) {
    _goalOrder = value;
    notifyListeners();
  }
}

class SelectAPModel with ChangeNotifier {
  String _selectedAPName = "제3목표를 클릭하여 선택해주세요."; // 초기값 설정
  String get selectedAPName => _selectedAPName;
  int? _selectedAPID; // 초기값 설정
  int? get selectedAPID => _selectedAPID;

  void selectAP(String name, int? ID) {
    _selectedAPName = name;
    _selectedAPID = ID;
    notifyListeners();
  }
}

class SelectRepeatModel with ChangeNotifier {
  bool _everyDay = false;
  bool get everyDay => _everyDay;

  bool _everyWeek = false;
  bool get everyWeek => _everyWeek;

  bool _everyTwoWeek = false;
  bool get everyTwoWeek => _everyTwoWeek;

  bool _everyMonth = false;
  bool get everyMonth => _everyMonth;

  bool _result = false;
  bool get result => _result;

  void selectRepeat(bool everyDay, bool everyWeek, bool everyTwoWeek, bool everyMonth) {
    _everyDay = everyDay;
    _everyWeek = everyWeek;
    _everyTwoWeek = everyTwoWeek;
    _everyMonth = everyMonth;
    notifyListeners();
  }

  bool repeatedResult() {
    _result = _everyDay && _everyWeek && _everyTwoWeek && _everyMonth == false ? false : true;
    return _result;
  }
}

class SaveInputtedDetailGoalModel with ChangeNotifier {
  final Map<String, String> _inputtedDetailGoal = {
    '0': '',
    '1': '',
    '2': '',
    '3': '',
    '4': '',
    '5': '',
    '6': '',
    '7': '',
    '8': ''
  };

  Map<String, String> get inputtedDetailGoal => _inputtedDetailGoal;

  void updateDetailGoal(String key, String value) {
    if (_inputtedDetailGoal.containsKey(key)) {
      _inputtedDetailGoal[key] = value;
      notifyListeners();
    }
  }

  bool isAllEmpty() {
    return _inputtedDetailGoal.values.every((value) => value == '');
  }

  // 빈 값이 있는 키들을 반환
  List<String> getEmptyKeys() {
    return _inputtedDetailGoal.entries
        .where((entry) => entry.value == '')
        .map((entry) => entry.key)
        .toList();
  }
}

class TestInputtedDetailGoalModel with ChangeNotifier {
  final Map<String, String> _testinputtedDetailGoal = {
    '0': '',
    '1': '',
    '2': '',
    '3': '',
    '4': '',
    '5': '',
    '6': '',
    '7': '',
    '8': ''
  };

  Map<String, String> get testinputtedDetailGoal => _testinputtedDetailGoal;

  void updateTestDetailGoal(String key, String value) {
    if (_testinputtedDetailGoal.containsKey(key)) {
      _testinputtedDetailGoal[key] = value;
      notifyListeners();
    }
  }

  void resetDetailGoals() {
    _testinputtedDetailGoal.updateAll((key, value) => '');
    notifyListeners();
  }

  /// 비어있는 값 (empty string)을 가진 key의 개수 반환
  int countEmptyKeys() {
    return _testinputtedDetailGoal.values.where((value) => value == "").length;
  }

   /// 비어있는 값 (empty string)을 가진 key들의 리스트 반환
  List<String> getEmptyKeys() {
    return _testinputtedDetailGoal.entries
        .where((entry) => entry.value == "")
        .map((entry) => entry.key)
        .toList();
  }
}


class SaveInputtedActionPlanModel with ChangeNotifier {
  final List<Map<String, String>> _inputtedActionPlan = List.generate(9, (_) {
    return {
      '0': '',
      '1': '',
      '2': '',
      '3': '',
      '4': '',
      '5': '',
      '6': '',
      '7': '',
      '8': ''
    };
  });

  List<Map<String, String>> get inputtedActionPlan => _inputtedActionPlan;

  void updateActionPlan(int goalId, String key, String value) {
    if (goalId >= 0 && goalId < _inputtedActionPlan.length) {
      // 유효한 인덱스인지 확인
      if (_inputtedActionPlan[goalId].containsKey(key)) {
        // 키가 존재하는지 확인
        _inputtedActionPlan[goalId][key] = value;
        notifyListeners();
      }
    }
  }

  bool isAllEmpty() {
    for (var plan in _inputtedActionPlan) {
      for (var value in plan.values) {
        if (value != '') {
          return false; // 하나라도 ''이 아닌 값이 있으면 false 반환
        }
      }
    }
    return true; // 모든 값이 ''이면 true 반환
  }
}

class TestInputtedActionPlanModel with ChangeNotifier {
  final List<Map<String, String>> _testinputtedActionPlan = List.generate(9, (_) {
    return {
      '0': '',
      '1': '',
      '2': '',
      '3': '',
      '4': '',
      '5': '',
      '6': '',
      '7': '',
      '8': ''
    };
  });

  List<Map<String, String>> get inputtedActionPlan => _testinputtedActionPlan;

  void updateTestActionPlan(int goalId, String key, String value) {
    if (goalId >= 0 && goalId < _testinputtedActionPlan.length) {
      // 유효한 인덱스인지 확인
      if (_testinputtedActionPlan[goalId].containsKey(key)) {
        // 키가 존재하는지 확인
        _testinputtedActionPlan[goalId][key] = value;
        notifyListeners();
      }
    }
  }

  // 초기화 메서드
  void resetActionPlans() {
    for (int i = 0; i < _testinputtedActionPlan.length; i++) {
      _testinputtedActionPlan[i].updateAll((key, value) => '');
    }
    notifyListeners();
  }

  // ""인 value 값을 가진 key의 개수를 세는 함수
  int countEmptyValues(int index) {
    if (index >= 0 && index < _testinputtedActionPlan.length) {
      return _testinputtedActionPlan[index].values.where((value) => value.isEmpty).length;
    }
    return 0; // 유효하지 않은 인덱스인 경우 0 반환
  }

  // ""인 value 값을 가진 key를 저장하는 함수
  List<String> getEmptyValueKeys(int index) {
    if (index >= 0 && index < _testinputtedActionPlan.length) {
      return _testinputtedActionPlan[index].entries
          .where((entry) => entry.value.isEmpty)
          .map((entry) => entry.key)
          .toList();
    }
    return []; // 유효하지 않은 인덱스인 경우 빈 리스트 반환
  }
}



class SelectDetailGoal with ChangeNotifier {
  String _selectedDetailGoal = "";
  String get selectedDetailGoal => _selectedDetailGoal;

  void selectDetailGoal(String value) {
    _selectedDetailGoal = value;
    notifyListeners();
  }
}

class GoalColor with ChangeNotifier {
  final Map<String, Color> _selectedGoalColor = {
    '0': const Color(0xff929292),
    '1': const Color(0xff929292),
    '2': const Color(0xff929292),
    '3': const Color(0xff929292),
    '4': const Color(0xff929292),
    '5': const Color(0xff929292),
    '6': const Color(0xff929292),
    '7': const Color(0xff929292),
    '8': const Color(0xff929292)
  };

  Map<String, Color> get selectedGoalColor => _selectedGoalColor;

  void updateGoalColor(String key, Color value) {
    if (_selectedGoalColor.containsKey(key)) {
      // 키가 존재하는지 확인
      _selectedGoalColor[key] = value;
      notifyListeners();
    }
  }
}

class SaveEditedDetailGoalIdModel with ChangeNotifier {
  final Map<String, int> _editedDetailGoalId = {
    '0': 0,
    '1': 0,
    '2': 0,
    '3': 0,
    '4': 0,
    '5': 0,
    '6': 0,
    '7': 0,
    '8': 0
  };

  Map<String, int> get editedDetailGoalId => _editedDetailGoalId;

  void editDetailGoalId(String key, int value) {
    if (_editedDetailGoalId.containsKey(key)) {
      // 키가 존재하는지 확인
      _editedDetailGoalId[key] = value;
      notifyListeners();
    }
  }
}

class SaveEditedActionPlanIdModel with ChangeNotifier {
  final List<Map<String, int>> _editedActionPlanId = List.generate(9, (_) {
    return {
      '0': 0,
      '1': 0,
      '2': 0,
      '3': 0,
      '4': 0,
      '5': 0,
      '6': 0,
      '7': 0,
      '8': 0
    };
  });

  List<Map<String, int>> get editedActionPlanId => _editedActionPlanId;

  void editActionPlanId(int goalId, String key, int value) {
    if (goalId >= 0 && goalId < _editedActionPlanId.length) {
      // 유효한 인덱스인지 확인
      if (_editedActionPlanId[goalId].containsKey(key)) {
        // 키가 존재하는지 확인
        _editedActionPlanId[goalId][key] = value;
        notifyListeners();
      }
    }
  }
}


class SaveMandalartCreatedGoal with ChangeNotifier {
  final List<String> _mandalartCreatedGoal = [];

  List<String> get mandalartCreatedGoal => _mandalartCreatedGoal;

  void updateMandalartCreatedGoal(String goalId) {
    _mandalartCreatedGoal.add(goalId);  
    notifyListeners();  
  }

  void removeGoal(String goalId) {
    _mandalartCreatedGoal.remove(goalId);
    notifyListeners();
  }

}

