import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['BASE_URL'];

class Event {
  final int id;
  final String goalName;
  final String color;
  final String thirdGoal;
  final String attainment;
  final String repetition;
  int interval;
  bool switchValue;
  bool didZero;
  bool didHalf;
  bool didAll;

  Event({
    required this.id,
    required this.goalName,
    required this.color,
    required this.thirdGoal,
    required this.attainment,
    required this.repetition,
    this.interval = 0,
    this.switchValue = false,
    this.didZero = false,
    this.didHalf = false,
    this.didAll = false,
  });

  // JSON 데이터를 Event 객체로 변환하는 팩토리 메서드
  factory Event.fromJson(Map<String, dynamic> json) {
    String? attainment = json['attainment'] as String?;
    bool didZero = attainment == "FAIL";
    bool didHalf = attainment == "IN_PROGRESS";
    bool didAll = attainment == "SUCCESS";
    return Event(
      id: json['id'] ?? 0,
      goalName: json['goalName'] ?? 'Unknown',
      color: json['color'] ?? 'white',
      thirdGoal: json['thridGoal'] ?? 'No content',
      attainment: json['attainment'] ?? 'NONE',
      repetition: json['repetition'] ?? 'NONE',
      didZero: didZero,
      didHalf: didHalf,
      didAll: didAll,
    );
  }
}

class DominoInfoService {
  static Future<List<Event>?> dominoInfo(
    context, {
    required String date,
  }) async {
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
      return [];
    }

    final url = Uri.parse('$baseUrl/api/goal?date=$date');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> responseData =
            jsonDecode(utf8.decode(response.bodyBytes));
        List<Event> events = responseData.map<Event>((item) {
          return Event.fromJson(item);
        }).toList();

        return events;
      } else if (response.statusCode >= 400) {
      } else {}
      return [];
    } catch (e) {
      return [];
    }
  }
}

class AddDominoService {
  static Future<bool> addDomino(
      {required int thirdGoalId,
      required String name,
      required List<DateTime> dates,
      required String repetition}) async {
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

    final url = Uri.parse('$baseUrl/api/goal/add');

    // DateTime을 ISO 8601 string으로 변환
    final dateStrings = dates.map((date) => date.toIso8601String()).toList();

    final body = jsonEncode({
      'thirdGoalId': thirdGoalId,
      'name': name,
      'dates': dateStrings,
      'repetition': repetition
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '도미노가 성공적으로 저장되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: '도미노 저장 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: '도미노 저장 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: '도미노 저장 오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}

class DominoStatusService {
  static Future<bool> dominoStatus(
      {required int goalId,
      required String attainment,
      required String date}) async {
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

    final url = Uri.parse('$baseUrl/api/goal/status');

    final body =
        jsonEncode({'goalId': goalId, 'attainment': attainment, 'date': date});

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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '도미노 상태가 성공적으로 변경되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode >= 400) {
        Fluttertoast.showToast(
          msg: '도미노 변경 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: '도미노 변경 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: '도미노 변경 오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}

class EditDominoService {
  static Future<bool> editDomino({
    required int goalId,
    required String newGoal,
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

    final url = Uri.parse('$baseUrl/api/goal');

    final body = jsonEncode({
      'goalId': goalId,
      'newGoal': newGoal,
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
      print('도미노수정api');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '도미노 목표가 변경되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode >= 400) {
        Fluttertoast.showToast(
          msg: '도미노 수정 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: '도미노 수정 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return false;
    } catch (e) {
      Fluttertoast.showToast(
        msg: '도미노 수정 오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }
}

class EditTodayDominoService {
  static Future<bool> editTodayDomino(
      {required int goalId, required String goalDate}) async {
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

    final url = Uri.parse('$baseUrl/api/goal');

    final body = jsonEncode({'goalId': goalId, 'goalDate': goalDate});

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답 본문: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '오늘의 도미노가 성공적으로 수정되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode >= 400) {
        Fluttertoast.showToast(
          msg: '오늘의 도미노 수정 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: '오늘의 도미노 수정 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return false;
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

class DeleteDominoService {
  static Future<bool> deleteDomino({required int goalId}) async {
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

    final url = Uri.parse('$baseUrl/api/goal/$goalId');

    final body = jsonEncode({
      'goalId': goalId,
    });

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답 본문: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '도미노가 성공적으로 삭제되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode >= 400) {
        Fluttertoast.showToast(
          msg: '삭제 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: '도미노 삭제 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return false;
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

class DeleteTodayDominoService {
  static Future<bool> deleteTodayDomino(
      {required int goalId, required String goalDate}) async {
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

    final url = Uri.parse('$baseUrl/api/goal');

    final body = jsonEncode({'goalId': goalId, 'goalDate': goalDate});

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답 본문: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '오늘의 도미노가 성공적으로 삭제되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode >= 400) {
        Fluttertoast.showToast(
          msg: '오늘의 도미노 삭제 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: '오늘의 도미노 삭제 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return false;
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

class MandalartInfoService {
  static Future<Map<String, dynamic>?> mandalartInfo(
      {required int mandalartId}) async {
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
      return null; // 로그인 토큰 없으면 null 반환
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

      print('서버 응답 상태 코드: ${response.statusCode}');
      final decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩

      if (response.statusCode >= 200) {
        
        print('서버 응답 데이터: $decodedResponse');
        return decodedResponse; // 성공 시 데이터 반환
      } else if (response.statusCode >= 400) {
        Fluttertoast.showToast(
          msg: '조회 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: '조회 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return null; // 실패 시 null 반환
    } catch (e) {
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null; // 오류 발생 시 null 반환
    }
  }
}

/*class MandalartInfoService {
  static Future<bool> mandalartInfo(context, {required int mandalartId}) async {
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

    final url = Uri.parse('$baseUrl/api/mandalart/all/$mandalartId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답 본문: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '조회 성공',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode >= 400) {
        Fluttertoast.showToast(
          msg: '조회 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: '조회 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
      return false;
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
}*/
