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
      context: context
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
              Text('아이디/비밀번호 찾기',
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
                          fontSize: currentWidth < 600 ? 14 : 20,
                          fontWeight: FontWeight.w700,
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
                                child: SizedBox(
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
                    Column(
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
                          SizedBox(height: currentWidth < 600 ? 15 : 0),
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
                              NewButton(Colors.black, Colors.white, '찾기',
                                      _pwFind, currentWidth)
                                  .newButton(),
                            ],
                          ),
                        ],
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
