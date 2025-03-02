import 'package:domino/styles.dart';
import 'package:flutter/material.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
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
                  '문의하기',
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
            children: [
              const SizedBox(height: 15),
              Container(
                  color: const Color(0xff2A2A2A),
                  height: 350,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '언제든 물어봐.',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 17),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        '궁금한 점이나,\n개선하고 싶은 부분이 있으면\n내 이메일은 24시간 열려있어!',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 90),
                              Icon(Icons.email, color: Color(0xffD4D4D4)),
                              SizedBox(height: 3),
                              Text(
                                'dodakki123@gmail.com',
                                style: TextStyle(
                                    fontWeight: FontWeight.w400, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Image.asset('assets/img/Dominho2.png')
                        ],
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
