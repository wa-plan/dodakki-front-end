import 'package:domino/style/style_dominoPlan.dart';
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

  final titles = ['갓생살기 ⭐', '워너비 대학 가기', '마음의 여유 찾기', '취뽀하기'];

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
              //❤️뒤로가기 버튼
              CustomBackButton(
                () {
                  Navigator.pop(context);
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.tips_and_updates_rounded,
                color: mainRed,
                size: 19,
              ),
              SizedBox(width: 7),
              DPTitleText('만다라트 예시', currentWidth).dPTitleText(),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: SingleChildScrollView(
          child:
              Center(
                child: Column(
                  children: [
                            const SizedBox(height: 20), 
                            ...List.generate(imagePaths.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0xff2C2C2C),
                        ),
                        width: currentWidth < 600 ? double.infinity : 500,
                        padding: EdgeInsets.all(13),
                        child: Center(
                          child: Text(
                            titles[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ImagePreviewPage(
                                    imagePath: imagePaths[index],
                                    title: titles[index],),
                            ),
                          );
                        },
                        child: Image.asset(
                          imagePaths[index],
                          width: 330,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                );
                            }),
                          ]),
              ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: NewButton(mainRed, backgroundColor, '돌아가기', () {
          Navigator.pop(context);
        }).newButton(),
      ),
    );
  }
}

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;
  final String title;

  const ImagePreviewPage({super.key, required this.imagePath, required this.title});

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
              //❤️뒤로가기 버튼
              CustomBackButton(
                () {
                  Navigator.pop(context);
                },
              ).customBackButton(),
              SizedBox(width: 15),
              Icon(
                Icons.tips_and_updates_rounded,
                color: mainRed,
                size: 19,
              ),
              SizedBox(width: 7),
              DPTitleText('만다라트 예시', currentWidth).dPTitleText(),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Padding(
        padding: fullPadding,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20), 
              Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Color(0xff2C2C2C),
                        ),
                        width: currentWidth < 600 ? double.infinity : 500,
                        padding: EdgeInsets.all(13),
                        child: Center(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
              InteractiveViewer(
                panEnabled: true,
                minScale: 1.0,
                maxScale: 4.0,
                child: Image.asset(
                  imagePath,
                  width: currentWidth < 600 ? 330 : 450,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 70),
              Text('확대해서 자세히 볼 수 있어요!',
              style: TextStyle(
                color: settingGrey, fontSize: 13, fontWeight: FontWeight.w600
              ),),
              SizedBox(height: 10),
              Icon(Icons.pinch_rounded, color: settingGrey, size: 20,)
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: fullPadding,
        child: NewButton(mainRed, backgroundColor, '돌아가기', () {
          Navigator.pop(context);
        }).newButton(),
      ),
    );
  }
}
