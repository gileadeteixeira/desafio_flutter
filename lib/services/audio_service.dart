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

  dynamic get state => _state;
  AudioPlayer get player => _player;
  
  AudioPlayerHandler(){
    playbackState.add(playbackState.value.copyWith(
      controls: [MediaControl.play],
      processingState: AudioProcessingState.loading,
    ));
    //preparePlayer();
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
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause],
    ));
    await _player.play();
  }

  @override
  Future<void> playFromUri(Uri uri, [Map<String, dynamic>? extras]) async {
    await _player.setUrl(
      uri.toString(),
      initialPosition: Duration(
        milliseconds: extras!["initial_value"]
      ),
    );
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.ready,
    ));
    _state = playbackState;
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause],
    ));
    await _player.play();
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    await _player.pause();
  }

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    await _player.stop();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
    ));
    // AudioProcessingState.
    // await AudioService.cacheManager.removeFile("libCachedImageData");
    // await playbackState.drain();
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