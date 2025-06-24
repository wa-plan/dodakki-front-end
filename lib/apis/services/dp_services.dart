import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:math' as math;


String? baseUrl = dotenv.env['BASE_URL'];

class MainGoalListService {
  static Future<List<Map<String, dynamic>>?> mainGoalList(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return null;
    }

    final url = Uri.parse('$baseUrl/api/mandalart');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        
        final List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));

        List<Map<String, dynamic>> mainGoals = jsonResponse
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
        return mainGoals;
      } else {
        
        return null;
      }
    } catch (e) {
      
      return null;
    }
  }
}

class AddSecondGoalService {
  static Future<bool> addSecondGoal({
    required String mandalartId,
    required List<String> name,
    required List<String> color,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/secondgoal/add');

    if (name.length != color.length) {
      throw Exception("Mismatch in the number of names and colors");
    }

    bool allSuccess = true;

    for (int i = 0; i < name.length; i++) {
      final body = json.encode(
          {"mandalartId": mandalartId, "name": name[i], "color": color[i]});

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
        } else {
          
          allSuccess = false;
        }
      } catch (e) {
        
        allSuccess = false;
      }
    }

    return allSuccess;
  }
}

class SecondGoalListService {
  static Future<List<Map<String, dynamic>>?> secondGoalList(
    BuildContext context,
    String mandalartId, // Added to dynamically insert mandalartId in the URL
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }

    final url = Uri.parse('$baseUrl/api/mandalart/all/$mandalartId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));

        final List<Map<String, dynamic>> mainGoals = [
          {
            "mandalart": jsonResponse["mandalart"],
            "color": jsonResponse["color"],
            "secondGoals": (jsonResponse["secondGoals"] as List<dynamic>)
                .map((secondGoal) => {
                      "id": secondGoal["id"],
                      "secondGoal": secondGoal["secondGoal"],
                      "color": secondGoal["color"], // color 속성 추가
                      "thirdGoals": (secondGoal["thirdGoals"] as List<dynamic>)
                          .map((thirdGoal) => {
                                "id": thirdGoal["id"],
                                "thirdGoal": thirdGoal["thirdGoal"],
                              })
                          .toList(),
                    })
                .toList(),
          }
        ];

        return mainGoals;
      } else {
        
        return null;
      }
    } catch (e) {
      
      return null;
    }
  }
}

class AddThirdGoalService {
  static Future<bool> addThirdGoal({
    required List<int> secondGoalId,
    required List<List<String>> thirdValues,
   
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/thirdgoal/add');

    bool allSuccess = true;

    final minLen = math.min(secondGoalId.length, thirdValues.length);

    for (int i = 0; i < minLen; i++) {
      final curSecondGoalId = secondGoalId[i];
      final curThirdGoals = thirdValues[i];

      for (final thirdGoalName in curThirdGoals) {

        final body = json.encode({
          'secondGoalId': curSecondGoalId,
          'name': thirdGoalName,
        });

        try {
          final response = await http.post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: body,
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
          } else {
            
            allSuccess = false;
          }
        } catch (e) {
          
          allSuccess = false;
        }
      }
    }

    return allSuccess;
  }
}

class DeleteMandalartService {
  static Future<bool> deleteMandalart(
    BuildContext context,
    int secondGoalId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/secondgoal/$secondGoalId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }
}

class DeleteThirdGoalService {
  static Future<bool> deleteThirdGoal(
    BuildContext context,
    int thirdGoalId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/thirdgoal/$thirdGoalId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }
}

class EditSecondGoalService {
  static Future<bool> editSecondGoal({
    required List<int> secondGoalId,
    required List<String> newSecondGoal,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/secondgoal');

    if (secondGoalId.length != newSecondGoal.length) {
      throw Exception(
          "Mismatch in the number of secondGoalId and newSecondGoal");
    }

    bool allSuccess = true;

    for (int i = 0; i < secondGoalId.length; i++) {
      final body = json.encode({
        "secondGoalId": secondGoalId[i],
        "newSecondGoal": newSecondGoal[i],
      });

      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
        } else {
          
          allSuccess = false;
        }
      } catch (e) {
        
        allSuccess = false;
      }
    }

    return allSuccess;
  }
}

class EditGoalColorService {
  static Future<bool> editGoalColor({
    required List<int> secondGoalId,
    required List<String> color,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/secondgoal/color');

    if (secondGoalId.length != color.length) {
      throw Exception("Mismatch in the number of secondGoalId and color");
    }

    bool allSuccess = true;

    for (int i = 0; i < secondGoalId.length; i++) {
      final body = json.encode({
        "secondGoalId": secondGoalId[i],
        "color": color[i],
      });

      try {
        final response = await http.put(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
        } else {
          
          allSuccess = false;
        }
      } catch (e) {
        
        allSuccess = false;
      }
    }

    return allSuccess;
  }
}

class EditThirdGoalService {
  static Future<bool> editThirdGoal({
    required List<List<int>> thirdGoalIds,    
    required List<List<String>> thirdGoals,    
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      return false;
    }

    final url = Uri.parse('$baseUrl/api/thirdgoal');
    bool allSuccess = true;

    final goalCount = math.min(thirdGoalIds.length, thirdGoals.length);

    for (int i = 0; i < goalCount; i++) {
      final idList = thirdGoalIds[i];
      final goalList = thirdGoals[i];
      final loopCount = math.min(idList.length, goalList.length);

      for (int j = 0; j < loopCount; j++) {
        final body = json.encode({
          "thirdGoalId": idList[j],
          "newThirdGoal": goalList[j],
        });

        try {
          final response = await http.put(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
            body: body,
          );

          if (response.statusCode != 200 && response.statusCode != 201) {
            allSuccess = false;
          }
        } catch (e) {
          allSuccess = false;
        }
      }
    }

    return allSuccess;
  }
}


class MainGoalDetailService {
  static Future<List<Map<String, dynamic>>?> mainGoalDetailList(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return null;
    }

    final url = Uri.parse('http://13.124.78.26:8080/api/goal');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse =
            json.decode(utf8.decode(response.bodyBytes));
        List<Map<String, dynamic>> mainGoalsDetail = jsonResponse
            .map((item) => {
                  'id': item['id'],
                  'goalName': item['goalName'],
                  'color': item['color'],
                  'thirdGoal': item['thirdGoal'],
                  'attainment': item['attainment'],
                  'repetition': item['repetition'],
                })
            .toList();
        return mainGoalsDetail;
      } else {
        
        return null;
      }
    } catch (e) {
      
      return null;
    }
  }
}
