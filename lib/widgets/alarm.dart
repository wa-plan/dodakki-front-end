/*import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
 
  @override
  HomeScreenState createState() => HomeScreenState();
}
 
class HomeScreenState extends State<HomeScreen> {
  int _counter = 0; // _counter 변수를 0으로 초기화
  int _targetNumber = 10; // _targetNumber 변수를 10으로 초기화
  Timer? _timer; // 타이머를 선언
 
  @override
  void initState() {
    super.initState();
    _requestNotificationPermissions(); // 알림 권한 요청
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
    //화면 구성
    return Scaffold(
      appBar: AppBar(title: const Text('쭈미로운 생활 푸시 알림 예제')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('타이머: $_counter'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('알림 시간 입력(초) : '),
                SizedBox(
                  width: 60,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _targetNumber = int.parse(value);
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _resetCounter,
                  child: const Text('초기화'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _toggleTimer,
                  child: Text(_timer?.isActive == true ? '정지' : '시작'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
 
  void _resetCounter() {
    setState(() {
      _counter = 0; // _counter 변수를 0으로 초기화
    });
  }
 
  void _toggleTimer() {
    // 타이머 시작/정지 기능
    if (_timer?.isActive == true) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }
 
  void _startTimer() {
    //타이머 시작
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _counter++;
        if (_counter == _targetNumber) {
          NotificationService().showNotification(_targetNumber);
          _stopTimer();
        }
      });
    });
  }
 
  void _stopTimer() {
    //타이머 정지
    _timer?.cancel();
  }
}


class NotificationService {
  // 싱글톤 패턴을 사용하기 위한 private static 변수
  static final NotificationService _instance = NotificationService._();
  // NotificationService 인스턴스 반환
  factory NotificationService() {
    return _instance;
  }
  // private 생성자
  NotificationService._();
  // 로컬 푸시 알림을 사용하기 위한 플러그인 인스턴스 생성
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  // 초기화 작업을 위한 메서드 정의
  Future<void> init() async {
    // 알림을 표시할 때 사용할 로고를 지정
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // 안드로이드 플랫폼에서 사용할 초기화 설정
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    // 로컬 푸시 알림을 초기화
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  // 푸시 알림 생성
  Future<void> showNotification(int targetNumber) async {
    // 푸시 알림의 ID
    const int notificationId = 0;
    // 알림 채널 설정값 구성
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'counter_channel', // 알림 채널 ID
      'Counter Channel', // 알림 채널 이름
      channelDescription:
          'This channel is used for counter-related notifications',
      // 알림 채널 설명
      importance: Importance.high, // 알림 중요도
    );
    // 알림 상세 정보 설정
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    // 알림 보이기
    await flutterLocalNotificationsPlugin.show(
      notificationId, // 알림 ID
      '목표 도달', // 알림 제목
      '$targetNumber 회 눌렀습니다!', // 알림 메시지
      notificationDetails, // 알림 상세 정보
    );
  }
  // 푸시 알림 권한 요청
  Future<PermissionStatus> requestNotificationPermissions() async {
    final status = await Permission.notification.request();
    return status;
  }
}*/