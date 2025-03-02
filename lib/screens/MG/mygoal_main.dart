import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/apis/services/td_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/MG/mygoal_goal_detail.dart';
import 'package:domino/styles.dart';
import 'package:domino/widgets/MG/buildcard.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/MG/mygoal_profile_edit.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:domino/screens/MG/mygoal_goal_add.dart';
import 'package:provider/provider.dart';
import 'package:domino/widgets/MG/cheering_message.dart';

class MyGoal extends StatefulWidget {
  const MyGoal({super.key});

  @override
  State<MyGoal> createState() => _MyGoalState();
}

class _MyGoalState extends State<MyGoal> {
  final String message = "";
  String nickname = '';
  String description = '';
  String selectedImage = "assets/img/profile_smp4.png";

  late PageController _pageController; // PageController 추가
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

  List<Map<String, String>> mandalarts = [];
  List<Map<String, String>> bookmarks = [];

  void userInfo() async {
    final data = await UserInfoService.userInfo();
    if (data.isNotEmpty) {
      setState(() {
        nickname = data['nickname'] ?? '당신은 어떤 사람인가요?';
        description = data['description'] ?? '프로필 편집을 통해 \n자신을 표현해주세요.';
      });
    }
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

        print('로드된 mandalarts: $mandalarts');
        print('로드된 bookmarks: $bookmarks');
        print('bookmarks리스트는 빠밤 $bookmarks');

        // 비동기 작업 병렬 처리
        final tasks = mandalarts.map((mandalart) async {
          final String mandalartId = mandalart['id'] ?? '0';
          await userMandaInfo(mandalartId);
          await mandaColor(mandalartId);
        });

        await Future.wait(tasks); // 모든 작업 완료를 기다림
        print('모든 mandalart 데이터가 성공적으로 로드되었습니다.');

        // id 값을 기준으로 오름차순 정렬
        failedIDs.sort((a, b) {
          return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
        });
        /*inProgressIDs.sort((a, b) {
          return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
        });*/

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

        print('inProgressIDs=$inProgressIDs');

        context.read<GoalOrder>().saveGoalOrder(inProgressIDs);
        print(inProgressIDs);

        successIDs.sort((a, b) {
          return int.parse(a["id"]!).compareTo(int.parse(b["id"]!));
        });
      }
    } catch (e) {
      // 에러 발생 시 처리
      print('userMandaIdInfo 에러 발생: $e');
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
          //photoList.add({'mandalartId': id, 'photos': photos});
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
        //print('userMandaInfo 성공: $name ($id)');
      } else {
        //print('userMandaInfo 실패: 데이터 없음 ($mandalartId)');
      }
    } catch (e) {
      print('userMandaInfo 에러 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터 로드 실패: $e')),
      );
    }
  }

  Future<void> mandaColor(String mandalartId) async {
// 중복 방지
    if (colorList.any((item) => item['id'] == mandalartId)) return;

    try {
      // 서버에서 데이터 가져오기
      final data = await MandalartInfoService.mandalartInfo(
          mandalartId: int.parse(mandalartId));
      if (data != null) {
        // 반환된 데이터를 colorList에 추가
        setState(() {
          colorList.add({"id": mandalartId, "color": data["color"]});
        });
        print('colorList=$colorList');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('만다라트 조회에 실패했습니다.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('오류 발생: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    userInfo();
    userMandaIdInfo();
  }

  @override
  void dispose() {
    _pageController.dispose(); // 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Text(
            '나의 목표',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      bottomNavigationBar: const NavBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        width: 95 / 1.2, // CircleAvatar의 전체 크기
                        height: 95 / 1.2,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xff575757), // 원하는 테두리 색
                            width: 0.5, // 테두리 두께
                          ),
                        ),
                        child: Container(
                          width: 95,
                          height: 95,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(selectedImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nickname,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 11),
                          Text(
                            description,
                            style: const TextStyle(
                                height: 1.5,
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w200),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  //프로필 편집 버튼
                  CustomIconButton(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEdit(
                          selectedImage: selectedImage,
                        ),
                      ),
                    );
                  }, Icons.edit, currentWidth)
                      .customIconButton(),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Color.fromARGB(255, 114, 114, 114),
                thickness: 0.3,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MGSubTitle('쓰러뜨릴 목표').mgSubTitle(context),
                  Container(
                    width: 40,
                    height: 27,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 44, 44, 44),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                          color: const Color(0xff575757), width: 0.5), // 테두리 색상
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyGoalAdd()),
                        );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Color.fromARGB(255, 106, 106, 106),
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Column(
                children: [
                  SizedBox(
                    height: 175,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: inProgressIDs.length,
                      itemBuilder: (context, index) {
                        String mandalartId =
                            inProgressIDs[index]['id'] ?? ''; // id 값

                        String name =
                            inProgressIDs[index]['name'] ?? ''; // name 값

                        String status = statusList.firstWhere(
                              (element) =>
                                  element['mandalartId'] ==
                                  mandalartId, // mandalartId와 비교
                              orElse: () =>
                                  {'status': ''}, // 일치하는 항목이 없을 경우 빈 문자열 반환
                            )['status'] ??
                            '';

                        String dday = ddayList.firstWhere(
                              (element) =>
                                  element['mandalartId'] ==
                                  mandalartId, // mandalartId와 비교
                              orElse: () =>
                                  {'dday': ''}, // 일치하는 항목이 없을 경우 빈 문자열 반환
                            )['dday'] ??
                            '0';

                        String color = colorList.firstWhere(
                              (element) =>
                                  element['id'] ==
                                  mandalartId, // mandalartId와 비교
                              orElse: () => {
                                'color': '0xff000000'
                              }, // 일치하는 항목이 없을 경우 빈 문자열 반환
                            )['color'] ??
                            '0xff000000';

                        int successNum = successNums.firstWhere(
                              (element) =>
                                  element['mandalartId'] ==
                                  mandalartId, // mandalartId와 비교
                              orElse: () =>
                                  {'successNum': 0}, // 일치하는 항목이 없을 경우 빈 문자열 반환
                            )['successNum'] ??
                            0;

                        List<String> photoList = (photos[mandalartId] ?? [])
                            .map<String>((photo) => photo['path'].toString())
                            .toList();

                        String bookmark = bookmarks.firstWhere(
                              (element) =>
                                  element['id'] ==
                                  mandalartId, // mandalartId와 비교
                              orElse: () => {
                                'bookmark': 'UNBOOKMARK'
                              }, // 일치하는 항목이 없을 경우 빈 문자열 반환
                            )['bookmark'] ??
                            'UNBOOKMARK';

                        print('$mandalartId $name의 북마크 상태는 $bookmark입니다');

                        return GoalCard(
                          mandalartId: mandalartId,
                          name: name,
                          status: status,
                          photoList: photoList,
                          dday: dday,
                          color: color,
                          successNum: successNum,
                          bookmark: bookmark,
                          onBookmarkToggle: (id, action) {},
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (inProgressIDs.length != 1 && inProgressIDs.isNotEmpty)
                    Center(
                      child: PageIndicator(_pageController, inProgressIDs)
                          .pageIndicator(),
                    ),
                ],
              ),
              const SizedBox(height: 35),
              MGSubTitle('이번주의 응원!').mgSubTitle(context),
              const SizedBox(height: 12),
              const CheeringMessage(),
              const SizedBox(height: 40),
              MGSubTitle('쓰러뜨린 목표').mgSubTitle(context),
              const SizedBox(height: 12),
              if (successIDs.isEmpty)
                Image.asset('assets/img/completed_goals.png')
              else
                Column(
                  children: [
                    ...successIDs.map((item) {
                      String status = statusList.firstWhere(
                            (element) =>
                                element['mandalartId'] ==
                                item['id'], // mandalartId와 비교
                            orElse: () =>
                                {'status': ''}, // 일치하는 항목이 없을 경우 빈 문자열 반환
                          )['status'] ??
                          '';

                      String dday = ddayList.firstWhere(
                            (element) =>
                                element['mandalartId'] ==
                                item['id'], // mandalartId와 비교
                            orElse: () =>
                                {'dday': ''}, // 일치하는 항목이 없을 경우 빈 문자열 반환
                          )['dday'] ??
                          '0';

                      List<String> photoList = (photos[item['id']] ?? [])
                          .map<String>((photo) => photo['path'].toString())
                          .toList();

                      // id에 맞는 색상을 찾아서 적용
                      final color = colorList.firstWhere(
                          (element) => element['id'] == item['id'],
                          orElse: () => {
                                'color': 'Color(0xff000000)'
                              } // 색상이 없을 경우 기본값 (검정색)
                          )['color'];

                      // Color로 변환 (문자열에서 'Color('와 ')'를 제거하고 int로 변환한 뒤 Color 객체로 감싸기)
                      final colorValue = Color(int.parse(
                          color!.replaceAll('Color(', '').replaceAll(')', '')));

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyGoalDetail(
                                      id: item['id']!,
                                      name: item['name']!,
                                      status: status,
                                      photoList: photoList,
                                      dday: int.parse(dday),
                                      color: color,
                                      colorValue: colorValue.value,
                                    )),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 13),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: colorValue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.width * 0.09,
                          child: Center(
                            child: Text(
                              item['name']!,
                              style: const TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.5),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              const SizedBox(height: 40),
              MGSubTitle('쓰러뜨리지 못한 목표').mgSubTitle(context),
              const SizedBox(height: 12),
              if (failedIDs.isEmpty)
                Image.asset('assets/img/failed_goals.png')
              else
                Column(
                  children: [
                    ...failedIDs.map((item) {
                      String status = statusList.firstWhere(
                            (element) =>
                                element['mandalartId'] ==
                                item['id'], // mandalartId와 비교
                            orElse: () =>
                                {'status': ''}, // 일치하는 항목이 없을 경우 빈 문자열 반환
                          )['status'] ??
                          '';

                      String dday = ddayList.firstWhere(
                            (element) =>
                                element['mandalartId'] ==
                                item['id'], // mandalartId와 비교
                            orElse: () =>
                                {'dday': ''}, // 일치하는 항목이 없을 경우 빈 문자열 반환
                          )['dday'] ??
                          '0';

                      List<String> photoList = (photos[item['id']] ?? [])
                          .map<String>((photo) => photo['path'].toString())
                          .toList();
                      // id에 맞는 색상을 찾아서 적용
                      final color = colorList.firstWhere(
                          (element) => element['id'] == item['id'],
                          orElse: () => {
                                'color': 'Color(0xff000000)'
                              } // 색상이 없을 경우 기본값 (검정색)
                          )['color'];

                      // Color로 변환 (문자열에서 'Color('와 ')'를 제거하고 int로 변환한 뒤 Color 객체로 감싸기)
                      final colorValue = Color(int.parse(
                          color!.replaceAll('Color(', '').replaceAll(')', '')));

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyGoalDetail(
                                      id: item['id']!,
                                      name: item['name']!,
                                      status: status,
                                      photoList: photoList,
                                      dday: int.parse(dday),
                                      color: color,
                                      colorValue: colorValue.value,
                                      //successNum: int.parse(successNum)
                                    )),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 13),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: colorValue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: MediaQuery.of(context).size.width * 0.09,
                          child: Center(
                            child: Text(
                              item['name']!,
                              style: const TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.5),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
