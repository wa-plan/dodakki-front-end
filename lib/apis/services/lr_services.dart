import 'dart:convert';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:domino/main.dart';
import 'package:domino/screens/LR/login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['BASE_URL'];

class LoginService {
  Future<bool> login(
      BuildContext context, String userId, String password) async {
    final url = Uri.parse('$baseUrl/api/auth/login');

    final body = jsonEncode({
      'userId': userId,
      'password': password,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);

        if (responseData != null && responseData is Map<String, dynamic>) {
          final accessToken = responseData['accessToken'] ?? '';

          if (accessToken.isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('authToken', accessToken);

            if (context.mounted) {
              return true;
            }
          } else {
            if (context.mounted) {
              
            }
          }
          return false;
        } else {
          if (context.mounted) {
            
          }
        }
        return false;
      } else {
        if (context.mounted) {
          Message(
            "입력하신 정보가 올바르지 않습니다.",
            const Color(0xffFF6767), // 텍스트 색상
            const Color(0xff412C2C), // 배경 색상
            borderColor: const Color(0xffFF6767), // 테두리 색상
            icon: Icons.block, // 아이콘
          ).message(context);
        }
        return false;
      }
    } catch (e) {
      if (context.mounted) {
        
      }
      return false;
    }
  }
}

class ChangePasswordService {
  static Future<bool> changePassword(
      {required String currentPassword, required String newPassword}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/user/me/password');

    final body = jsonEncode({
      'currentPassword': currentPassword,
      'newPassword': newPassword,
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
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}

class RegistrationService {
  static Future<void> register({
    required BuildContext context,
    required String userId,
    required String password,
    required String email,
    required String phoneNum,
  }) async {
    final url = Uri.parse('$baseUrl/api/user/signup');

    final body = jsonEncode({
      'userId': userId,
      'password': password,
      'email': email,
      'phoneNum': phoneNum,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (context.mounted) {
          
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      } else {
        if (context.mounted) {
          
        }
      }
    } catch (e) {
      if (context.mounted) {
        
      }
    }
  }
}

class IdFindService {
  static Future<String> findUserId({
    required String phoneNum,
    required String email,
  }) async {
    final url = Uri.parse('$baseUrl/api/user/find_userId');

    final body = jsonEncode({
      'phoneNum': phoneNum,
      'email': email,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        //final responseData = jsonDecode(response.body);
        return response.body; // Adjust based on your API response
      } else {
        return '실패';
      }
    } catch (e) {
      
      return '실패';
    }
  }
}

class PwFindService {
  static Future<String> findPassword({
    required String userId,
    required String email,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$baseUrl/api/user/reset_password');

    final body = jsonEncode({
      'userId': userId,
      'email': email,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body; // Adjust based on your API response
        
      } else {
        return '실패';
      }
    } catch (e) {
      
      return '실패';
    }
  }
}

class SignOutService {
  static Future<String?> signOut(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      if (context.mounted) {
        
      }
      return null;
    }

    final url = Uri.parse('$baseUrl/api/user/me/password');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (context.mounted) {
          

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyApp(),
            ),
          );
        }
      } else {
        if (context.mounted) {
          
        }
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        
      }
      return null;
    }
    return null;
  }
}

class MorningAlertService {
  static Future<bool> morningAlert({
    required String alarm,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null || token.isEmpty) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/user/morning_alarm');
    final body = jsonEncode({
      'alarm': alarm,
    });

    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        
        return true;
      } else {
        
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }
}

class NightAlertService {
  static Future<bool> nightAlert({required String alarm}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null || token.isEmpty) {
      
      return false;
    }

    final url = Uri.parse('$baseUrl/api/user/night_alarm');
    final body = jsonEncode({
      'alarm': alarm,
    });

    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        
        return true; //성공한 경우 'on' 또는 'off' 값을 반환
      } else {
        
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }
}
