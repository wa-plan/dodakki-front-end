import 'package:domino/styles.dart';
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
                    height: 400,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '편하게 물어봐:)',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: currentWidth < 600 ? 15 : 20),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          '궁금한 점이나,\n개선하고 싶은 점이 있으면\n내 이메일은 24시간 열려있어!',
                          style: TextStyle(
                              color: Color(0xff6C6C6C),
                              fontWeight: FontWeight.w500,
                              fontSize: currentWidth < 600 ? 13 : 18),
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                NewCustomIconButton(
                                        () {},
                                        Icons.mail_outline_rounded,
                                        currentWidth,
                                        13)
                                    .newCustomIconButton(),
                                const SizedBox(width: 8),
                                Text(widget.email,
                                    style: TextStyle(
                                        fontSize: currentWidth < 600 ? 12 : 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
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
