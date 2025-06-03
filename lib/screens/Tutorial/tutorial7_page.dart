import 'package:domino/screens/TD/td_main_page.dart';
import 'package:domino/style/style_tutorial.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class Tutorial7 extends StatefulWidget {
  const Tutorial7({super.key});

  @override
  State<Tutorial7> createState() => Tutorial7State();
}

class Tutorial7State extends State<Tutorial7> {
  late VideoPlayerController _videoController;
  bool _showVideo = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset("assets/img/domino_final.mp4");

    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration &&
          _videoController.value.isInitialized &&
          mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TdMain()),
        );
      }
    });

    _videoController.initialize().then((_) {
      if (_showVideo) {
        setState(() {});
        _videoController.play();
      }
    });
  }

  @override
  void dispose() {
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 22, 30, 30),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Stack(
                  children: [
                    Image.asset(
                      "assets/img/confetti.png",
                      height: currentWidth < 600 ? 270 : 380,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: currentWidth < 600 ? 60 : 110,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: '달성 완료',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.7,
                                    color: Color(0xFFFF6767),
                                  ),
                                ),
                                TextSpan(
                                  text: '하면\n그동안 모든 도미노로\n너의 목표를\n쓰러뜨릴 수 있어!',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    height: 1.7,
                                    color: Color(0xFFD9D9D9),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: _showVideo
                    ? _videoController.value.isInitialized
                        ? AspectRatio(
                            aspectRatio: _videoController.value.aspectRatio,
                            child: VideoPlayer(_videoController),
                          )
                        : const CircularProgressIndicator()
                    : Image.asset(
                        "assets/img/Complete.png",
                        height: currentWidth < 600 ? 180 : 300,
                      ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: tutorialPadding,
        child: TutorialButton('공 굴려서 시작하기', () {
          setState(() {
            _showVideo = true;
            _videoController.play();
          });
        }).tutorialButton(),
      ),
    );
  }
}
