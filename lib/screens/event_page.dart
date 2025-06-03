import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:domino/style/styles.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EventPage extends StatefulWidget {
  final int domino;
  final String goalName;

  const EventPage({super.key, required this.domino, required this.goalName});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isContentVisible = true;
  bool _isVideoEnded = false;
  bool _isCountdownStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/img/domino_final.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(false);
    _controller.setVolume(1.0);

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        if (!_isVideoEnded) {
          setState(() {
            _isVideoEnded = true;
            _isCountdownStarted = true; // 카운트다운 시작
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MyGoal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: VideoPlayer(_controller),
                ),
                if (_isContentVisible && !_isVideoEnded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 90, 30, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(TextSpan(children: [
                          const TextSpan(
                            text: '드디어 도미노를\n쓰러뜨리는 날이에요.\n그동안 ',
                            style: TextStyle(
                              height: 2,
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(
                            text: widget.domino.toString(),
                            style: const TextStyle(
                              height: 2,
                              color: Color(0xffFF7575),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const TextSpan(
                            text: '개의 도미노를\n모았어요.',
                            style: TextStyle(
                              height: 2,
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ])),
                        const SizedBox(height: 20),
                        const Text(
                          '준비 되셨나요?\n공을 굴려주세요!',
                          style: TextStyle(
                            height: 2,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isContentVisible = !_isContentVisible;
                              if (_controller.value.isPlaying) {
                                _controller.pause();
                              } else {
                                _controller.play();
                              }
                            });
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: mainRed,
                          ),
                          child: const Text(
                            '공 굴리기',
                            style: TextStyle(
                              color: backgroundColor,
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                if (_isVideoEnded)
                  Align(
                    alignment: const Alignment(0, -0.5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.goalName}\n쓰러뜨리기 성공!',
                          style: const TextStyle(
                            height: 1.5,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '축하해요!',
                          style: TextStyle(
                            height: 2,
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),

                        /// ✅ 원형 카운트다운 애니메이션
                        if (_isCountdownStarted)
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 1.0, end: 0.0),
                            duration: const Duration(seconds: 3),
                            onEnd: _goToNextPage,
                            builder: (context, value, child) {
                              int seconds = (value * 3).ceil();
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircularProgressIndicator(
                                      value: value,
                                      strokeWidth: 6,
                                      valueColor: const AlwaysStoppedAnimation<Color>(mainRed),
                                      backgroundColor: Colors.transparent,
                                    ),
                                  ),
                                  Text(
                                    '$seconds',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
