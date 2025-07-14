import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_myGoal.dart';
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
import 'package:domino/screens/Tutorial/tutorial1_page.dart';

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
              MGSubTitle(
                '계정',
              ).mgSubTitle(context),
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
              MGSubTitle(
                '알림',
              ).mgSubTitle(context),
              const SizedBox(height: 8),
              _buildCombinedSwitchItem(),
              const SizedBox(height: 14),
              MGSubTitle(
                '문의',
              ).mgSubTitle(context),
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
              MGSubTitle(
                '도움',
              ).mgSubTitle(context),
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
              MGSubTitle(
                '앱 정보',
              ).mgSubTitle(context),
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
                        fontSize: 15,
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
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 13),
              Text('아침 9시',
                  style: TextStyle(
                      color: Color(0xffAAAAAA),
                      fontSize: 14,
                      fontWeight: FontWeight.w400)),
              const Spacer(),
              customSwitch(time: "morning")
            ],
          ),
          SizedBox(height: 2),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('리마인드 알림',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              const SizedBox(width: 13),
              Text('저녁 9시',
                  style: TextStyle(
                      color: Color(0xffAAAAAA),
                      fontSize: 14,
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
          activeTrackColor: mainRed,
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
                                        }).newButton(),
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
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  Text('1.0.14  ',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('서비스 이용약관',
                      style: TextStyle(
                          fontSize: 15,
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
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {},
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('개인정보 처리방침',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  NewCustomIconButton(() {
                    showPersonalInfoPopup(context, currentWidth);
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

  Future<void> init() async {
    await _initializeTimezone();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _initializeTimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
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
      icon: '@drawable/smallicon',
      largeIcon: DrawableResourceAndroidBitmap('@drawable/ic_notification'),
      enableVibration: true,
      playSound: true,
      color: backgroundColor,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    final tz.TZDateTime scheduledTime = _getScheduledTime(time);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      time == 'morning' ? '도민호의 동기부여' : '도민호의 리마인드',
      time == 'morning'
          ? '오늘도 아자아자! 도미노를 쓰러뜨리자!!!'
          : '아직 쓰러뜨리지 못한 도미노가 있는지 체크해보자!',
      scheduledTime,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  tz.TZDateTime _getScheduledTime(String time) {
    final now = tz.TZDateTime.now(tz.local);
    int hour = time == "morning" ? 9 : 21;

    tz.TZDateTime scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      0,
    );

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

void showServiceRulePopup(BuildContext context, double currentWidth) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(23, 25, 23, 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: SizedBox(
            width: 300,
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '서비스 이용약관',
                            style: TextStyle(
                                color: backgroundColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  'https://sites.google.com/view/dodakki-policy/privacy-policy'))) {
                                throw 'Could not launch';
                              }
                            },
                            child: Icon(
                              Icons.link_rounded,
                              color: backgroundColor,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '''1. 동의
사용자가 도닦기 앱을 다운로드하거나 사용하는 경우, 아래 조건에 동의한 것으로 간주됩니다. 본 약관을 숙지 후 사용해 주시기 바랍니다.


2. 지식재산권
앱 및 그 구성 요소에 대한 저작권, 상표권, 데이터베이스 권리 등은 “도를 닦는 사람들”에게 있으며, 무단 복제, 수정, 배포를 금합니다.


3. 서비스 제공
앱은 최선의 서비스 제공을 위해 수시로 업데이트되며, 서비스 제공자는 예고 없이 앱의 일부 기능을 수정하거나 중단할 수 있습니다.


4. 인터넷 연결
일부 기능은 인터넷 연결을 필요로 하며, 연결 불가 시 앱이 정상 작동하지 않을 수 있습니다. 데이터 요금은 사용자 책임입니다.


5. 기기 사용 책임
기기 충전 상태, 성능 저하 등으로 인해 앱 사용에 제한이 생길 경우, 이는 사용자 책임입니다.


6. 업데이트 및 종료
앱은 운영체제 업데이트나 정책 변경에 따라 업데이트가 필요할 수 있으며, 서비스 제공자는 앱의 배포를 중단할 권리를 가집니다.


7. 향후 광고
현재 앱은 광고를 포함하지 않으나, 추후 광고 기능이 추가될 수 있으며 그에 따라 약관 및 방침이 변경될 수 있습니다.''',
                        style: TextStyle(
                            color: backgroundColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NewButton(Colors.black, Colors.white, '닫기', () {
                        Navigator.pop(context);
                      }).newButton(),
                    ],
                  )
                ],
              ),
            ),
          ));
    },
  );
}

void showPersonalInfoPopup(BuildContext context, double currentWidth) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(23, 25, 23, 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: SizedBox(
            width: 300,
            height: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '개인정보 처리방침',
                            style: TextStyle(
                                color: backgroundColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  'https://sites.google.com/view/dodakki-policy/privacy-policy'))) {
                                throw 'Could not launch';
                              }
                            },
                            child: Icon(
                              Icons.link_rounded,
                              color: backgroundColor,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '''이 개인정보처리방침은 “도를 닦는 사람들”(이하 “서비스 제공자”)이 제공하는 모바일 애플리케이션 도닦기(dodakki) (이하 “앱”)에 적용됩니다. 본 앱은 오픈소스로 제공되며, “있는 그대로(AS IS)”의 형태로 사용됩니다.


1. 수집하는 정보 및 이용 목적
사용자 제공 정보: 이메일 주소, 전화번호 (회원가입 및 인증 목적)
자동 수집 정보: 앱 사용 시점, 사용 시간, 기기 운영체제 정보 등
앱은 정확한 위치정보를 수집하지 않습니다.


2. 알림 기능
앱은 flutter_local_notifications 및 timezone 패키지를 통해 로컬 알림(Local Notification) 기능을 제공합니다. 외부 서버나 제3자 서비스와 연결되지 않으며, 개인정보를 수집하지 않습니다.


3. 제3자 서비스
앱은 다음 외부 서비스를 사용할 수 있습니다:
- OpenAI API


4. 정보 제공 및 공개
서비스 제공자는 아래의 경우 사용자 정보를 공개할 수 있습니다:
- 법령에 따른 요구 또는 수사 협조
- 사기 방지, 안전 보호 등 공익적 목적
- 서비스 운영을 지원하는 위탁사 (보안 준수 조건)


5. 수집 거부 권리
앱 삭제를 통해 모든 정보 수집을 중단할 수 있습니다.


6. 데이터 보관 및 삭제
서비스 제공자는 수집된 개인정보를 필요한 기간 동안 보관하며, 사용자가 요청 시 즉시 삭제합니다. 삭제 요청은 이메일(dodakki123@gmail.com)로 접수 가능합니다.


7. 아동의 개인정보
앱은 만 13세 미만 아동의 개인정보를 의도적으로 수집하지 않습니다. 수집 사실이 확인되면 즉시 삭제 조치하며, 보호자는 이메일로 연락 부탁드립니다.


8. 보안
서비스 제공자는 사용자 정보 보호를 위해 물리적·전자적 보안 조치를 적용합니다.


9. 방침 변경
본 방침은 수시로 변경될 수 있으며, 변경 시 본 페이지에 고지됩니다.


10. 앱 권한
앱은 아래 기능 제공을 위해 다음 권한을 요청할 수 있습니다:
- 알림 권한: 사용자에게 목표 알림 등 로컬 알림을 제공하기 위해 사용됩니다.
- 사진 및 갤러리 접근 권한: 사용자가 프로필 사진을 설정할 수 있도록 하기 위해 사용됩니다. 사용자가 목표를 설정할 때 목표 이미지를 업로드할 수 있도록 하기 위해 사용됩니다.


해당 권한들은 명시적인 사용자 동의 하에 요청되며, 고지된 목적 외에는 사용되지 않으며, 제3자에게 제공되지 않습니다.
              
시행일자: 2025년 4월 20일''',
                        style: TextStyle(
                            color: backgroundColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NewButton(Colors.black, Colors.white, '닫기', () {
                        Navigator.pop(context);
                      }).newButton(),
                    ],
                  )
                ],
              ),
            ),
          ));
    },
  );
}
