import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const secondGoalColor = Color(0xff929292);
const thirdGoalColor = Color(0xff5C5C5C);

const List<Color> colors = [
  Color(0xffFF7A7A),
  Color(0xffFFB82D),
  Color(0xffFCFF62),
  Color(0xff72FF5B),
  Color(0xff5DD8FF),
  Color(0xff929292),
  Color(0xffFF5794),
  Color(0xffAE7CFF),
  Color(0xffC77B7F),
  Color(0xff009255),
  Color(0xff3184FF),
  Color(0xff11D1C2),
];

// 디데이 태그
class DdayTag {
  final int dday;

  const DdayTag(this.dday);

  Widget ddayTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 51, 51, 51),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05), // 검은색 10% 투명도
            offset: const Offset(0, 0), // X, Y 위치 (0,0)
            blurRadius: 7, // 블러 7
            spreadRadius: 0, // 스프레드 0
          ),
        ],
      ),
      child: Text(
        dday < 0 ? 'D+${dday * -1}' : 'D-$dday',
        style: TextStyle(
          color: Color.fromARGB(255, 105, 105, 105),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// 아이콘 버튼
class DPIconButton {
  final Function function;
  final IconData icon;

  const DPIconButton(this.function, this.icon);

  Widget dPIconButton() {
    return Container(
      width: 40,
      height: 27,
      decoration: BoxDecoration(
        color: Color(0xff303030),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 0),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () {
          function(); // 함수 호출
        },
        child: Icon(
          icon,
          color: const Color(0xff646464),
          size: 25,
        ),
      ),
    );
  }
}

// 페이지 타이틀
class DPTitleText {
  final String text;
  final double currentWidth;

  DPTitleText(this.text, this.currentWidth);

  Widget dPTitleText() {
    return Text(text,
        style: TextStyle(
            color: Colors.white, fontSize: 21, fontWeight: FontWeight.w600));
  }
}

//DPMainGoal
class DPMainGoal {
  final String text;
  final Color color;

  DPMainGoal(this.text, this.color);

  Widget dpMainGoal() {
    return Container(
        height: 43,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(3),
          color: color,
        ),
        child: Text(
            textAlign: TextAlign.center,
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            )));
  }
}

void resetAllProviders(BuildContext context) {
  context.read<SaveSecondGoalModel>().resetAllValues();
  context.read<SaveGoalColor>().resetAllValues();
  context.read<SaveThirdGoalModel>().resetAllValues();
}

void out(BuildContext context) {
  () {
    //주의 팝업
    PopupDialog.show(
        context, '지금 나가면,\n작성한 내용이 사라져!', '잠깐!', true, false, false, true,
        onCancel: () {
      Navigator.pop(context);
    }, onSuccess: () {
      resetAllProviders(context);

      Navigator.pop(context);
      if (!context.mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const DPMain()),
        (route) => false,
      );
    });
  };
}

//플로팅 버튼
class FloatingButton {
  final IconData icon;
  final Function function;
  final double size;

  FloatingButton(this.icon, this.function, this.size);

  Widget floatingButton() {
    return FloatingActionButton(
      onPressed: () {
        function();
      },
      shape: const CircleBorder(),
      mini: true,
      elevation: 0,
      heroTag: null,
      backgroundColor: Colors.transparent, 
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColor,
          ),
        ),
        child: Icon(
          icon,
          color: backgroundColor, 
          size: size,
        ),
      ),
    );
  }
}

class DominoLoading extends StatefulWidget {
  final int count;
  final Color color;
  final Duration delay;
  final double width;
  final double height;
  final double angle;

  const DominoLoading({
    super.key,
    this.count = 6,
    this.color = const Color(0xffFF6767),
    this.delay = const Duration(milliseconds: 150),
    this.width = 8,
    this.height = 20,
    this.angle = 0.5, // Radians (~28.6도)
  });

  @override
  State<DominoLoading> createState() => _DominoLoadingState();
}

class _DominoLoadingState extends State<DominoLoading> {
  late List<bool> fallen;

  @override
  void initState() {
    super.initState();
    fallen = List.generate(widget.count, (_) => false);
    _startDominoAnimation();
  }

  void _startDominoAnimation() async {
    while (mounted) {
      for (int i = 0; i < widget.count; i++) {
        await Future.delayed(widget.delay);
        if (!mounted) return;
        setState(() {
          fallen[i] = true;
        });
      }

      // 모두 쓰러졌으면 리셋
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() {
        fallen = List.generate(widget.count, (_) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.count, (i) {
        final isFallen = fallen[i];
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: widget.width,
          height: widget.height,
          transform: isFallen
              ? Matrix4.rotationZ(widget.angle)
              : Matrix4.identity(),
          transformAlignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }
}