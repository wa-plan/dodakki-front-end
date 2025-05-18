import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/nav_provider.dart';
import 'package:domino/screens/ST/settings_main.dart';
import 'package:domino/screens/MG/mygoal_main.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navBarProvider = Provider.of<NavBarProvider>(context);
    final int selectedIndex = navBarProvider.selectedIndex;

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(12.0),
        topRight: Radius.circular(12.0),
      ),
      child: BottomAppBar(
        height: 77,
          color: Color(0xff2D2D2D),
          shadowColor: Colors.black,
          elevation: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  context, 'assets/img/vector1.png', '나의 목표', 0, selectedIndex),
              _buildNavItem(
                  context, 'assets/img/vector2.png', '도미노 플랜', 1, selectedIndex),
              _buildNavItem(
                  context, 'assets/img/vector3.png', '오늘의 도미노', 2, selectedIndex),
              _buildNavItem(
                  context, 'assets/img/vector4.png', '설정', 3, selectedIndex),
            ],
          ),
        ),
    );
  }

  Widget _buildNavItem(BuildContext context, String iconPath, String label,
      int index, int selectedIndex) {
    final isSelected = selectedIndex == index;


    return Expanded(
      child: GestureDetector( // 터치 영역 확장
        onTap: () {
          if (selectedIndex != index) {
            Provider.of<NavBarProvider>(context, listen: false).setIndex(index);
            _onItemTapped(context, index);
          }
        },
        behavior: HitTestBehavior.opaque, // 빈 공간도 터치 인식
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
              child: Image.asset(
                iconPath,
                scale:1.15,
                color: isSelected ? mainRed : const Color(0xffAAAAAA), // 선택된 색상 조정
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5,
                color: isSelected ? mainRed : const Color(0xffAAAAAA),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyGoal()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DPMain()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TdMain()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SettingsMain()),
        );
        break;
      default:
        break;
    }
  }
}
