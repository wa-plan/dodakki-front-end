import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:domino/style/styles.dart';

class PermissionUtil {
  static Future<bool> checkAndRequestGalleryPermission(
      BuildContext context, String whatPermission) async {
    final currentWidth = MediaQuery.of(context).size.width;

    // Android 버전에 따라 권한 선택
    Permission permission;
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        permission = Permission.photos; // 또는 Permission.mediaImages
      } else {
        permission = Permission.storage;
      }
    } else {
      return true; // iOS는 여기서 처리 안 함
    }

    final status = await permission.status;
    if (status.isGranted) return true;

    final result = await permission.request();
    if (result.isGranted) return true;

    // 거부 시 다이얼로그
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(0),
              elevation: 30.0,
              content: Container(
                padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 26, 26, 26),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 200,
                width: 300,
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/img/popup.png',
                        height: 170,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 30, 23),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$whatPermission 권한이 필요해!',
                            style: TextStyle(
                                color: mainRed,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                height: 1.7),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            '설정 앱에서\n$whatPermission 권한을 허용해줘.',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: currentWidth < 600 ? 16 : 20,
                                fontWeight: FontWeight.w600,
                                height: 1.7),
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 110,
                                child: NewButton(mainGrey, Colors.white, '취소',
                                    () {
                                  Navigator.of(context).pop();
                                }, currentWidth).newButton(),
                              ),
                              SizedBox(
                                width: 110,
                                child: NewButton(mainRed, backgroundColor, '설정 가기',
                                    () {
                                  Navigator.of(context).pop();
                                  openAppSettings();
                                }, currentWidth).newButton(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));

    return false;
  }
}
