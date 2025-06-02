// DP 메인 페이지
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/DP_main_mandalart.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/DP/Create/dp_create1_page.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/screens/DP/Detail/dp_detail1_page.dart';
import 'package:provider/provider.dart';

class DPMain extends StatefulWidget {
  const DPMain({super.key});

  @override
  State<DPMain> createState() => _DPMainState();
}

class _DPMainState extends State<DPMain> {
  List<Map<String, dynamic>> mainGoals = [];
  List<Map<String, dynamic>> emptyMainGoals = [];
  final PageController _pageController = PageController();
  List<Map<String, String>> inProgressID = [];

  final String message = "";
  String nickname = '';
  String description = '';
  String selectedImage = "assets/img/profile_smp4.png";

  int successNum = 0;
  String mandaDescription = '';
  String bookmark = 'UNBOOKMARK';
  List<Map<String, String>> failedIDs = [];
  List<Map<String, String>> inProgressIDs = [];
  List<Map<String, String>> successIDs = [];
  List<Map<String, String>> nameList = [];
  List<Map<String, String>> statusList = [];
  List<Map<String, String>> ddayList = [];
  List<Map<String, String>> colorList = [];
  List<Map<dynamic, dynamic>> successNums = [];
  Map<String, List<Map<String, String>>> photos = {};
  String? profile;
  String defaultImage = 'assets/img/profile_smp4.png'; // 기본 이미지 경로

  List<Map<String, String>> mandalarts = [];
  List<Map<String, String>> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await userMandaIdInfo(); // 데이터를 먼저 가져오기
    _mainGoalList(); // 데이터를 기반으로 호출
  }

  String ddayFinder(String mandalartId) {
    String dday = ddayList.firstWhere(
          (element) => element['mandalartId'] == mandalartId, // mandalartId와 비교
          orElse: () => {'dday': ''}, // 일치하는 항목이 없을 경우 빈 문자열 반환
        )['dday'] ??
        '0';

    return dday;
  }

  Future<void> userMandaIdInfo() async {
    if (mandalarts.isNotEmpty) return;

    try {
      final data = await UserMandaIdService.userManda();

      if (data.isNotEmpty) {
        setState(() {
          mandalarts = data['mandalarts']!;
          bookmarks = data['bookmarks']!;
        });

        // 비동기 작업 병렬 처리
        final tasks = mandalarts.map((mandalart) async {
          final String mandalartId = mandalart['id'] ?? '0';
          await userMandaInfo(mandalartId);
        });

        await Future.wait(tasks); // 모든 작업 완료를 기다림

        // id 값을 기준으로 오름차순 정렬
        failedIDs.sort((a, b) {
          return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
        });

        inProgressIDs.sort((a, b) {
          // BOOKMARK 상태 확인
          final aBookmark = bookmarks
              .any((bm) => bm["id"] == a["id"] && bm["bookmark"] == "BOOKMARK");
          final bBookmark = bookmarks
              .any((bm) => bm["id"] == b["id"] && bm["bookmark"] == "BOOKMARK");

          // BOOKMARK 상태 기준으로 정렬
          if (aBookmark && !bBookmark) {
            return -1; // a가 BOOKMARK 상태이고, b는 UNBOOKMARK 상태
          }
          if (!aBookmark && bBookmark) {
            return 1; // b가 BOOKMARK 상태이고, a는 UNBOOKMARK 상태
          }

          // 같은 상태라면 id 값 기준 정렬 (오름차순)
          return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
        });

        context.read<GoalOrder>().saveGoalOrder(inProgressIDs);

        successIDs.sort((a, b) {
          return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
        });
      }
    } catch (e) {
      // 에러 발생 시 처리
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터 로드 중 오류가 발생했습니다: $e')),
      );
    }
  }

  Future<void> userMandaInfo(String mandalartId) async {
    if (nameList.any((item) => item['mandalartId'] == mandalartId)) return;

    try {
      final data = await UserMandaInfoService.userMandaInfo(context,
          mandalartId: int.parse(mandalartId));

      if (data != null) {
        String id = mandalartId;
        String name = data['name'] ?? '';
        String status = data['status']?.toString() ?? '';
        List<dynamic> photoList = data['photoList'] ?? [];
        String dday = data['dday']?.toString() ?? '0';
        int successNum = data['statusNum']?['successNum'] ?? 0;

        setState(() {
          if (status == "FAIL") failedIDs.add({"id": id, "name": name});
          if (status == "IN_PROGRESS") {
            inProgressIDs.add({"id": id, "name": name});
          }
          if (status == "SUCCESS") successIDs.add({"id": id, "name": name});

          nameList.add({'mandalartId': id, 'name': name});
          statusList.add({'mandalartId': id, 'status': status});
          ddayList.add({'mandalartId': id, 'dday': dday});
          successNums.add({'mandalartId': id, 'successNum': successNum});

          // 사진 리스트를 photos에 저장
          if (photoList.isNotEmpty) {
            photos[id] = [];
            for (var photo in photoList) {
              photos[id]?.add({
                'path': photo['path'] ?? '',
                'id': photo['id'].toString(),
              });
            }
          }
        });
      } else {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터 로드 실패: $e')),
      );
    }
  }

  void _mainGoalList() async {
    List<Map<String, dynamic>>? goals =
        await MainGoalListService.mainGoalList(context);
    if (goals != null) {
      List<Map<String, dynamic>> filteredGoals = [];
      List<Map<String, dynamic>> emptySecondGoals =
          []; // 비어 있는 secondGoals를 위한 리스트 추가
      List<Map<String, String>> inProgressID =
          Provider.of<GoalOrder>(context, listen: false).goalOrder;

      for (var goal in inProgressID) {
        final mandalartId = goal['id'].toString();
        final name = goal['name']; // 목표의 이름 가져오기

        // Fetch second goals to check their content
        final data = await _fetchSecondGoals(mandalartId);
        if (data != null) {
          final secondGoals =
              data[0]['secondGoals'] as List<Map<String, dynamic>>?;

          // Only add the goal if secondGoals is not null and not empty
          if (secondGoals != null &&
              secondGoals.isNotEmpty &&
              secondGoals != "") {
            filteredGoals.add(goal);
          } else {
            // secondGoals가 비어있을 경우 mandalartId와 name을 emptySecondGoals 리스트에 추가
            emptySecondGoals.add({
              'mandalartId': mandalartId,
              'name': name,
            });
          }
        }
      }

      setState(() {
        mainGoals = filteredGoals;
        emptyMainGoals = emptySecondGoals;
      });
    }
  }

  Future<List<Map<String, dynamic>>?> _fetchSecondGoals(
      String mandalartId) async {
    return await SecondGoalListService.secondGoalList(context, mandalartId);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
                  //초기화 로직
                  for (int i = 0; i < 9; i++) {
                    context
                        .read<SaveInputtedDetailGoalModel>()
                        .updateDetailGoal(i.toString(), "");
                  }

                  for (int i = 0; i < 9; i++) {
                    context
                        .read<TestInputtedDetailGoalModel>()
                        .updateTestDetailGoal(i.toString(), "");
                  }

                  for (int i = 0; i < 9; i++) {
                    context
                        .read<GoalColor>()
                        .updateGoalColor(i.toString(), const Color(0xff929292));
                  }

                  for (int i = 0; i < 9; i++) {
                    for (int j = 0; j < 9; j++) {
                      context
                          .read<SaveInputtedActionPlanModel>()
                          .updateActionPlan(i, j.toString(), "");
                    }
                  }

                  for (int i = 0; i < 9; i++) {
                    for (int j = 0; j < 9; j++) {
                      context
                          .read<TestInputtedActionPlanModel>()
                          .updateTestActionPlan(i, j.toString(), "");
                    }
                  }

                  // 살짝 기다려줌 (프레임 간 처리 타이밍 보장)
                  await Future.delayed(Duration(milliseconds: 10));

                  // 화면 전환
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DPcreateSelectPage(
                        emptyMainGoals: emptyMainGoals,
                      ),
                    ),
                  );
                },
        backgroundColor: mainRed,
        shape: const CircleBorder(),
        mini: true,
        heroTag: null,
        child: Icon(
          Icons.add,
          color: backgroundColor,
          size: 25,
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: DPTitleText('도미노 플랜', currentWidth).dPTitleText(),
        ),
        backgroundColor: backgroundColor,
      ),
      bottomNavigationBar: const NavBar(),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            
            SizedBox(height: currentWidth < 600 ? 10 : 15),
            mainGoals.isEmpty
                ? Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xff2D2D2D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        // 텍스트: 좌측 상단 정렬
                        Positioned(
                          top: 25, // 텍스트의 상단 여백
                          left: 25, // 텍스트의 좌측 여백
                          child: Text(
                            '아직 플랜이 없어요.\n목표를 이루려면\n철저한 계획은 필수!',
                            style: TextStyle(
                                color: Color(0xff595959),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.7),
                          ),
                        ),
                        // 이미지: 우측 하단 정렬
                        Positioned(
                          bottom: 0, // 이미지의 하단 여백
                          right: 0, // 이미지의 우측 여백
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              'assets/img/emptyDominho.png',
                              height: 190,
                              // 이미지 크기 유지
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

                //만다라트 목록 UI
                : SizedBox(
                    height: 440,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: mainGoals.length,
                      itemBuilder: (context, index) {
                        final goal = mainGoals[index];
                        final mandalartId = goal['id'].toString();

                        return FutureBuilder<List<Map<String, dynamic>>?>(
                          future: _fetchSecondGoals(mandalartId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(
                                child: Text(
                                  '데이터를 불러오는 데 실패했습니다.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  '목표가 없습니다.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              );
                            } else {
                              final data = snapshot.data!;
                              final firstColor = data[0]['color'];
                              final mandalart = data[0]['mandalart'];
                              final secondGoals = data[0]['secondGoals']
                                  as List<Map<String, dynamic>>?;

                              if (secondGoals == null || secondGoals.isEmpty) {
                                return const SizedBox.shrink();
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DPdetailPage(
                                        mandalart: mandalart,
                                        secondGoals: secondGoals,
                                        mandalartId: int.parse(mandalartId),
                                        firstColor: firstColor,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    color: Color(0xff2A2A2A),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    children: [
                                      //디데이
                                      DdayTag(int.parse(
                                              ddayFinder(mandalartId)))
                                          .ddayTag(),
                                      SizedBox(height: 15),
                                      //제1목표
                                      Text(
                                        mandalart,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 35),
                                      //만다라트
                                      MandalartGrid(
                                        mandalart: mandalart,
                                        firstColor: firstColor,
                                        secondGoals: secondGoals,
                                        mandalartId: int.parse(mandalartId),
                                        currentHeight: currentHeight,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            //페이지 인디케이터
            PageIndicator(_pageController, mainGoals).pageIndicator(),
          ],
        ),
      ),
    );
  }
}
