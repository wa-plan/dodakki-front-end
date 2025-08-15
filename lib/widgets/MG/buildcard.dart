import 'package:domino/screens/MG/mygoal_goal_detail.dart';
import 'package:domino/style/style_myGoal.dart';
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
  final int pageIndex;
  final double currentWidth;

  const GoalCard({
    super.key,
    required this.mandalartId,
    required this.name,
    required this.status,
    required this.photoList,
    required this.dday,
    required this.color,
    required this.successNum,
    required this.bookmark,
    required this.onBookmarkToggle,
    required this.pageIndex,
    required this.currentWidth
  });

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
      starColor = isBookmarked ? mainGold : Color(0xff3A3A3A);
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
                pageIndex: widget.pageIndex,
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Color(0xff2C2C2C),
              borderRadius: BorderRadius.circular(8)),
          child: Container(
            width: 320,
            padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            child: Column(children: [
              //첫번째 줄 (북마크/제1목표/디데이)
              Row(
                children: [
                //제1목표
                Text(
                  widget.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 10),
                //디데이
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
                  decoration: BoxDecoration(
                    color: Color(0xff3A3A3A),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    ddayParsed < 0 ? 'D+${ddayParsed * -1}' : 'D-$ddayParsed',
                    style: TextStyle(
                      color: Color(0xffAAAAAA),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacer(),
                //북마크
                GestureDetector(
                  onTap: _toggleBookmark,
                  child: Icon(
                    Icons.star_rate_rounded,
                    color: starColor,
                    size: 25,
                  ),
                ),
              ]),
            
              SizedBox(height: 13),
              //두 번째 + 세 번째 줄
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                              height: 105,
                              width: widget.currentWidth < 370 ? 200 : 251,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 3,
                                itemBuilder: (context, i) {
                                  return Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                    width: 105,
                                    height: 105,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 53, 53, 53),
                                      borderRadius: BorderRadius.circular(6),
                                      image: i == 0
                                          ? DecorationImage(
                                              image: AssetImage(
                                                sampleImages[widget.pageIndex %
                                                    sampleImages.length],
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            SizedBox(
                              height: 105,
                              width: 251,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.photoList.length.clamp(1, 3),
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        widget.photoList[index],
                                        width: 105,
                                        height: widget.currentWidth < 370 ? 200 : 251,
                                        fit: BoxFit.cover,
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
                            width: widget.currentWidth < 370 ? 200 : 251,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 3),
                                Column(
                                  children: [
                                    Text(
                                      '나의 도미노',
                                      style: TextStyle(
                                          color: settingGrey,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      '${widget.successNum}개',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 6),
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
          ),
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
