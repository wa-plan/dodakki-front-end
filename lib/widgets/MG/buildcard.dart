import 'package:domino/screens/MG/mygoal_goal_detail.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/apis/services/mg_services.dart';

class GoalCard extends StatefulWidget {
  final String mandalartId;
  final String name;
  final String status;
  final List<String> photoList;
  final String dday;
  final String color;
  final int successNum;
  final String bookmark;
  final Function(String id, String action) onBookmarkToggle;

  const GoalCard(
      {super.key,
      required this.mandalartId,
      required this.name,
      required this.status,
      required this.photoList,
      required this.dday,
      required this.color,
      required this.successNum,
      required this.bookmark,
      required this.onBookmarkToggle});

  @override
  State<GoalCard> createState() => _GoalCardState();
}

class _GoalCardState extends State<GoalCard> {
  late bool isBookmarked;
  late Color starColor;

  Future<void> _mandaBookmark(String mandalartId, String bookmark) async {
    // 서버에 북마크 상태 전송
    final success = await MandaBookmarkService.MandaBookmark(
      id: int.parse(mandalartId),
      bookmark: bookmark,
    );
    if (success) {
    } else {}
  }

  void _toggleBookmark() {
    // 북마크 상태와 색상 토글
    setState(() {
      isBookmarked = !isBookmarked;
      starColor = isBookmarked ? mainGold : Color(0xff474747);
    });
    // 서버로 북마크 상태 전송
    _mandaBookmark(
        widget.mandalartId, isBookmarked ? 'BOOKMARK' : 'UNBOOKMARK');
  }

  @override
  void initState() {
    super.initState();
    // 초기 bookmark 상태에 따라 색상 설정
    isBookmarked = widget.bookmark == 'BOOKMARK';
    starColor = isBookmarked ? mainGold : Color.fromARGB(255, 71, 71, 71);
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final colorValue =
        int.parse(widget.color.replaceAll('Color(', '').replaceAll(')', ''));
    int ddayParsed = int.parse(widget.dday);

    final List<Color> colors = _getColorsByCondition(Color(colorValue));

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyGoalDetail(
                id: widget.mandalartId,
                name: widget.name,
                status: widget.status,
                photoList: widget.photoList,
                dday: ddayParsed,
                color: widget.color,
                colorValue: colorValue,
              ),
            ),
          );
        },
        child: Container(
          width: 350,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Color(0xff2B2B2B),),
          child: Column(children: [
            //첫번째 줄 (북마크/제1목표/디데이)

            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              //북마크
              GestureDetector(
                onTap: _toggleBookmark,
                child: Icon(
                  Icons.star,
                  color: starColor,
                  size: 25,
                ),
              ),
              const SizedBox(width: 10),
              //제1목표
              Text(
                widget.name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 10),
              //디데이
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 51, 51, 51),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      offset: const Offset(0, 0),
                      blurRadius: 7,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  ddayParsed < 0 ? 'D+${ddayParsed * -1}' : 'D-$ddayParsed',
                  style: TextStyle(
                    color: Color.fromARGB(255, 105, 105, 105),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ]),

            SizedBox(height: 13),
            //두 번째 + 세 번째 줄
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //첫번째 열
                SizedBox(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //목표 이미지
                        if (widget.photoList.isEmpty)
                          SizedBox(
                            height: 105, // 이미지 높이 설정
                            width: currentWidth < 390 ? 260 : 290, // 가로 크기 제한 (화면의 80%)
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal, // 가로 스크롤 가능
                              itemCount: 3, // 최대 3개 제한
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  
                                  width: 105,
                                  height: 105,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 53, 53, 53),
                                    borderRadius:
                                        BorderRadius.circular(6),
                                  ),
                                );
                              },
                            ),
                          )
                        else
                          SizedBox(
                            height: 105, // 이미지 높이 설정
                            width: currentWidth < 390 ? 260 : 290, // 가로 크기 제한 (화면의 80%)
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal, // 가로 스크롤 가능
                              itemCount: widget.photoList.length
                                  .clamp(1, 3), // 최대 3개 제한
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(6), // 둥근 모서리 적용
                                    child: Image.network(
                                      widget.photoList[index], // 이미지 URL
                                      width: 105,
                                      height: 105,
                                      fit: BoxFit.cover, // 이미지가 꽉 차도록 설정
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 105,
                                          height: 105,
                                          color: Colors.grey[300],
                                          child: Center(
                                            child: Text(
                                              '이미지 로드 실패',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 12),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 17),
                        //세 번째 줄
                        SizedBox(
                          width: currentWidth < 390 ? 260 : 290,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: 40),
                                  Column(
                                    children: [
                                      Text(
                                        '나의 도미노',
                                        style: TextStyle(
                                            color: Color(0xffAAAAAA),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15),
                                      ),
                                      Text(
                                        '${widget.successNum}개',
                                        style: TextStyle(
                                          color: const Color(0xffFCFF62),
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 6),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 5,
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  // 첫 번째 색상
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colors[0], // 첫 번째 색상
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    width: 13, //13
                                    height: 6, // 첫 번째 높이 (6.0으로 고정)
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  // 두 번째 색상
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colors.length > 1
                                          ? colors[1]
                                          : Colors.transparent, // 두 번째 색상
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    width: 13,
                                    height: 16, //16
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  // 세 번째 색상
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colors.length > 2
                                          ? colors[2]
                                          : Colors.transparent, // 세 번째 색상
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    width: 13,
                                    height: 26, // 세 번째 높이 (예: 20 추가)
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  // 네 번째 색상
                                  Container(
                                      decoration: BoxDecoration(
                                        color: colors.length > 3
                                            ? colors[3]
                                            : Colors.transparent, // 네 번째 색상
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                      width: 13,
                                      height: 37 // 네 번째 높이 (예: 30 추가)
                                      ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  width: 16,
                ),

                Container(
                  decoration: BoxDecoration(
                    color: Color(colorValue),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  width: 13,
                  height: 165,
                ),
              ],
            ),
          ]),
        ));
  }

  /// 조건에 따라 색상 배열 반환
  List<Color> _getColorsByCondition(Color colorValue) {
    if (colorValue == const Color(0xffFF7A7A)) {
      return const [
        Color(0xff5DD8FF), // 파랑
        Color(0xff72FF5B), // 초록
        Color(0xffFCFF62), // 노랑
        Color(0xffFFAC2F), // 주황
      ];
    } else if (colorValue == const Color(0xffFFB82D)) {
      return const [
        Color(0xffFF7A7A), // 빨강
        Color(0xff5DD8FF), // 파랑
        Color(0xff72FF5B),
        Color(0xffFCFF62),
      ];
    } else if (colorValue == const Color(0xffFCFF62) ||
        colorValue == Colors.white) {
      return const [
        Color(0xffFF7A7A), // 빨강
        Color(0xffFFAC2F), // 주황
        Color(0xff72FF5B), // 초록
        Color(0xff5DD8FF), // 파랑
      ];
    } else if (colorValue == const Color(0xff5DD8FF)) {
      return const [
        Color(0xffFF7A7A), // 빨강
        Color(0xffFFAC2F), // 주황
        Color(0xffFCFF62),
        Color(0xff72FF5B), // 초록
      ];
    } else if (colorValue == const Color(0xff72FF5B)) {
      return const [
        Color(0xffFF7A7A), // 빨강
        Color(0xffFFAC2F), // 주황
        Color(0xffFCFF62),
        Color(0xff5DD8FF), // 초록
      ];
    } else {
      // Default case if no other conditions match
      return [
        const Color(0xffFFFFFF), // white
      ];
    }
  }
}
