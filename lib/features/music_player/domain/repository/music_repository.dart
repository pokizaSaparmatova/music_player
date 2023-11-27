import 'package:audio_service/audio_service.dart';

abstract class MusicRepository{
  List<MediaItem> getAllMusic();
}