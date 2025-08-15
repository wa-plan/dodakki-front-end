import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final mandalartProvider = context.read<MandalartProvider>();

    // 1️⃣ 모든 만다라트 정보 가져오기
    final data = await UserMandaIdService.userManda();
    List<Map<String, String>> mandalarts = data['mandalarts'] ?? [];
    List<Map<String, String>> bookmarks = data['bookmarks'] ?? [];

    List<Map<String, String>> inProgressIDs = [];
    List<Map<String, String>> failedIDs = [];
    List<Map<String, String>> successIDs = [];
    List<Map<String, String>> nameList = [];
    List<Map<String, String>> statusList = [];
    List<Map<String, String>> ddayList = [];

    // 2️⃣ 모든 만다라트 상세 정보 가져오기
    await Future.wait(mandalarts.map((mandalart) async {
      final mandalartId = mandalart['id'] ?? '0';
      final info = await UserMandaInfoService.userMandaInfo(context,
          mandalartId: int.parse(mandalartId));
      if (info != null) {
        final id = mandalartId;
        final name = info['name'] ?? '';
        final status = info['status']?.toString() ?? '';
        final dday = info['dday']?.toString() ?? '0';

        nameList.add({'mandalartId': id, 'name': name});
        statusList.add({'mandalartId': id, 'status': status});
        ddayList.add({'mandalartId': id, 'dday': dday});

        if (status == "FAIL") failedIDs.add({"id": id, "name": name});
        if (status == "IN_PROGRESS")
          inProgressIDs.add({"id": id, "name": name});
        if (status == "SUCCESS") successIDs.add({"id": id, "name": name});
      }
    }));

    // 3️⃣ MainGoal, EmptyMainGoal 처리
    List<Map<String, dynamic>> mainGoals = [];
    List<Map<String, dynamic>> emptyMainGoals = [];
    List<Map<String, dynamic>> secondGoals = [];

    for (var goal in inProgressIDs) {
      final mandalartId = goal['id']!;
      final data =
          await SecondGoalListService.secondGoalList(context, mandalartId);

      final secondGoalData =
          data?[0]['secondGoals'] as List<Map<String, dynamic>>?;

      if (secondGoalData != null && secondGoalData.isNotEmpty) {
        mainGoals.add(goal);
      } else {
        emptyMainGoals.add({'mandalartId': mandalartId, 'name': goal['name']});
      }

      // ✅ mandalartId 추가해서 secondGoals 저장
      if (data != null) {
        for (var item in data) {
          item['mandalartId'] = mandalartId; // 추가
          secondGoals.add(item);
        }
      }
    }

    // 4️⃣ 최소 표시 시간 확보
    await Future.delayed(const Duration(seconds: 3));

    // 5️⃣ Provider에 저장
    mandalartProvider.setMandalartData(
      mainGoals: mainGoals,
      emptyMainGoals: emptyMainGoals,
      secondGoals: secondGoals,
      inProgressIDs: inProgressIDs,
      failedIDs: failedIDs,
      successIDs: successIDs,
      nameList: nameList,
      statusList: statusList,
      ddayList: ddayList,
      mandalarts: mandalarts,
      bookmarks: bookmarks,
    );

    // 🔍 저장 확인 로그
    print('✅ Provider 저장 완료');
    print('mainGoals: ${mandalartProvider.mainGoals}');
    print('emptyMainGoals: ${mandalartProvider.emptyMainGoals}');
    print('secondGoals: ${mandalartProvider.secondGoals}');
    print('inProgressIDs: ${mandalartProvider.inProgressIDs}');
    print('failedIDs: ${mandalartProvider.failedIDs}');
    print('successIDs: ${mandalartProvider.successIDs}');

    // 6️⃣ TdMain으로 이동
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => TdMain()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: fullPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/img/splash(2).png',
                    scale: 5,
                  ),
                  const SizedBox(height: 30),
                  const DominoLoading(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
