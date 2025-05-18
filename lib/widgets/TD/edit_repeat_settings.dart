import 'package:domino/provider/TD/datelist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditRepeatSettings extends StatefulWidget {
  final bool everyDay;
  final bool everyWeek;
  final bool everyTwoWeek;
  final bool everyMonth;
  const EditRepeatSettings(
      this.everyDay, this.everyWeek, this.everyTwoWeek, this.everyMonth,
      {super.key});

  @override
  State<EditRepeatSettings> createState() => EditRepeatSettingsState();
}

class EditRepeatSettingsState extends State<EditRepeatSettings> {
  late bool everyDay;
  late bool everyWeek;
  late bool everyTwoWeek;
  late bool everyMonth;

  @override
  void initState() {
    super.initState();
    everyDay = widget.everyDay;
    everyWeek = widget.everyWeek;
    everyTwoWeek = widget.everyTwoWeek;
    everyMonth = widget.everyMonth;
    print('전달받은 값: $everyDay, $everyWeek, $everyTwoWeek, $everyMonth');
  }

  @override
  void didUpdateWidget(EditRepeatSettings oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.everyDay != widget.everyDay ||
        oldWidget.everyWeek != widget.everyWeek ||
        oldWidget.everyTwoWeek != widget.everyTwoWeek ||
        oldWidget.everyMonth != widget.everyMonth) {
      setState(() {
        everyDay = widget.everyDay;
        everyWeek = widget.everyWeek;
        everyTwoWeek = widget.everyTwoWeek;
        everyMonth = widget.everyMonth;
        print(
            'didUpdateWidget: $everyDay, $everyWeek, $everyTwoWeek, $everyMonth');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              children: [
                Transform.scale(
                  scale: 1,
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
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 14 : 16),
                ),
              ],
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 1,
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
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 14 : 16),
                ),
              ],
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 1,
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
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 14 : 16),
                ),
              ],
            ),
            Row(
              children: [
                Transform.scale(
                  scale: 1,
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
                      context
                          .read<DateListProvider>()
                          .setEverymonth(everyMonth);
                    },
                  ),
                ),
                Text(
                  '매월',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 14 : 16),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
