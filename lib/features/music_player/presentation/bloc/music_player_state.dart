part of 'music_player_bloc.dart';

@immutable
class MusicPlayerState {
  final Status status;
  final String errorMessage;
  final String title;
  final List<MediaItem> list;
  final bool isFirstSong;
  final bool isLastSong;
  final PlayButtonEnum playButtonState;
  final bool isShuffle;
  final Duration current;
  final Duration buffered;
  final Duration total;
  final AudioServiceRepeatMode repeatEnum;

  MusicPlayerState(
      {this.status = Status.initial,
      this.errorMessage = "",
      this.title = "",
      this.list = const [],
      this.isFirstSong = false,
      this.isLastSong = false,
      this.playButtonState = PlayButtonEnum.PAUSED,
      this.isShuffle = false,
      this.current = Duration.zero,
      this.buffered = Duration.zero,
      this.total = Duration.zero,
      this.repeatEnum = AudioServiceRepeatMode.none});

  MusicPlayerState copyWith(
      {Status? status,
      String? errorMessage,
      String? title,
      List<MediaItem>? list,
      bool? isFirstSong,
      bool? isLastSong,
      PlayButtonEnum? playButtonState,
      bool? isShuffle,
      Duration? current,
      Duration? buffered,
      Duration? total,
        AudioServiceRepeatMode? repeatEnum}) {
    return MusicPlayerState(
        status: status ?? this.status,
        errorMessage: errorMessage ?? this.errorMessage,
        title: title ?? this.title,
        list: list ?? this.list,
        isFirstSong: isFirstSong ?? this.isFirstSong,
        isLastSong: isLastSong ?? this.isLastSong,
        playButtonState: playButtonState ?? this.playButtonState,
        isShuffle: isShuffle ?? this.isShuffle,
        current: current ?? this.current,
        buffered: buffered ?? this.buffered,
        total: total ?? this.total,
        repeatEnum: repeatEnum ?? this.repeatEnum);
  }
}
