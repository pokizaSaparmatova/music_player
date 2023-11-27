part of 'music_player_bloc.dart';

@immutable
abstract class MusicPlayerEvent {}

class LoadPlayList extends MusicPlayerEvent {}

class PlayButtonEvent extends MusicPlayerEvent {}

class PauseButtonEvent extends MusicPlayerEvent {}

class NextButtonEvent extends MusicPlayerEvent {}

class PrevButtonEvent extends MusicPlayerEvent {}

class PlayMusicEvent extends MusicPlayerEvent {
  final MediaItem item;

  PlayMusicEvent(this.item);
}

class SeekEvent extends MusicPlayerEvent {
  final Duration duration;

  SeekEvent(this.duration);
}
// for listening Streams

class ChangeCurrentPositionStream extends MusicPlayerEvent {
  final Duration currentDuration;

  ChangeCurrentPositionStream(this.currentDuration);
}

class ChangeBufferedPositionStream extends MusicPlayerEvent {
  final Duration bufferedDuration;

  ChangeBufferedPositionStream(this.bufferedDuration);
}

class ChangeTotalPositionStream extends MusicPlayerEvent {
  final Duration totalDuration;

  ChangeTotalPositionStream(this.totalDuration);
}

class ChangeTitleStream extends MusicPlayerEvent {
  final String title;

  ChangeTitleStream(this.title);
}

class ChangePlayBackStream extends MusicPlayerEvent {
  final PlayButtonEnum playState;

  ChangePlayBackStream(this.playState);
}

class UpdateStream extends MusicPlayerEvent {}

class ChangeListStream extends MusicPlayerEvent {
  final List<MediaItem> list;

  ChangeListStream(this.list);
}

class ChangeRepeatMode extends MusicPlayerEvent{

}
class RepeatNextState extends MusicPlayerEvent{}
