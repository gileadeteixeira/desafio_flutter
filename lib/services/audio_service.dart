// ignore_for_file: unused_element

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

Future<AudioHandler> initAudioHandler(MediaItem item) async {
  return await AudioService.init(
    builder: () => AudioPlayerHandler(item),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );
}

Future<void> finishAudioHandler(AudioHandler handler) async {
  return await handler.stop();
}

class AudioPlayerHandler extends BaseAudioHandler with SeekHandler{
  late MediaItem _item;
  final _player = AudioPlayer();
  AudioPlayerHandler(MediaItem item){
    _item = item;
    PlaybackState _transformEvent(PlaybackEvent event) {
      return PlaybackState(
        controls: [
          MediaControl.rewind,
          if (_player.playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.fastForward,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: event.currentIndex,
      );
    }
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    mediaItem.add(_item);

    _player.setAudioSource(AudioSource.uri(Uri.parse(_item.id)));

    @override
    Future<void> play() => _player.play();

    @override
    Future<void> pause() => _player.pause();

    @override
    Future<void> seek(Duration position) => _player.seek(position);

    @override
    Future<void> stop() => _player.stop();
  }
}