import 'package:domino/screens/LR/loginregister_find_password.dart';
import 'package:domino/screens/LR/agreement.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/screens/Tutorial/tutorial1_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
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
  final _formKey = GlobalKey<FormState>(); 
  final storage = const FlutterSecureStorage();
  String userInfo = "";
  final LoginService _loginService = LoginService();

  //자동 로그인 함수
  Future<void> _asyncMethod() async {
    final String? authToken = await storage.read(key: "token");

    if (authToken == null || authToken.isEmpty) {
      return;
    }

    final String? storedUserInfo = await storage.read(key: "login");

    userInfo = storedUserInfo ?? "";

    if (userInfo.isNotEmpty) {
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

      if (userId != null && password != null) {
        bool isSuccess = await _loginService.login(context, userId, password);

        if (isSuccess) {
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
  
  //로그인 함수
  void _login() async {
    final userId = _idcontroller.text;
    final password = _pwcontroller.text;

    if (userId.isEmpty || password.isEmpty) {
      return;
    }

    bool isSuccess = await _loginService.login(context, userId, password);
    if (isSuccess) {
      final String? accessToken = await storage.read(key: "token");
      if (accessToken == null || accessToken.isEmpty) {
        await storage.write(
            key: "token",
            value: "your_generated_token_here");
      }

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Tutorial1()),
        );
      }
    } else {}
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [

          //도민호 이미지
          Positioned(
            top: 60,
            right: 0,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                "assets/img/tr_1.png",
                height: 350,
              ),
            ),
          ),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              left: loginPadding.left,
              right: loginPadding.right,
              top: loginPadding.top,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),

                  //인사말
                  Description('도닦기에 오신 것을\n환영합니다 :)').description(),
                  const SizedBox(height: 45),

                  //아이디 입력창
                  LoginTextField(
                    '  아이디를 입력해 주세요.',
                    _idcontroller,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return '  아이디를 입력해 주세요.';
                      }
                      return null;
                    },
                    false,
                    Icons.person,
                  ).loginTextField(),
                  const SizedBox(height: 14),

                  //비밀번호 입력창
                  LoginTextField(
                    '  비밀번호를 입력해 주세요.',
                    _pwcontroller,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return '  비밀번호를 입력해 주세요.';
                      }
                      return null;
                    },
                    true,
                    Icons.lock,
                  ).loginTextField(),
                  const SizedBox(height: 14),

                  //로그인 버튼
                  LoginButton('로그인', () async {
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
                  }).loginButton(),
                  const SizedBox(height: 60),

                  //아이디/비밀번호 찾기 버튼
                  LoginEtcButton('아이디/비밀번호 찾기', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginregisterFindPassword(),
                      ),
                    );
                  }).loginEtcButton(),
                  const SizedBox(height: 14),

                  //계정 만들기 버튼
                  LoginEtcButton('계정 만들기', () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Agreement(),
                      ),
                    );
                  }).loginEtcButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
