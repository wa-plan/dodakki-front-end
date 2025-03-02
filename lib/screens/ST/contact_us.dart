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
                  style: TextStyle(
                      fontSize: currentWidth < 600 ? 20 : 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          backgroundColor: backgroundColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: fullPadding,
            child: Column(
              children: [
                const SizedBox(height: 15),
                Container(
                    color: const Color(0xff2A2A2A),
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '언제든 물어봐.',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: currentWidth < 600 ? 15 : 20),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '궁금한 점이나,\n개선하고 싶은 부분이 있으면\n내 이메일은 24시간 열려있어!',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: currentWidth < 600 ? 13 : 18),
                        ),
                        //const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 70),
                                const Icon(Icons.email,
                                    color: Color(0xffD4D4D4)),
                                const SizedBox(height: 3),
                                Text(
                                  'dodakki123@gmail.com',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: currentWidth < 600 ? 14 : 18),
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            ),
                            const SizedBox(width: 6),
                            Image.asset(
                              'assets/img/Dominho2.png',
                              width: currentWidth < 600 ? 50 : 150,
                              height: currentWidth < 600 ? 70 : 210,
                            )
                          ],
                        )
                      ],
                    )),
              ],
            ),
          ),
        ));
  }
}
