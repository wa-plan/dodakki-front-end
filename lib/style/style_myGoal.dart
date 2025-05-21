import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

//비어있는 데이터 (for 쓰러뜨릴 목표)
class BlankData {
  final String text;
  final double height;

  const BlankData(this.text, this.height);

  Widget blankData() {
    return Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
      decoration: BoxDecoration(
        color: const Color(0xff2D2D2D),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Text(
            text,
            style: TextStyle(
              height: 1.5,
              color: Color(0xff595959),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Positioned(
              top: 50,
              right: 10,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/img/emptyDominho.png', height: 150),
              ))
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
        color: const Color.fromARGB(255, 178, 178, 178),
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

//비어있는 데이터 (for 쓰러뜨린/쓰러뜨리지 못한 목표)
class BlankData2 {
  final String text;

  const BlankData2(this.text);

  Widget blankData2() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff2D2D2D),
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
                color: Color(0xff595959),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            Column(
              children: [
                SizedBox(height: 15),
                Opacity(
                    opacity: 0.3,
                    child: Image.asset('assets/img/haha.png', scale: 2)),
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
    '산다는 건, 치열한 전투지...',
    '용기있는 자는 결코 버림받지 않아!',
    '인생은 오늘의 너 안에 있고 내일은 스스로 만드는 거야!',
    '모든 인생은 실험이고 더 많이 실험할수록 더 나아지지!',
    '길을 잃는다는 건 곧 길을 알게 된다는 거지!',
    '성공으로 가는 엘리베이터는 고장이니 계단을 이용해야 해!',
    '실패는 잊어도 실패가 준 교훈은 절대 잊으면 안 돼!',
    '인생에 뜻을 세우는 데 있어 늦은 때란 없어!',
    '최후의 성공을 거둘 때까지 밀고 나가자!',
    '원하는 것을 얻기 위한 첫단계는 네가 무엇을 원하는지 결정하는 거야!',
    '너가 해야 할 일을 결정하는 건 오직 너 자신뿐이야!',
    '한 번의 실패와 영원한 실패를 혼동하지 마!',
    '지금까지 네가 만들어온 모든 선택으로 인해 지금의 너가 있는 거야!',
    '고난의 시기에 동요하지 않는 건 정말 칭찬받을 만한 뛰어난 인물의 증거야!',
    '해야할 일을 하는 건 타인의 행복과 무엇보다 너의 행복을 위해서야!',
    '중요한 건 스스로의 재능과 자신의 행동에 쏟아 붓는 사랑의 정도지!',
    '고난이 지나면 반드시 기쁨이 스며들거야!',
    '작은 기회에서 위대한 업적이 시작되는거야!',
    '1퍼센트의 가능성, 그것이 너의 길이야!',
    '좋은 성과를 얻으려면 한걸음 한걸음이 힘차고 충실해야해!',
    '계단을 밟아야 계단 위에 올라설 수 있어!',
    '작은 기회에서 종종\n위대한 업적이 시작되지!',
    '오랫동안 꿈을 그리는 사람은 마침내 그 꿈을 닮아 간대!',
    '시간 걱정을 하지 말고 스스로 마음을 바쳐 최선을 다 할 수 있을지를 고민해!',
    '이 또한 지나갈 테니 걱정 마!',
    '비가 내리고 바람이 불어야 비옥한 땅이 될 수 있어!',
    '미래는 꿈의 아름다움을 믿는 사람이 쟁취하는거야!',
    '무언가를 시도할 용기를 갖지 못한다면 인생은 대체 뭐겠어?',
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
        color: const Color(0xff2D2D2D),
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
                child: const Icon(Icons.format_quote, color: mainRed, size: 25)),
            SizedBox(
              width: currentWidth < 600 ? 205 : 250,
              child: Text(
                currentMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.format_quote, color: mainRed, size: 25),
          ],
        ),
      ),
    );
  }
}

//바텀시트 버튼
class BottomButton {
  final String text;
  final IconData icon;
  final Function function;

  const BottomButton (this.text, this.icon, this.function);

  Widget bottomButton(){
    return SizedBox(
      width: double.infinity,
      height: 70,
      child: TextButton(
        onPressed: () => function(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          backgroundColor: Color(0xff262626),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: mainRed,
              size: 20,
            ),
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
        style: const TextStyle(
            fontFamily: "Pretendard",
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16));
  }
}