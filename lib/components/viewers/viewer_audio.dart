import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:desafio_flutter/classes/initial_value.dart';
// import 'package:desafio_flutter/components/copy/common.dart';
// import 'package:desafio_flutter/services/audio_service.dart';


class ViewerAudios extends StatefulWidget {
  final String url;
  final String title;
  final InitialValue initialValue;
  final List<dynamic> arrayMaster;
  final Map<String, dynamic> element;
  final String storageKey;
  final AudioHandler audioHandler;

  const ViewerAudios({Key? key,
    required this.url,
    required this.title,
    required this.initialValue,
    required this.arrayMaster,
    required this.element,
    required this.storageKey,
    required this.audioHandler,
  }) : super(key: key);

  @override
  _AudioPage createState() => _AudioPage();  
}

class _AudioPage extends State<ViewerAudios> {
  late MediaItem item;
  late Timer timer;
  late AudioHandler audioHandler;
  late int currentPosition;

  Stream<MediaState> getMediaStateStream(AudioHandler audioHandler) {
    return Rx.combineLatest2<MediaItem?, Duration, MediaState>(
      audioHandler.mediaItem,
      AudioService.position,
      (mediaItem, position) => MediaState(mediaItem, position)
    );
  }

  IconButton _button(IconData iconData, VoidCallback onPressed) => IconButton(
    icon: Icon(iconData),
    iconSize: 64.0,
    onPressed: onPressed,
  );

  void updatePosition() async {
    Duration current = await AudioService.position.firstWhere((duration) => true);
    currentPosition = current.inMilliseconds;
    widget.initialValue.updateValue(
      currentPosition,
      widget.storageKey,
      widget.arrayMaster,
      widget.element,
    );
  }

  void doAction(Future<void> action) async {
    await action;
  }

  @override
  void initState() {
    super.initState();
    item = MediaItem(
      id: widget.url,
      title: widget.title,
    );
    widget.audioHandler.prepareFromUri(Uri.parse(widget.url));
    currentPosition = widget.initialValue.value == "" ? 0 : widget.initialValue.value;
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => updatePosition());
  }

  @override
  void dispose() {
    // doAction(widget.audioHandler.stop());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stream<MediaState> mediaStateStream = Rx.combineLatest2<MediaItem?, Duration, MediaState>(
    //   widget.audioHandler.mediaItem,
    //   AudioService.position,
    //   (mediaItem, position) => MediaState(mediaItem, position)
    // );  
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Center(
        child: StreamBuilder<PlaybackState>(
          stream: widget.audioHandler.playbackState,
          builder: (context, snapshot) {
            final playing = snapshot.data?.playing ?? false;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _button(
                      Icons.fast_rewind,
                      (){
                        doAction(widget.audioHandler.rewind());
                      }
                    ),
                    if (playing)
                      _button(
                        Icons.pause,
                        (){
                          doAction(widget.audioHandler.pause());
                        }                        
                      )
                    else
                    _button(
                      Icons.play_arrow,
                      (){
                        doAction(
                          widget.audioHandler.playFromUri(
                            Uri.parse(widget.url),
                            {
                              "initial_value": currentPosition
                            } 
                          )
                        );
                      },
                    ),
                    _button(
                      Icons.stop,
                      (){
                        doAction(widget.audioHandler.stop());
                      }                      
                    ),
                    _button(
                      Icons.fast_forward,
                      (){
                        doAction(widget.audioHandler.fastForward());
                      }                      
                    ),
                  ]
                ),
                // StreamBuilder<MediaState>(
                //   stream: mediaStateStream,
                //   builder: (context, snapshot) {
                //     final mediaState = snapshot.data;
                //     return SeekBar(
                //       duration: mediaState?.mediaItem?.duration ?? Duration.zero,
                //       position: mediaState?.position ?? Duration.zero,
                //       onChanged: (newPosition) {
                //         widget.audioHandler.seek(newPosition);
                //         currentPosition = newPosition.inMilliseconds;
                //       },
                //     );
                //   },
                // ),
              ],
            );
          }
        ),
      )
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;
  MediaState(this.mediaItem, this.position);
}