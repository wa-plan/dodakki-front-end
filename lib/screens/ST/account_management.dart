import 'package:domino/main.dart';
import 'package:domino/screens/LR/login.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_setting.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/ST/change_password.dart';
import 'package:domino/widgets/popup.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:domino/apis/services/lr_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountManagement extends StatefulWidget {
  final String email;
  final String password;
  final String phoneNum;
  const AccountManagement({
    super.key,
    required this.email,
    required this.password,
    required this.phoneNum,
  });

  @override
  State<AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              //뒤로가기 버튼 (style_login.dart)
              CustomBackButton(
                () {
                  Navigator.of(context).pop();
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.person,
                color: mainRed,
              ),
              SizedBox(width: 7),
              DPTitleText('내 계정', currentWidth).dPTitleText(),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            //❤️개인 정보 카테고리
            STSubTitle('개인 정보', Icons.person, 20).sTSubTitle(context),
            const SizedBox(height: 12),
            _buildSettingItem(
              title: '이메일',
              email: true,
              onTap: () {},
            ),

            //❤️보안 카테고리
            const SizedBox(height: 41),
            STSubTitle('보안', Icons.lock, 18).sTSubTitle(context),
            const SizedBox(height: 12),
            _buildSettingItem(
              title: '비밀번호 바꾸기',
              email: false,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChangePassword(
                      password: widget.password,
                    ),
                  ),
                );
              },
            ),

            //❤️종료 카테고리
            const SizedBox(height: 41),
            STSubTitle('종료', Icons.exit_to_app_rounded, 20).sTSubTitle(context),
            const SizedBox(height: 12),
            _buildSettingItem(
              title: '로그아웃',
              email: false,
              onTap: () {
                _logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 5),
            _buildSettingItem(
              title: '탈퇴하기',
              email: false,
              onTap: () {
                PopupDialog.show(
                  context,
                  '지금 떠나면,\n지금까지의 기록이 없어져..!',
                  '잠깐만!!',
                  true, // cancel
                  false, // delete
                  true, //signout
                  false, // success
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onDelete: () {},
                  onSignOut: () async {
                    final success = await SignOutService.signOut(context);
                    if (!context.mounted) return;
                    if (success) {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MyApp()),
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  //카테고리 내 아이템 위젯
  Widget _buildSettingItem(
      {required String title, required bool email, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(22),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color(0xff2C2C2C),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              offset: const Offset(0, 0),
              blurRadius: 15,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                )),
            if (email)
              Text(widget.email,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  )),
          ],
        ),
      ),
    );
  }

  //로그아웃 함수
  void _logout() async {
    final FlutterSecureStorage storage = const FlutterSecureStorage();
    await storage.deleteAll();

    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }
}
