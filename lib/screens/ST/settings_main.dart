import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/ST/account_management.dart';
import 'package:domino/screens/ST/contact_us.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:domino/apis/services/lr_services.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


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
    if (success) {}
  }

  Future<bool> _updateNightAlarm(bool isNightAlarmOn) async {
    if (isNightAlarmOn) {
      nightAlarm = "ON";
    } else {
      nightAlarm = "OFF";
    }
    final success = await NightAlertService.nightAlert(alarm: nightAlarm!);
    if (success) {}
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
          child: DPTitleText('설정', currentWidth).dPTitleText(),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              Text(
                '계정',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
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
              const SizedBox(height: 8),
              Text(
                '알림',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildCombinedSwitchItem(),
              const SizedBox(height: 8),
              Text(
                '문의',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
                title: '문의하기',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContactUs(email: email!),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              Text(
                '도움',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingItem(
                title: '앱 사용설명서',
                onTap: () async {
                  if (!await launchUrl(Uri.parse(
                      'https://www.notion.so/343b8dda304c415fb9cd0417120103eb?v=d2780555ab674e33b6e9c96e22575921&pvs=4'))) {
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

  Widget _buildSettingItem({required String title, void Function()? onTap}) {
    final currentWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xff2A2A2A),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: currentWidth < 600 ? 12 : 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                if (onTap != null)
                  NewCustomIconButton(() {}, Icons.arrow_forward_ios_rounded,
                          currentWidth, 16)
                      .newCustomIconButton(),
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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('동기부여 알림',
                  style: TextStyle(
                      fontSize: currentWidth < 600 ? 12 : 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 13),
              Text('아침 9시',
                  style: TextStyle(
                      color: Color(0xffAAAAAA),
                      fontSize: currentWidth < 600 ? 12 : 16,
                      fontWeight: FontWeight.w300)),
              const Spacer(),
              customSwitch(time: "morning")
            ],
          ),
          Row(
            children: [
              Text('리마인드 알림',
                  style: TextStyle(
                      fontSize: currentWidth < 600 ? 12 : 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 13),
              Text('저녁 8시',
                  style: TextStyle(
                      color: Color(0xffAAAAAA),
                      fontSize: currentWidth < 600 ? 12 : 16,
                      fontWeight: FontWeight.w300)),
              const Spacer(),
              customSwitch(time: "night")
            ],
          ),
        ],
      ),
    );
  }

  Widget customSwitch({required String time}) {
    final currentWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: currentWidth < 600 ? 32 : 45,
      width: currentWidth < 600 ? 45 : 55,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          activeColor: Colors.white,
          activeTrackColor: const Color(0xff00C300),
          inactiveTrackColor: const Color(0xff474747),
          inactiveThumbColor: Colors.white,
          trackOutlineColor: null,
          value: time == "morning"
              ? isMorningAlarmOn != false
                  ? true
                  : false
              : isNightAlarmOn != false
                  ? true
                  : false,
          onChanged: (value) async {
            setState(() {
              time == 'morning'
                  ? isMorningAlarmOn = value
                  : isNightAlarmOn = value;
            });
            time == 'morning'
                ? _updateMorningAlarm(isMorningAlarmOn!)
                : await _updateNightAlarm(isMorningAlarmOn!);
          },
        ),
      ),
    );
  }
}
