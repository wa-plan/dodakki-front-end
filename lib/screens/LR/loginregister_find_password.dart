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

  Widget _buildTextFormField({
    required String hintText,
    required TextEditingController controller,
    required FormFieldValidator<String?> validator,
    bool obscureText = false,
    void Function()? onClear,
  }) {
    return TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
        contentPadding: const EdgeInsets.all(10.0),
        hintStyle: const TextStyle(
            color: Color(0xffBFBFBF),
            fontSize: 13,
            fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 147, 147, 147), width: 0.5)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(3),
            borderSide: const BorderSide(
                color: Color.fromARGB(255, 147, 147, 147), width: 0.5)),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                onPressed: onClear ??
                    () {
                      controller.clear();
                    },
                icon: const Icon(Icons.clear_outlined),
              )
            : null,
        ),
        validator: validator,
      );
  }

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
  return Scaffold(
    backgroundColor: backgroundColor,
    appBar: AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0.0,
      title: Padding(
        padding: appBarPadding,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: const Color(0xffD4D4D4),
              iconSize: 17,
            ),
            Text(
              '아이디/비밀번호 찾기',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
    ),
    body: Padding(
      padding: fullPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15),
          // 아이디 찾기 영역
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xff2A2A2A),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "아이디 찾기",
                  style: TextStyle(
                    color: Color(0xff949494),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Phone',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 35,
                      width: 240,
                      child: _buildTextFormField(
                        hintText: '전화번호를 입력해 주세요.',
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '전화번호를 입력해 주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 35,
                      width: 240,
                      child: _buildTextFormField(
                        hintText: '이메일을 입력해 주세요.',
                        controller: _idEmailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해 주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _responseId,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    Button(Colors.black, Colors.white, '찾기', _idFind).button(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // 비밀번호 찾기 영역
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xff2A2A2A),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "비밀번호 찾기",
                  style: TextStyle(
                    color: Color(0xff949494),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ID',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 35,
                      width: 240,
                      child: _buildTextFormField(
                        hintText: '아이디를 입력해 주세요.',
                        controller: _userIdController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '아이디를 입력해 주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Email',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                    SizedBox(
                      height: 35,
                      width: 240,
                      child: _buildTextFormField(
                        hintText: '이메일을 입력해 주세요.',
                        controller: _pwEmailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해 주세요.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(Colors.black, Colors.white, '찾기', _pwFind).button(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}