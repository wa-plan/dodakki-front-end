import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String _responseId = '';
  String _responsePw = '';
  final _userIdController = TextEditingController();
  final _pwEmailController = TextEditingController();
  
  //아이디 찾기 함수
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
      TutorialMessage('아이디를 찾을 수 없습니다.').tutorialMessage(context);
    } else {}
  }
  
  //비밀번호 찾기 함수
  void _pwFind() async {
    final userId = _userIdController.text;
    final email = _pwEmailController.text;

    final result = await PwFindService.findPassword(
        userId: userId, email: email, context: context);
    
    setState(() {
      _responsePw = result;
    });

    if (result == "실패") {
      TutorialMessage('비밀번호를 찾을 수 없습니다.').tutorialMessage(context);
    } else { }
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
              PageTitle('아이디/비밀번호 찾기').pageTitle(),
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
                    const SizedBox(height: 30),

                    //아이디 찾기 타이틀
                    FieldTitle('아이디 찾기').fieldTitle(),
                    SizedBox(height: 15),
                    Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              //아이디 찾기 입력창
                              LoginTextField('전화번호를 입력해 주세요.', _phoneController,
                                      (value) {
                                if (value == null || value.isEmpty) {
                                  return '전화번호를 입력해 주세요.';
                                }
                                return null;
                              }, false, Icons.phone)
                                  .loginTextField(),

                              SizedBox(height: 10),
                              LoginTextField(
                                      '이메일을 입력해 주세요.', _idEmailController,
                                      (value) {
                                if (value == null || value.isEmpty) {
                                  return '이메일을 입력해 주세요.';
                                }
                                return null;
                              }, false, Icons.mail)
                                  .loginTextField(),
                            ],
                          ),
                        ),
                        SizedBox(height: 15),

                        //아이디 찾기 버튼
                        LoginButton('찾기', () {
                          if (_formKey.currentState!.validate()) {
                            if (_idEmailController.text.isNotEmpty &&
                                _phoneController.text.isNotEmpty) {
                              _idFind();
                            }
                          }
                        }).loginButton(),
                        const SizedBox(height: 10),

                        //피드백
                        (_responseId != "" && _responseId != '실패')
                            ? FeedBack('회원님의 아이디는 $_responseId 입니다.').feedBack()
                            : SizedBox.shrink(),
                      ],
                    ),
                    const SizedBox(height: 25),

                    FieldTitle('비밀번호 찾기').fieldTitle(),
                    SizedBox(height: 15),
                    Form(
                      key: _formKey2,
                      child: Column(
                        children: [
                          LoginTextField('아이디를 입력해 주세요.', _userIdController,
                                  (value) {
                            if (value == null || value.isEmpty) {
                              return '아이디를 입력해 주세요.';
                            }
                            return null;
                          }, false, Icons.person)
                              .loginTextField(),

                          SizedBox(height: 10),
                          LoginTextField('이메일을 입력해 주세요.', _pwEmailController,
                                  (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해 주세요.';
                            }
                            return null;
                          }, false, Icons.mail)
                              .loginTextField(),

                          SizedBox(height: 15),

                          //비밀번호 찾기 버튼
                          LoginButton('찾기', () {
                            if (_formKey2.currentState!.validate()) {
                              if (_userIdController.text.isNotEmpty &&
                                  _pwEmailController.text.isNotEmpty) {
                                _pwFind();
                              }
                            }
                          }).loginButton(),
                          const SizedBox(height: 10),

                          //피드백
                          (_responsePw != "" && _responsePw != '실패')
                              ? FeedBack('임시 비밀번호를 이메일로 전송하였습니다.')
                                  .feedBack()
                              : SizedBox.shrink(),
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
