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
  late Future<void> _initFuture;
  bool _showVideo = false;
  bool _isVideoEnded = false;

  @override
  void initState() {
    super.initState();
    _videoController =
        VideoPlayerController.asset("assets/img/domino_final.mp4");
    _initFuture = _videoController.initialize();
    _videoController.setLooping(false);
    _videoController.setVolume(1.0);

    _videoController.addListener(() {
      if (_videoController.value.position >= _videoController.value.duration &&
          !_isVideoEnded &&
          mounted) {
        setState(() {
          _isVideoEnded = true;
        });

        // 화면 전환
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TdMain()),
            );
          }
        });
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
      backgroundColor: Colors.black,

      body: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                /// 🎥 중앙 정렬된 영상 (비율 유지)
                Center(
                  child: Transform.scale(
                    scale: 1.0, // 1.0보다 크면 확대
                    child: AspectRatio(
                      aspectRatio: _videoController.value.aspectRatio,
                      child: VideoPlayer(_videoController),
                    ),
                  ),
                ),

                /// 🎊 confetti 이미지 – 화면 상단 중앙
                if (!_showVideo)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding:
                          EdgeInsets.only(top: currentWidth < 600 ? 90 : 100),
                      child: _showVideo
                          ? SizedBox(
                              height: currentWidth < 600 ? 270 : 350) // 공간 유지
                          : Image.asset(
                              "assets/img/confetti.png",
                              height: currentWidth < 600 ? 270 : 350,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                /// 📝 텍스트 – 영상 위쪽에 정렬
                if (!_showVideo)
                  Align(
                    alignment: const Alignment(0, -0.57),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text.rich(
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
                              text: '하면\n그동안 모은 도미노로\n너의 목표를\n쓰러뜨릴 수 있어!',
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
                    ),
                  ),

                /// ✅ 영상 끝난 후 메시지
                if (_isVideoEnded)
                  const Align(
                    alignment: Alignment(0, -0.57),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '그럼 이제\n',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: '목표 달성',
                            style: TextStyle(
                              fontSize: 30,
                              color: mainRed, // 강조 색상
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                          TextSpan(
                            text: '하러\n가보자!!',
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                if (!_showVideo)
                  Positioned(
                    bottom: 30,
                    left: 30,
                    right: 30,
                    child: TutorialButton('공 굴리기', () {
                      setState(() {
                        _showVideo = true;
                        _videoController.play();
                      });
                    }).tutorialButton(),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

      /// 🔘 버튼은 여기
      /*bottomNavigationBar: !_showVideo
          ? Padding(
              padding: tutorialPadding,
              child: TutorialButton('공 굴리기', () {
                setState(() {
                  _showVideo = true;
                  _videoController.play();
                });
              }).tutorialButton(),
            )
          : null,*/
    );
  }
}
