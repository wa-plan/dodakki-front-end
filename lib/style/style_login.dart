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

//텍스트 필드
class LoginTextField {
  final String hintText;
  final TextEditingController controller;
  final FormFieldValidator<String?> validator;
  final bool obscureText;
  final IconData icon;

  const LoginTextField(this.hintText, this.controller, this.validator,
      this.obscureText, this.icon);

  Widget loginTextField({
    bool obscureText = false,
    void Function()? onClear,
  }) {
    return TextFormField(
      cursorColor: mainRed,
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 17, right: 8),
          child: Icon(
            icon,
            size: 19,
            color: Color(0xffAAAAAA),
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 0),
        errorBorder: OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        focusedErrorBorder:
            OutlineInputBorder(borderSide: BorderSide(color: mainRed)),
        errorStyle: TextStyle(
            color: mainRed, fontSize: 12, fontWeight: FontWeight.w400),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xffAAAAAA))),
        filled: true,
        fillColor: const Color(0xff2A2A2A).withOpacity(0.9),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(6),
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.fromLTRB(15, 13, 15, 13),
        hintStyle: TextStyle(
            color: Color(0xffAAAAAA),
            fontSize: 15,
            fontWeight: FontWeight.w400),
        suffixIcon: controller.text.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start, // 아이콘 상단 정렬
                children: [
                  GestureDetector(
                    onTap: onClear ??
                        () {
                          controller.clear();
                        },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                      child: const Icon(
                        Icons.cancel,
                        size: 17,
                        color: Color(0xffAAAAAA),
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
          side: const BorderSide(color: Color(0xff545454), width: 1),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          backgroundColor: Color(0xff313131),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xffCECECE),
            fontSize: 15,
            fontWeight: FontWeight.w500,
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
    return Container(
      width: 45,
      height: 30,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            offset: const Offset(0, 0),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
        color: Color(0xff303030),
        borderRadius: BorderRadius.circular(25),
      ),
      child: GestureDetector(
        onTap: () {
          function();
        },
        child: Icon(
          Icons.arrow_back_ios_rounded,
          color: const Color(0xff646464),
          size: 20,
        ),
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
class Description {
  final String text;

  Description(this.text);

  Widget description() {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
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
        childrenPadding: const EdgeInsets.fromLTRB(25, 0, 25, 20),
        tilePadding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
        iconColor: const Color(0xffAAAAAA),
        collapsedIconColor: const Color(0xffAAAAAA),
        shape: const Border(),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        children: [
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.w400,
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
        onPressed: (){},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          backgroundColor: Color(0xff452D2D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
        child: Text(
          text,
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