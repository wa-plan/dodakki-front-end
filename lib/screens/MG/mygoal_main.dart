import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/apis/services/td_services.dart';
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/MG/mygoal_goal_detail.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_myGoal.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/MG/buildcard.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/MG/mygoal_profile_edit.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:domino/screens/MG/mygoal_goal_add.dart';
import 'package:provider/provider.dart';

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

  late PageController _pageController;
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
  String defaultImage = 'assets/img/profile_smp4.png';

  List<Map<String, String>> mandalarts = [];
  List<Map<String, String>> bookmarks = [];

  void userInfo() async {
    final data = await UserInfoService.userInfo();
    if (data.isNotEmpty) {
      setState(() {
        nickname = (data['nickname']?.toString().isEmpty ?? true)
            ? '당신은 어떤 사람인가요?'
            : data['nickname'];

        description = (data['description']?.toString().isEmpty ?? true)
            ? '프로필 편집을 통해 \n자신을 표현해주세요.'
            : data['description'];

        final profile = data['profile']?.toString() ?? '';
        selectedImage = profile ==
                'https://dodakkibucket.s3.ap-northeast-2.amazonaws.com/baseImage.png'
            ? defaultImage
            : profile;
      });
    }
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
        await mandaColor(mandalartId);
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
  }

  Future<void> mandaColor(String mandalartId) async {
    if (colorList.any((item) => item['id'] == mandalartId)) return;
    final data = await MandalartInfoService.mandalartInfo(
        mandalartId: int.parse(mandalartId));
    if (data != null) {
      setState(() {
        colorList.add({"id": mandalartId, "color": data["color"]});
      });
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
    _pageController.dispose();
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
                          width: 80,
                          height: 80,
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
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          //프로필 설명
                          Text(
                            description,
                            style: TextStyle(
                                height: 1.5,
                                color: Colors.white,
                                fontSize: 13,
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
                  MGSubTitle('쓰러뜨릴 목표').mgSubTitle(context),
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
                height: 15,
              ),
              Column(children: [
                if (inProgressIDs.isEmpty)
                  BlankData("엇!\n아직 쓰러뜨릴 목표가 없어요!\n어서 만들어봅시다!", 220).blankData()
                else ...[
                  Container(
                    decoration: BoxDecoration(
                        color: Color(0xff2B2B2B),
                        borderRadius: BorderRadius.circular(10)),
                    width: double.infinity,
                    child: SizedBox(
                      height: 240,
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

                          return Center(
                            child: GoalCard(
                              mandalartId: mandalartId,
                              name: name,
                              status: status,
                              photoList: photoList,
                              dday: dday,
                              color: color,
                              successNum: successNum,
                              bookmark: bookmark,
                              onBookmarkToggle: (id, action) {},
                            ),
                          );
                        },
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

              //이번주의 응원
              MGSubTitle('이번주의 응원d!').mgSubTitle(context),
              const SizedBox(height: 15),
              const CheeringMessage(),
              const SizedBox(height: 40),

              //쓰러뜨린 목표
              MGSubTitle('쓰러뜨린 목표').mgSubTitle(context),
              const SizedBox(height: 15),
              if (successIDs.isEmpty)
                BlankData2("함께 목표를 쓰러뜨려봐요").blankData2()
              else
                Column(
                  children: [
                    ...successIDs.map((item) {
                      String status = statusList.firstWhere(
                            (element) => element['mandalartId'] == item['id'],
                            orElse: () => {'status': ''},
                          )['status'] ??
                          '';

                      String dday = ddayList.firstWhere(
                            (element) => element['mandalartId'] == item['id'],
                            orElse: () => {'dday': ''},
                          )['dday'] ??
                          '0';

                      List<String> photoList = (photos[item['id']] ?? [])
                          .map<String>((photo) => photo['path'].toString())
                          .toList();

                      final color = colorList.firstWhere(
                          (element) => element['id'] == item['id'],
                          orElse: () =>
                              {'color': 'Color(0xff000000)'})['color'];

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
                          height: 35,
                          child: Center(
                            child: Text(
                              item['name']!,
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              const SizedBox(height: 40),

              //쓰러뜨리지 못한 목표
              MGSubTitle('쓰러뜨리지 못한 목표').mgSubTitle(context),
              const SizedBox(height: 15),
              if (failedIDs.isEmpty)
                BlankData2("못 쓰러뜨린 목표가 없어요").blankData2()
              else
                Column(
                  children: [
                    ...failedIDs.map((item) {
                      String status = statusList.firstWhere(
                            (element) => element['mandalartId'] == item['id'],
                            orElse: () => {'status': ''},
                          )['status'] ??
                          '';

                      String dday = ddayList.firstWhere(
                            (element) => element['mandalartId'] == item['id'],
                            orElse: () => {'dday': ''},
                          )['dday'] ??
                          '0';

                      List<String> photoList = (photos[item['id']] ?? [])
                          .map<String>((photo) => photo['path'].toString())
                          .toList();
                      final color = colorList.firstWhere(
                          (element) => element['id'] == item['id'],
                          orElse: () =>
                              {'color': 'Color(0xff000000)'})['color'];

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
                          height: 35,
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 10),
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
                                  fontSize: 15),
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
