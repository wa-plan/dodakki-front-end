import 'package:domino/style/style_dominoPlan.dart';
import 'package:flutter/material.dart';

class SelectFinalGoalModel with ChangeNotifier {
  String _selectedFinalGoal = "선택 안됨!";
  String get selectedFinalGoal => _selectedFinalGoal;

  void selectFinalGoal(String value) {
    _selectedFinalGoal = value;
    notifyListeners();
  }
}

class SelectFinalGoalId with ChangeNotifier {
  String _selectedFinalGoalId = "선택 안됨!"; 
  String get selectedFinalGoalId => _selectedFinalGoalId;

  void selectFinalGoalId(String value) {
    _selectedFinalGoalId = value;
    notifyListeners();
  }
}

class GoalOrder with ChangeNotifier {
  List<Map<String, String>> _goalOrder = []; 
  List<Map<String, String>> get goalOrder => _goalOrder;

  void saveGoalOrder(List<Map<String, String>> value) {
    _goalOrder = value;
    notifyListeners();
  }
}

class SelectAPModel with ChangeNotifier {
  String _selectedAPName = "만다라트에서 플랜을 선택해주세요."; 
  String get selectedAPName => _selectedAPName;
  int? _selectedAPID; 
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

class SaveSecondGoalModel with ChangeNotifier {
  final Map<String, String> _secondGoal = {
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

  Map<String, String> get secondGoal => _secondGoal;

  void updateSecondGoal(String key, String value) {
    if (_secondGoal.containsKey(key)) {
      _secondGoal[key] = value;
      notifyListeners();
    }
  }

  bool isAllEmpty() {
    return _secondGoal.values.every((value) => value == '');
  }

  List<String> getEmptyKeys() {
    return _secondGoal.entries
        .where((entry) => entry.value == '')
        .map((entry) => entry.key)
        .toList();
  }

  void resetAllValues() {
  _secondGoal.updateAll((key, value) => '');
  notifyListeners();
}

}


class SaveThirdGoalModel with ChangeNotifier {
  final List<Map<String, String>> _thirdGoal = List.generate(9, (_) {
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

  List<Map<String, String>> get thirdGoal => _thirdGoal;

  void updatethirdGoal(int goalId, String key, String value) {
    if (goalId >= 0 && goalId < _thirdGoal.length) {
      if (_thirdGoal[goalId].containsKey(key)) {
        _thirdGoal[goalId][key] = value;
        notifyListeners();
      }
    }
  }

  bool isAllEmpty() {
    for (var plan in _thirdGoal) {
      for (var value in plan.values) {
        if (value != '') {
          return false;
        }
      }
    }
    return true;
  }

  void resetAllValues() {
    for (var plan in _thirdGoal) {
      plan.updateAll((key, value) => '');
    }
    notifyListeners();
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

class SaveGoalColor with ChangeNotifier {
  final Map<String, Color> _saveGoalColor = {
    '0': Colors.transparent,
    '1': Colors.transparent,
    '2': Colors.transparent,
    '3': Colors.transparent,
    '4': Colors.transparent,
    '5': Colors.transparent,
    '6': Colors.transparent,
    '7': Colors.transparent,
    '8': Colors.transparent
  };

  Map<String, Color> get selectedGoalColor => _saveGoalColor;

  void updateGoalColor(String key, Color value) {
    if (_saveGoalColor.containsKey(key)) {
      _saveGoalColor[key] = value;
      notifyListeners();
    }
  }

  void resetAllValues() {
  _saveGoalColor.updateAll((key, value) => secondGoalColor);
  notifyListeners();
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

class MandalartProvider with ChangeNotifier {
  List<Map<String, dynamic>> mainGoals = [];
  List<Map<String, dynamic>> emptyMainGoals = [];
  List<Map<String, dynamic>> secondGoals = [];
  List<Map<String, String>> inProgressIDs = [];
  List<Map<String, String>> failedIDs = [];
  List<Map<String, String>> successIDs = [];
  List<Map<String, String>> nameList = [];
  List<Map<String, String>> statusList = [];
  List<Map<String, String>> ddayList = [];
  List<Map<String, String>> mandalarts = [];
  List<Map<String, String>> bookmarks = [];

  void setMandalartData({
    required List<Map<String, dynamic>> mainGoals,
    required List<Map<String, dynamic>> emptyMainGoals,
    required List<Map<String, dynamic>> secondGoals,
    required List<Map<String, String>> inProgressIDs,
    required List<Map<String, String>> failedIDs,
    required List<Map<String, String>> successIDs,
    required List<Map<String, String>> nameList,
    required List<Map<String, String>> statusList,
    required List<Map<String, String>> ddayList,
    required List<Map<String, String>> mandalarts,
    required List<Map<String, String>> bookmarks,
  }) {
    this.mainGoals = mainGoals;
    this.emptyMainGoals = emptyMainGoals;
    this.secondGoals = secondGoals;
    this.inProgressIDs = inProgressIDs;
    this.failedIDs = failedIDs;
    this.successIDs = successIDs;
    this.nameList = nameList;
    this.statusList = statusList;
    this.ddayList = ddayList;
    this.mandalarts = mandalarts;
    this.bookmarks = bookmarks;
    notifyListeners();
  }
}
