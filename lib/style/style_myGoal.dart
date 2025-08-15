import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

final List<String> sampleImages = [
    'assets/img/sampleImage1.png',
    "assets/img/sampleImage2.png",
    "assets/img/sampleImage3.png",
    "assets/img/sampleImage4.png",
    "assets/img/sampleImage5.png",
    'assets/img/sampleImage6.png',
    "assets/img/sampleImage7.png",
    "assets/img/sampleImage8.png",
    "assets/img/sampleImage9.png",
    "assets/img/sampleImage10.png",
    "assets/img/sampleImage11.png",
    "assets/img/sampleImage12.png",
  ];

//비어있는 데이터 (for 쓰러뜨릴 목표)
class BlankData {
  final String text;
  final double height;
  final double currentWidth;

  const BlankData(this.text, this.height, this.currentWidth);

  Widget blankData() {
    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
      decoration: BoxDecoration(
                      color: const Color(0xff2C2C2C),
                      borderRadius: BorderRadius.circular(8),
                    ),
      child: Stack(
        children: [
          Text(
            text,
            style: TextStyle(
                              color: settingGrey,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              height: 1.7,
                            ),
          ),
          Positioned(
              bottom: 0,
              right: 0,
              child: Image.asset('assets/img/emptyDominho.png', height: currentWidth < 325 ? 120: 180),
              )
        ],
      ),
    );
  }
}

//서브메뉴 타이틀
class MGSubTitle {
  final String text;

  MGSubTitle(this.text);

  Widget mgSubTitle(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Color(0xffAAAAAA),
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

//비어있는 데이터 (for 쓰러뜨린/쓰러뜨리지 못한 목표)
class BlankData2 {
  final String text;
  final double currentWidth;

  const BlankData2(this.text, this.currentWidth);

  Widget blankData2() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff2C2C2C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 0, 10, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                              color: settingGrey,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.7,
                            ),
            ),
            Column(
              children: [
                SizedBox(height: 15),
                Image.asset('assets/img/haha.png', scale: currentWidth < 325 ? 3 : 2),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//응원 메시지
class CheeringMessage extends StatefulWidget {
  const CheeringMessage({super.key});

  @override
  State<CheeringMessage> createState() => _CheeringMessageState();
}

class _CheeringMessageState extends State<CheeringMessage> {
  List<String> messages = [
    "포기하지 마, 아직 끝난 게 아니야.",
    "네 안의 힘을 믿어, 넌 할 수 있어.",
    "지금이 기회야, 놓치지 마.",
    "두려워하지 마, 한 걸음만 더 나가면 돼.",
    "너 자신을 믿어야 모든 게 시작돼.",
    "포기하지 않는 사람만 꿈을 이뤄.",
    "작은 용기가 큰 변화를 만들어.",
    "네 길을 만들어, 아무도 대신 못 해.",
    "실패해도 괜찮아, 다시 일어나면 돼.",
    "넌 이미 충분히 강해.",
    "도전 없이는 아무것도 얻을 수 없어.",
    "오늘을 살지 않으면 내일도 없어.",
    "눈앞에 기회가 있어, 잡아야 돼.",
    "마음속 불을 꺼트리지 마.",
    "믿음이 있으면 길이 보여.",
    "두려움은 잠시일 뿐, 넌 더 강해.",
    "네가 선택한 길이 곧 너야.",
    "운명을 바꾸고 싶다면 지금 움직여.",
    "넌 혼자가 아니야, 함께 하면 더 강해.",
    "포기하지 않는 한, 끝난 게 아니야.",
    "용기 있는 자에게 세상이 기회를 줘.",
    "실수해도 괜찮아, 그게 성장이야.",
    "꿈은 기다리는 게 아니라 만드는 거야.",
    "오늘 한 걸음이 내일을 바꿔.",
    "넌 이미 시작했어, 계속 나아가.",
    "마음이 흔들려도 멈추지 마.",
    "힘든 시간도 지나가, 믿어.",
    "넌 네가 생각하는 것보다 훨씬 강해.",
    "기회는 준비된 자에게 찾아와.",
    "지금 움직이지 않으면, 아무것도 바뀌지 않아."
];


  @override
  Widget build(BuildContext context) {
    // 현재 날짜를 기반으로 주차 계산
    final DateTime now = DateTime.now();
    final DateTime startOfYear = DateTime(now.year);
    final int weekOfYear =
        ((now.difference(startOfYear).inDays) / 7).floor() + 1;

    // 메시지 인덱스를 주차에 따라 순환하도록 설정
    final int messageIndex = weekOfYear % messages.length;
    final String currentMessage = messages[messageIndex];
    final currentWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff2C2C2C),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(25, 16, 25, 16),
        child: Row(
  crossAxisAlignment: CrossAxisAlignment.center,
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  mainAxisSize: MainAxisSize.min,
  children: [
    Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(3.1416),
      child: const Icon(Icons.format_quote, color: mainRed, size: 25),
    ),
    const SizedBox(width: 3),
    
    // ✅ Flexible 추가!
    Flexible(
      child: Text(
        currentMessage,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    ),

    const SizedBox(width: 3),
    const Icon(Icons.format_quote, color: mainRed, size: 25),
  ],
)

      ),
    );
  }
}

//바텀시트 버튼
class BottomButton {
  final String text;
  final IconData icon;
  final Function function;
  final String image;

  const BottomButton (this.text, this.icon, this.function, this.image);

  Widget bottomButton(){
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: TextButton(
        onPressed: () => function(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          backgroundColor: Color(0xff242424),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Row(
          children: [
            if(image == '')
              Icon(
                icon,
                color: mainRed,
                size: 20,
              ),
            if(image != '')
              Image.asset(image, scale: 5,),
            SizedBox(width: 15),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//질문
class Question extends StatelessWidget {
  final String question;

  const Question({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Text(question,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),);
  }
}