import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
      final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

      if (token == null || token.isEmpty) {
        
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

      // 서버 응답 본문 읽기
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // 서버 응답 본문은 URL이므로 해당 URL을 변수에 저장
        uploadedUrl = responseBody;
      } else {
        
        return ''; // 업로드 실패 시 빈 문자열 반환
      }
    } catch (e) {
      
      return ''; // 오류 발생 시 빈 문자열 반환
    }

    return uploadedUrl; // 업로드된 파일 URL 반환
  }
}

class UploadFilesService {
  // 반환 타입을 List<String>에서 String으로 수정
  static Future<List<String>> uploadFiles(List<PlatformFile> files) async {
    List<String> uploadedUrls = [];

    try {
      final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

      if (token == null || token.isEmpty) {
        
        return [];
      }

      for (var file in files) {
        var uri = Uri.parse("$baseUrl/s3/upload");
        var request = http.MultipartRequest('POST', uri);
        request.headers['Authorization'] = 'Bearer $token';

        if (kIsWeb) {
          var byteData = file.bytes!;
          var multipartFile = http.MultipartFile.fromBytes(
            'image',
            byteData,
            filename: file.name,
          );
          request.files.add(multipartFile);
        } else {
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

        var response = await request.send();
        var responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          uploadedUrls.add(responseBody); // ✅ 그대로 사용하면 됨
        } else {
          
        }
      }
    } catch (e) {
      
      return [];
    }

    return uploadedUrls; // ⬅️ 여러 개의 URL 반환
  }
}

class DeleteFileService {
  static Future<bool> deleteFile(String imageUrl) async {
    try {
      // SharedPreferences에서 토큰 가져오기
      final storage = const FlutterSecureStorage();
    String? token = await storage.read(key: 'token'); 

      if (token == null || token.isEmpty) {
        
        return false; // 토큰이 없으면 삭제 실패
      }

      // 서버 DELETE 요청 URL
      var uri = Uri.parse("$baseUrl/s3/delete?addr=$imageUrl");

      // DELETE 요청 보내기
      var response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        
        return false;
      }
    } catch (e) {
      
      return false;
    }
  }
}
