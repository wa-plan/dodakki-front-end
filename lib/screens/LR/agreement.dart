import 'package:domino/screens/LR/register.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
            Divider(color: Color(0xff4E4E4E), height: 30),
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
                const Tag(Colors.transparent, Color(0xffFF7E7E), '필수').tag()
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
                      onTap: () {
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
                const Tag(Colors.transparent, Color(0xffFF7E7E), '필수').tag()
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
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NewButton(Colors.black, Colors.white, '취소', () {
              Navigator.pop(context);
            }, currentWidth)
                .newButton(),
            NewButton(Colors.black, Colors.white, '다음', () {
              if (agreeAll == true || agreeFirst && agreeSecond == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterScreen()),
                );
              } else {
                Message(
                        "약관 동의를 하지 않으면 넘어갈 수 없어ㅠㅠ",
                        const Color(0xffFF6767), // 텍스트 색상
                        const Color(0xff412C2C), // 배경 색상
                        borderColor: const Color(0xffFF6767), // 테두리 색상
                        icon: Icons.block)
                    .message(context);
              }
            }, currentWidth)
                .newButton()
          ],
        ),
      ),
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '개인정보 처리방침',
                            style: TextStyle(
                                color: backgroundColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  'https://sites.google.com/view/dodakki-policy/privacy-policy'))) {
                                throw 'Could not launch';
                              }
                            },
                            child: Icon(
                              Icons.link_rounded,
                              color: backgroundColor,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '''이 개인정보처리방침은 “도를 닦는 사람들”(이하 “서비스 제공자”)이 제공하는 모바일 애플리케이션 도닦기(dodakki) (이하 “앱”)에 적용됩니다. 본 앱은 오픈소스로 제공되며, “있는 그대로(AS IS)”의 형태로 사용됩니다.


1. 수집하는 정보 및 이용 목적
사용자 제공 정보: 이메일 주소, 전화번호 (회원가입 및 인증 목적)
자동 수집 정보: 앱 사용 시점, 사용 시간, 기기 운영체제 정보 등
앱은 정확한 위치정보를 수집하지 않습니다.


2. 알림 기능
앱은 flutter_local_notifications 및 timezone 패키지를 통해 로컬 알림(Local Notification) 기능을 제공합니다. 외부 서버나 제3자 서비스와 연결되지 않으며, 개인정보를 수집하지 않습니다.


3. 제3자 서비스
앱은 다음 외부 서비스를 사용할 수 있습니다:
- OpenAI API


4. 정보 제공 및 공개
서비스 제공자는 아래의 경우 사용자 정보를 공개할 수 있습니다:
- 법령에 따른 요구 또는 수사 협조
- 사기 방지, 안전 보호 등 공익적 목적
- 서비스 운영을 지원하는 위탁사 (보안 준수 조건)


5. 수집 거부 권리
앱 삭제를 통해 모든 정보 수집을 중단할 수 있습니다.


6. 데이터 보관 및 삭제
서비스 제공자는 수집된 개인정보를 필요한 기간 동안 보관하며, 사용자가 요청 시 즉시 삭제합니다. 삭제 요청은 이메일(dodakki123@gmail.com)로 접수 가능합니다.


7. 아동의 개인정보
앱은 만 13세 미만 아동의 개인정보를 의도적으로 수집하지 않습니다. 수집 사실이 확인되면 즉시 삭제 조치하며, 보호자는 이메일로 연락 부탁드립니다.


8. 보안
서비스 제공자는 사용자 정보 보호를 위해 물리적·전자적 보안 조치를 적용합니다.


9. 방침 변경
본 방침은 수시로 변경될 수 있으며, 변경 시 본 페이지에 고지됩니다.


10. 앱 권한
앱은 아래 기능 제공을 위해 다음 권한을 요청할 수 있습니다:
- 알림 권한: 사용자에게 목표 알림 등 로컬 알림을 제공하기 위해 사용됩니다.
- 사진 및 갤러리 접근 권한: 사용자가 프로필 사진을 설정할 수 있도록 하기 위해 사용됩니다. 사용자가 목표를 설정할 때 목표 이미지를 업로드할 수 있도록 하기 위해 사용됩니다.


해당 권한들은 명시적인 사용자 동의 하에 요청되며, 고지된 목적 외에는 사용되지 않으며, 제3자에게 제공되지 않습니다.
              
시행일자: 2025년 4월 20일''',
                        style: TextStyle(
                            color: backgroundColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NewButton(Colors.black, Colors.white, '닫기', () {
                        Navigator.pop(context);
                      }, currentWidth)
                          .newButton(),
                    ],
                  )
                ],
              ),
            ),
          ));
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '서비스 이용약관',
                            style: TextStyle(
                                color: backgroundColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  'https://sites.google.com/view/dodakki-policy/privacy-policy'))) {
                                throw 'Could not launch';
                              }
                            },
                            child: Icon(
                              Icons.link_rounded,
                              color: backgroundColor,
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 5),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 5),
                      Text(
                        '''1. 동의
사용자가 도닦기 앱을 다운로드하거나 사용하는 경우, 아래 조건에 동의한 것으로 간주됩니다. 본 약관을 숙지 후 사용해 주시기 바랍니다.


2. 지식재산권
앱 및 그 구성 요소에 대한 저작권, 상표권, 데이터베이스 권리 등은 “도를 닦는 사람들”에게 있으며, 무단 복제, 수정, 배포를 금합니다.


3. 서비스 제공
앱은 최선의 서비스 제공을 위해 수시로 업데이트되며, 서비스 제공자는 예고 없이 앱의 일부 기능을 수정하거나 중단할 수 있습니다.


4. 인터넷 연결
일부 기능은 인터넷 연결을 필요로 하며, 연결 불가 시 앱이 정상 작동하지 않을 수 있습니다. 데이터 요금은 사용자 책임입니다.


5. 기기 사용 책임
기기 충전 상태, 성능 저하 등으로 인해 앱 사용에 제한이 생길 경우, 이는 사용자 책임입니다.


6. 업데이트 및 종료
앱은 운영체제 업데이트나 정책 변경에 따라 업데이트가 필요할 수 있으며, 서비스 제공자는 앱의 배포를 중단할 권리를 가집니다.


7. 향후 광고
현재 앱은 광고를 포함하지 않으나, 추후 광고 기능이 추가될 수 있으며 그에 따라 약관 및 방침이 변경될 수 있습니다.''',
                        style: TextStyle(
                            color: backgroundColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      NewButton(Colors.black, Colors.white, '닫기', () {
                        Navigator.pop(context);
                      }, currentWidth)
                          .newButton(),
                    ],
                  )
                ],
              ),
            ),
          ));
    },
  );
}
