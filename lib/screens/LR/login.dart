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
  final _formKey = GlobalKey<FormState>(); // Form key 추가
  final storage = const FlutterSecureStorage();
  String userInfo = ""; //user의 정보를 저장하기 위한 변수

  final LoginService _loginService = LoginService();

  Future<void> _asyncMethod() async {
    // 먼저 저장된 토큰이 있는지 확인
    final String? authToken = await storage.read(key: "token");

    if (authToken == null || authToken.isEmpty) {
      return; // 토큰이 없으면 자동 로그인하지 않음
    }

    // 저장된 로그인 정보 읽기
    final String? storedUserInfo = await storage.read(key: "login");

    // null 체크 후 할당 (null이면 빈 문자열로 초기화)
    userInfo = storedUserInfo ?? "";

    if (userInfo.isNotEmpty) {
      // userInfo에서 userId와 password 추출
      final parts = userInfo.split(' ');
      final userIdIndex = parts.indexOf('id');
      final passwordIndex = parts.indexOf('password');

      String? userId;
      String? password;

      if (userIdIndex != -1 && userIdIndex + 1 < parts.length) {
        userId = parts[userIdIndex + 1];
      }
      if (passwordIndex != -1 && passwordIndex + 1 < parts.length) {
        password = parts[passwordIndex + 1];
      }

      // userId와 password가 모두 있으면 로그인 처리
      if (userId != null && password != null) {
        bool isSuccess = await _loginService.login(context, userId, password);

        if (isSuccess) {
          // 로그인 성공 시에만 이동
          if (context.mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TdMain()),
            );
          }
        } else {}
      } else {}
    } else {}
  }

  void _login() async {
    final userId = _idcontroller.text;
    final password = _pwcontroller.text;

    if (userId.isEmpty || password.isEmpty) {
      return;
    }

    bool isSuccess = await _loginService.login(context, userId, password);
    if (isSuccess) {
      // 로그인 성공 시 화면 전환
      final String? accessToken = await storage.read(key: "token");
      if (accessToken == null || accessToken.isEmpty) {
        await storage.write(
            key: "token",
            value: "your_generated_token_here"); // 실제 토큰을 받아와 저장해야 함
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Tutorial1()),
        );
      }
    } else {
      
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  @override
  void dispose() {
    _idcontroller.dispose();
    _pwcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xff222222),
      body: SingleChildScrollView(
        child: Padding(
          padding: currentWidth < 600
              ? const EdgeInsets.fromLTRB(25, 20, 0, 20)
              : const EdgeInsets.fromLTRB(50, 60, 0, 50),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  '도닦기에 오신 것을\n환영합니다:)',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: currentWidth < 600 ? 17 : 24,
                      fontWeight: FontWeight.w700,
                      height: 1.4),
                ),
                SizedBox(height: currentWidth < 600 ? 35 : 45),
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
                                    fontSize: currentWidth < 600 ? 15 : 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: SizedBox(
                                child: NewCustomTextField(
                                        '아이디를 입력해 주세요.', _idcontroller, (value) {
                                  if (value == null || value.isEmpty) {
                                    return '아이디를 입력해 주세요.';
                                  }
                                  return null;
                                }, false, 1, currentWidth)
                                    .newtextField(),
                              ),
                            )
                          ]),
                      SizedBox(height: currentWidth < 600 ? 15 : 15),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Text(
                                'PW',
                                style: TextStyle(
                                    color: const Color(0xffAAAAAA),
                                    fontSize: currentWidth < 600 ? 13 : 20,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: SizedBox(
                                child: NewCustomTextField(
                                        '비밀번호를 입력해 주세요.', _pwcontroller, (value) {
                                  if (value == null || value.isEmpty) {
                                    return '비밀번호를 입력해 주세요.';
                                  }
                                  return null;
                                }, true, 1, currentWidth)
                                    .newtextField(),
                              ),
                            )
                          ]),
                      SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: currentWidth < 600 ? 40 : 50,
                        child: TextButton(
                            onPressed: () async {
                              // SecureStorage에 데이터 저장
                              if (_formKey.currentState!.validate()) {
                                if (_idcontroller.text.isNotEmpty &&
                                    _pwcontroller.text.isNotEmpty) {
                                  await storage.write(
                                    key: "login",
                                    value:
                                        "id ${_idcontroller.text} password ${_pwcontroller.text}",
                                  );
                                  _login();
                                }
                              }
                            },
                            style: TextButton.styleFrom(
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            child: Text(
                              '로그인',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: currentWidth < 600 ? 13 : 16),
                            )),
                      ),
                      SizedBox(
                        height: currentWidth < 600 ? 5 : 20,
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
                              overlayColor: Colors.black,
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            child: Text(
                              '아이디/비밀번호 찾기',
                              style: TextStyle(
                                color: const Color(0xffAAAAAA),
                                fontSize: currentWidth < 600 ? 12.5 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            width: 1.3,
                            height: 15,
                            color: const Color(0xffAAAAAA),
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
                              overlayColor: Colors.black,
                              padding:
                                  const EdgeInsets.fromLTRB(15, 10.5, 15, 10.5),
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                            ),
                            child: Text(
                              '계정생성하기',
                              style: TextStyle(
                                color: const Color(0xffAAAAAA),
                                fontSize: currentWidth < 600 ? 12.5 : 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Image.asset("assets/img/tr_1.png",
                      height: currentWidth < 1000 ? currentHeight * 0.37 : 0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
