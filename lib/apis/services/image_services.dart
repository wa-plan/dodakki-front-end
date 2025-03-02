import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart'; // kIsWeb을 사용하기 위한 import
import 'package:flutter_dotenv/flutter_dotenv.dart';

String? baseUrl = dotenv.env['BASE_URL'];

class UploadFileService {
  // 반환 타입을 List<String>에서 String으로 수정
  static Future<String> uploadFiles(List<PlatformFile> files) async {
    String uploadedUrl = ''; // 업로드된 파일의 URL을 저장할 변수

    try {
      // SharedPreferences에서 토큰 가져오기
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
        return ''; // 토큰이 없으면 빈 문자열 반환
      }

      var uri = Uri.parse("$baseUrl/s3/upload"); // 업로드할 서버 URL
      var request = http.MultipartRequest('POST', uri);

      // Authorization 헤더에 토큰 추가
      request.headers['Authorization'] = 'Bearer $token';

      // 파일 처리
      for (var file in files) {
        if (kIsWeb) {
          // 웹에서 처리
          var byteData = file.bytes!;
          var multipartFile = http.MultipartFile.fromBytes(
            'image',
            byteData,
            filename: file.name,
          );
          request.files.add(multipartFile);
        } else {
          // 모바일에서 처리
          var filePath = file.path!;
          var fileStream = File(filePath).openRead();
          var multipartFile = http.MultipartFile(
            'image',
            fileStream,
            await File(filePath).length(),
            filename: file.name,
          );
          request.files.add(multipartFile);
        }
      }

      // 요청 보내기
      var response = await request.send();

      // 서버 응답 상태 코드 출력
      print('서버 응답 상태 코드: ${response.statusCode}');

      // 서버 응답 본문 읽기
      var responseBody = await response.stream.bytesToString();
      print('서버 응답 본문: $responseBody');

      if (response.statusCode == 200) {
        // 서버 응답 본문은 URL이므로 해당 URL을 변수에 저장
        uploadedUrl = responseBody;
        print('업로드된 파일 URL: $uploadedUrl');
      } else {
        print('파일 업로드 실패: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: '파일 업로드 실패: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return ''; // 업로드 실패 시 빈 문자열 반환
      }
    } catch (e) {
      print('파일 업로드 오류: $e');
      Fluttertoast.showToast(
        msg: '오류 발생: $e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return ''; // 오류 발생 시 빈 문자열 반환
    }

    return uploadedUrl; // 업로드된 파일 URL 반환
  }
}

class DeleteFileService {
  static Future<bool> deleteFile(String imageUrl) async {
    try {
      // SharedPreferences에서 토큰 가져오기
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
        return false; // 토큰이 없으면 삭제 실패
      }

      // 서버 DELETE 요청 URL
      var uri = Uri.parse("$baseUrl/s3/delete?addr=$imageUrl");

      // DELETE 요청 보내기
      var response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      print('서버 응답 상태 코드: ${response.statusCode}');
      print('서버 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        print("✅ 이미지 삭제 성공: $imageUrl");
        return true;
      } else {
        print("❌ 이미지 삭제 실패: ${response.statusCode}");
        Fluttertoast.showToast(
          msg: '이미지 삭제 실패: ${response.statusCode}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print("❌ 서버 요청 오류: $e");
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
