import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:desafio_flutter/classes/initial_value.dart';
import 'package:desafio_flutter/components/copy/common.dart';
import 'package:desafio_flutter/services/audio_service.dart';


class ViewerAudios extends StatefulWidget {
  final String url;
  final String title;
  final InitialValue initialValue;

  const ViewerAudios({Key? key,
    required this.url,
    required this.title,
    required this.initialValue,
  }) : super(key: key);

  @override
  _AudioPage createState() => _AudioPage();
  
}

class _AudioPage extends State<ViewerAudios> {
  late MediaItem item;
  late AudioHandler audioHandler;
  late Duration currentPosition;

  @override
  void initState() {
    super.initState();
    item = MediaItem(
      id: widget.url,
      title: widget.title,
    );
  }

  Stream<MediaState> getMediaStateStream(AudioHandler audioHandler) {
    return Rx.combineLatest2<MediaItem?, Duration, MediaState>(
      audioHandler.mediaItem,
      AudioService.position,
      (mediaItem, position) => MediaState(mediaItem, position)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<AudioHandler>(
          future: initAudioHandler(item),
          builder: (context, snapshot){
            if (snapshot.hasData){
              audioHandler = snapshot.data!;
              IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
                icon: Icon(iconData),
                iconSize: 64.0,
                onPressed: onPressed,
              );
              Stream<MediaState> mediaStateStream =
              Rx.combineLatest2<MediaItem?, Duration, MediaState>(
                  audioHandler.mediaItem,
                  AudioService.position,
                      (mediaItem, position) => MediaState(mediaItem, position)
              );
              return WillPopScope(
                  onWillPop: () async {
                    finishAudioHandler(audioHandler);
                    Navigator.pop(context, currentPosition.inMilliseconds);
                    return true;
                  },
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text(item.title),
                    ),
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Show media item title
                        StreamBuilder<MediaItem?>(
                          stream: audioHandler.mediaItem,
                          builder: (context, snapshot) {
                            final mediaItem = snapshot.data;
                            return Text(mediaItem?.title ?? "");
                          },
                        ),
                        // Play/pause/stop buttons.
                        StreamBuilder<bool>(
                          stream: audioHandler.playbackState
                              .map((state) => state.playing)
                              .distinct(),
                          builder: (context, snapshot) {
                            final playing = snapshot.data ?? false;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _button(Icons.fast_rewind, audioHandler.rewind),
                                if (playing)
                                  _button(Icons.pause, audioHandler.pause)
                                else
                                  _button(Icons.play_arrow, audioHandler.play),
                                _button(Icons.stop, audioHandler.stop),
                                _button(Icons.fast_forward, audioHandler.fastForward),
                              ],
                            );
                          },
                        ),
                        // A seek bar.
                        StreamBuilder<MediaState>(
                          stream: mediaStateStream,
                          builder: (context, snapshot) {
                            final mediaState = snapshot.data;
                            return SeekBar(
                              duration: mediaState?.mediaItem?.duration ?? Duration.zero,
                              position: mediaState?.position ?? Duration.zero,
                              onChangeEnd: (newPosition) {
                                audioHandler.seek(newPosition);
                                currentPosition = newPosition;
                              },
                            );
                          },
                        ),
                        // Display the processing state.
                        StreamBuilder<AudioProcessingState>(
                          stream: audioHandler.playbackState
                              .map((state) => state.processingState)
                              .distinct(),
                          builder: (context, snapshot) {
                            final processingState =
                              snapshot.data ?? AudioProcessingState.idle;
                            return Text(
                              "Processing state: ${describeEnum(processingState)}"
                            );
                          },
                        ),
                      ]
                    )
                  )
              );
            }else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }
        )
      ),
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;
  MediaState(this.mediaItem, this.position);
}