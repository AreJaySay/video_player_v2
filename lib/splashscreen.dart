import 'package:fitness_video_player/video_players/video_player.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => VideoPlayerPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.play_arrow_rounded,
              color: Colors.tealAccent,
              size: 120.0,
            ),
            SizedBox(
              height: 130,
            ),
            CircularProgressIndicator(color: Colors.teal,)
          ],
        ),
      ),
    );
  }
}