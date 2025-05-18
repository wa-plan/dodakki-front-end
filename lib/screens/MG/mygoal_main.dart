import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/apis/services/td_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/MG/mygoal_goal_detail.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
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
  String? profile;
  String defaultImage = 'assets/img/profile_smp4.png'; // 기본 이미지 경로

  List<Map<String, String>> mandalarts = [];
  List<Map<String, String>> bookmarks = [];

  void userInfo() async {
    final data = await UserInfoService.userInfo();
    if (data.isNotEmpty) {
      setState(() {
        nickname = data['nickname'] ?? '당신은 어떤 사람인가요?';
        description = data['description'] ?? '프로필 편집을 통해 \n자신을 표현해주세요.';

        // ✅ 프로필 이미지 경로도 서버에서 불러와서 반영
        selectedImage = data['profile']?.isNotEmpty == true
            ? data['profile']
            : defaultImage;
      });

      print('selectedImage: $selectedImage');
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

        // 비동기 작업 병렬 처리
        final tasks = mandalarts.map((mandalart) async {
          final String mandalartId = mandalart['id'] ?? '0';
          await userMandaInfo(mandalartId);
          await mandaColor(mandalartId);
        });

        await Future.wait(tasks); // 모든 작업 완료를 기다림

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
      } else {}
    } catch (e) {
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
      print('이건 만다라아이디디 $mandalartId');
      print('이건 되나? $data');
      if (data != null) {
        // 반환된 데이터를 colorList에 추가
        setState(() {
          colorList.add({"id": mandalartId, "color": data["color"]});
        });
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
          child: DPTitleText('나의 목표', currentWidth).dPTitleText(),
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
              SizedBox(height: currentWidth < 600 ? 0 : 15),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //프로필 이미지
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff303030),
                          
                        ),
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.05), // 검은색 10% 투명도
                                offset: const Offset(0, 0), // X, Y 위치 (0,0)
                                blurRadius: 7, // 블러 7
                                spreadRadius: 0, // 스프레드 0
                              ),
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: selectedImage.startsWith('http')
                                  ? NetworkImage(selectedImage)
                                  : AssetImage(selectedImage) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //프로필 닉네임
                          Text(nickname,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: currentWidth < 600 ? 14 : 15,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5),
                          //프로필 설명
                          Text(
                            description,
                            style: TextStyle(
                                height: 1.5,
                                color: Colors.white,
                                fontSize: currentWidth < 600 ? 12 : 13,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  //프로필 편집 버튼
                  NewCustomIconButton(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileEdit(
                            selectedImage: selectedImage,
                            profileImage: profile ?? "",
                            cameraImage: ""),
                      ),
                    );
                  }, Icons.edit, currentWidth, 17)
                      .newCustomIconButton(),
                ],
              ),
              SizedBox(height: currentWidth < 600 ? 40 : 50),
              //쓰러뜨릴 목표
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MGSubTitle('쓰러뜨릴 목표', currentWidth).mgSubTitle(context),
                  //목표 추가 버튼
                  NewCustomIconButton(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyGoalAdd()),
                    );
                  }, Icons.add, currentWidth, 22)
                      .newCustomIconButton(),
                ],
              ),
              SizedBox(
                height: currentWidth < 600 ? 10 : 25,
              ),
              Column(children: [
                if (inProgressIDs.isEmpty)
                  Container(
                    height: currentWidth < 600 ? 200 : 220, // 높이 조정 가능
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xff2B2B2B),
                      borderRadius: BorderRadius.circular(8), // 모서리 둥글게
                    ),
                    child: Text(
                      "새로운 목표를 세워볼까요?",
                      style: TextStyle(
                        color: Color(0xff6C6C6C),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                else ...[
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff2B2B2B),
                        borderRadius: BorderRadius.circular(6)),
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        height: 240,
                        width: 350,
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
                                  orElse: () => {
                                    'successNum': 0
                                  }, // 일치하는 항목이 없을 경우 빈 문자열 반환
                                )['successNum'] ??
                                0;

                            List<String> photoList = (photos[mandalartId] ?? [])
                                .map<String>(
                                    (photo) => photo['path'].toString())
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
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (inProgressIDs.length != 1 && inProgressIDs.isNotEmpty)
                    Center(
                      child: PageIndicator(_pageController, inProgressIDs)
                          .pageIndicator(),
                    ),
                ],
              ]),
              const SizedBox(height: 40),
              MGSubTitle('이번주의 응원!', currentWidth).mgSubTitle(context),
              const SizedBox(height: 10),
              const CheeringMessage(),
              const SizedBox(height: 40),
              MGSubTitle('쓰러뜨린 목표', currentWidth).mgSubTitle(context),
              const SizedBox(height: 10),
              if (successIDs.isEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff2B2B2B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min, // 자식 위젯 크기만큼만 높이를 조정
                      children: [
                        Text(
                          "함께 목표를 쓰러뜨려봐요!",
                          style: TextStyle(
                            color: Color(0xff6C6C6C),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 15),
                            Image.asset('assets/img/haha.png', scale: 2),
                          ],
                        )
                      ],
                    ),
                  ),
                )
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
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 10),
                          decoration: BoxDecoration(
                            color: colorValue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          height: currentWidth < 600 ? 35 : 70,
                          child: Center(
                            child: Text(
                              item['name']!,
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: currentWidth < 600 ? 12 : 20),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              const SizedBox(height: 40),
              MGSubTitle('쓰러뜨리지 못한 목표', currentWidth).mgSubTitle(context),
              const SizedBox(height: 10),
              if (failedIDs.isEmpty)
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xff2B2B2B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min, // 자식 위젯 크기만큼만 높이를 조정
                      children: [
                        Text(
                          "쓰러뜨리지 못한 목표가 없어요~!",
                          style: TextStyle(
                            color: Color(0xff6C6C6C),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Column(
                          children: [
                            SizedBox(height: 15),
                            Image.asset('assets/img/haha.png', scale: 2),
                          ],
                        )
                      ],
                    ),
                  ),
                )
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
                                    )),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 8),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            color: colorValue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              item['name']!,
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: currentWidth < 600 ? 12 : 20),
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
