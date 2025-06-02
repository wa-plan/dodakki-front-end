import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
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
              PageTitle('문의하기').pageTitle(),
              const Spacer(),

              
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
                  borderRadius: BorderRadius.circular(6),
                  color: const Color(0xff2A2A2A),
                ),
                padding: const EdgeInsets.fromLTRB(30, 30, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '편하게 물어봐:)',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 17),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '궁금한 점이나\n개선하고 싶은 점이 있다면\n내 이메일은 24시간 열려있어!',
                          style: TextStyle(
                              color: Color.fromARGB(255, 169, 169, 169),
                              fontWeight: FontWeight.w500,
                              height: 1.7,
                              fontSize: 15),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 30),
                          child: Row(
                            children: [
                              NewCustomIconButton(
                                      () {},
                                      Icons.mail_outline_rounded,
                                      currentWidth,
                                      16)
                                  .newCustomIconButton(),
                                  SizedBox(width: 10),
                              Text('dodakki123@gmail.com',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Spacer(),
                        Image.asset(
                          height: 220,
                          "assets/img/tr_1.png",
                        ),
                      ],
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
