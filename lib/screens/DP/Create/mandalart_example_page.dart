import 'package:domino/style/style_login.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';

class ManadaEx extends StatefulWidget {
  const ManadaEx({super.key});

  @override
  State<ManadaEx> createState() => _ManadaEx();
}

class _ManadaEx extends State<ManadaEx> {
  final imagePaths = [
    'assets/img/Ex1.png',
    'assets/img/Ex2.png',
    'assets/img/Ex3.png',
    'assets/img/Ex4.png',
  ];

  final titles = [
    '갓생살기',
    '워너비 대학 가기',
    '마음의 여유 찾기',
    '취뽀하기'
  ];

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
              // 나가기 버튼
              CustomBackButton(
                () {
                  Navigator.of(context).pop();
                },
              ).customBackButton(),
              const SizedBox(width: 15),

              // 페이지 타이틀
              PageTitle('만다라트 예시').pageTitle(),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(imagePaths.length, (index) {
              return Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0xff2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                margin: const EdgeInsets.only(bottom: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      titles[index],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ImagePreviewPage(imagePath: imagePaths[index]),
                          ),
                        );
                      },
                      child: Image.asset(
                        imagePaths[index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;

  const ImagePreviewPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0.0,
        title: Padding(
          padding: appBarPadding,
          child: Row(
            children: [
              // 나가기 버튼
              CustomBackButton(
                () {
                  Navigator.of(context).pop();
                },
              ).customBackButton(),

             
            ],
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: fullPadding,
        child: Column(
          children: [
            SizedBox(height: 50),
            InteractiveViewer(
                  panEnabled: true,
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Image.asset(imagePath),
                ),
          ],
        ),
       
      ),
    );
  }
}
