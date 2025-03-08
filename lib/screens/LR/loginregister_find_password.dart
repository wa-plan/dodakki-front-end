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
  }

  void _pwFind() async {
    final userId = _userIdController.text;
    final email = _pwEmailController.text;

    await PwFindService.findPassword(
      userId: userId,
      email: email,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff222222),
      body: Padding(
        padding: currentWidth < 600
            ? const EdgeInsets.fromLTRB(25, 25, 0, 15)
            : const EdgeInsets.fromLTRB(50, 50, 0, 50),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomIconButton(() {
                          Navigator.of(context).pop();
                        }, Icons.keyboard_arrow_left_rounded, currentWidth)
                            .customIconButton(),
                        SizedBox(width: currentWidth < 600 ? 10 : 15),
                        DPTitleText('아이디/비밀번호 찾기', currentWidth).dPTitleText(),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: currentWidth < 600 ? 40 : 70),
                    Text(
                      "아이디 찾기",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: currentWidth < 600 ? 14 : 20,
                          fontWeight: FontWeight.w700,
                          height: 1.4),
                    ),
                    SizedBox(height: currentWidth < 600 ? 20 : 30),
                    Padding(
                      padding: currentWidth < 600
                          ? const EdgeInsets.fromLTRB(0, 0, 25, 0)
                          : const EdgeInsets.fromLTRB(0, 0, 50, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Phone',
                                  style: TextStyle(
                                      color: const Color(0xffAAAAAA),
                                      fontFamily: "Pretendard",
                                      fontSize: currentWidth < 600 ? 13 : 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: currentWidth < 600 ? 38 : 70,
                                  child: NewCustomTextField(
                                          '전화번호를 입력해 주세요.', _phoneController,
                                          (value) {
                                    if (value == null || value.isEmpty) {
                                      return '전화번호를 입력해 주세요.';
                                    }
                                    return null;
                                  },
                                          false, // obscureText
                                          1,
                                          currentWidth // maxLines
                                          )
                                      .newtextField(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: currentWidth < 600 ? 15 : 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                      color: const Color(0xffAAAAAA),
                                      fontSize: currentWidth < 600 ? 13 : 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: currentWidth < 600 ? 38 : 70,
                                  child: NewCustomTextField(
                                          '이메일을 입력해 주세요.', _idEmailController,
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
                              Text(
                                _responseId,
                                style: TextStyle(
                                    color: mainRed,
                                    fontSize: currentWidth < 600 ? 13 : 15,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(width: currentWidth < 600 ? 20 : 35),
                              NewButton(Colors.black, Colors.white, '찾기',
                                      _idFind, currentWidth)
                                  .newButton(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "비밀번호 찾기",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: currentWidth < 600 ? 14 : 20,
                          fontWeight: FontWeight.w700,
                          height: 1.4),
                    ),
                    SizedBox(height: currentWidth < 600 ? 20 : 30),
                    Padding(
                      padding: currentWidth < 600
                          ? const EdgeInsets.fromLTRB(0, 0, 25, 0)
                          : const EdgeInsets.fromLTRB(0, 0, 50, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'ID',
                                  style: TextStyle(
                                      color: const Color(0xffAAAAAA),
                                      fontFamily: "Pretendard",
                                      fontSize: currentWidth < 600 ? 13 : 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: currentWidth < 600 ? 38 : 70,
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
                          SizedBox(height: currentWidth < 600 ? 15 : 0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Email',
                                  style: TextStyle(
                                      color: const Color(0xffAAAAAA),
                                      fontSize: currentWidth < 600 ? 13 : 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: currentWidth < 600 ? 38 : 70,
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
                              NewButton(Colors.black, Colors.white, '찾기',
                                      _pwFind, currentWidth)
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
