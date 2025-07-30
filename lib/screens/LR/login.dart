import 'package:domino/screens/LR/loginregister_find_password.dart';
import 'package:domino/screens/LR/agreement.dart';
import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/screens/Tutorial/tutorial1_page.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_setting.dart';
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
    final token = await storage.read(key: "token");

    if (token != null && token.isNotEmpty) {
      print('✅ 토큰 있음. 자동 로그인 진행.');

      // TODO: 서버에서 토큰 유효성 검사 API가 있다면 여기서 호출 (추천)

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TdMain()),
        );
      }
    } else {
      print('⛔️ 저장된 토큰 없음. 로그인 필요.');
    }
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
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Tutorial1()),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인이 실패하였습니다. 아이디와 비밀번호를 확인해주세요.'),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ),
        );
      }
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          //도민호 이미지
          Positioned(
            top: 100,
            right: 0,
            child: Image.asset(
              "assets/img/tr_1.png",
              height: 350,
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
                  const SizedBox(height: 95),

                  //❤️인사말
                  LoginDescription('도닦기에 오신 것을\n환영합니다 :)').loginDescription(),
                  const SizedBox(height: 30),

                  //❤️아이디 입력창
                  STSubTitle('아이디', Icons.person, 20).sTSubTitle(context),
                  const SizedBox(height: 12),
                  CustomTextField(
                    '아이디를 입력해 주세요.',
                    _idcontroller,
                    (value) {
                      if (value == null || value.isEmpty) {
                        return '  아이디를 입력해 주세요.';
                      }
                      return null;
                    },
                    false,
                  ).customTextField(),
                  const SizedBox(height: 20),

                  //❤️비밀번호 입력창
                  STSubTitle('비밀번호', Icons.key_rounded, 20).sTSubTitle(context),
                  const SizedBox(height: 12),
                  PasswordTextField(
                    hintText: '비밀번호를 입력해 주세요.',
                    controller: _pwcontroller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력해 주세요.';
                      }
                      return null;
                    },
                    icon: Icons.lock,
                  ),

                  const SizedBox(height: 50),

                  //로그인 버튼
                  LoginButton('로그인', () async {
                    if (_formKey.currentState!.validate()) {
                      if (_idcontroller.text.isNotEmpty &&
                          _pwcontroller.text.isNotEmpty) {
                        _login();
                      }
                    }
                  }).loginButton(),
                  const SizedBox(height: 14),

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
