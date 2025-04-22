import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PermissionUtil {
  static Future<bool> checkAndRequestGalleryPermission() async {
    final status = await Permission.photos.status;

    if (status.isGranted) {
      return true;
    }

    final result = await Permission.photos.request();

    if (result.isGranted) {
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
}
