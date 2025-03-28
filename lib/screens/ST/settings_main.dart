import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/ST/account_management.dart';
import 'package:domino/screens/ST/contact_us.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:domino/apis/services/lr_services.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    _requestNotificationPermissions(); // 알림 권한 요청
    NotificationService().init();
    userInfo();
  }

  void _requestNotificationPermissions() async {
    //알림 권한 요청
    final status = await NotificationService().requestNotificationPermissions();
    if (status.isDenied && context.mounted) {
      showDialog(
        // 알림 권한이 거부되었을 경우 다이얼로그 출력
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('알림 권한이 거부되었습니다.'),
          content: const Text('알림을 받으려면 앱 설정에서 권한을 허용해야 합니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('설정'), //다이얼로그 버튼의 죄측 텍스트
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); //설정 클릭시 권한설정 화면으로 이동
              },
            ),
            TextButton(
              child: const Text('취소'), //다이얼로그 버튼의 우측 텍스트
              onPressed: () => Navigator.of(context).pop(), //다이얼로그 닫기
            ),
          ],
        ),
      );
    }
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
              MGSubTitle('계정', currentWidth).mgSubTitle(context),
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
              const SizedBox(height: 14),
              MGSubTitle('알림', currentWidth).mgSubTitle(context),
              const SizedBox(height: 8),
              _buildCombinedSwitchItem(),
              const SizedBox(height: 14),
              MGSubTitle('문의', currentWidth).mgSubTitle(context),
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
              const SizedBox(height: 14),
              MGSubTitle('도움', currentWidth).mgSubTitle(context),
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
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xff2A2A2A),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02), // 검은색 10% 투명도
              offset: const Offset(0, 0), // X, Y 위치 (0,0)
              blurRadius: 15, // 블러 7
              spreadRadius: 0, // 스프레드 0
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                NewCustomIconButton(onTap as Function,
                        Icons.arrow_forward_ios_rounded, currentWidth, 14)
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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02), // 검은색 10% 투명도
              offset: const Offset(0, 0), // X, Y 위치 (0,0)
              blurRadius: 15, // 블러 7
              spreadRadius: 0, // 스프레드 0
            ),
          ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('동기부여 알림',
                  style: TextStyle(
                      fontSize: currentWidth < 600 ? 13 : 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 13),
              Text('아침 9시, 도민호의 응원',
                  style: TextStyle(
                      color: Color(0xffAAAAAA),
                      fontSize: currentWidth < 600 ? 12 : 16,
                      fontWeight: FontWeight.w300)),
              const Spacer(),
              customSwitch(time: "morning")
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('리마인드 알림',
                  style: TextStyle(
                      fontSize: currentWidth < 600 ? 13 : 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 13),
              Text('저녁 9시, 도민호의 할일 체크',
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
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (true) {
                return Colors.transparent;
              }
            },
          ),
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

            time == 'morning' && isMorningAlarmOn == true
                ? NotificationService().scheduleNotification(time)
                : null;
            time == 'night' && isNightAlarmOn == true
                ? NotificationService().scheduleNotification(time)
                : null;

            time == 'morning'
                ? _updateMorningAlarm(isMorningAlarmOn!)
                : await _updateNightAlarm(isMorningAlarmOn!);
          },
        ),
      ),
    );
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the time zone data before using it
  Future<void> init() async {
    // Initialize time zones data
    await _initializeTimezone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Ensuring time zone data is initialized properly
  Future<void> _initializeTimezone() async {
    tz.initializeTimeZones();
    // Explicitly set the local timezone once timezones are initialized
    tz.setLocalLocation(tz.getLocation(
        'Asia/Seoul')); // Adjust the location as needed (this is for Seoul)
  }

  Future<void> scheduleNotification(String time) async {
    const int notificationId = 0;

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'counter_channel',
      'Counter Channel',
      channelDescription:
          'This channel is used for counter-related notifications',
      importance: Importance.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    final tz.TZDateTime scheduledTime = _getScheduledTime(time);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      '알람 on',
      '$time 푸시알림 on 성공',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _getScheduledTime(String time) {
    final now = tz.TZDateTime.now(
        tz.local); // Make sure tz.local is initialized correctly
    int hour =
        (time == "morning") ? 9 : 21; // 9 AM for "morning", 9 PM for "night"

    tz.TZDateTime scheduledTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, 0);

    // If the time is in the past, schedule for the next day
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    return scheduledTime;
  }

  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }
}
