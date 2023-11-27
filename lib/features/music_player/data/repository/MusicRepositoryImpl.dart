import 'package:audio_service/audio_service.dart';
import 'package:music_player/core/utils/my_audio_handler.dart';
import 'package:music_player/features/music_player/domain/repository/music_repository.dart';

class MusicRepositoryImpl extends MusicRepository {
  final AudioHandler handler;


  Future<void> addQueue() async{
    print("printttttttt");
    final playlist = await fetchInitialPlaylist();
    final mediaItems = playlist
        .map((song) => MediaItem(
      id: song['id'] ?? '',
      album: song['album'] ?? '',
      title: song['title'] ?? '',
      extras: {'url': song['url']},
    ))
        .toList();
    handler.addQueueItems(mediaItems);
  }


  MusicRepositoryImpl({required this.handler});

  @override
  List<MediaItem> getAllMusic() {
    //handler.addQueueItems(list);
    print("listtttttttttttt:${handler.queue.value}");

    return  handler.queue.value;

  }

  Future<List<Map<String, String>>> fetchInitialPlaylist(
      {int length =3}) async {
    return List.generate(length, (index) => _nextSong());
  }

  var _songIndex = 0;
  static const _maxSongNumber = 25;

  Map<String, String> _nextSong()  {
    _songIndex = (_songIndex % _maxSongNumber) + 1;
    return {
      'id': _songIndex.toString().padLeft(3, '0'),
      'title': 'Music $_songIndex',
      'album': 'SoundHelix',
      'url':
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_songIndex.mp3',
    };
  }
}
