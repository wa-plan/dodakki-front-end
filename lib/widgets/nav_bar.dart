import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domino/provider/nav_provider.dart';
import 'package:domino/screens/DP/dp_main_page.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/screens/ST/settings_main.dart';
import 'package:domino/screens/MG/mygoal_main.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navBarProvider = Provider.of<NavBarProvider>(context);
    final int selectedIndex = navBarProvider.selectedIndex;

    return BottomAppBar(
      color: backgroundColor,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Image.asset(
                iconPath,
                width: isSelected ? 25 : 21, // 선택된 아이콘 크기 조정
                height: isSelected ? 25 : 21,
                color: isSelected ? mainGold : const Color(0xffE5E5E5), // 선택된 색상 조정
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? mainGold : const Color(0xffE5E5E5),
                fontWeight: FontWeight.w300,
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
