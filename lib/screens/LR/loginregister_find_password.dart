import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/apis/services/lr_services.dart';

class LoginregisterFindPassword extends StatefulWidget {
  const LoginregisterFindPassword({super.key});

  @override
  State<LoginregisterFindPassword> createState() =>
      _LoginregisterFindPasswordState();
}

class _LoginregisterFindPasswordState extends State<LoginregisterFindPassword> {
  final _phoneController = TextEditingController();
  final _idEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Form key 추가
  final _formKey2 = GlobalKey<FormState>(); // Form key 추가
  String _responseId = '';

  final _userIdController = TextEditingController();
  final _pwEmailController = TextEditingController();

  void _idFind() async {
    final phoneNum = _phoneController.text;
    final email = _idEmailController.text;

    final result = await IdFindService.findUserId(
      phoneNum: phoneNum,
      email: email,
    );

    setState(() {
      _responseId = result;
    });

    if (result == "실패") {
      Message(
              '아이디를 찾을 수 없습니다.',
              const Color(0xffFF6767), // 텍스트 색상
              const Color(0xff412C2C), // 배경 색상
              borderColor: const Color(0xffFF6767), // 테두리 색상
              icon: Icons.block)
          .message(context);
    } else {}
  }

  void _pwFind() async {
    final userId = _userIdController.text;
    final email = _pwEmailController.text;

    await PwFindService.findPassword(
        userId: userId, email: email, context: context);
  }

  @override
  void dispose() {
    _idEmailController.dispose();
    _pwEmailController.dispose();
    _userIdController.dispose();
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
          padding: currentWidth < 600 ? appBarPadding : tabletPadding,
          child: Row(
            children: [
              NewCustomIconButton(() {
                Navigator.of(context).pop();
              }, Icons.arrow_back_ios_rounded, currentWidth, 12)
                  .newCustomIconButton(),
              SizedBox(width: currentWidth < 600 ? 10 : 14),
              Text('아이디/비밀번호 찾기',
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
        padding: currentWidth < 600 ? fullPadding : tabletFullPadding,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: currentWidth < 600 ? 15 : 70),
                    Text(
                      "아이디 찾기",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: currentWidth < 600 ? 13 : 20,
                          fontWeight: FontWeight.w600,
                          height: 1.4),
                    ),
                    SizedBox(height: currentWidth < 600 ? 20 : 30),
                    Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: NewCustomTextField(
                                              '전화번호를 입력해 주세요.',
                                              _phoneController, (value) {
                                        if (value == null || value.isEmpty) {
                                          return '전화번호를 입력해 주세요.';
                                        }
                                        return null;
                                      }, false, 1, currentWidth)
                                          .newtextField(),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: currentWidth < 600 ? 15 : 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      child: NewCustomTextField('이메일을 입력해 주세요.',
                                              _idEmailController, (value) {
                                        if (value == null || value.isEmpty) {
                                          return '이메일을 입력해 주세요.';
                                        }
                                        return null;
                                      }, false, 1, currentWidth)
                                          .newtextField(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: currentWidth < 600 ? 20 : 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              _responseId == '실패' ? '' : _responseId,
                              style: TextStyle(
                                  color: mainRed,
                                  fontSize: currentWidth < 600 ? 13 : 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(width: currentWidth < 600 ? 20 : 35),
                            NewButton(Colors.black, Colors.white, '찾기', () {
                              if (_formKey.currentState!.validate()) {
                                if (_idEmailController.text.isNotEmpty &&
                                    _phoneController.text.isNotEmpty) {
                                  _idFind();
                                }
                              }
                            }, currentWidth)
                                .newButton(),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "비밀번호 찾기",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: currentWidth < 600 ? 13 : 20,
                          fontWeight: FontWeight.w600,
                          height: 1.4),
                    ),
                    SizedBox(height: currentWidth < 600 ? 20 : 30),
                    Form(
                      key: _formKey2,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  child: NewCustomTextField(
                                          '아이디를 입력해 주세요.', _userIdController,
                                          (value) {
                                    if (value == null || value.isEmpty) {
                                      return '아이디를 입력해 주세요.';
                                    }
                                    return null;
                                  }, false, 1, currentWidth)
                                      .newtextField(),
                                ),
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
                                child: SizedBox(
                                  child: NewCustomTextField(
                                          '이메일을 입력해 주세요.', _pwEmailController,
                                          (value) {
                                    if (value == null || value.isEmpty) {
                                      return '이메일을 입력해 주세요.';
                                    }
                                    return null;
                                  }, false, 1, currentWidth)
                                      .newtextField(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: currentWidth < 600 ? 20 : 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              NewButton(Colors.black, Colors.white, '찾기', () {
                                if (_formKey2.currentState!.validate()) {
                                  if (_userIdController.text.isNotEmpty &&
                                      _pwEmailController.text.isNotEmpty) {
                                    _pwFind();
                                  }
                                }
                              }, currentWidth)
                                  .newButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
