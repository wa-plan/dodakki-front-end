import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/mainPage_mandalart.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/DP/Create/goalSelect_page.dart';
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
  List<Map<String, dynamic>> secondGoals = [];
  final PageController _pageController = PageController();
  List<Map<String, String>> inProgressID = [];
  List<Map<String, String>> failedIDs = [];
  List<Map<String, String>> inProgressIDs = [];
  List<Map<String, String>> successIDs = [];
  List<Map<String, String>> nameList = [];
  List<Map<String, String>> statusList = [];
  List<Map<String, String>> ddayList = [];
  List<Map<String, String>> colorList = [];
  List<Map<dynamic, dynamic>> successNums = [];
  List<Map<String, String>> mandalarts = [];
  List<Map<String, String>> bookmarks = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await userMandaIdInfo();
    _mainGoalList(); 
  }

  String ddayFinder(String mandalartId) {
    String dday = ddayList.firstWhere(
          (element) => element['mandalartId'] == mandalartId, 
          orElse: () => {'dday': ''},
        )['dday'] ??
        '0';
    return dday;
  }

  Future<void> userMandaIdInfo() async {
    if (mandalarts.isNotEmpty) return;

    final data = await UserMandaIdService.userManda();

    if (data.isNotEmpty) {
      setState(() {
        mandalarts = data['mandalarts']!;
        bookmarks = data['bookmarks']!;
      });

      final tasks = mandalarts.map((mandalart) async {
        final String mandalartId = mandalart['id'] ?? '0';
        await userMandaInfo(mandalartId);
      });

      await Future.wait(tasks); 

      failedIDs.sort((a, b) {
        return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
      });

      inProgressIDs.sort((a, b) {
        final aBookmark = bookmarks
            .any((bm) => bm["id"] == a["id"] && bm["bookmark"] == "BOOKMARK");
        final bBookmark = bookmarks
            .any((bm) => bm["id"] == b["id"] && bm["bookmark"] == "BOOKMARK");

        if (aBookmark && !bBookmark) {
          return -1; 
        }
        if (!aBookmark && bBookmark) {
          return 1; 
        }

        return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
      });

      context.read<GoalOrder>().saveGoalOrder(inProgressIDs);

      successIDs.sort((a, b) {
        return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
      });
    }
  }

  Future<void> userMandaInfo(String mandalartId) async {
    if (nameList.any((item) => item['mandalartId'] == mandalartId)) return;

    final data = await UserMandaInfoService.userMandaInfo(context,
        mandalartId: int.parse(mandalartId));

    if (data != null) {
      String id = mandalartId;
      String name = data['name'] ?? '';
      String status = data['status']?.toString() ?? '';
      String dday = data['dday']?.toString() ?? '0';

      setState(() {
        if (status == "FAIL") failedIDs.add({"id": id, "name": name});
        if (status == "IN_PROGRESS") {
          inProgressIDs.add({"id": id, "name": name});
        }
        if (status == "SUCCESS") successIDs.add({"id": id, "name": name});

        nameList.add({'mandalartId': id, 'name': name});
        statusList.add({'mandalartId': id, 'status': status});
        ddayList.add({'mandalartId': id, 'dday': dday});
      });
    } else {}
  }

  void _mainGoalList() async {
    List<Map<String, dynamic>>? goals =
        await MainGoalListService.mainGoalList(context);
    if (goals != null) {
      List<Map<String, dynamic>> filteredGoals = [];
      List<Map<String, dynamic>> emptySecondGoals =
          []; 
      List<Map<String, String>> inProgressID =
          Provider.of<GoalOrder>(context, listen: false).goalOrder;

      for (var goal in inProgressID) {
        final mandalartId = goal['id'].toString();
        final name = goal['name'];

        final data = await _fetchSecondGoals(mandalartId);
        if (data != null) {
          final secondGoals =
              data[0]['secondGoals'] as List<Map<String, dynamic>>?;

          if (secondGoals != null &&
              secondGoals.isNotEmpty &&
              secondGoals != "") {
            filteredGoals.add(goal);
          } else {
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
        secondGoals = secondGoals;
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

    return Scaffold(
      backgroundColor: backgroundColor,
      //추가 플로팅 버튼
      floatingActionButton: FloatingButton(
        Icons.add, 
        () async {
          resetAllProviders(context);
          await Future.delayed(Duration(milliseconds: 10));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DPcreateSelectPage(
                emptyMainGoals: emptyMainGoals,
                secondGoals: secondGoals,
              ),
            ),
          );
        }, 25).floatingButton(),
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
            SizedBox(height: 10),
            mainGoals.isEmpty
            //도미노 플랜이 없을 경우.
                ? Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xff2D2D2D),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 25, 
                          left: 25, 
                          child: Text(
                            '아직 플랜이 없어요.\n목표를 이루려면\n철저한 계획은 필수!',
                            style: TextStyle(
                                color: Color(0xff595959),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                height: 1.7),
                          ),
                        ),
                        Positioned(
                          bottom: 0, 
                          right: 0, 
                          child: Opacity(
                            opacity: 0.3,
                            child: Image.asset(
                              'assets/img/emptyDominho.png',
                              height: 190,
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
                                        firstGoalName: mandalart,
                                        secondGoals: secondGoals,
                                        mandalartId: int.parse(mandalartId),
                                        firstGoalColor: ColorTransform(firstColor).colorTransform(),
                                        dday: ddayFinder(mandalartId),
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(30),
                                  margin: const EdgeInsets.all(5),
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
                                      SizedBox(height: 20),
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
                                      IgnorePointer(
                                        child: MainMandalart(
                                          firstGoalName: mandalart, 
                                          secondGoals: secondGoals, 
                                          mandalartId: int.parse(mandalartId), 
                                          firstGoalColor: 
                                          ColorTransform(firstColor).colorTransform(),
                                          size: 250,
                                          detail: false,),
                                      )
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
            PageIndicator(_pageController, mainGoals),
          ],
        ),
      ),
    );
  }
}
