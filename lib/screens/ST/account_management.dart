import 'package:domino/main.dart';
import 'package:domino/screens/LR/login.dart';
import 'package:domino/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/ST/change_password.dart';
import 'package:domino/widgets/popup.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:domino/apis/services/lr_services.dart'; // Import the new service

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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color(0xffD4D4D4),
                iconSize: 17,
              ),
              Text(
                '내 계정',
                style: Theme.of(context).textTheme.titleLarge,
              ),
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
                  // Information Section

                  _buildSettingItem(
                    menu: '이메일',
                    title: widget.email,
                  ),
                  _buildSettingItem(
                    menu: '휴대폰 번호',
                    title: widget.phoneNum,
                  ),

                  // Security Section

                  _buildSettingItem(
                    menu: '보안',
                    title: '비밀번호 변경',
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

                  // End Section

                  _buildCombinedSwitchItem()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
      {required String menu, required String title, void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xff2A2A2A),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(menu, style: const TextStyle(color: Color(0xff949494))),
            const SizedBox(height: 9),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600)),
                if (onTap != null)
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xffD4D4D4),
                    size: 17,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCombinedSwitchItem() {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 14),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xff2A2A2A),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('종료', style: TextStyle(color: Color(0xff949494))),
          const SizedBox(height: 9),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('로그아웃',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
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
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xffD4D4D4),
                  size: 17,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('탈퇴하기',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
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
                    onDelete: () {
                      // 삭제 버튼을 눌렀을 때 실행할 코드
                    },
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
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xffD4D4D4),
                  size: 17,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
  }
}
