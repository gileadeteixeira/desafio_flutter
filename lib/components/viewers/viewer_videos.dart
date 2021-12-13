import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:desafio_flutter/classes/initial_value.dart';

class ViewerVideos extends StatefulWidget {
  final String url;
  final String title;
  final InitialValue initialValue;

  const ViewerVideos({Key? key,
    required this.url,
    required this.title,
    required this.initialValue,
  }) : super(key: key);

  @override
  _VideoPage createState() => _VideoPage();
  
}

class _VideoPage extends State<ViewerVideos> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late String title;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url);
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      fullScreenByDefault: false,
      looping: false,
      startAt: Duration(
        milliseconds: widget.initialValue.value == "" ? 0 : widget.initialValue.value
      ),
    );
    title = widget.title;
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: WillPopScope(
          onWillPop: () async {
            Duration? current = await chewieController.videoPlayerController.position;
            Navigator.pop(context, current!.inMilliseconds);
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Chewie(controller: chewieController),
          ),
        ),
      ));
  }
}