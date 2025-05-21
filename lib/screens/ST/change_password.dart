import 'package:domino/apis/services/lr_services.dart';
import 'package:domino/screens/ST/settings_main.dart';
import 'package:domino/style/style_login.dart';
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
                          MaterialPageRoute(
                              builder: (context) => const SettingsMain()),
                        );

      
    } else {
      Message('기존 비밀번호와 일치하지 않습니다.', const Color(0xffFF6767), // 텍스트 색상
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
              //나가기 버튼
              CustomBackButton(
                () {
                  Navigator.of(context).pop();
                },
              ).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('비밀번호 바꾸기').pageTitle(),
              const Spacer(),

              
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
              SizedBox(height: currentWidth < 600 ? 40 : 70),
              //현재 비밀번호
              FieldTitle("현재 비밀번호").fieldTitle(),   
              SizedBox(height: 15),
              LoginTextField(
                              '현재 비밀번호를 입력해주세요.', _currentkeycontroller,
                              (value) {
                        if (value == null || value.isEmpty) {
                          return '현재 비밀번호를 입력해주세요.';
                        }
                        return null;
                      },
                              true, // 비밀번호 필드이므로 obscureText = true
                              Icons.lock)
                          .loginTextField(),
                 
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const LoginregisterFindPassword(),
                          ));
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    child: Text(
                      '비밀번호를 잊으셨나요?',
                      style: TextStyle(
                        color: const Color(0xffAAAAAA),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              //새 비밀번호
              FieldTitle("새 비밀번호").fieldTitle(),             
              SizedBox(height: 15),
              LoginTextField(
                              '8~16자를 입력해 주세요.', _newkeycontroller, (value) {
                        if (value == null ||
                            value.length < 8 ||
                            value.length > 16) {
                          return '비밀번호는 8~16자리여야 해요.';
                        }
                        return null;
                      },
                              true, // 비밀번호 필드이므로 obscureText = true
                              Icons.lock)
                          .loginTextField(),
                   
                 
             
              SizedBox(height: 15),
              LoginTextField(
                              '한번 더 비밀번호를 확인해주세요.', _checkkeycontroller, (value) {
                        if (value != _newkeycontroller.text) {
                          return '비밀번호가 일치하지 않습니다.';
                        }
                        return null;
                      },
                              true, // 비밀번호 필드이므로 obscureText = true
                              Icons.lock)
                          .loginTextField(),
            
              
              
            ],
          ),
        ),
      ),

      bottomNavigationBar: Padding(padding: fullPadding,
      child:LoginButton('변경하기', () {
                    if (_formKey.currentState!.validate()) {
                      if (_newkeycontroller.text == _newkeycontroller.text) {
                        _changePassword(
                            _currentkeycontroller.text, _newkeycontroller.text);
                        
                      }
                    }
                  })
                      .loginButton(),),
    );
  }
}
