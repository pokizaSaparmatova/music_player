import 'package:dartz/dartz.dart';
import 'package:music_player/core/error/failures.dart';

abstract class UseCase<Type> {
  Future<Either<Failure, Type>> getAllMusics();
}
