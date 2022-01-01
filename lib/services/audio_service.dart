// ignore_for_file: unused_element

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioHandler() async {
  return await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );
}

Future<void> finishAudioHandler(AudioHandler handler) async {
  await handler.stop();
  // return await AudioService.cacheManager.dispose();
}

class AudioPlayerHandler extends BaseAudioHandler{
  final _player = AudioPlayer();
  late dynamic _state;
  late Uri? _currentUri;
  late int? _currentPosition;

  dynamic get state => _state;
  AudioPlayer get player => _player;
  
  AudioPlayerHandler(){
    _currentUri = null;
    _currentPosition = null;
    playbackState.add(playbackState.value.copyWith(
      androidCompactActionIndices: [1, 2],
      controls: [MediaControl.rewind, MediaControl.play, MediaControl.stop, MediaControl.fastForward],
      systemActions: {
        MediaAction.seek,
        MediaAction.seekForward,
        MediaAction.seekBackward,
        MediaAction.playFromUri
      },
      processingState: AudioProcessingState.loading,
    ));
    _state = playbackState;
  }  

  void preparePlayer(/*MediaItem item*/) async {
    await _player.setUrl("https://github.com/App2Sales/mobile-challenge/raw/master/a-arte-da-guerra.mp3");
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
    ));
    _state = playbackState;
  }

  @override
  Future<void> play() async {
    // await playFromUri(_currentUri!);
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.rewind, MediaControl.pause, MediaControl.stop, MediaControl.fastForward],
    ));
    await _player.play();
    _state = playbackState;
  }

  @override
  Future<void> playFromUri(Uri uri, [Map<String, dynamic>? extras]) async {
    if(uri != _currentUri){
      _currentUri = uri;
      _currentPosition = extras!["initial_value"];
      await _player.setUrl(
        _currentUri.toString(),
        initialPosition: Duration(
          milliseconds: _currentPosition!
        ),
      );
    }
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
    ));
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.rewind, MediaControl.pause, MediaControl.stop, MediaControl.fastForward],
    ));
    await _player.play();
    _state = playbackState;
  }

  @override
  Future<void> pause() async {
    Duration current = await AudioService.position.firstWhere((duration) => true);
    _currentPosition = current.inMilliseconds;
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.rewind, MediaControl.play, MediaControl.stop, MediaControl.fastForward],
    ));
    await _player.pause();
    _state = playbackState;
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      processingState: AudioProcessingState.idle,
    ));
    _currentUri = null;
    _currentPosition = null;
    await _player.dispose();
  }

  // PlaybackState _transformEvent(PlaybackEvent event) {
  //   return PlaybackState(
  //     controls: [
  //       MediaControl.rewind,
  //       if (_player.playing) MediaControl.pause else MediaControl.play,
  //       MediaControl.stop,
  //       MediaControl.fastForward,
  //     ],
  //     systemActions: const {
  //       MediaAction.seek,
  //       MediaAction.seekForward,
  //       MediaAction.seekBackward,
  //     },
  //     androidCompactActionIndices: const [0, 1, 3],
  //     processingState: const {
  //       ProcessingState.idle: AudioProcessingState.idle,
  //       ProcessingState.loading: AudioProcessingState.loading,
  //       ProcessingState.buffering: AudioProcessingState.buffering,
  //       ProcessingState.ready: AudioProcessingState.ready,
  //       ProcessingState.completed: AudioProcessingState.completed,
  //     }[_player.processingState]!,
  //     playing: _player.playing,
  //     updatePosition: _player.position,
  //     bufferedPosition: _player.bufferedPosition,
  //     speed: _player.speed,
  //     queueIndex: event.currentIndex,
  //   );
  // }
}