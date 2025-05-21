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
              Fluttertoast.showToast(
                msg: '토큰을 받아오지 못했습니다.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          }
          return false;
        } else {
          if (context.mounted) {
            Fluttertoast.showToast(
              msg: '서버 응답 형식이 올바르지 않습니다.',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
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
        Fluttertoast.showToast(
          msg: '오류 발생: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '계정생성이 완료되었습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '계정생성에 실패했습니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '계정생성에 실패했습니다.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
            ),
            backgroundColor: Colors.red,
          ),
        );
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
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
        Fluttertoast.showToast(
          msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
          Fluttertoast.showToast(
            msg: '탈퇴가 성공적으로 이루어졌습니다.',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const MyApp(),
            ),
          );
        }
      } else {
        if (context.mounted) {
          Fluttertoast.showToast(
            msg: '탈퇴 실패: ${response.body}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
        }
        return null;
      }
    } catch (e) {
      if (context.mounted) {
        Fluttertoast.showToast(
          msg: '오류 발생: $e',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
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
      Fluttertoast.showToast(
        msg: '로그인 토큰이 없습니다. 다시 로그인해 주세요.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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
        Fluttertoast.showToast(
          msg: '업데이트 실패: ${response.body}',
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

class NightAlertService {
  static Future<bool> nightAlert({required String alarm}) async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

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
        Fluttertoast.showToast(
          msg: '업데이트 실패: ${response.body}',
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
