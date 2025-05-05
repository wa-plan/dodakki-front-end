import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionUtil {
  static Future<bool> checkAndRequestGalleryPermission() async {
    PermissionStatus status;

    if (Platform.isAndroid) {
      if (await _isAndroid13OrAbove()) {
        // Android 13 이상이면 photos 권한 사용
        status = await Permission.photos.status;
        if (!status.isGranted) {
          status = await Permission.photos.request();
        }
      } else {
        // Android 13 미만이면 storage 권한 사용
        status = await Permission.storage.status;
        if (!status.isGranted) {
          status = await Permission.storage.request();
        }
      }
    } else if (Platform.isIOS) {
      status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
    } else {
      return true;
    }

    if (status.isGranted) {
      return true;
    } else {
      Fluttertoast.showToast(
        msg: '갤러리 접근 권한이 필요합니다.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  static Future<bool> _isAndroid13OrAbove() async {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }
}
