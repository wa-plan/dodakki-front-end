import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:domino/screens/MG/piechart.dart';
import 'package:domino/screens/event_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:domino/screens/MG/mygoal_goal_edit.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class MyGoalDetail extends StatefulWidget {
  final String id;
  final String name;
  final String status;
  final List<String> photoList;
  final int dday;
  final String color;
  final int colorValue;

  const MyGoalDetail(
      {super.key,
      required this.id,
      required this.name,
      required this.status,
      required this.photoList,
      required this.dday,
      required this.color,
      required this.colorValue});

  @override
  MyGoalDetailState createState() => MyGoalDetailState();
}

class MyGoalDetailState extends State<MyGoalDetail> {
  final _status = ['달성 실패', '진행 중', '달성 완료'];
  String? _selectedStatus;
  List<Uint8List> selectedFiles = [];
  bool bookmark = false;
  String o = '0';
  String v = '0';
  String x = '0';
  String name = '';
  int dday = 0;
  int parsedId = 0;
  bool hasNoImages = false;
  String color = '0xffFCFF62';
  String mandaDescription = '';
  String status = '';
  int successNum = 0;
  int failedNum = 0;
  int inProgressNum = 0;
  List<String> goalImage = [];
  List<String> photoList = [];
  int total = 0;
  int successRate = 0;
  int inProgressRate = 0;
  int failedRate = 0;
  final GlobalKey _iconKey = GlobalKey();
  Offset _iconPosition = Offset.zero;

  Future<void> userMandaInfo(String mandalartId) async {
    final data = await UserMandaInfoService.userMandaInfo(context,
        mandalartId: int.parse(mandalartId));

    if (data != null) {
      String description = data['description'] ?? '';
      int failedNum = data['statusNum']?['failed'] ?? 0;
      int inProgressNum = data['statusNum']?['inProgressNum'] ?? 0;
      int successNum = data['statusNum']?['successNum'] ?? 0;

      setState(() {
        mandaDescription = description;
        this.failedNum = failedNum;
        this.inProgressNum = inProgressNum;
        this.successNum = successNum;

        total = this.successNum + this.inProgressNum + this.failedNum;
        successRate = total == 0 ? 0 : (this.successNum / total * 100).round();
        inProgressRate =
            total == 0 ? 0 : (this.inProgressNum / total * 100).round();
        failedRate = 100 - successRate - inProgressRate;
      });
    } else {}
  }

  void _mandaProgress(int id, String status) async {
    final success = await MandaProgressService.MandaProgress(
      id: id,
      status: status,
    );
    if (success) {}
  }

  @override
  void initState() {
    super.initState();
    String mandalartId = widget.id;
    color = widget.color;
    name = widget.name;
    dday = widget.dday;
    status = widget.status;
    photoList = widget.photoList;

    userMandaInfo(mandalartId);

    goalImage = photoList.map((photo) => photo).toList();

    if (status == 'FAIL') {
      _selectedStatus = _status[0];
    } else if (status == 'IN_PROGRESS') {
      _selectedStatus = _status[1];
    } else if (status == 'SUCCESS') {
      _selectedStatus = _status[2];
    } else {
      _selectedStatus = _status[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: SpeedDial(
        buttonSize: Size(45, 45),
        gradient: LinearGradient(colors: gradientColor),
        animatedIcon: AnimatedIcons.menu_close,
        overlayColor: Colors.black,
        foregroundColor: backgroundColor,
        gradientBoxShape: BoxShape.circle,
        spacing: 20,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.delete, color: Colors.white, size: 20),
            backgroundColor: Color(0xff303030),
            labelBackgroundColor: Colors.white,
            elevation: 0,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600, color: backgroundColor, fontSize: 15
            ),
            label: '삭제하기',
            shape: CircleBorder(),
            onTap: () async {
              PopupDialog.show(
                  context,
                  '헐 진짜..?\n이 목표는 없어지는거야?',
                  '잠깐!',
                  true, // cancel
                  true, // delete
                  false, //signout
                  false, // success
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onDelete: () async {
                    bool isDeleted =
                        await DeleteFirstGoalService.deleteFirstGoal(
                      context,
                      int.parse(widget.id),
                    );
                    if (isDeleted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyGoal(),
                        ),
                      );
                    }
                  },
                  onSignOut: () {},
                );
              
            }
          ),
          SpeedDialChild(
            child: const Icon(Icons.edit, color: Colors.white, size: 20),
            backgroundColor: Color(0xff303030),
            labelBackgroundColor: Colors.white,
            elevation: 0,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.w600, color: backgroundColor, fontSize: 15
            ),
            label: '수정하기',
            shape: CircleBorder(),
            onTap: () {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MygoalEdit(
                              id: widget.id,
                              dday: dday,
                              name: name,
                              description: mandaDescription,
                              color: color,
                              goalImage: goalImage)));
            }, 
          ),
        ],
      ),
      appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Padding(
            padding: appBarPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //나가기 버튼
                CustomBackButton(
                  () {
                    Navigator.of(context).pop();
                  },
                ).customBackButton(),

              
                //진행 상태 드롭다운
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Color(0xff303030)),
                      child: DropdownButton<String>(
                          icon: Icon(Icons.circle),
                          iconSize: 10,
                          iconEnabledColor: _selectedStatus == "진행 중" ? mainGreen : mainGrey,
                          elevation: 0,
                          underline: const SizedBox.shrink(),
                          dropdownColor: Colors.black,
                          value: _selectedStatus,
                          items: _status
                              .map(
                                (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Center(
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                              if (_selectedStatus == '달성 완료') {
                                PopupDialog.show(
                                  context,
                                  '이 목표 정말 \n달성 완료한거야?',
                                  '대박!',
                                  true,
                                  false,
                                  false,
                                  true,
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                  onDelete: () {},
                                  onSignOut: () {},
                                  onSuccess: () {
                                    _mandaProgress(
                                        int.parse(widget.id), "SUCCESS");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EventPage(
                                          domino: successNum,
                                          goalName: name,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                              if (_selectedStatus == '진행 중') {
                                PopupDialog.show(
                                  context,
                                  '잘 생각했어!\n다시 도전해보는거야?',
                                  '좋아!',
                                  true,
                                  false,
                                  false,
                                  true,
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                  onDelete: () {},
                                  onSignOut: () {},
                                  onSuccess: () {
                                    _mandaProgress(
                                        int.parse(widget.id), "IN_PROGRESS");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MyGoal(),
                                      ),
                                    );
                                  },
                                );
                              }
                              if (_selectedStatus == '달성 실패') {
                                PopupDialog.show(
                                  context,
                                  '이 목표는\n달성 실패인거야?',
                                  '아쉽다..',
                                  true,
                                  false,
                                  false,
                                  true,
                                  onCancel: () {
                                    Navigator.of(context).pop();
                                  },
                                  onDelete: () {},
                                  onSignOut: () {},
                                  onSuccess: () {
                                    _mandaProgress(
                                        int.parse(widget.id), "FAIL");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MyGoal(),
                                      ),
                                    );
                                  },
                                );
                              }
                            });
                          },
                        ),
                     
                    ),
                  ],
                ),

                
              ],
            ),
          ),
          backgroundColor: backgroundColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 15,
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xff2B2B2B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //목표 이름
                        Text(
                          name,
                          style: TextStyle(
                              fontFamily: "Pretendard",
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //디데이 태그
                        DdayTag(dday).ddayTag(),
                      ],
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    //이미지
                    if (goalImage.isEmpty) ...[
                      Center(
                        child: SizedBox(
                          height: 105,
                          width: currentWidth < 600 ? 325 : double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Container(
                                margin:
                                    EdgeInsets.only(right: index == 2 ? 0 : 5),
                                width: 105,
                                height: 105,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 53, 53, 53),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ] else ...[
                      SizedBox(
                        height: 105,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            if (index < goalImage.length) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 7, 0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    goalImage[index],
                                    fit: BoxFit.cover,
                                    width: 105,
                                    height: 105,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Text(
                                          '이미지 로드 실패',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return Container(
                                color: Colors.grey[200], // 빈 자리 회색 처리
                              );
                            }
                          },
                        ),
                      ),
                    ],
                    if (mandaDescription.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                        child: Text(
                          mandaDescription,
                          style: const TextStyle(
                              height: 1.5,
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                  ],
                ),
              ),

              //통계
              const SizedBox(
                height: 90,
              ),
              //원형 그래프
              Center(
                child: CustomPaint(
                  size: const Size(60, 60),
                  painter: PieChart(
                      successPercentage: successRate,
                      inProgressPercentage: inProgressRate,
                      failPercentage: failedRate,
                      color: color),
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 17),
                decoration: BoxDecoration(
                  color: const Color(0xff2B2B2B),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.bar_chart,
                            color: Color(0xffAAAAAA),
                            size: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '할 일 달성 통계',
                            style: TextStyle(
                                color: Color(0xffAAAAAA),
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      statistics(
                          rate: successRate,
                          num: successNum,
                          text: '달성 완료',
                          textColor: Color(widget.colorValue)),
                      const SizedBox(height: 8),
                      statistics(
                          rate: inProgressRate,
                          num: inProgressNum,
                          text: '달성 중간',
                          textColor: Color(0xffC7C7C7)),
                      const SizedBox(height: 8),
                      statistics(
                          rate: failedRate == 100 ? 0 : failedRate,
                          num: failedNum,
                          text: '달성 실패',
                          textColor: Color(0xff5E5E5E)),
                      const SizedBox(height: 10),
                      Divider(
                        color: mainGrey,
                      ),
                      const SizedBox(height: 10),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //나의 도미노
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.bar_chart,
                                    color: Color(0xffAAAAAA),
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '나의 도미노',
                                    style: TextStyle(
                                        color: Color(0xffAAAAAA),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  _updateIconPosition();
                                  _showPopupMessage(context,
                                      '도미노는 ‘달성완료’ 시에만 만들어지며,\n목표를 달성했을 때 이 도미노들로 \n목표를 쓰러뜨리게 돼요!');
                                },
                                child: Icon(
                                  Icons.help,
                                  key: _iconKey,
                                  color: Color.fromARGB(255, 107, 107, 107),
                                  size: 17,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Image.asset(
                                'assets/img/domino.png',
                                width: 27,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                'x',
                                style: TextStyle(
                                    color: Color(0xffAAAAAA),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$successNum',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget statistics({
    required int rate,
    required int num,
    required String text,
    required Color textColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10),
            Text(
              '$rate%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            Spacer(),
            Text(
              '$num개',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        // 막대 그래프
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: rate / 100.0,
            backgroundColor: const Color(0xff444444),
            valueColor: AlwaysStoppedAnimation<Color>(textColor),
            minHeight: 10,
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }

  void _updateIconPosition() {
    // 아이콘의 현재 위치를 계산
    final RenderBox renderBox =
        _iconKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _iconPosition = position; // 아이콘의 위치 업데이트
    });
  }

// 팝업 메시지를 띄우는 함수
  void _showPopupMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          overlayEntry?.remove(); // 팝업 닫기
          overlayEntry = null;
        },
        child: Stack(
          children: [
            // 투명한 배경으로 메시지 외부 클릭 감지
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // 팝업 메시지 위치 설정
            Positioned(
              top: _iconPosition.dy - -20, // 아이콘 아래 위치
              left: _iconPosition.dx - 230,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // 오버레이에 추가
    overlay.insert(overlayEntry!);
  }
}
