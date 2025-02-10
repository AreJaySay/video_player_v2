import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class ViewVideo extends StatefulWidget {
  final String videoPath;
  ViewVideo({required this.videoPath});
  @override
  State<ViewVideo> createState() => _ViewVideoState();
}

class _ViewVideoState extends State<ViewVideo> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {});
        _chewieController = ChewieController(
          videoPlayerController: _videoController!,
          autoPlay: true,
          looping: true,
        );
      });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Player"),
      ),
      body: Center(
        child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
            ? Chewie(controller: _chewieController!)
            : CircularProgressIndicator(),
      ),
    );
  }
}