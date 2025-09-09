import 'package:flutter/material.dart';
import 'package:netflix_clone/login/ui/login_screen.dart';
import 'package:video_player/video_player.dart';

class SplashVideoScreen extends StatefulWidget {
  const SplashVideoScreen({super.key});

  @override
  State<SplashVideoScreen> createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/videos/netflix_splash.mp4')
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
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
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(color: Colors.red),
      ),
    );
  }
}
