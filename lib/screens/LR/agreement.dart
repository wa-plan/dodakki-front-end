import 'package:domino/screens/LR/register.dart';
import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class Agreement extends StatefulWidget {
  const Agreement({super.key});

  @override
  State<Agreement> createState() => _AgreementState();
}

class _AgreementState extends State<Agreement> {
  bool agreeAll = false;
  bool agreeFirst = false;
  bool agreeSecond = false;

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
                      fontSize: currentWidth < 600 ? 17 : 27,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffD9D9D9), // 첫 번째 색상
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
                      color: const Color(0xff515151), // 첫 번째 색상
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Text(
              '계정생성을 위해서는\n이용약관에 동의해주셔야 해요. :)',
              style: TextStyle(
                  color: Color(0xffAAAAAA),
                  fontWeight: FontWeight.w600,
                  fontSize: currentWidth < 600 ? 15 : 20),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    visualDensity: VisualDensity.compact,
                    fillColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Color(0xff323232);
                      }
                      return Color(0xff323232);
                    }),
                    activeColor: Colors.transparent,
                    side: BorderSide(color: Colors.transparent),
                    checkColor: const Color(0xffFF6767),
                    value: agreeAll,
                    onChanged: (value) {
                      setState(() {
                        agreeAll = value!;
                        agreeFirst = value;
                        agreeSecond = value;
                      });
                    },
                  ),
                ),
                Text(
                  '모두 동의하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: currentWidth < 600 ? 16 : 16),
                ),
              ],
            ),
            Divider(
              color: Color(0xff4E4E4E),
              height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 1,
                      child: Checkbox(
                        visualDensity: VisualDensity.compact,
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) {
                            return Color(0xff323232);
                          }
                          return Color(0xff323232);
                        }),
                        activeColor: Colors.transparent,
                        side: BorderSide(color: Colors.transparent),
                        checkColor: const Color(0xffFF6767),
                        value: agreeFirst,
                        onChanged: (value) {
                          setState(() {
                            agreeFirst = value!;
                          });
                        },
                      ),
                    ),
                    Text(
                      '만 14세 이상입니다.',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: currentWidth < 600 ? 14 : 16),
                    ),
                  ],
                ),
                const Tag(Colors.transparent, Color(0xffFF7E7E), '필수')
                          .tag()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Transform.scale(
                      scale: 1,
                      child: Checkbox(
                        visualDensity: VisualDensity.compact,
                        fillColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          if (states.contains(WidgetState.disabled)) {
                            return Color(0xff323232);
                          }
                          return Color(0xff323232);
                        }),
                        activeColor: Colors.transparent,
                        side: BorderSide(color: Colors.transparent),
                        checkColor: const Color(0xffFF6767),
                        value: agreeSecond,
                        onChanged: (value) {
                          setState(() {
                            agreeSecond = value!;
                          });
                        },
                      ),
                    ),
                    Text(
                      '개인정보 수집 및 이용에 동의합니다.',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: currentWidth < 600 ? 14 : 16),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: (){
                        showAgreementPopup(context, currentWidth);
                        },
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Color(0xff5C5C5C),
                        size: 19,
                      ),
                    )
                  ],
                ),
                const Tag(Colors.transparent, Color(0xffFF7E7E), '필수')
                          .tag()
                
              ],
            ),
            const SizedBox(height: 45),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xff323232),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '목적 : 개인식별 서비스 이용을 위한 연락처\n항목 : 이메일, 비밀번호, 닉네임\n보유 기간 : 회원탈퇴 후 30일동안 보관\n\n*개인정보 수집 및 이용에 대한 동의를 거부할 권리가 있으며\n동의 거부 시 회원가입이 제한됩니다.',
                    style: TextStyle(
                        color: Color(0xffAAAAAA),
                        fontWeight: FontWeight.w500,
                        height: 1.7,
                        fontSize: currentWidth < 600 ? 12 : 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(padding: fullPadding,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NewButton(Colors.black, Colors.white, '취소', () {
              Navigator.pop(context);
            }, currentWidth)
                .newButton(),
            NewButton(Colors.black, Colors.white, '다음', () {
             if(agreeAll == true || agreeFirst && agreeSecond == true){
                Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RegisterScreen()),
                              );
             }else{
              Message("약관 동의를 하지 않으면 넘어갈 수 없어ㅠㅠ", const Color(0xffFF6767), // 텍스트 색상
            const Color(0xff412C2C), // 배경 색상
            borderColor: const Color(0xffFF6767), // 테두리 색상
            icon: Icons.block)
        .message(context);
             }
            }, currentWidth)
                .newButton()
          ],
        ),),
    );
  }
}

void showAgreementPopup(BuildContext context, double currentWidth) {

  showDialog(
    context: context,
    builder: (context) {

        return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.fromLTRB(23, 25, 23, 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            content: SizedBox(
              width: 300,
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '개인정보 처리방침',
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '개인정보 처리방침 내용이 여기에 들어가게 됩니당.',
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NewButton(Colors.black, Colors.white, '닫기', (){Navigator.pop(context);}, currentWidth).newButton(),
                    ],
                  )
                ],
              ),
            )
            
           
           
          );
   
      },
    );
  }

  void showServiceRulePopup(BuildContext context, double currentWidth) {

  showDialog(
    context: context,
    builder: (context) {

        return AlertDialog(
            backgroundColor: Colors.white,
            contentPadding: const EdgeInsets.fromLTRB(23, 25, 23, 25),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            content: SizedBox(
              width: 300,
              height: 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '서비스 이용약관',
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '서비스 이용약관 내용이 여기에 들어가게 됩니당.',
                        style: TextStyle(
                          color: backgroundColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w700
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NewButton(Colors.black, Colors.white, '닫기', (){Navigator.pop(context);}, currentWidth).newButton(),
                    ],
                  )
                ],
              ),
            )
            
           
           
          );
   
      },
    );
  }