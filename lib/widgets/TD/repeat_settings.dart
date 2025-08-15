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
  bool everyMonth = false; 


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                visualDensity: VisualDensity.compact,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Color(0xff323232);
                  }
                  return Color(0xff323232);
                }),
                activeColor: Colors.transparent,
                side: BorderSide(color: Colors.transparent),
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
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                visualDensity: VisualDensity.compact,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Color(0xff323232);
                  }
                  return Color(0xff323232);
                }),
                activeColor: Colors.transparent,
                side: BorderSide(color: Colors.transparent),
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
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                visualDensity: VisualDensity.compact,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Color(0xff323232);
                  }
                  return Color(0xff323232);
                }),
                activeColor: Colors.transparent,
                side: BorderSide(color: Colors.transparent),
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
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Row(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                visualDensity: VisualDensity.compact,
                fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.disabled)) {
                    return Color(0xff323232);
                  }
                  return Color(0xff323232);
                }),
                activeColor: Colors.transparent,
                side: BorderSide(color: Colors.transparent),
                checkColor: const Color(0xffFF6767),
                value: everyMonth,
                onChanged: (value) {
                  setState(() {
                    everyMonth = value!;
                    everyDay = false;
                    everyWeek = false;
                    everyTwoWeek = false;
                  });
                  context.read<DateListProvider>().setEverymonth(everyMonth);
              
                },
              ),
            ),
            Text(
              '매월',
              style: TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
