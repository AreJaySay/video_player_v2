import 'dart:io';

import 'package:fitness_video_player/video_players/view_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  List<String> _vids = ["boxing","heavy_lefting","jogging","lefting","relaxition","training"];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 4;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Video Playlist",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
        centerTitle: true,
      ),
      body: SafeArea(
        child: GridView.count(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: (itemWidth / itemHeight),
          controller: new ScrollController(keepScrollOffset: false),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            for(int x = 0; x < _vids.length; x++)...{
              CurrentVideo(video: _vids[x],)
            }
          ]
        ),
      ),
    );
  }
}

class CurrentVideo extends StatefulWidget {
  final String video;
  CurrentVideo({required this.video});
  @override
  State<CurrentVideo> createState() => _CurrentVideoState();
}

class _CurrentVideoState extends State<CurrentVideo> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/${widget.video}.mp4")
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      child: _controller!.value.isInitialized
          ? Stack(
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewVideo(controller: _controller!)),
                  );
                },
                child: Center(
                  child: AspectRatio(
                                aspectRatio: _controller!.value.aspectRatio,
                                child: VideoPlayer(_controller!),
                              ),
                ),
              ),
              Center(child: Icon(Icons.play_circle_outline_rounded,color: Colors.teal,size: 30,))
            ],
          )
          : Center(child: CircularProgressIndicator(color: Colors.teal,))
    );
  }
}
