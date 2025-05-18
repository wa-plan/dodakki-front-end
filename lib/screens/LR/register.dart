import 'package:domino/style/styles.dart';
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

  final GlobalKey _iconKey = GlobalKey(); // 아이콘 위치를 추적하기 위한 키
  Offset _iconPosition = Offset.zero; // 아이콘의 위치

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
              const Spacer(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff515151), // 첫 번째 색상
                      borderRadius:
                          BorderRadius.circular(currentWidth < 600 ? 2 : 3),
                    ),
                    width: currentWidth < 600 ? 8 : 12,
                    height: currentWidth < 600 ? 8 : 12,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffD9D9D9), // 첫 번째 색상
                      borderRadius:
                          BorderRadius.circular(currentWidth < 600 ? 2 : 3),
                    ),
                    width: currentWidth < 600 ? 8 : 12,
                    height: currentWidth < 600 ? 8 : 12,
                  ),
                ],
              ),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "개인정보 입력",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: currentWidth < 600 ? 13 : 20,
                                fontWeight: FontWeight.w600,
                                height: 1.4),
                          ),
                          GestureDetector(
                            onTap: () {
                              _updateIconPosition();
                              _showPopupMessage(context,
                                  '이메일 주소와 전화번호는 필요 시,\n아이디/비밀번호를 찾기 위해 사용되니\n안심해도 돼 :)');
                            },
                            child: Icon(
                              Icons.info_outline_rounded,
                              key: _iconKey,
                              color: Colors.grey,
                              size: 19,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: currentWidth < 600 ? 15 : 30),
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
                      SizedBox(height: currentWidth < 600 ? 15 : 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Expanded(
                            child: NewCustomTextField(
                                    '아이디를 입력해 주세요.', _idController, (value) {
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
                      SizedBox(height: currentWidth < 600 ? 15 : 30),
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

  void _updateIconPosition() {
    // 아이콘의 현재 위치를 계산
    final RenderBox renderBox =
        _iconKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    setState(() {
      _iconPosition = position; // 아이콘의 위치 업데이트
    });
  }

// 팝업 메시지를 띄우는 함수
  void _showPopupMessage(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: () {
          overlayEntry?.remove(); // 팝업 닫기
          overlayEntry = null;
        },
        child: Stack(
          children: [
            // 투명한 배경으로 메시지 외부 클릭 감지
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // 팝업 메시지 위치 설정
            Positioned(
              top: _iconPosition.dy + 25,
              left: _iconPosition.dx - 200,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(207, 255, 255, 255),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: backgroundColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // 오버레이에 추가
    overlay.insert(overlayEntry!);
  }
}
