
import 'package:domino/provider/DP/model.dart';
import 'package:domino/screens/DP/Detail/dp_detail1_page.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/DP/mainPage_mandalart.dart';
import 'package:domino/screens/DP/Create/goalSelect_page.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DPMain extends StatefulWidget {
  const DPMain({super.key});

  @override
  State<DPMain> createState() => _DPMainState();
}

class _DPMainState extends State<DPMain> {
  final PageController _pageController = PageController();

  String ddayFinder(String mandalartId, MandalartProvider provider) {
    String dday = provider.ddayList.firstWhere(
          (element) => element['mandalartId'] == mandalartId,
          orElse: () => {'dday': '0'},
        )['dday'] ??
        '0';
    return dday;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mandalartProvider = context.watch<MandalartProvider>();
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      floatingActionButton: FloatingButton(Icons.add, () async {
        resetAllProviders(context);
        await Future.delayed(const Duration(milliseconds: 10));
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DPcreateSelectPage(
              emptyMainGoals: mandalartProvider.emptyMainGoals,
              secondGoals: mandalartProvider.secondGoals,
            ),
          ),
        );
      }, 25).floatingButton(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              Image.asset(
                'assets/img/dp_icon.png',
                scale: 11,
              ),
              const SizedBox(width: 10),
              DPTitleText('도미노 플랜', currentWidth).dPTitleText(),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      bottomNavigationBar: const NavBar(),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            const SizedBox(height: 10),
            mandalartProvider.mainGoals.isEmpty
                ? Container(
                    height: 240,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                    decoration: BoxDecoration(
                      color: const Color(0xff2C2C2C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Text(
                          '엇!\n아직 플랜이 없어요.\n목표를 이루려면\n철저한 계획은 필수!',
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
                          child: Image.asset(
                            'assets/img/emptyDominho.png',
                            height: currentWidth < 330 ? 130 : 180,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 440,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: mandalartProvider.mainGoals.length,
                      itemBuilder: (context, index) {
                        final goal = mandalartProvider.mainGoals[index];
                        final mandalartId = goal['id'].toString();

                        final secondGoalData = mandalartProvider.secondGoals
                            .where((e) => e['mandalartId'] == mandalartId)
                            .toList();
                        if (secondGoalData.isEmpty) return const SizedBox.shrink();

                        final firstColor = secondGoalData[0]['color'];
                        final mandalart = secondGoalData[0]['mandalart'];
                        final secondGoals = secondGoalData[0]['secondGoals']
                            as List<Map<String, dynamic>>?;

                        return GestureDetector(
                          onTap: () {
                            if (secondGoals.isEmpty) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DPdetailPage(
                                  firstGoalName: mandalart,
                                  secondGoals: secondGoals,
                                  mandalartId: int.parse(mandalartId),
                                  firstGoalColor:
                                      ColorTransform(firstColor).colorTransform(),
                                  dday: ddayFinder(mandalartId, mandalartProvider),
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: const Color(0xff2C2C2C),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                DdayTag(
                                        int.parse(ddayFinder(
                                            mandalartId, mandalartProvider)))
                                    .ddayTag(),
                                const SizedBox(height: 20),
                                Text(
                                  mandalart,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 35),
                                IgnorePointer(
                                  child: MainMandalart(
                                    firstGoalName: mandalart,
                                    secondGoals: secondGoals!,
                                    mandalartId: int.parse(mandalartId),
                                    firstGoalColor:
                                        ColorTransform(firstColor).colorTransform(),
                                    size: 250,
                                    detail: false,
                                    currentWidth: currentWidth,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 20),
            PageIndicator(_pageController, mandalartProvider.mainGoals),
          ],
        ),
      ),
    );
  }
}
