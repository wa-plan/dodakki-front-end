import 'package:flutter/material.dart';

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
    '작은 기회에서 종종 위대한 업적이 시작되지!',
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
        color: const Color(0xff2B2B2B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // 자식 위젯 크기만큼만 높이를 조정
          children: [
            const Text(
              '"',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  fontFamily: "NotoSansKR"),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                currentMessage,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: currentWidth < 600 ? 12 : 20,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // 최대 두 줄로 제한
                overflow: TextOverflow.ellipsis, // 텍스트가 넘칠 경우 말줄임표(...) 표시
              ),
            ),
            const SizedBox(width: 15),
            const Text(
              '"',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  fontFamily: "NotoSansKR"),
            ),
          ],
        ),
      ),
    );
  }
}
