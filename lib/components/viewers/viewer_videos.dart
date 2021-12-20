import 'dart:async';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
import 'package:desafio_flutter/classes/initial_value.dart';

class ViewerVideos extends StatefulWidget {
  final String url;
  final String title;
  final InitialValue initialValue;
  final List<dynamic> arrayMaster;
  final Map<String, dynamic> element;
  final String storageKey;

  const ViewerVideos({Key? key,
    required this.url,
    required this.title,
    required this.initialValue,
    required this.arrayMaster,
    required this.element,
    required this.storageKey,
  }) : super(key: key);

  @override
  _VideoPage createState() => _VideoPage();  
}

class _VideoPage extends State<ViewerVideos> {
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;
  late String title;
  late Timer timer;
  late int currentPosition;

  void updatePosition() async {
    Duration? current = await chewieController.videoPlayerController.position;
    widget.initialValue.updateValue(
      current!.inMilliseconds,
      widget.storageKey,
      widget.arrayMaster,
      widget.element,
    );
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(widget.url);
    currentPosition = widget.initialValue.value == "" ? 0 : widget.initialValue.value;
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 1.7,
      autoPlay: true,
      autoInitialize: true,
      looping: false,
      startAt: Duration(
        milliseconds: currentPosition
      ),
    );
    title = widget.title;
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => updatePosition());
  }

  @override
  void dispose() {
    timer.cancel();
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Chewie(controller: chewieController),
        ),
      ),
    );
  }
}