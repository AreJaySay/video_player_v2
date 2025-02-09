import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget {
  final VideoPlayerController controller;
  ViewVideo({required this.controller});
  @override
  State<ViewVideo> createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  ChewieController? _chewieController;

  @override
  void initState() {
    // TODO: implement initState
    _chewieController = ChewieController(
      videoPlayerController: widget.controller,
      autoPlay: true,
      looping: true,
      showSubtitles: true, // Automatically display subtitles
      subtitleBuilder: (context, subtitle) => Container(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          subtitle,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _chewieController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Chewie(controller: _chewieController!)
    );
  }
}
