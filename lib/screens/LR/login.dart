import 'dart:ui';
import 'package:domino/screens/LR/loginregister_find_password.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/screens/Tutorial/tutorial1_page.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';
import 'package:domino/screens/LR/register.dart';
import 'package:domino/apis/services/lr_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _idcontroller = TextEditingController();
  final TextEditingController _pwcontroller = TextEditingController();
  final storage = const FlutterSecureStorage();

  final LoginService _loginService = LoginService();

  _asyncMethod() async {
    if (await storage.read(key: "token") != null) {
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Tutorial1()));
    }
  }

  void _login() {
    final userId = _idcontroller.text;
    final password = _pwcontroller.text;

    if (userId.isEmpty || password.isEmpty) {
      Message(
        "아이디와 비밀번호를 모두 입력해주세요.",
        const Color(0xffFF6767), // 텍스트 색상
        const Color(0xff412C2C), // 배경 색상
        borderColor: const Color(0xffFF6767), // 테두리 색상
        icon: Icons.block, // 아이콘
      ).message(context);
      return;
    }

    _loginService.login(context, userId, password);
  }

  @override
  void initState() {
    super.initState();
    _asyncMethod(); // SecureStorage에서 로그인 유무 확인
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/img/newBG.png'), // 배경 이미지
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                    const Text(
                      '도닦기에 오신 것을\n환영합니다:)',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          height: 1.7),
                    ),
               
                const SizedBox(height: 30),
                
                Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'ID',
                                  style: TextStyle(
                                      color: Color(0xffAAAAAA),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 37,
                                  width: 290,
                                  child: CustomTextField(
                                    '아이디를 입력해 주세요.',
                                    _idcontroller,
                                    (value) {
                                      if (value == null || value.isEmpty) {
                                        return '아이디를 입력해 주세요.';
                                      }
                                      return null;
                                    },
                                    false, 1
                                  ).textField(),
                                )
                              ]),
                          const SizedBox(height: 20.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'PW',
                                  style: TextStyle(
                                      color: Color(0xffAAAAAA),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 37,
                                  width: 290,
                                  child: CustomTextField(
                                      '비밀번호를 입력해 주세요.', _pwcontroller, (value) {
                                    if (value == null || value.isEmpty) {
                                      return '비밀번호를 입력해 주세요.';
                                    }
                                    return null;
                                  },
                                  false, 1).textField(),
                                )
                              ]),
                          const SizedBox(height: 20.0),
                          SizedBox(
                                      width: 400,
                                      child: TextButton(
                                        onPressed: _login, 
                                        style: TextButton.styleFrom(
                                            padding: const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                                            backgroundColor:
                                                Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                        child: const Text(
                                          '로그인',
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        )),
                                    ),
                               
                            
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginregisterFindPassword(),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                            ),
                                            child: const Text(
                                              '아이디/비밀번호 찾기',
                                              style: TextStyle(
                                                color: Color(0xffAAAAAA),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          

                                           TextButton(
                                            onPressed: () {
                                              Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                                            },
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                                              backgroundColor:
                                                  Colors.transparent,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                            ),
                                            child: const Text(
                                              '계정생성하기',
                                              style: TextStyle(
                                                color: Color(0xffAAAAAA),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                ],
                              )
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
