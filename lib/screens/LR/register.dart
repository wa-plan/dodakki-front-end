import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_setting.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/apis/services/lr_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _idController = TextEditingController();
  final _pwController = TextEditingController();
  final _checkpwController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _idController.dispose();
    _pwController.dispose();
    _checkpwController.dispose();
    super.dispose();
  }

  void _register() {
    final userId = _idController.text;
    final password = _pwController.text;
    final email = _emailController.text;
    final phoneNum = _phoneController.text;

    RegistrationService.register(
      context: context,
      userId: userId,
      password: password,
      email: email,
      phoneNum: phoneNum,
    );
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
          padding: currentWidth < 600 ? appBarPadding : tabletPadding1,
          child: Row(
            children: [
              //뒤로가기 버튼
              CustomBackButton(
                () {
                  Navigator.pop(context);
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.build_rounded,
                color: mainRed,
                size: 19,
              ),
              SizedBox(width: 7),
              DPTitleText('계정 만들기', currentWidth).dPTitleText(),
              Spacer(),

              //프로그레스 바 (from style_tutorial.dart)
              ProgressBar(1, 2)
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: currentWidth < 600 ? fullPadding : tabletPadding2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            //설명문
            LoginDescription('아이디와 비밀번호를\n만들어주세요.').loginDescription(),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  STSubTitle('아이디', Icons.person, 20).sTSubTitle(context),
                  const SizedBox(height: 12),
                  //아이디 입력창
                  CustomTextField(
                    '아이디를 입력해 주세요.',
                    _idController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return '3~15자 영문/숫자 조합으로 입력해주세요.';
                      }
                      if (value.length < 3 || value.length > 15) {
                        return '아이디는 3~15자로 입력해 주세요.';
                      }
                      return null;
                    },
                    false,
                  ).customTextField(),
                  SizedBox(height: 41),

                  //비밀번호 타이틀
                  STSubTitle('비밀번호', Icons.key, 20).sTSubTitle(context),
                  const SizedBox(height: 12),

                  //비밀번호 입력창 1
                  PasswordTextField(
                    hintText: '8~16자를 입력해 주세요.',
                    controller: _pwController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '8~16자를 입력해 주세요.';
                      }
                      if (value.length < 8 || value.length > 16) {
                        return '비밀번호는 8~16자로 입력해 주세요.';
                      }
                      return null;
                    },
                    icon: Icons.lock,
                  ),
                  const SizedBox(height: 12),

                  //비밀번호 입력창 2
                  PasswordTextField(
                    hintText: '비밀번호를 한번 더 확인해 주세요.',
                    controller: _checkpwController,
                    validator: (value) {
                      if (value == null || value != _pwController.text) {
                        return '비밀번호가 일치하지 않습니다.';
                      }
                      return null;
                    },
                    icon: Icons.lock,
                  ),

                  SizedBox(height: 41),

                  //개인정보 타이틀
                  STSubTitle('개인정보', Icons.numbers_rounded, 20).sTSubTitle(context),
                  const SizedBox(height: 12),
                  //개인정보 입력창
                  CustomTextField(
                    '이메일 주소를 입력해 주세요.',
                    _emailController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 주소를 입력해 주세요.';
                      }
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value)) {
                        return '유효한 이메일을 입력해 주세요.';
                      }
                      return null;
                    },
                    false,
                  ).customTextField(),
                  SizedBox(height: 12),
                  CustomTextField(
                    '- 없이 전화번호를 입력해 주세요.',
                    _phoneController,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return '올바른 전화번호를 입력해 주세요.';
                      }
                      return null;
                    },
                    false,
                  ).customTextField(),
                  SizedBox(height: 30),

                  //드롭다운 설명문
                  DropDownDescription(
                          Color(0xff452D2D),
                          mainRed,
                          Color(0xffFFC4C4),
                          "왜 개인정보가 필요하지?",
                          "이메일 주소와 전화번호는 분실한 아이디와 비밀번호를 찾기 위해서만 사용되기 때문에 안심해도 돼 :)")
                      .dropDownDescription()
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: fullPadding,
          child: Row(
            children: [
              //취소 버튼
              Expanded(
                flex: 1,
                child: NewButton(Color(0xff2C2C2C), settingGrey, '이전', () {
                  Navigator.pop(context);
                }).newButton(),
              ),
              SizedBox(width: 15),
              //비밀번호 바꾸기 버튼
              Expanded(
                flex: currentWidth < 360 ? 2 : 3,
                child: NewButton(mainRed, backgroundColor, '계정 만들기 완료!', () {
                  if (_formKey.currentState!.validate()) {
                    if (_emailController.text.isNotEmpty &&
                        _phoneController.text.isNotEmpty &&
                        _idController.text.isNotEmpty &&
                        _pwController.text.isNotEmpty &&
                        _checkpwController.text.isNotEmpty) {
                      _register();
                    }
                  }
                }).newButton(),
              ),
            ],
          )),
    );
  }
}
