import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/core/utils/my_audio_handler.dart';
import 'package:music_player/features/music_player/data/repository/MusicRepositoryImpl.dart';
import 'package:music_player/features/music_player/domain/repository/music_repository.dart';
import 'package:music_player/features/music_player/domain/usecases/musicUsecasImpl.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';

final di = GetIt.I;

Future<void> init() async {
  //di.registerFactory(() => MyAudioHandler());
  di.registerSingleton<AudioHandler>(await initAudioService());
  di.registerFactory<MusicRepository>(
      () => MusicRepositoryImpl(handler: di<AudioHandler>())..addQueue());
  di.registerFactory(() => UseCaseImpl(repository: di<MusicRepository>()));

  di.registerFactory(() => MusicPlayerBloc(usecase: di<UseCaseImpl>(), handler: di<AudioHandler>()));
}
