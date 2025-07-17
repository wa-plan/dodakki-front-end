import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/TD/td_create1_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:flutter/material.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:domino/widgets/TD/event_calendar.dart';
import 'package:domino/style/styles.dart';
import 'package:provider/provider.dart';

class TdMain extends StatelessWidget {
  const TdMain({super.key});

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      //오늘의 도미노 추가 버튼
      floatingActionButton: FloatingButton(Icons.add, () {
        context.read<SelectAPModel>().selectAP("만다라트에서 플랜을 선택해주세요.", null);

        context
            .read<SelectRepeatModel>()
            .selectRepeat(false, false, false, false);
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPage1(),
            ));
      }, 25)
          .floatingButton(),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              Image.asset(
                'assets/img/td_icon.png',
                scale: 10,
              ),
              SizedBox(width: 10),
              DPTitleText('오늘의 도미노', currentWidth).dPTitleText(),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),

      body: const Padding(padding: fullPadding, child: EventCalendar()),
      bottomNavigationBar: const NavBar(),
    );
  }
}
