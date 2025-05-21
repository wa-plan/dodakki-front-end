import 'package:domino/screens/LR/register.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
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
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              //나가기 버튼
              CustomBackButton(
                () {
                  Navigator.of(context).pop();
                },
              ).customBackButton(),
              SizedBox(width: 15),

              //페이지 타이틀
              PageTitle('계정 만들기').pageTitle(),
              const Spacer(),

              //프로그레스 바 (from style_tutorial.dart)
              ProgressBar(1, 2).progressBar()
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: SingleChildScrollView(
        padding: fullPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            //설명문
            Description('도닦기를 시작하려면\n권한이 필요해요.').description(),
            const SizedBox(height: 30),

            Row(
              children: [
                //체크박스 1
                CustomCheckBox(
                  scale: 1.2,
                  myValue: agreeAll,
                  onItemSelected: (val) {
                    setState(() {
                      agreeAll = val;
                      agreeFirst = val;
                      agreeSecond = val;
                    });
                  },
                ),

                //항목 1
                Text(
                  '모두 동의하기',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 17),
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //체크박스 2
                CustomCheckBox(
                  scale: 1,
                  myValue: agreeFirst,
                  onItemSelected: (val) {
                    setState(() {
                      agreeFirst = val;
                    });
                  },
                ),

                //항목 2
                Text(
                  '만 14세 이상입니다.',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                Spacer(),

                //필수 태그 (from styles.dart)
                const Tag(Color(0xff503333), '필수').tag()
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //체크박스 3
                CustomCheckBox(
                  scale: 1,
                  myValue: agreeSecond,
                  onItemSelected: (val) {
                    setState(() {
                      agreeSecond = val;
                    });
                  },
                ),

                //항목 3
                Text(
                  '개인정보 수집 및 이용에 동의합니다.',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16),
                ),
                Spacer(),

                //필수 태그 (from styles.dart)
                const Tag(Color(0xff503333), '필수').tag()
              ],
            ),
            const SizedBox(height: 30),
            DropDownDescription(
                    Color(0xff2A2A2A),
                    Color(0xffD3D3D3),
                    Color(0xffC9C9C9),
                    '개인정보 처리방침',
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
              
시행일자: 2025년 4월 20일''')
                .dropDownDescription()
          ],
        ),
      ),
      bottomNavigationBar: Padding(
          padding: fullPadding,
          child:
              //다음 버튼
              LoginButton('다음', () {
            if (agreeAll == true || agreeFirst && agreeSecond == true) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            } else {
              //미선택 메시지 (from style_tutorial.dart)
              TutorialMessage("약관 동의를 하지 않으면 가입할 수 없어ㅜㅜ")
                  .tutorialMessage(context);
            }
          }).loginButton()),
    );
  }
}
