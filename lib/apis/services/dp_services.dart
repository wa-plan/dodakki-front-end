import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['BASE_URL'];

class MainGoalListService {
  static Future<List<Map<String, dynamic>>?> mainGoalList(
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    print('저장된 토큰: $token');

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

    final url = Uri.parse('$baseUrl/api/mandalart');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        List<Map<String, dynamic>> mainGoals = jsonResponse
            .map((item) => {
                  'id': item['id'],
                  'name': item['name'],
                })
            .toList();
        print('mainGoals: $mainGoals');
        return mainGoals;
      } else {
        Fluttertoast.showToast(
          msg: '업데이트 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
    print('저장된 토큰: $token');

    if (token == null) {
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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

        //print('서버 응답 상태 코드: ${response.statusCode}');
        //print('서버 응답 본문: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          
        } else {
          Fluttertoast.showToast(
            msg: '목표 생성 실패: ${response.body}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          allSuccess = false;
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: '오류 발생: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
    print('저장된 토큰: $token');

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

    final url = Uri.parse(
        '$baseUrl/api/mandalart/all/$mandalartId'); // Insert mandalartId here

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답: ${response.body}');

      if (response.statusCode == 200) {

        final Map<String, dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));

        // Parsing the response to match the desired structure
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

        print('mainGoals: $mainGoals');
        return mainGoals;
      } else {
        Fluttertoast.showToast(
          msg: '업데이트 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }
}

class AddThirdGoalService {
  static Future<bool> addThirdGoal({
    required List<int> secondGoalId,
    required List<String> third0,
    required List<String> third1,
    required List<String> third2,
    required List<String> third3,
    required List<String> third4,
    required List<String> third5,
    required List<String> third6,
    required List<String> third7,
    required List<String> third8,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    print('저장된 토큰: $token');

    if (token == null) {
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }

    final url = Uri.parse('$baseUrl/api/thirdgoal/add');

    bool allSuccess = true;

    // List of all thirdGoals
    List<List<String>> allThirdGoals = [
      third0,
      third1,
      third2,
      third3,
      third4,
      third5,
      third6,
      third7,
      third8
    ];

    for (int i = 0; i < secondGoalId.length; i++) {
      // Check if we have more thirdGoals than secondGoals
      if (i >= allThirdGoals.length) break;

      List<String> currentThirdGoals = allThirdGoals[i];

      for (int j = 0; j < currentThirdGoals.length; j++) {
        final thirdGoalName = currentThirdGoals[j];

        final body = json.encode({
          "secondGoalId": secondGoalId[i],
          "name": thirdGoalName,
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

          print('서버 응답 상태 코드: ${response.statusCode}');
          print('서버 응답 본문: ${response.body}');

          if (response.statusCode == 200 || response.statusCode == 201) {
            
          } else {
            Fluttertoast.showToast(
              msg: '목표 생성 실패: ${response.body}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            allSuccess = false;
          }
        } catch (e) {
          Fluttertoast.showToast(
            msg: '오류 발생: $e',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
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
    print('저장된 토큰: $token');

    if (token == null) {
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답: ${response.body}');

      if (response.statusCode == 204) {
        // Handle successful deletion
        return true;
      } else {
        Fluttertoast.showToast(
          msg: '삭제 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
    print('저장된 토큰: $token');

    if (token == null) {
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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

        print('서버 응답 상태 코드: ${response.statusCode}');
        print('서버 응답 본문: ${response.body}');
        print(secondGoalId);
        print(newSecondGoal);

        if (response.statusCode == 200 || response.statusCode == 201) {
          Fluttertoast.showToast(
            msg: '목표가 성공적으로 수정되었습니다.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: '목표 수정 실패: ${response.body}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          allSuccess = false;
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: '오류 발생: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
    print('저장된 토큰: $token');

    if (token == null) {
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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

        print('서버 응답 상태 코드: ${response.statusCode}');
        print('서버 응답 본문: ${response.body}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          Fluttertoast.showToast(
            msg: '목표가 성공적으로 수정되었습니다.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
        } else {
          Fluttertoast.showToast(
            msg: '목표 수정 실패: ${response.body}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          allSuccess = false;
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: '오류 발생: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        allSuccess = false;
      }
    }

    return allSuccess;
  }
}

class EditThirdGoalService {
  static Future<bool> editThirdGoal({
    required List<int> third0id,
    required List<int> third1id,
    required List<int> third2id,
    required List<int> third3id,
    required List<int> third4id,
    required List<int> third5id,
    required List<int> third6id,
    required List<int> third7id,
    required List<int> third8id,
    required List<String> third0,
    required List<String> third1,
    required List<String> third2,
    required List<String> third3,
    required List<String> third4,
    required List<String> third5,
    required List<String> third6,
    required List<String> third7,
    required List<String> third8,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    print('저장된 토큰: $token');

    if (token == null) {
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }

    final url = Uri.parse('$baseUrl/api/thirdgoal');
    bool allSuccess = true;

    // List of all thirdGoalIds and corresponding goals
    List<List<int>> allThirdGoalIds = [
      third0id,
      third1id,
      third2id,
      third3id,
      third4id,
      third5id,
      third6id,
      third7id,
      third8id
    ];

    List<List<String>> allThirdGoals = [
      third0,
      third1,
      third2,
      third3,
      third4,
      third5,
      third6,
      third7,
      third8
    ];

    // Loop through all the goal lists and send them one by one
    for (int i = 0; i < allThirdGoalIds.length; i++) {
      for (int j = 0; j < allThirdGoalIds[i].length; j++) {
        // For each thirdGoalId and newThirdGoal pair, make a request
        final body = json.encode({
          "thirdGoalId": allThirdGoalIds[i][j],
          "newThirdGoal": allThirdGoals[i][j],
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

          print('서버 응답 상태 코드: ${response.statusCode}');
          print('서버 응답 본문: ${response.body}');
          print(allThirdGoals);
          print(allThirdGoalIds);

          if (response.statusCode == 200 || response.statusCode == 201) {
            Fluttertoast.showToast(
              msg: '목표가 성공적으로 저장되었습니다.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
            );
          } else {
            Fluttertoast.showToast(
              msg: '목표 생성 실패: ${response.body}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            allSuccess = false;
          }
        } catch (e) {
          Fluttertoast.showToast(
            msg: '오류 발생: $e',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
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
    print('저장된 토큰: $token');

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

    final url = Uri.parse('http://13.124.78.26:8080/api/goal');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonResponse = json.decode(utf8.decode(response.bodyBytes));
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
        print('mainGoalsDetail: $mainGoalsDetail');
        return mainGoalsDetail;
      } else {
        Fluttertoast.showToast(
          msg: '업데이트 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return null;
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }
}
