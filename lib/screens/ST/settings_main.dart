import 'package:domino/screens/LR/agreement.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
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
    await NotificationService().requestNotificationPermissions();
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
              const SizedBox(height: 14),
              MGSubTitle('앱 정보', currentWidth).mgSubTitle(context),
              const SizedBox(height: 8),
              _buildCombinedNavigationItem()
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
              Text('아침 9시',
                  style: TextStyle(
                      color: Color(0xffAAAAAA),
                      fontSize: currentWidth < 600 ? 12 : 16,
                      fontWeight: FontWeight.w400)),
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
              Text('저녁 9시',
                  style: TextStyle(
                      color: Color(0xffAAAAAA),
                      fontSize: currentWidth < 600 ? 12 : 16,
                      fontWeight: FontWeight.w400)),
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
              return Colors.transparent;
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
            // 🔥 먼저 권한 체크
            final status = await Permission.notification.status;

            if (!status.isGranted) {
              if (context.mounted) {
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
                          borderRadius: BorderRadius.all(Radius.circular(7))),
                      height: currentWidth < 600 ? 160 : 220,
                      width: currentWidth < 600 ? 340 : 400,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Image.asset('assets/img/Dominho2.png',
                                  width: currentWidth < 600 ? 84 : 120),
                              SizedBox(width: currentWidth < 600 ? 30 : 50),
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
                                        SizedBox(
                                          width: 5,
                                        ),
                                        const Text(
                                          '알림 권한이 필요해!',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      '설정 앱에서 도닦기 알림을 허용해줘.',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        
                                        NewButton(Colors.black, Colors.white,
                                                '설정으로 이동', () {
                                          Navigator.of(context).pop();
                                          openAppSettings();
                                        }, currentWidth)
                                            .newButton(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: currentWidth < 600 ? 15 : 20,
                                    ),
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
              }
              return; // ❗ 권한 없으면 여기서 끝내고 뒤 코드 실행 안 함
            }

            // 🔥 권한 있을 때만 setState 실행
            setState(() {
              if (time == 'morning') {
                isMorningAlarmOn = value;
              } else {
                isNightAlarmOn = value;
              }
            });

            if (time == 'morning' && isMorningAlarmOn == true) {
              NotificationService().scheduleNotification(time);
            } else if (time == 'night' && isNightAlarmOn == true) {
              NotificationService().scheduleNotification(time);
            }

            if (time == 'morning') {
              _updateMorningAlarm(isMorningAlarmOn!);
            } else {
              await _updateNightAlarm(isNightAlarmOn!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildCombinedNavigationItem() {
    final currentWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(3),
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
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('앱 버전',
                      style: TextStyle(
                          fontSize: currentWidth < 600 ? 13 : 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  Text('1.0.0 (2025.5.1)',
                      style: TextStyle(
                          fontSize: currentWidth < 600 ? 13 : 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 13),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('서비스 이용약관',
                      style: TextStyle(
                          fontSize: currentWidth < 600 ? 13 : 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  NewCustomIconButton(() {
                    showServiceRulePopup(context, currentWidth);
                  }, Icons.arrow_forward_ios_rounded, currentWidth, 14)
                      .newCustomIconButton(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 13),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('개인정보 처리방침',
                      style: TextStyle(
                          fontSize: currentWidth < 600 ? 13 : 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  NewCustomIconButton(() {
                    showAgreementPopup(context, currentWidth);
                  }, Icons.arrow_forward_ios_rounded, currentWidth, 14)
                      .newCustomIconButton(),
                ],
              ),
            ),
          )
        ],
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
        AndroidNotificationDetails('counter_channel', 'Counter Channel',
            channelDescription:
                'This channel is used for counter-related notifications',
            importance: Importance.high,
            icon: '@drawable/smallicon',
            largeIcon: DrawableResourceAndroidBitmap(
                '@drawable/ic_notification'), // 컬러 이미지 표시
            enableVibration: true,
            playSound: true,
            color: backgroundColor);

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    final tz.TZDateTime scheduledTime = _getScheduledTime(time);

    await flutterLocalNotificationsPlugin.show(
      notificationId,
      '도민호의 동기부여',
      '오늘도 아자아자! 도미노를 쓰러뜨리자!!!',
      notificationDetails,
    );

    /*await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      time == 'morning' ? '도민호의 동기부여' : '도민호의 리마인드',
      time == 'morning' ? '오늘도 아자아자! 도미노를 쓰러뜨리자!!!' : '아직 쓰러뜨리지 못한 도미노가 있는지 체크해보자!',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );*/
  }

  tz.TZDateTime _getScheduledTime(String time) {
    final now = tz.TZDateTime.now(
        tz.local); // Make sure tz.local is initialized correctly
    int hour =
        (time == "morning") ? 24 : 24; // 9 AM for "morning", 9 PM for "night"

    tz.TZDateTime scheduledTime =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, 11);

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
