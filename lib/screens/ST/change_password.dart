import 'package:domino/apis/services/lr_services.dart';
import 'package:domino/screens/ST/settings_main.dart';
import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_setting.dart';
import 'package:domino/style/styles.dart';
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
      Message('비밀번호가 성공적으로 변경되었습니다.', const Color(0xff00DB00),
              Color(0xff31412C), // 배경 색상
              borderColor: const Color(0xff00DB00), // 테두리 색상
              icon: Icons.block)
          .message(context);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsMain()),
      );
    } else {
      Message(
              '기존 비밀번호와 일치하지 않습니다.',
              const Color(0xffFF6767), // 텍스트 색상
              const Color(0xff412C2C), // 배경 색상
              borderColor: const Color(0xffFF6767), // 테두리 색상
              icon: Icons.block)
          .message(context);
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
              //뒤로가기 버튼
              CustomBackButton(
                () {
                  Navigator.of(context).pop();
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.lock,
                color: mainRed,
              ),
              SizedBox(width: 7),
              DPTitleText('비밀번호 바꾸기', currentWidth).dPTitleText(),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              //❤️현재 비밀번호 카테고리
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  STSubTitle('현재 비밀번호', Icons.key_rounded, 20)
                      .sTSubTitle(context),
                  //비밀번호 찾기 버튼
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginregisterFindPassword(),
                          ));
                    },
                    child: Container(
                      width: 130,
                      height: 21,
                      alignment: Alignment.centerRight,
                      child: Text(
                        '비밀번호 찾기',
                        style: TextStyle(
                          color: mainRed,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              CustomTextField('현재 비밀번호를 입력해주세요.', _currentkeycontroller, (value) {
                if (value == null || value.isEmpty) {
                  return '현재 비밀번호를 입력해주세요.';
                }
                return null;
              }, true)
                  .customTextField(),

              //❤️새 비밀번호 카테고리
              const SizedBox(height: 41),
              STSubTitle('새 비밀번호', Icons.key_rounded, 20).sTSubTitle(context),
              const SizedBox(height: 12),
              CustomTextField('새 비밀번호를 입력해 주세요.', _newkeycontroller, (value) {
                if (value == null || value.length < 8 || value.length > 16) {
                  return '비밀번호는 8~16자리여야 해요.';
                }
                return null;
              },
                      true, // 비밀번호 필드이므로 obscureText = true
                      )
                  .customTextField(),

              SizedBox(height: 12),
              CustomTextField('새 비밀번호를 한번 더 확인해주세요.', _checkkeycontroller, (value) {
                if (value != _newkeycontroller.text) {
                  return '비밀번호가 일치하지 않습니다.';
                }
                return null;
              },
                      true, // 비밀번호 필드이므로 obscureText = true
                      )
                  .customTextField(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
  padding: fullPadding,
  child: Row(
    children: [
      //취소 버튼
      Expanded(
        flex: 1, 
        child: NewButton(
          Color(0xff2C2C2C),
          settingGrey,
          '취소',
          () {
            Navigator.pop(context);
          },
        ).newButton(),
      ),
      SizedBox(width: 15),
      //비밀번호 바꾸기 버튼
      Expanded(
        flex: currentWidth < 330 ? 2 : 3, 
        child: NewButton(
          mainRed,
          backgroundColor,
          '비밀번호 바꾸기',
          () {
            if (_formKey.currentState!.validate()) {
              if (_newkeycontroller.text == _newkeycontroller.text) {
                _changePassword(
                  _currentkeycontroller.text,
                  _newkeycontroller.text,
                );
              }
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
