import 'package:domino/styles.dart';
import 'package:domino/widgets/alarm.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/ST/account_management.dart';
import 'package:domino/screens/ST/contact_us.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:domino/apis/services/lr_services.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsMain extends StatefulWidget {
  const SettingsMain({super.key});

  @override
  State<SettingsMain> createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  String? userId;
  String? password;
  String? email;
  String? phoneNum;
  String? description;
  String? role;
  String? morningAlarm;
  String? nightAlarm;
  String? nickname;
  bool? isMorningAlarmOn;
  bool? isNightAlarmOn;

  void userInfo() async {
    final data = await UserInfoService.userInfo();
    if (data.isNotEmpty) {
      setState(() {
        //id = data['id'];
        userId = data['userId'];
        password = data['password'];
        email = data['email'];
        phoneNum = data['phoneNum'];
        description = data['description'];
        role = data['role'];
        morningAlarm = data['morningAlarm'];
        nightAlarm = data['nightAlarm'];
        nickname = data['nickname'];

        if (morningAlarm == 'ON') {
          isMorningAlarmOn = true;
        } else {
          isMorningAlarmOn = false;
        }
        if (nightAlarm == 'ON') {
          isNightAlarmOn = true;
        } else {
          isNightAlarmOn = false;
        }
      });
      print('morningAlarm=$morningAlarm');
      print('nightAlarm=$nightAlarm');
    }
  }

  void _updateMorningAlarm(bool isMorningAlarmOn) async {
    if (isMorningAlarmOn) {
      morningAlarm = "ON";
    } else {
      morningAlarm = "OFF";
    }
    final success =
        await MorningAlertService.morningAlert(alarm: morningAlarm!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('아침알람이 업데이트되었습니다.')),
      );
    }
  }

  Future<bool> _updateNightAlarm(bool isNightAlarmOn) async {
    if (isNightAlarmOn) {
      nightAlarm = "ON";
    } else {
      nightAlarm = "OFF";
    }
    final success = await NightAlertService.nightAlert(alarm: nightAlarm!);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('저녁알람이 업데이트되었습니다.')),
      );
    }
    return success;
  }

  @override
  void initState() {
    super.initState();
    userInfo();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Text(
            '설정',
            style: TextStyle(
                fontSize: currentWidth < 600 ? 20 : 24,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Column(
            children: [
              const SizedBox(height: 15),
              _buildSettingItem(
                menu: '계정',
                title: '내 계정',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountManagement(
                        email: email!,
                        phoneNum: phoneNum!,
                        password: password!,
                      ),
                    ),
                  );
                },
              ),
              _buildCombinedSwitchItem(),
              _buildSettingItem(
                menu: '문의',
                title: '문의하기',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ContactUs(),
                    ),
                  );
                },
              ),
              _buildSettingItem(
                menu: '도움',
                title: '앱 사용설명서',
                onTap: () async {
                  if (!await launchUrl(Uri.parse(
                      'https://www.notion.so/343b8dda304c415fb9cd0417120103eb?v=d2780555ab674e33b6e9c96e22575921&pvs=4'))) {
                    //도닦기 앱 소개 노션 링크 넣기
                    throw 'Could not launch';
                  }
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  Widget _buildSettingItem(
      {required String menu, required String title, void Function()? onTap}) {
    final currentWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xff2A2A2A),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(menu,
                style: TextStyle(
                    fontSize: currentWidth < 600 ? 12 : 16,
                    color: const Color(0xff949494))),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: currentWidth < 600 ? 12 : 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                if (onTap != null)
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xffD4D4D4),
                    size: 17,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedSwitchItem() {
    final currentWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('알림',
              style: TextStyle(
                  fontSize: currentWidth < 600 ? 12 : 16,
                  color: const Color(0xff949494))),
          const SizedBox(height: 9),
          Row(
            children: [
              Text('동기부여 알림',
                  style: TextStyle(
                      fontSize: currentWidth < 600 ? 12 : 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 13),
              Text('오늘의 응원',
                  style: TextStyle(
                      color: const Color(0xffD4D4D4),
                      fontSize: currentWidth < 600 ? 12 : 16,
                      fontWeight: FontWeight.w300)),
              const Spacer(),
              Transform.scale(
                scale: 0.8, // Switch 크기 줄이기
                child: SizedBox(
                  height: 10,
                  child: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xff18AD00),
                    inactiveTrackColor: const Color(0xff5D5D5D),
                    inactiveThumbColor: Colors.white,
                    value: isMorningAlarmOn != false ? true : false,
                    onChanged: (value) async {
                      // isMorningAlarmOn 값을 업데이트하고 알람을 업데이트하는 비동기 작업 실행
                      setState(() {
                        isMorningAlarmOn = value;
                      });
                      _updateMorningAlarm(isMorningAlarmOn!); // 비동기 함수 호출
                    },
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 13),
          Row(
            children: [
              Text('리마인드 알림',
                  style: TextStyle(
                      fontSize: currentWidth < 600 ? 12 : 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 13),
              Text('일정 리마인드',
                  style: TextStyle(
                      color: const Color(0xffD4D4D4),
                      fontSize: currentWidth < 600 ? 12 : 16,
                      fontWeight: FontWeight.w300)),
              const Spacer(),
              Transform.scale(
                scale: 0.8, // Switch 크기 줄이기
                child: SizedBox(
                  height: 10,
                  child: Switch(
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xff18AD00),
                    inactiveTrackColor: const Color(0xff5D5D5D),
                    inactiveThumbColor: Colors.white,
                    value: isNightAlarmOn != false ? true : false,
                    onChanged: (value) async {
                      // isMorningAlarmOn 값을 업데이트하고 알람을 업데이트하는 비동기 작업 실행
                      setState(() {
                        isNightAlarmOn = value;
                      });
                      await _updateNightAlarm(isMorningAlarmOn!); // 비동기 함수 호출
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
