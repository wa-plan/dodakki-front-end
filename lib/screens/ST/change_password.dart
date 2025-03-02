import 'package:domino/apis/services/lr_services.dart';
import 'package:domino/screens/ST/settings_main.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/LR/loginregister_find_password.dart';

class ChangePassword extends StatefulWidget {
  final String password;
  const ChangePassword({
    super.key,
    required this.password,
  });

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>(); // Form key 추가
  final _currentkeycontroller = TextEditingController();
  final _newkeycontroller = TextEditingController();
  final _checkkeycontroller = TextEditingController();

  void _changePassword(String currentPassword, String newPassword) async {
    final success = await ChangePasswordService.changePassword(
        currentPassword: currentPassword, newPassword: newPassword);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 성공적으로 변경되었습니다.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('기존 비밀번호와 일치하지 않습니다.')),
      );
    }
  }

  @override
  void dispose() {
    _currentkeycontroller.dispose();
    _newkeycontroller.dispose();
    _checkkeycontroller.dispose();
    super.dispose();
  }

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
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                color: const Color(0xffD4D4D4),
                iconSize: 17,
              ),
              Text(
                '비밀번호 변경',
                style: TextStyle(
                    fontSize: currentWidth < 600 ? 20 : 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: fullPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: currentWidth < 600 ? 15 : 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '현재 비밀번호',
                          style: TextStyle(
                              fontSize: currentWidth < 600 ? 14 : 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: currentWidth < 600 ? 140 : 330,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    SizedBox(
                      height: currentWidth < 600 ? 30 : 45,
                      width: currentWidth < 600 ? 210 : 350,
                      child: CustomTextField(
                              '현재 비밀번호를 입력해주세요.', _currentkeycontroller,
                              (value) {
                        if (value == null || value.isEmpty) {
                          return '현재 비밀번호를 입력해주세요.';
                        }
                        return null;
                      },
                              true, // 비밀번호 필드이므로 obscureText = true
                              1)
                          .textField(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: currentWidth < 600 ? 120 : 250,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const LoginregisterFindPassword(),
                                ));
                          },
                          child: Text(
                            '비밀번호를 잊으셨나요?',
                            style: TextStyle(
                                color: const Color(0xff949494),
                                fontSize: currentWidth < 600 ? 10 : 13),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: currentWidth < 600 ? 20 : 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '새 비밀번호',
                          style: TextStyle(
                              fontSize: currentWidth < 600 ? 14 : 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: currentWidth < 600 ? 160 : 345,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    SizedBox(
                      width: currentWidth < 600 ? 290 : 350,
                      child: Column(
                        children: [
                          SizedBox(
                            height: currentWidth < 600 ? 30 : 45,
                            width: currentWidth < 600 ? 210 : 350,
                            child: CustomTextField(
                                    '8~16자를 입력해 주세요.', _newkeycontroller,
                                    (value) {
                              if (value == null ||
                                  value.length < 8 ||
                                  value.length > 16) {
                                return '비밀번호는 8~16자리여야 해요.';
                              }
                              return null;
                            },
                                    true, // 비밀번호 필드이므로 obscureText = true
                                    1)
                                .textField(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: currentWidth < 600 ? 30 : 45,
                            width: currentWidth < 600 ? 210 : 350,
                            child: CustomTextField(
                                    '비밀번호를 확인해주세요.', _checkkeycontroller,
                                    (value) {
                              if (value != _newkeycontroller.text) {
                                return '비밀번호가 일치하지 않습니다.';
                              }
                              return null;
                            },
                                    true, // 비밀번호 필드이므로 obscureText = true
                                    1)
                                .textField(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Button(Colors.black, Colors.white, '완료', () {
                                if (_formKey.currentState!.validate()) {
                                  if (_newkeycontroller.text ==
                                      _newkeycontroller.text) {
                                    _changePassword(_currentkeycontroller.text,
                                        _newkeycontroller.text);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SettingsMain()),
                                    );
                                  }
                                }
                              }).button(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
