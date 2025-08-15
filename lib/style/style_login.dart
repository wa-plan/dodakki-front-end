import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

//로그인 패딩
const loginPadding = EdgeInsets.fromLTRB(28, 40, 28, 0);

//CTA 버튼
class LoginButton {
  final String text;
  final Function function;

  LoginButton(this.text, this.function);

  Widget loginButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextButton(
        onPressed: () => function(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          backgroundColor: mainRed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: backgroundColor,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

//아이디 입력창
class CustomTextField {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String?> validator;
  final bool obscureText;

  const CustomTextField(this.hintText, this.controller, this.validator,
      this.obscureText);

  Widget customTextField({
    bool obscureText = false,
    void Function()? onClear,
  }) {
    return TextFormField(
      cursorColor: mainRed,
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        focusedErrorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        errorStyle: TextStyle(
            color: mainRed, fontSize: 12, fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: settingGrey, width: 2)),
        filled: true,
        fillColor: const Color(0xff2A2A2A).withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(22, 17, 22, 17),
        hintStyle: TextStyle(
            color: settingGrey,
            fontSize: 15,
            fontWeight: FontWeight.w600),
        suffixIcon: controller.text.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  GestureDetector(
                    onTap: onClear ??
                        () {
                          controller.clear();
                        },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 15, 10),
                      child: const Icon(
                        Icons.cancel,
                        size: 17,
                        color: settingGrey,
                      ),
                    ),
                  ),
                ],
              )
            : null,
      ),
      validator: validator,
    );
  }
}

//비밀번호 입력창
class PasswordTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String?> validator;
  final IconData icon;

  const PasswordTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.icon,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = true;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      cursorColor: mainRed,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: mainRed),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: mainRed),
        ),
        errorStyle: const TextStyle(
          color: mainRed,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffAAAAAA), width: 2),
        ),
        filled: true,
        fillColor: const Color(0xff2A2A2A),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
            color: settingGrey,
            fontSize: 15,
            fontWeight: FontWeight.w600),
        contentPadding: const EdgeInsets.fromLTRB(22, 17, 22, 17),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              padding: EdgeInsets.fromLTRB(0, 2, 4, 0),
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                size: 20,
                color: const Color(0xffAAAAAA),
              ),
              onPressed: _toggleVisibility,
            ),
            if (widget.controller.text.isNotEmpty)
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  setState(() {});
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0, 15, 10, 10),
                  child: const Icon(
                    Icons.cancel,
                        size: 17,
                        color: settingGrey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

//비밀번호 찾기, 계정 만들기 버튼
class LoginEtcButton {
  final String text;
  final Function function;

  LoginEtcButton(this.text, this.function);

  Widget loginEtcButton() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextButton(
        onPressed: () => function(),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          backgroundColor: Color(0xff2C2C2C),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xffCECECE),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

//나가기 버튼
class CustomBackButton {
  final Function function;

  const CustomBackButton(this.function);

  Widget customBackButton() {
    return GestureDetector(
        onTap: () {
          function();
        },
        child: Icon(
          Icons.arrow_circle_left_rounded,
          color: settingGrey,
          size: 26,
        ),
      );
  }
}

//페이지 타이틀
class PageTitle {
  final String text;

  PageTitle(this.text);

  Widget pageTitle() {
    return Text(text,
        style: TextStyle(
            color: Color(0xffA1A1A1),
            fontSize: 17,
            fontWeight: FontWeight.w600));
  }
}

//설명문 및 인사말
class LoginDescription {
  final String text;

  LoginDescription(this.text);

  Widget loginDescription() {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.6,
      ),
    );
  }
}

//체크 박스
class CustomCheckBox extends StatelessWidget {
  final double scale;
  final bool myValue;
  final void Function(bool index)? onItemSelected;

  const CustomCheckBox({
    super.key,
    required this.scale,
    required this.myValue,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Checkbox(
        value: myValue,
        visualDensity: VisualDensity.compact,
        fillColor: WidgetStateProperty.resolveWith<Color>(
          (Set<WidgetState> states) => const Color(0xff323232),
        ),
        activeColor: Colors.transparent,
        side: const BorderSide(color: Colors.transparent),
        checkColor: mainRed,
        onChanged: (value) {
          if (value != null) {
            onItemSelected?.call(value);
          }
        },
      ),
    );
  }
}

//드롭다운 설명
class DropDownDescription {
  final Color backColor;
  final Color titleColor;
  final Color textColor;
  final String title;
  final String text;

  DropDownDescription(
      this.backColor, this.titleColor, this.textColor, this.title, this.text);

  Widget dropDownDescription() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: ExpansionTile(
        backgroundColor: backColor,
        collapsedBackgroundColor: backColor,
        childrenPadding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        tilePadding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        iconColor: titleColor,
        collapsedIconColor: titleColor,
        shape: const Border(),
        title: Text(
          title,
          textAlign: TextAlign.left,
          style: TextStyle(
            color: titleColor,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        children: [
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.7
            ),
          ),
        ],
      ),
    );
  }
}

//텍스트필드 타이틀
class FieldTitle {
  final String title;

  const FieldTitle(this.title);

  Widget fieldTitle() {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

//피드백 컨테이너
class FeedBack {
  final String text;

  FeedBack(this.text);

  Widget feedBack() {
    return SizedBox(
      width: double.infinity,
      height: 45,
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          
        ),
        child: Text(
          text,
          maxLines: 2,
          style: TextStyle(
            color: mainRed,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
