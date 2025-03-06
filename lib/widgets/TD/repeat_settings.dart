import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/TD/datelist_provider.dart';

class RepeatSettings extends StatefulWidget {
  const RepeatSettings({super.key});

  @override
  State<RepeatSettings> createState() => RepeatSettingsState();
}

class RepeatSettingsState extends State<RepeatSettings> {
  bool everyDay = false;
  bool everyWeek = false;
  bool everyTwoWeek = false;
  bool everyMonth = false; //변수: 체크박스 체크 여부

  // true 값을 가지는 변수의 이름을 반환하는 생성자

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return 
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                children: [
                  Transform.scale(
                    scale: 0.7,
                    child: Checkbox(
                      visualDensity: VisualDensity.compact,
                      side: WidgetStateBorderSide.resolveWith((states) =>
                          const BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 156, 156, 156))), //체크박스 테두리의 두께와 색깔 지정
                      activeColor: const Color(0xff262626),
                      checkColor: const Color(0xffFF6767),
                      value: everyDay,
                      onChanged: (value) {
                        setState(() {
                          everyDay = value!;
                          everyWeek = false;
                          everyTwoWeek = false;
                          everyMonth = false;
                        });
                        context.read<DateListProvider>().setEveryday(everyDay);
                      },
                    ),
                  ),
                  Text(
                    '매일',
                    style: TextStyle(color: Colors.white, 
                    fontSize: currentWidth < 600 ? 11 : 13),
                  ),
                ],
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.7,
                    child: Checkbox(
                      side: WidgetStateBorderSide.resolveWith((states) =>
                          const BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 156, 156, 156))), //체크박스 테두리의 두께와 색깔 지정
                      activeColor: const Color(0xff262626),
                      checkColor: const Color(0xffFF6767),
                      value: everyWeek,
                      onChanged: (value) {
                        setState(() {
                          everyWeek = value!;
                          everyDay = false;
                          everyTwoWeek = false;
                          everyMonth = false;
                        });
                        context.read<DateListProvider>().setEveryweek(everyWeek);
                      },
                    ),
                  ),
                   Text(
                    '매주',
                    style: TextStyle(color: Colors.white,
                    fontSize: currentWidth < 600 ? 11 : 13),
                  ),
                ],
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.7,
                    child: Checkbox(
                      side: WidgetStateBorderSide.resolveWith((states) =>
                          const BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 156, 156, 156))), //체크박스 테두리의 두께와 색깔 지정
                      activeColor: const Color(0xff262626),
                      checkColor: const Color(0xffFF6767),
                      value: everyTwoWeek,
                      onChanged: (value) {
                        setState(() {
                          everyTwoWeek = value!;
                          everyDay = false;
                          everyWeek = false;
                          everyMonth = false;
                        });
                        context
                            .read<DateListProvider>()
                            .setEverytwoweek(everyTwoWeek);
                      },
                    ),
                  ),
                   Text(
                    '격주',
                    style: TextStyle(color: Colors.white, fontSize: currentWidth < 600 ? 11 : 13),
                  ),
                ],
              ),
              Row(
                children: [
                  Transform.scale(
                    scale: 0.7,
                    child: Checkbox(
                      side: WidgetStateBorderSide.resolveWith((states) =>
                          const BorderSide(
                              width: 1.5,
                              color: Color.fromARGB(255, 156, 156, 156))), //체크박스 테두리의 두께와 색깔 지정
                      activeColor: const Color(0xff262626),
                      checkColor: const Color(0xffFF6767),
                      value: everyMonth,
                      onChanged: (value) {
                        setState(() {
                          everyMonth = value!;
                          everyDay = false;
                          everyWeek = false;
                          everyTwoWeek = false;
                        });
                        context
                            .read<DateListProvider>()
                            .setEverymonth(everyMonth);
                      },
                    ),
                  ),
                   Text(
                    '매월',
                    style: TextStyle(color: Colors.white, fontSize: currentWidth < 600 ? 11 : 13),
                  ),
                ],
              ),
            ],
          );

  }
}
