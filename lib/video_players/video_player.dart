import 'dart:io';
import 'package:fitness_video_player/video_players/view_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  final String selectedMood;
  VideoPlayerPage({required this.selectedMood});

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  Map<String, List<Map<String, String>>> moodVideos = {
    "Relaxed": [{"title": "Creamy Garlic Butter Shrimp", "description": "Enjoy a peaceful moment.", "video": "relaxed"}],
    "Sad": [{"title": "Chicken Noodle Soup ", "description": "Let it all out.", "video": "sad"}],
    "Tired": [{"title": "Ramen", "description": "Boost your energy levels.", "video": "tired"}],
    "Romantic": [{"title": "Chocolate Fondue", "description": "Feel the romance.", "video": "romantic"}],
    "Adventure": [{"title": "Buffalo Wings", "description": "Get ready for excitement.", "video": "adventure"}]
  };

  List<Map<String, String>> get videos => moodVideos[widget.selectedMood] ?? [];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("${widget.selectedMood} Videos"),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Center(
          child: GridView.count(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            crossAxisCount: videos.length == 1 ? 1 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: (itemWidth / itemHeight),
            children: videos.map((videoData) => CurrentVideo(videoData: videoData)).toList(),
          ),
        ),
      ),
    );
  }
}

class CurrentVideo extends StatelessWidget {
  final Map<String, String> videoData;
  CurrentVideo({required this.videoData});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewVideo(videoPath: "assets/videos/${videoData['video']}.mp4"),
              ),
            );
          },
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(Icons.play_circle_outline_rounded, color: Colors.teal, size: 50),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          videoData['title']!,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        Text(
          videoData['description']!,
          style: TextStyle(fontSize: 14, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}