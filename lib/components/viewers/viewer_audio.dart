import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:desafio_flutter/classes/initial_value.dart';
import 'package:desafio_flutter/components/copy/common.dart';
import 'package:desafio_flutter/services/audio_service.dart';


class ViewerAudios extends StatefulWidget {
  final String url;
  final String title;
  final InitialValue initialValue;
  final List<dynamic> arrayMaster;
  final Map<String, dynamic> element;
  final String storageKey;

  const ViewerAudios({Key? key,
    required this.url,
    required this.title,
    required this.initialValue,
    required this.arrayMaster,
    required this.element,
    required this.storageKey,
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
  void dispose() {
    finishAudioHandler(audioHandler);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
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
              return StreamBuilder<PlaybackState>(
                stream: audioHandler.playbackState,
                builder: (context, snapshot) {
                  final playing = snapshot.data?.playing ?? false;
                  // final processingState = snapshot.data?.processingState ?? AudioProcessingState.idle;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _button(Icons.fast_rewind, audioHandler.rewind),
                          if (playing)
                            _button(Icons.pause, audioHandler.pause)
                          else
                            _button(Icons.play_arrow, audioHandler.play),
                          _button(Icons.stop, audioHandler.stop),
                          _button(Icons.fast_forward, audioHandler.fastForward),
                        ]
                      ),
                      StreamBuilder<MediaState>(
                        stream: mediaStateStream,
                        builder: (context, snapshot) {
                          final mediaState = snapshot.data;
                          return SeekBar(
                            duration: mediaState?.mediaItem?.duration ?? Duration.zero,
                            position: mediaState?.position ?? Duration.zero,
                            onChanged: (newPosition) {
                              audioHandler.seek(newPosition);
                              currentPosition = newPosition;
                            },
                          );
                        },
                      ),
                    ],
                  );
                }
              );
            } else if (snapshot.hasError) {
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