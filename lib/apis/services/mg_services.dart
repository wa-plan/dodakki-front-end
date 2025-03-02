import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['BASE_URL'];

class AddGoalService {
  static Future<bool> addGoal({
    required String name,
    required String description,
    required String color,
    required DateTime date,
    required List<String> pictures,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    print('저장된 토큰: $token');

    if (token == null || token.isEmpty) {
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }

    final url = Uri.parse('$baseUrl/api/mandalart/add');

    final body = jsonEncode({
      'name': name,
      'description': description,
      'color': color, // 색상은 이제 문자열로 전달됨
      'date': date.toIso8601String(), // 날짜는 ISO 8601 형식 문자열로 변환됨
      'picture': pictures,
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
          msg: '목표가 성공적으로 저장되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: '인증 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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

class EditGoalNameService {
  static Future<bool> editGoalName({
    required String name,
    required int mandalartId,
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

    final url = Uri.parse('$baseUrl/api/mandalart');

    final body = jsonEncode({'name': name, 'mandalartId': mandalartId});

    try {
      final response = await http.patch(
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
          msg: '목표가 성공적으로 수정되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: '인증 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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

class EditGoalDescriptionService {
  static Future<bool> editGoalDescription({
    required String description,
    required int mandalartId,
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

    final url = Uri.parse('$baseUrl/api/mandalart/description');

    final body =
        jsonEncode({'description': description, 'mandalartId': mandalartId});

    try {
      final response = await http.patch(
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
          msg: '목표가 성공적으로 수정되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: '인증 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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

class EditGoalColorService {
  static Future<bool> editGoalColor({
    required String color,
    required int mandalartId,
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

    final url = Uri.parse('$baseUrl/api/mandalart/color');

    final body = jsonEncode({'color': color, 'mandalartId': mandalartId});

    try {
      final response = await http.patch(
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
          msg: '목표가 성공적으로 수정되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: '인증 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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

class EditProfileService {
  static Future<bool> editProfile({
    required String nickname,
    required String profile,
    required String description,
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

    final url = Uri.parse('$baseUrl/api/user/me');

    final body = jsonEncode({
      'nickname': nickname,
      'profile': profile,
      'description': description,
    });

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('프로필 수정 완료');
      print('서버 응답 본문: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '목표가 성공적으로 저장되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: '인증 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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

class UserInfoService {
  static Future<Map<String, dynamic>> userInfo() async {
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
      return {};
    }

    final url = Uri.parse('$baseUrl/api/user/me');

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
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        int id = data['id'];
        String userId = data['userId'];
        String password = data['password'];
        String email = data['email'];
        String phoneNum = data['phoneNum'];
        String description = data['description'] ?? '프로필 편집을 통해 \n자신을 표현해주세요.';

        String role = data['role'];
        String morningAlarm = data['morningAlarm'];
        String nightAlarm = data['nightAlarm'];
        String nickname = data['nickname'] ?? '당신은 어떤 사람인가요?';

        /*Fluttertoast.showToast(
          msg: '조회 성공',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );*/
        return {
          'id': id,
          'userId': userId,
          'password': password,
          'email': email,
          'phoneNum': phoneNum,
          'description': description,
          'role': role,
          'morningAlarm': morningAlarm,
          'nightAlarm': nightAlarm,
          'nickname': nickname,
        };
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
      return {};
    } catch (e) {
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return {};
    }
  }
}

class UserMandaIdService {
  static Future<Map<String, List<Map<String, String>>>> userManda() async {
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
      return {'mandalarts': [], 'bookmarks': []};
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
      print('서버 응답 본문: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

        List<Map<String, String>> mandaList = data.map((item) {
          String id = item['id'].toString();
          String name = item['name'];
          return {'id': id, 'name': name};
        }).toList();

        List<Map<String, String>> bookmarkList = data.map((item) {
          String id = item['id'].toString();
          String bookmark = item['bookmark'];
          return {'id': id, 'bookmark': bookmark};
        }).toList();

        print('생성된 mandaList: $mandaList');
        print('생성된 bookmarkList: $bookmarkList');

        return {
          'mandalarts': mandaList,
          'bookmarks': bookmarkList,
        };
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
      return {'mandalarts': [], 'bookmarks': []};
    } catch (e) {
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return {'mandalarts': [], 'bookmarks': []};
    }
  }
}

class UserMandaInfoService {
  static Future<Map<String, dynamic>?> userMandaInfo(context,
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

    final url = Uri.parse('$baseUrl/api/mandalart/$mandalartId');

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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        /*Fluttertoast.showToast(
          msg: '조회 성공',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );*/

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

class MandaBookmarkService {
  static Future<bool> MandaBookmark({
    required int id,
    required String bookmark,
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

    final url = Uri.parse('$baseUrl/api/mandalart/bookmark');

    final body = jsonEncode({
      'id': id,
      'bookmark': bookmark,
    });

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('프로필 수정 완료');
      print('서버 응답 본문: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '목표가 성공적으로 저장되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: '인증 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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

class MandaProgressService {
  static Future<bool> MandaProgress({
    required int id,
    required String status,
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

    final url = Uri.parse('$baseUrl/api/mandalart/progress');

    final body = jsonEncode({
      'id': id,
      'status': status,
    });

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('프로필 수정 완료');
      print('서버 응답 본문: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Fluttertoast.showToast(
          msg: '목표가 성공적으로 저장되었습니다.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        return true;
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: '인증 실패: ${response.body}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
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

class CheeringService {
  static Future<List<Map<String, String>>> cheering() async {
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
      return [];
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
      print('서버 응답 본문: ${jsonDecode(utf8.decode(response.bodyBytes))}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        List<Map<String, String>> mandaList = data.map((item) {
          String id = item['id'].toString();
          String name = item['name'];
          return {'id': id, 'name': name};
        }).toList();

        Fluttertoast.showToast(
          msg: '조회 성공',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        return mandaList;
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
      return [];
    } catch (e) {
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return [];
    }
  }
}

/*class DeleteMainGoalService {
  static Future<bool> deleteMainGoal(
    BuildContext context,
    int mandalartId,
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

    final url = Uri.parse('$baseUrl/api/mandalart/$mandalartId');

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
}*/

class UploadImage {
  static Future<bool> uploadImage({
  required String filePath,
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

  Dio dio = Dio();
  dio.options.headers = {
    "Authorization": "Bearer $token",
    "Content-Type": "multipart/form-data",
  };

  String s3Url = '$baseUrl/s3/upload';

  try {
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, filename: "profile_image.jpg"),
    });

    Response response = await dio.post(s3Url, data: formData);

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: '프로필 이미지가 성공적으로 업로드되었습니다.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      return true;
    } else {
      Fluttertoast.showToast(
        msg: '이미지 업로드 실패: ${response.data}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  } on DioException catch (e) {
    Fluttertoast.showToast(
      msg: '업로드 중 오류 발생: ${e.response?.statusCode} - ${e.response?.data}',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    return false;
  }
}
}



class DeleteFirstGoalService {
  static Future<bool> deleteFirstGoal(
    BuildContext context,
    int mandalartId,
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

    final url = Uri.parse('$baseUrl/api/mandalart/$mandalartId');

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
