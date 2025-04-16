import 'package:domino/main.dart';
import 'package:domino/screens/LR/login.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/ST/change_password.dart';
import 'package:domino/widgets/popup.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              NewCustomIconButton(() {
                Navigator.of(context).pop();
              }, Icons.arrow_back_ios_rounded, currentWidth, 12)
                  .newCustomIconButton(),
              SizedBox(width: currentWidth < 600 ? 10 : 14),
              Text('내 계정',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 27,
                      fontWeight: FontWeight.w600)),
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
            Expanded(
              child: ListView(
                children: [
                  const SizedBox(height: 15),
                  MGSubTitle('정보', currentWidth).mgSubTitle(context),
                  const SizedBox(height: 8),
                  _buildSettingItem2(
                    title: widget.email,
                  ),
                  const SizedBox(height: 14),
                  MGSubTitle('보안', currentWidth).mgSubTitle(context),
                  const SizedBox(height: 8),
                  _buildSettingItem(
                    title: '비밀번호 변경하기',
                    onTap: () {
                      print(widget.phoneNum);
                      print(widget.email);
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
                  const SizedBox(height: 14),
                  MGSubTitle('종료', currentWidth).mgSubTitle(context),
                  const SizedBox(height: 8),
                  _buildCombinedSwitchItem()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({required String title, void Function()? onTap}) {
    final currentWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xff2A2A2A),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02), // 검은색 10% 투명도
              offset: const Offset(0, 0), // X, Y 위치 (0,0)
              blurRadius: 15, // 블러 7
              spreadRadius: 0, // 스프레드 0
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                if (onTap != null)
                  NewCustomIconButton(onTap, Icons.arrow_forward_ios_rounded,
                          currentWidth, 14)
                      .newCustomIconButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem2({required String title, void Function()? onTap}) {
    final currentWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xff2A2A2A),
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02), // 검은색 10% 투명도
              offset: const Offset(0, 0), // X, Y 위치 (0,0)
              blurRadius: 15, // 블러 7
              spreadRadius: 0, // 스프레드 0
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NewCustomIconButton(
                        () {}, Icons.mail_outline_rounded, currentWidth, 16)
                    .newCustomIconButton(),
                const SizedBox(width: 7),
                Text('이메일',
                    style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600)),
                Spacer(),
                Text(title,
                    style: TextStyle(
                        fontSize: currentWidth < 600 ? 13 : 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w300)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedSwitchItem() {
    final currentWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02), // 검은색 10% 투명도
            offset: const Offset(0, 0), // X, Y 위치 (0,0)
            blurRadius: 15, // 블러 7
            spreadRadius: 0, // 스프레드 0
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('로그아웃',
                      style: TextStyle(
                          fontSize: currentWidth < 600 ? 13 : 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  NewCustomIconButton(() {
                    _logout();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  }, Icons.arrow_forward_ios_rounded, currentWidth, 14)
                      .newCustomIconButton(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 13),
          GestureDetector(
            onTap: () {
              PopupDialog.show(
                context,
                '이건 아니야.. \n정말 떠날거야...?',
                true, // cancel
                false, // delete
                true, //signout
                false, // success
                onCancel: () {
                  Navigator.of(context).pop();
                },
                onDelete: () {},
                onSignOut: () {
                  SignOutService.signOut(context);
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                  );
                },
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('탈퇴하기',
                      style: TextStyle(
                          fontSize: currentWidth < 600 ? 13 : 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600)),
                  NewCustomIconButton(() {
                    PopupDialog.show(
                      context,
                      '이건 아니야..\n정말 떠날거야...?',
                      true, // cancel
                      false, // delete
                      true, //signout
                      false, // success
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                      onDelete: () {},
                      onSignOut: () {
                        SignOutService.signOut(context);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyApp(),
                          ),
                        );
                      },
                    );
                  }, Icons.arrow_forward_ios_rounded, currentWidth, 14)
                      .newCustomIconButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // 모든 SharedPreferences 데이터 삭제

    const FlutterSecureStorage storage = FlutterSecureStorage();
    await storage.deleteAll();
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');*/
  }
}
