import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/apis/services/lr_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>(); // Form key 추가

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
          padding: appBarPadding,
          child: Row(
            children: [
              NewCustomIconButton(() {
                Navigator.of(context).pop();
              }, Icons.arrow_back_ios_rounded, currentWidth, 12)
                  .newCustomIconButton(),
              SizedBox(width: currentWidth < 600 ? 10 : 14),
              Text('계정생성',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 21,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: currentWidth < 600 ? 15 : 70),
                      Text(
                        "본인확인 및 본인인증",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: currentWidth < 600 ? 13 : 20,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                      ),
                      SizedBox(height: currentWidth < 600 ? 20 : 30),
                      Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: NewCustomTextField(
                                      '이메일 주소를 입력해 주세요.', _emailController,
                                      (value) {
                                if (value == null || value.isEmpty) {
                                  return '이메일을 주소를 입력해 주세요.';
                                }
                                final emailRegex =
                                    RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegex.hasMatch(value)) {
                                  return '유효한 이메일을 입력해 주세요.';
                                }
                                return null;
                              }, false, 1, currentWidth)
                                  .newtextField(),
                            ),
                          ],
                        ),
                        SizedBox(height: currentWidth < 600 ? 15 : 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              child: NewCustomTextField(
                                      '전화번호를 입력해 주세요.', _phoneController,
                                      (value) {
                                if (value == null || value.isEmpty) {
                                  return '올바른 전화번호를 입력해 주세요.';
                                }
                                return null;
                              }, false, 1, currentWidth)
                                  .newtextField(),
                            ),
                          ],
                        ),
                      ]),
                      SizedBox(height: currentWidth < 600 ? 40 : 25),
                      Text(
                        "아이디 생성",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: currentWidth < 600 ? 13 : 20,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                      ),
                      SizedBox(height: currentWidth < 600 ? 20 : 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: NewCustomTextField(
                                    '아이디를 입력해주세요.', _idController, (value) {
                              if (value == null || value.isEmpty) {
                                return '3~15자 영문/숫자 조합으로 입력해주세요.';
                              }
                              if (value.length < 3 || value.length > 15) {
                                return '아이디는 3~15자로 입력해 주세요.';
                              }
                              return null;
                            }, false, 1, currentWidth)
                                .newtextField(),
                          ),
                        ],
                      ),
                      SizedBox(height: currentWidth < 600 ? 40 : 25),
                      Text(
                        "비밀번호 생성",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: currentWidth < 600 ? 13 : 20,
                            fontWeight: FontWeight.w600,
                            height: 1.4),
                      ),
                      SizedBox(height: currentWidth < 600 ? 20 : 30),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                child: NewCustomTextField(
                                        '8~16자를 입력해 주세요.', _pwController,
                                        (value) {
                                  if (value == null || value.isEmpty) {
                                    return '8~16자를 입력해 주세요.';
                                  }
                                  if (value.length < 8 || value.length > 16) {
                                    return '비밀번호는 8~16자로 입력해 주세요.';
                                  }
                                  return null;
                                }, true, 1, currentWidth)
                                    .newtextField(),
                              ),
                            ],
                          ),
                          SizedBox(height: currentWidth < 600 ? 15 : 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                child: NewCustomTextField(
                                        '비밀번호를 확인해 주세요.', _checkpwController,
                                        (value) {
                                  if (value == null ||
                                      value != _pwController.text) {
                                    return '비밀번호가 일치하지 않습니다.';
                                  }
                                  return null;
                                }, true, 1, currentWidth)
                                    .newtextField(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NewButton(Colors.black, Colors.white, '취소', () {
              Navigator.pop(context);
            }, currentWidth)
                .newButton(),
            NewButton(Colors.black, Colors.white, '생성', () {
              if (_formKey.currentState!.validate()) {
                if (_emailController.text.isNotEmpty &&
                    _phoneController.text.isNotEmpty &&
                    _idController.text.isNotEmpty &&
                    _pwController.text.isNotEmpty &&
                    _checkpwController.text.isNotEmpty) {
                  _register();
                }
              }
            }, currentWidth)
                .newButton()
          ],
        ),
      ),
    );
  }
}
