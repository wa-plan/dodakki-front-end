import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PermissionUtil {
  static Future<bool> checkAndRequestGalleryPermission(BuildContext context) async {
    final status = await Permission.photos.status;
    print('현재 권한 상태: $status');

    if (status.isGranted) {
      return true;
    }

    final result = await Permission.photos.request();

    if (result.isGranted) {
      return true;
    } else {
      // 권한 요청 거부 시 다이얼로그 띄우기
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(0),
          elevation: 30.0,
          content: Container(
            padding: const EdgeInsets.fromLTRB(10, 30, 30, 0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 26, 26, 26),
              borderRadius: BorderRadius.all(Radius.circular(7))
            ),
            height: MediaQuery.of(context).size.width < 600 ? 160 : 220,
            width: MediaQuery.of(context).size.width < 600 ? 340 : 400,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset('assets/img/Dominho2.png',
                        width: MediaQuery.of(context).size.width < 600 ? 84 : 120),
                    SizedBox(width: MediaQuery.of(context).size.width < 600 ? 30 : 50),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5),
                              const Text(
                                '알림 권한이 필요해!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '설정 앱에서 도닦기 알림을 허용해줘.',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 12
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NewButton(
                                Colors.black, Colors.white, '설정으로 이동', () {
                                  Navigator.of(context).pop();
                                  openAppSettings();
                                }, MediaQuery.of(context).size.width
                              ).newButton(),
                            ],
                          ),
                          SizedBox(height: MediaQuery.of(context).size.width < 600 ? 15 : 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      return false;
    }
  }
}
