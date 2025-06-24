import 'dart:async';
import 'dart:math';
import 'package:domino/main.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/DP/Create/secondGoal_input_page.dart';
import 'package:domino/screens/DP/Create/thirdGoal_input_page.dart';
import 'package:domino/screens/DP/Create/color_select_page.dart';
import 'package:domino/screens/DP/Create/mandalart_example_page.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/popup.dart';
import 'package:domino/widgets/DP/Create/Around9Grid.dart';
import 'package:domino/widgets/DP/Create/middle9Grid.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/DP/model.dart';


class DPcreate99Page extends StatefulWidget {
  final bool edit;
  final String mainGoalId;
  final Color firstGoalColor;
  final List<Map<String, dynamic>> secondGoals;
  final String firstGoalName;

  const DPcreate99Page({
    super.key,
    required this.edit,
    required this.firstGoalColor,
    required this.firstGoalName,
    required this.mainGoalId,
    required this.secondGoals,
  });

  @override
  State<DPcreate99Page> createState() => _DPcreate99PageState();
}

class _DPcreate99PageState extends State<DPcreate99Page>
    with SingleTickerProviderStateMixin, RouteAware {
  double _currentAngle = 0.0;
  double _nextAngle = 0.0;
  Timer? _timer;

  void _scheduleNextRotation() {
    if (_timer?.isActive ?? false) return; // 중복 방지
    _timer = Timer(const Duration(milliseconds: 3000), () {
      if (!mounted) return;
      setState(() {
        _currentAngle = _nextAngle;
        _nextAngle += pi / 2;
      });
      _scheduleNextRotation();
    });
  }

  void _stopRotation() {
    _timer?.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _stopRotation();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 다음 페이지로 넘어갈 때 호출
  @override
  void didPushNext() {
    _stopRotation();
  }

  // 이전 페이지로 돌아올 때 호출
  @override
  void didPopNext() {
    _scheduleNextRotation();
  }

  @override
  void initState() {
    super.initState();
    _scheduleNextRotation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              //나가기 버튼
              CustomBackButton(() {
                PopupDialog.show(context, '지금 나가면,\n작성한 내용이 사라져!', '잠깐!', true,
                    false, false, true, onCancel: () {
                  Navigator.pop(context);
                }, onSuccess: () {
                  resetAllProviders(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DPMain(),
                      ),
                    );
                });
              }).customBackButton(),
              const SizedBox(width: 15),
              PageTitle(widget.edit == false ? '만다라트 작성' : '만다라트 수정')
                  .pageTitle(),
              const Spacer(),
              widget.edit == true ? ProgressBar(0, 2) : ProgressBar(1, 3)
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    DPMainGoal(widget.firstGoalName, widget.firstGoalColor)
                        .dpMainGoal(),
                    const SizedBox(height: 15),
                    Center(
                      child: SizedBox(
                        width: double.infinity,
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 1,
                                    mainAxisSpacing: 1),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              if (index == 4) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DPcreateInput1Page(
                                          edit: widget.edit,
                                          firstGoalColor: widget.firstGoalColor,
                                          firstGoalName: widget.firstGoalName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Middle9Grid(
                                    firstGoalName: widget.firstGoalName,
                                    firstColor: widget.firstGoalColor,
                                    needColor: false,
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DPcreateInput2Page(
                                          edit: widget.edit,
                                          firstGoalName: widget.firstGoalName,
                                          firstGoalColor: widget.firstGoalColor,
                                          secondGoalIndex: index,
                                          secondGoalName: context.select<SaveSecondGoalModel, String>(
                                            (model) => model.secondGoal[index.toString()] ?? '',
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Around9Grid(
                                    secondGoalIndex: index,
                                    needColor: false,
                                  ),
                                );
                              }
                            }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _stopRotation();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManadaEx(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            '만다라트 구경하기',
                            style: TextStyle(
                              color: Color(0xffA1A1A1),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 10),
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(
                                begin: _currentAngle, end: _nextAngle),
                            duration: const Duration(milliseconds: 1000),
                            builder: (context, angle, child) {
                              return Transform.rotate(
                                angle: angle,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'assets/img/floating.png',
                              scale: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 90,
              height: 45,
              child: NewButton(
                Colors.black,
                Colors.white,
                widget.edit == true ? "취소" : '이전',
                () {
                  PopupDialog.show(
                    context,
                    '지금 나가면,\n작성한 내용이 사라져!',
                    '잠깐!',
                    true,
                    false,
                    false,
                    true,
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onSuccess: () {
                      resetAllProviders(context);
                      Navigator.pop(context);
                      Navigator.pop(context);
                      _stopRotation;
                    },
                  );
                },
              ).newButton(),
            ),
            SizedBox(
              width: 90,
              height: 45,
              child: NewButton(
                Colors.black,
                Colors.white,
                '다음',
                () {
                  final isAllEmpty =
                      context.read<SaveThirdGoalModel>().isAllEmpty();

                  if (isAllEmpty) {
                    TutorialMessage('루틴이나 일정은 제3목표로만 만들 수 있어!')
                        .tutorialMessage(context);
                  } else {
                    _stopRotation;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DPcreateColorPage(
                          edit: widget.edit,
                          mainGoalId: widget.mainGoalId,
                          firstGoalColor: widget.firstGoalColor,
                          firstGoalName: widget.firstGoalName,
                          secondGoals: widget.secondGoals,
                        ),
                      ),
                    );
                  }
                },
              ).newButton(),
            ),
          ],
        ),
      ),
    );
  }
}
