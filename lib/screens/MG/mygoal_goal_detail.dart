import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:domino/screens/MG/piechart.dart';
import 'package:domino/screens/event_page.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data'; // Uint8List 사용을 위한 라이브러리 임포트
import 'package:domino/screens/MG/mygoal_goal_edit.dart';
import 'package:domino/apis/services/mg_services.dart';
import 'package:domino/widgets/popup.dart';

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
  //description, successNum

  final _status = ['달성 실패', '진행 중', '달성 완료'];
  String? _selectedStatus;
  // 선택된 파일 리스트를 관리할 변수 추가
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
  //double rate = 0.0;
  int total = 0;
  int successRate = 0;
  int inProgressRate = 0;
  int failedRate = 0;
  final GlobalKey _iconKey = GlobalKey(); // 아이콘 위치를 추적하기 위한 키
  Offset _iconPosition = Offset.zero; // 아이콘의 위치

  Future<void> userMandaInfo(String mandalartId) async {
    try {
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
          successRate =
              total == 0 ? 0 : (this.successNum / total * 100).toInt();
          inProgressRate =
              total == 0 ? 0 : (this.inProgressNum / total * 100).toInt();
          failedRate = 100 - successRate - inProgressRate;
          print('total=$total');
        });
      } else {
        print('userMandaInfo 실패: 데이터 없음 ($mandalartId)');
      }
    } catch (e) {
      print('userMandaInfo 에러 발생: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('데이터 로드 실패: $e')),
      );
    }
  }

  void _mandaProgress(int id, String status) async {
    final success = await MandaProgressService.MandaProgress(
      id: id,
      status: status,
    );
    if (success) {
      print('성공');
    }
  }

  @override
  void initState() {
    super.initState();
    String mandalartId = widget.id;
    color = widget.color;
    //final colorValue =
    //    int.parse(color.replaceAll('Color(', '').replaceAll(')', ''));
    //print('colorValue=$colorValue');
    name = widget.name;
    dday = widget.dday;
    status = widget.status;
    photoList = widget.photoList;

    userMandaInfo(mandalartId);

    goalImage = photoList.map((photo) => photo).toList();
    print('goalImage=$goalImage');

    if (status == 'FAIL') {
      _selectedStatus = _status[0];
    } else if (status == 'IN_PROGRESS') {
      _selectedStatus = _status[1];
    } else if (status == 'SUCCESS') {
      _selectedStatus = _status[2];
    } else {
      // status가 예상 범위를 벗어날 경우 처리
      _selectedStatus = _status[1]; // 기본값으로 '진행 중' 설정
    }
  }

  void _onFileSelected() {
    // 파일 선택 로직 (예시로 빈 리스트를 추가)
    setState(() {
      selectedFiles.add(Uint8List.fromList([])); // 빈 바이트 리스트 추가
    });
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          titleSpacing: 0.0,
          title: Padding(
            padding: appBarPadding,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Color(0xffD4D4D4),
                    size: 17,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 3.0),
                  decoration: BoxDecoration(
                    color: Color(widget.colorValue).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: Color(widget.colorValue), width: 0.5), // 테두리 색상
                  ),
                  child: Text(
                    dday < 0 ? 'D+${dday * -1}' : 'D-$dday',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 194, 194, 194),
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 13.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: const Color(0xff303030),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                        color: const Color(0xff575757), width: 0.5), // 테두리 색상
                  ),
                  child: GestureDetector(
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
                      child: const Text(
                        '편집',
                        style:
                            TextStyle(color: Color(0xff979797), fontSize: 11),
                      )),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Text(
                        "이 목표는",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.fromLTRB(14, 5, 14, 5),
                        height: 33,
                        width: 106,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color(0xff575757), width: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: DropdownButton<String>(
                          underline: const SizedBox.shrink(),
                          dropdownColor: const Color(0xff262626),
                          iconEnabledColor: const Color(0xffBFBFBF),
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
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value;
                              if (_selectedStatus == '달성 완료') {
                                PopupDialog.show(
                                  context,
                                  '대박! 이 목표 정말 \n달성 완료한거야?',
                                  true, // cancel
                                  false, // delete
                                  false, // signout
                                  true, //success
                                  onCancel: () {
                                    // 취소 버튼을 눌렀을 때 실행할 코드
                                    Navigator.of(context).pop();
                                  },

                                  onDelete: () {
                                    // 삭제 버튼을 눌렀을 때 실행할 코드
                                  },
                                  onSignOut: () {
                                    // 탈퇴 버튼을 눌렀을 때 실행할 코드
                                  },
                                  onSuccess: () {
                                    _mandaProgress(
                                        int.parse(widget.id), "SUCCESS");
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const EventPage(),
                                      ),
                                    );
                                  },
                                );
                              }
                              if (_selectedStatus == '진행 중') {
                                PopupDialog.show(
                                  context,
                                  '잘 생각했어! 다시 도전해보는거야?',
                                  true, // cancel
                                  false, // delete
                                  false, // signout
                                  true, //success
                                  onCancel: () {
                                    // 취소 버튼을 눌렀을 때 실행할 코드
                                    Navigator.of(context).pop();
                                  },

                                  onDelete: () {
                                    // 삭제 버튼을 눌렀을 때 실행할 코드
                                  },
                                  onSignOut: () {
                                    // 탈퇴 버튼을 눌렀을 때 실행할 코드
                                  },
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
                                  '아쉬워! 이 목표는 \n달성 실패인거야?',
                                  true, // cancel
                                  false, // delete
                                  false, // signout
                                  true, //success
                                  onCancel: () {
                                    // 취소 버튼을 눌렀을 때 실행할 코드
                                    Navigator.of(context).pop();
                                  },

                                  onDelete: () {
                                    // 삭제 버튼을 눌렀을 때 실행할 코드
                                  },
                                  onSignOut: () {
                                    // 탈퇴 버튼을 눌렀을 때 실행할 코드
                                  },
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
              const SizedBox(
                height: 20,
              ),
              if (goalImage.isEmpty) ...[
                Image.asset(
                  'assets/img/if_no_img.png', // 로컬 기본 이미지
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                )
              ] else ...[
                SizedBox(
                  height: 140,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // 이미지 개수에 맞춰 열 개수 조정
                      childAspectRatio: 1 / 1,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: goalImage.length.clamp(0, 3),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index < goalImage.length) {
                        print('goalImage=$goalImage');
                        return ClipRRect(
                          borderRadius:
                              BorderRadius.circular(15), // 둥근 네모 형태로 설정
                          child: Image.network(
                            goalImage[index],
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Text(
                                  '이미지 로드 실패',
                                  style: TextStyle(color: Colors.red),
                                ),
                              );
                            },
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
              mandaDescription.isNotEmpty
                  ? Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 7.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 44, 44, 44),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            mandaDescription,
                            style: const TextStyle(
                                height: 1.5,
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              const SizedBox(
                height: 20,
              ),
              const Divider(
                color: Color.fromARGB(255, 114, 114, 114),
                thickness: 0.3,
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Question(number: '#', question: '할 일 달성 통계'),

                  const SizedBox(
                    height: 10,
                  ),

                  const SizedBox(height: 60), // 아이콘과 다른 콘텐츠 사이의 간격 조정
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Center(
                        child: CustomPaint(
                          size: const Size(80, 80),
                          painter: PieChart(
                              successPercentage: successRate, // int로 변환
                              inProgressPercentage: inProgressRate, // int로 변환
                              failPercentage: failedRate,
                              color: color),
                        ),
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.circle_outlined,
                                      color: Color(widget.colorValue),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '$successRate%',
                                      style: TextStyle(
                                          color: Color(widget.colorValue),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '$successNum개',
                                      style: TextStyle(
                                          color: Color(widget.colorValue),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 9),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.change_history_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '$inProgressRate%',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '$inProgressNum개',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 9),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.clear_outlined,
                                      color: Color(0xff626161),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${failedRate == 100 ? 0 : failedRate}%',
                                      style: const TextStyle(
                                          color: Color(0xff626161),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      '$failedNum개',
                                      style: const TextStyle(
                                          color: Color(0xff626161),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ]),
                          Container(
                            width: 200,
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0, vertical: 7.0),
                            decoration: BoxDecoration(
                              color: const Color(0xff303030),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '나의 도미노',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _updateIconPosition();
                                        print(_iconPosition);
                                        _showPopupMessage(
                                            context, '동그라미로만 도미노를 만들 수 있어요.');
                                      },
                                      child: Icon(
                                        Icons.help,
                                        key: _iconKey,
                                        color: const Color(0xff555555),
                                        size: 17,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/img/domino.png',
                                      width: 20,
                                    ),
                                    const SizedBox(width: 5),
                                    const Text(
                                      'x',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      '$successNum',
                                      style: TextStyle(
                                          color: Color(widget.colorValue),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
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
              top: _iconPosition.dy - 40, // 아이콘 아래 위치
              left: _iconPosition.dx - 210,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 64, 64, 64),
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
                      color: Colors.white,
                    ),
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
