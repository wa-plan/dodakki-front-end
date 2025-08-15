import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String? baseUrl = dotenv.env['BASE_URL'];

class AddGoalService {
  static Future<bool> addGoal({
    required String name,
    required String description,
    required String color,
    required String date,
    required List<String> pictures,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

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

    final url = Uri.parse('$baseUrl/api/mandalart/add');

    final body = jsonEncode({
      'name': name,
      'description': description,
      'color': color, // 색상은 이제 문자열로 전달됨
      'date': date,
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
      return false;
    }
  }
}

class EditGoalNameService {
  static Future<bool> editGoalName({
    required String name,
    required int mandalartId,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
      return false;
    }
  }
}

class EditGoalDateService {
  static Future<bool> editGoalDate({
    required String newDate,
    required int mandalartId,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
      return false;
    }

    final url = Uri.parse('$baseUrl/api/mandalart/date');

    final body = jsonEncode({'newDate': newDate, 'mandalartId': mandalartId});

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
      return false;
    }
  }
}

class EditGoalDescriptionService {
  static Future<bool> editGoalDescription({
    required String description,
    required int mandalartId,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
      return false;
    }
  }
}

class EditGoalPhotoService {
  static Future<bool> editGoalPhoto({
    required List<String> photo,
    required int mandalartId,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
      return false;
    }

    final url = Uri.parse('$baseUrl/api/mandalart/picture');

    final body = jsonEncode({'pictureUrls': photo, 'mandalartId': mandalartId});

    try {
      final response = await http.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
      return false;
    }
  }
}

class EditGoalColorService {
  static Future<bool> editGoalColor({
    required String color,
    required int mandalartId,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
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
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
      return false;
    }
  }
}

class UserInfoService {
  static Future<Map<String, dynamic>> userInfo() async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        int id = data['id'];
        String userId = data['userId'];
        String password = data['password'];
        String email = data['email'];
        String phoneNum = data['phoneNum'];
        String description = data['description'] ?? '프로필 편집을 통해 \n자신을 표현해주세요.';
        String profile = data['profile'];
        String role = data['role'];
        String morningAlarm = data['morningAlarm'];
        String nightAlarm = data['nightAlarm'];
        String nickname = data['nickname'] ?? '당신은 어떤 사람인가요?';

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
          'profile': profile
        };
      } else if (response.statusCode >= 400) {
      } else {}
      return {};
    } catch (e) {
      return {};
    }
  }
}

class UserMandaIdService {
  static Future<Map<String, List<Map<String, String>>>> userManda() async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

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

        return {
          'mandalarts': mandaList,
          'bookmarks': bookmarkList,
        };
      } else if (response.statusCode >= 400) {
      } else {}
      return {'mandalarts': [], 'bookmarks': []};
    } catch (e) {
      return {'mandalarts': [], 'bookmarks': []};
    }
  }
}

class UserMandaInfoService {
  static Future<Map<String, dynamic>?> userMandaInfo(context,
      {required int mandalartId}) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    print('토큰 값: $token');

    if (token == null) {
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

      final decodedResponse =
          jsonDecode(utf8.decode(response.bodyBytes)); // UTF-8로 디코딩

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decodedResponse; // 성공 시 데이터 반환
      } else if (response.statusCode >= 400) {
      } else {}
      return null; // 실패 시 null 반환
    } catch (e) {
      return null; // 오류 발생 시 null 반환
    }
  }
}

class MandaBookmarkService {
  static Future<bool> MandaBookmark({
    required int id,
    required String bookmark,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
      return false;
    }
  }
}

class MandaProgressService {
  static Future<bool> MandaProgress({
    required int id,
    required String status,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else if (response.statusCode == 401) {
      } else {}
      return false;
    } catch (e) {
      return false;
    }
  }
}

class CheeringService {
  static Future<List<Map<String, String>>> cheering() async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        List<Map<String, String>> mandaList = data.map((item) {
          String id = item['id'].toString();
          String name = item['name'];
          return {'id': id, 'name': name};
        }).toList();

        return mandaList;
      } else if (response.statusCode >= 400) {
      } else {}
      return [];
    } catch (e) {
      return [];
    }
  }
}

class UploadImage {
  static Future<bool> uploadImage({
    required String filePath,
  }) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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
        "file": await MultipartFile.fromFile(filePath,
            filename: "profile_image.jpg"),
      });

      Response response = await dio.post(s3Url, data: formData);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      return false;
    }
  }
}

class DeleteFirstGoalService {
  static Future<bool> deleteFirstGoal(
    BuildContext context,
    int mandalartId,
  ) async {
    final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

    if (token == null) {
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

      if (response.statusCode == 204) {
        // Handle successful deletion
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
