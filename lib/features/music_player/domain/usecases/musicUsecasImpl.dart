import 'package:audio_service/audio_service.dart';
import 'package:dartz/dartz.dart';
import 'package:music_player/core/error/exeptions.dart';
import 'package:music_player/core/error/failures.dart';
import 'package:music_player/core/usecase/usecases.dart';
import 'package:music_player/features/music_player/domain/repository/music_repository.dart';

class UseCaseImpl extends UseCase<List<MediaItem>> {
  final MusicRepository repository;
  UseCaseImpl({required this.repository});

  @override
  Future<Either<Failure, List<MediaItem>>> getAllMusics()async  {
   try{
     return Future.value(Right(repository.getAllMusic()));
   } on CustomException{
     return Future.value( Left(CustomFailure()));
   }
  }


}
