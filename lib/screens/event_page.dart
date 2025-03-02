import 'package:domino/screens/MG/mygoal_main.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class EventPage extends StatefulWidget {
  final int domino;
  const EventPage({super.key, required this.domino});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String goal = "환상적인 세계여행"; //제1목표 title api 가져오기
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isContentVisible = true;
  bool _isVideoEnded = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/img/domino_final.mp4");
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(false);
    _controller.setVolume(1.0);

    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        setState(() {
          _isVideoEnded = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                    padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
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
                        const SizedBox(
                          height: 20,
                        ),
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
                            backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            '공 굴리기',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900),
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
                          '$goal\n쓰러뜨리기 성공!\n\n축하해요!',
                          style: const TextStyle(
                            height: 2,
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        // 화면이 렌더링된 후 2초 딜레이
                        FutureBuilder(
                          future: Future.delayed(const Duration(seconds: 2)),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // MyGoal 페이지로 이동
                              Future.microtask(() {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const MyGoal(),
                                  ),
                                );
                              });
                            }
                            return const SizedBox(); // 빈 위젯 반환
                          },
                        ),
                      ],
                    ),
                  )

                /*if (_isVideoEnded)
                  Align(
                    alignment: const Alignment(0, -0.5),
                    child: Text(
                      '$goal\n쓰러뜨리기 성공!\n\n축하해요!',
                      style: const TextStyle(
                        height: 2,
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),*/
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
