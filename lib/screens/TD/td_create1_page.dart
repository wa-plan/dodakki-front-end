import 'package:domino/apis/services/dp_services.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_todaysDomino.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/td_create1_widget.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/TD/td_create2_page.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';

class AddPage1 extends StatefulWidget {
  const AddPage1({super.key});

  @override
  State<AddPage1> createState() => _AddPage1State();
}

class _AddPage1State extends State<AddPage1> {
  String selectedGoalName = "";
  String nextStage = '';
  List<Map<String, dynamic>> secondGoals = [];
  List<Map<String, dynamic>> mainGoals = []; // 데이터의 타입 변경
  int mandalartId = 1;
  String selectedGoalId = "";
  int thirdGoalId = 0;
  List<Map<String, dynamic>> emptyMainGoals = [];
  String firstColor = '0xff000000';

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
    setState(() {
      thirdGoalId = 0; // 초기화
    });
    _mainGoalList(); // 데이터를 기반으로 호출
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
      });
    } else {}
  }

  Future<void> userMandaIdInfo() async {
    if (mandalarts.isNotEmpty) return;

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
    // Fetch the result from the SecondGoalListService
    List<Map<String, dynamic>>? result =
        await SecondGoalListService.secondGoalList(context, mandalartId);

    // Check if the result is not null and contains data
    if (result != null && result.isNotEmpty) {
      setState(() {
        secondGoals =
            result[0]['secondGoals']; // Update the secondGoals state variable
        firstColor = result[0]['color'];
      });
    }

    // Return the result (this allows you to use the result wherever you call this function)
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    int thirdGoalId =
        int.tryParse(context.watch<SelectAPModel>().selectedAPID.toString()) ??
            0;

    String thirdGoalName =
        context.watch<SelectAPModel>().selectedAPName.toString();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              //나가기 버튼
              CustomBackButton(
                () {
                  context
                      .read<SelectAPModel>()
                      .selectAP("제3목표를 클릭하여 선택해주세요.", null);
                  context
                      .read<SelectRepeatModel>()
                      .selectRepeat(false, false, false, false);
                  Navigator.pop(context);
                },
              ).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('도미노 만들기').pageTitle(),
              const Spacer(),

              //프로그레스 바 (from style_tutorial.dart)
              ProgressBar(0, 2)
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TDQuestion('어떤 목표와 관련됐나요?', currentWidth).tDQuestion(),
              SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xff2A2A2A),
                ),
                child: FutureBuilder(
                  future: MainGoalListService.mainGoalList(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text(
                          '목표를 불러오는 데 실패했습니다.',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    } else if (snapshot.hasData) {
                      // createdGoals에 있는 목표만 필터링
                      List<Map<String, dynamic>> goals = mainGoals;

                      // 기본 옵션을 시작으로 추가
                      List<Map<String, dynamic>> options = [
                        {'id': '0', 'name': '클릭해서 목표를 선택해 주세요.'},
                        ...goals
                      ];

                      return DropdownButton<String>(
                        value: selectedGoalId.isNotEmpty ? selectedGoalId : '0',
                        items: options.map<DropdownMenuItem<String>>((goal) {
                          final goalName = goal['name'] ?? 'Unknown Goal';
                          final isGuideText = goalName == '클릭해서 목표를 선택해 주세요.';
                          return DropdownMenuItem<String>(
                            value: goal['id'].toString(),
                            child: Text(
                              goalName,
                              style: TextStyle(
                                  color: isGuideText
                                      ? const Color(0xff888888)
                                      : Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value != null) {
                            setState(() {
                              selectedGoalId = value;
                              if (value == '0') {
                                selectedGoalName = '';
                              } else {
                                final selectedGoal = options.firstWhere(
                                  (goal) => goal['id'].toString() == value,
                                );
                                selectedGoalName = selectedGoal['name'] ?? '';
                                _fetchSecondGoals(selectedGoalId);
                              }
                            });
                          }
                        },
                        isExpanded: true,
                        dropdownColor: const Color(0xff2A2A2A),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13),
                        icon: Icon(
                          Icons.arrow_drop_down_rounded, // 원하는 아이콘으로 변경 가능
                          color: const Color(0xff888888),
                          size: 30, // 아이 // 아이콘 크기 조절
                        ),
                        underline: Container(),
                        elevation: 0,
                        borderRadius: BorderRadius.circular(6),
                      );
                    } else {
                      return const Center(
                        child: Text(
                          '목표가 없습니다.',
                          style: TextStyle(
                              color: Color(0xff888888),
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      );
                    }
                  },
                ),
              ),
              if (selectedGoalName != "") ...[
                SizedBox(height: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TDQuestion('어떤 플랜과 관련됐나요?', currentWidth).tDQuestion(),
                    SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                      height: 60,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xff2A2A2A),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          thirdGoalName,
                          style: TextStyle(
                              color: thirdGoalName == '제3목표를 클릭하여 선택해주세요.'
                                  ? const Color(0xff888888)
                                  : Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: TDMandalart(
                        firstGoalName: selectedGoalName,
                        secondGoals: secondGoals,
                        firstGoalColor: ColorTransform(firstColor).colorTransform(),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //취소버튼
            SizedBox(
              width: 90,
              height: 45,
              child: NewButton(Colors.black, Colors.white, '취소', () {
                context
                    .read<SelectAPModel>()
                    .selectAP("제3목표를 클릭하여 선택해주세요.", null);
                context
                    .read<SelectRepeatModel>()
                    .selectRepeat(false, false, false, false);
                Navigator.pop(context);
              })
                  .newButton(),
            ),

            //다음버튼
            SizedBox(
              width: 90,
              height: 45,
              child: NewButton(Colors.black, Colors.white, '다음', () {
                if (thirdGoalName != '제3목표를 클릭하여 선택해주세요.' && thirdGoalName != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPage2(
                        thirdGoalId: thirdGoalId,
                        thirdGoalName: thirdGoalName,
                      ),
                    ),
                  );
                } else {
                  TutorialMessage(
                    "목표를 선택해 주세요.",
                  ).tutorialMessage(context);
                }
              })
                  .newButton(),
            ),
          ],
        ),
      ),
    );
  }
}
