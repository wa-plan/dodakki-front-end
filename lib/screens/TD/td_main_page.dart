import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/TD/td_create1_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:domino/widgets/TD/event_calendar.dart';
import 'package:domino/style/styles.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_redirect/store_redirect.dart';

class TdMain extends StatefulWidget {
  const TdMain({super.key});

  @override
  State<TdMain> createState() => _TdMainState();
}

class _TdMainState extends State<TdMain> {
  static const String latestAppVersion = '1.0.17'; // 하드코딩 최신 버전

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForceUpdate(); // 앱 시작 시 강제 업데이트 체크
    });
  }

  // 현재 앱 버전 가져오기
  Future<String> _getCurrentVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  // 버전 비교
  bool _isVersionOlder(String current, String latest) {
    List<int> currentParts = current.split('.').map(int.parse).toList();
    List<int> latestParts = latest.split('.').map(int.parse).toList();

    for (int i = 0; i < latestParts.length; i++) {
      if (i >= currentParts.length) return true;
      if (currentParts[i] < latestParts[i]) return true;
      if (currentParts[i] > latestParts[i]) return false;
    }
    return false;
  }

  // 강제 업데이트 체크
  Future<void> _checkForceUpdate() async {
    try {
      String currentVersion = await _getCurrentVersion();
      print('currentVersion=$currentVersion');
      bool forceUpdate = _isVersionOlder(currentVersion, latestAppVersion);

      if (forceUpdate) {
        _showForceUpdateDialog();
      }
    } catch (e) {
      print("Force update check failed: $e");
    }
  }

  // 강제 업데이트 다이얼로그
  void _showForceUpdateDialog() {
    showDialog(
      barrierDismissible: false, // 닫을 수 없게 설정
      context: context,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false, // 뒤로가기 차단
          child: AlertDialog(
            title: const Text(
              '최신 버전 업데이트',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: const Text('중요한 변경으로 인해 업데이트를 해야만 앱을 이용할 수 있어요.',
                style: TextStyle(color: Colors.black, fontSize: 16)),
            actions: [
              TextButton(
                onPressed: () {
                  // Android 전용 앱스토어 이동
                  StoreRedirect.redirect(androidAppId: 'com.dodakki.domino');
                },
                child: const Text('업데이트'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      //오늘의 도미노 추가 버튼
      floatingActionButton: FloatingButton(Icons.add, () {
        context.read<SelectAPModel>().selectAP("만다라트에서 플랜을 선택해주세요.", null);
        context
            .read<SelectRepeatModel>()
            .selectRepeat(false, false, false, false);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPage1(),
            ));
      }, 25)
          .floatingButton(),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              Image.asset(
                'assets/img/td_icon.png',
                scale: 10,
              ),
              SizedBox(width: 10),
              DPTitleText('오늘의 도미노', currentWidth).dPTitleText(),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),

      body: const Padding(padding: fullPadding, child: EventCalendar()),
      bottomNavigationBar: const NavBar(),
    );
  }
}