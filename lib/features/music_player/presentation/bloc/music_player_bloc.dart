import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:bloc/bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meta/meta.dart';
import 'package:music_player/core/error/failures.dart';
import 'package:music_player/core/utils/enums/page_statuses.dart';
import 'package:music_player/core/utils/enums/repeat_enum.dart';
import 'package:music_player/features/music_player/domain/usecases/musicUsecasImpl.dart';
import 'package:music_player/features/music_player/presentation/pages/detail_page.dart';

import '../../../../core/utils/enums/play_button_enum.dart';
import '../../../../core/utils/my_audio_handler.dart';

part 'music_player_event.dart';

part 'music_player_state.dart';

const String FAILURE_MESSAGE = "Empty data";

class MusicPlayerBloc extends Bloc<MusicPlayerEvent, MusicPlayerState> {
  final UseCaseImpl usecase;
  final AudioHandler handler;


  late StreamSubscription<Duration> currentDurationStream;
  late StreamSubscription<MediaItem?> mediaStream;
  late StreamSubscription<List<MediaItem>> playListStream;
  late StreamSubscription<PlaybackState> playbackStream;

  MusicPlayerBloc({required this.usecase, required this.handler})
      : super(MusicPlayerState()) {
    currentDurationStream = AudioService.position.listen((position) {
      //  print('Current playback position: ${position.inSeconds} seconds');
      add(ChangeCurrentPositionStream(position));
    });

    mediaStream = handler.mediaItem.listen((mediaItem) {
      if (mediaItem != null) {
        print("tatalPosition:${mediaItem.duration}");
        add(ChangeTotalPositionStream(mediaItem.duration ?? Duration.zero));
        print("title:${mediaItem.title}");
        add(ChangeTitleStream(mediaItem.title));
        add(UpdateStream());
      }
    });

    playbackStream = handler.playbackState.listen((playbackState) async {
      add(ChangeBufferedPositionStream(playbackState.bufferedPosition));
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        print("Loooooaaading");
        add(ChangePlayBackStream(PlayButtonEnum.LOADING));
      } else if (!isPlaying) {
        print("Pauuuussing");
        add(ChangePlayBackStream(PlayButtonEnum.PAUSED));
      } else if (processingState != AudioProcessingState.completed) {
        print("Playyyyyiiiing");
        add(ChangePlayBackStream(PlayButtonEnum.PLAYING));
      } else {
        print("compliteeeeddd");
        await handler.seek(Duration.zero);
        await handler.pause();
        add(ChangeCurrentPositionStream(Duration.zero));
        add(ChangePlayBackStream(PlayButtonEnum.PAUSED));
      }
    });

    playListStream = handler.queue.listen((playlist) {
      if (playlist.isEmpty) {
        add(ChangeListStream([]));
        add(ChangeTitleStream(""));
      } else {
        add(ChangeListStream(playlist));
      }
      add(UpdateStream());
    });

    on<LoadPlayList>((event, emit) async {
      final either = await usecase.getAllMusics();
      either.fold(
          (error) => emit(state.copyWith(
              status: Status.fail, errorMessage: _mapFailureMessage(error))),
          (list) => emit(state.copyWith(status: Status.succes, list: list)));
    });
    on<PlayButtonEvent>((event, emit) async {
      await handler.play();
    });
    on<NextButtonEvent>((event, emit) async {
      await handler.skipToNext();
    });
    on<PrevButtonEvent>((event, emit) async {
      await handler.skipToPrevious();
    });
    on<PauseButtonEvent>((event, emit) async {
      await handler.pause();
    });
    //******************
    on<ChangeCurrentPositionStream>((event, emit) async {
      emit(state.copyWith(current: event.currentDuration));
    });
    on<ChangeTotalPositionStream>((event, emit) async {
      emit(state.copyWith(total: event.totalDuration));
    });
    on<ChangeBufferedPositionStream>((event, emit) async {
      emit(state.copyWith(buffered: event.bufferedDuration));
    });
    on<ChangePlayBackStream>((event, emit) async {
      emit(state.copyWith(playButtonState: event.playState));
    });
    on<ChangeTitleStream>((event, emit) async {
      print("titleeeeeeeeeeeeeeeeeeeeee${event.title}");
      emit(state.copyWith(title: event.title));
    });
    on<UpdateStream>((event, emit) async {
      print("mediaItemValueee:${handler.mediaItem.value}");
      final mediaItem = handler.mediaItem.value;
      final playList = handler.queue.value;
      if (playList.length < 2 || mediaItem == null) {
        emit(state.copyWith(isFirstSong: true, isLastSong: true));
      } else {
        emit(state.copyWith(
            isLastSong: playList.last == mediaItem,
            isFirstSong: playList.first == mediaItem));
      }
    });
    on<PlayMusicEvent>((event, emit) async {
      bloc.add(ChangeTitleStream(event.item.title));
      print("URLLLLL:${event.item.extras}");
      try {
        await handler.playMediaItem(event.item);
      } catch (e) {}
    });
    on<RepeatNextState>((event, emit) async {
      final nextState = (state.repeatEnum.index + 1) % RepeatEnum.values.length;
      print("index:${AudioServiceRepeatMode.values[nextState].index}");
      emit(state.copyWith(repeatEnum: AudioServiceRepeatMode.values[nextState]));
    });
    on<ChangeRepeatMode>((event, emit) async {
    //  print("enummmmmmm:${state.repeatEnum}");

      add(RepeatNextState());
      print('state repeat mode: ${state.repeatEnum.index}');
     if(state.repeatEnum.index==0){
       handler.setRepeatMode(AudioServiceRepeatMode.one);
     }
     else if(state.repeatEnum.index==1){
       handler.setRepeatMode(AudioServiceRepeatMode.all);

     }
     else if(state.repeatEnum.index==2){
       handler.setRepeatMode(AudioServiceRepeatMode.none);

     }
    });

    on<SeekEvent>((event, emit) async {
      handler.seek(event.duration);
    });

    on<ChangeListStream>((event, emit) {
      emit(state.copyWith(list: event.list));
    });
  }
}

String _mapFailureMessage(Failure failure) {
  switch (failure.runtimeType) {
    case CustomFailure:
      return FAILURE_MESSAGE;
    default:
      return 'Aniqlanmagan Xatolik';
  }
}
