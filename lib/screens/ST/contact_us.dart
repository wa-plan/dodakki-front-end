import 'package:domino/style/style_dominoPlan.dart';
import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:domino/widgets/nav_bar.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  final String email;
  const ContactUs({super.key, required this.email});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      bottomNavigationBar: const NavBar(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              //뒤로가기 버튼
              CustomBackButton(
                () {
                  Navigator.of(context).pop();
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.question_answer_rounded,
                color: mainRed,
              ),
              SizedBox(width: 7),
              DPTitleText('문의하기', currentWidth).dPTitleText(),
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
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xff2C2C2C),
              ),
              padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '편하게 소통해줘 :)',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        '궁금한 점이나\n개선하고 싶은 점이 있다면\n내 이메일은 24시간 열려있어!',
                        style: TextStyle(
                            color: settingGrey,
                            fontWeight: FontWeight.w600,
                            height: 1.7,
                            fontSize: 15),
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Icon(Icons.mail_rounded,
                              color: settingGrey, size: 20),
                          SizedBox(width: 10),
                          Text('dodakki123@gmail.com',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    right: -25,
                    child:
                        Image.asset('assets/img/emptyDominho.png', height: currentWidth < 350 ? 100 : 160),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
