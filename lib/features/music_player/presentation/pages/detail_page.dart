import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import '../../../../core/utils/enums/play_button_enum.dart';
import '../../../../core/utils/enums/repeat_enum.dart';
import '../../../../service_locator.dart';
import '../bloc/music_player_bloc.dart';

class DetailPage extends StatefulWidget {

  const DetailPage({super.key,});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

final bloc = di<MusicPlayerBloc>();


class _DetailPageState extends State<DetailPage> {


  @override
  Widget build(BuildContext context) {
    final mediaItem=ModalRoute.of(context)!.settings.arguments as MediaItem;

    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: const Color(0xFF00041F),
            appBar: AppBar(
              iconTheme: const IconThemeData(
                color: Colors.white,
              ),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
              elevation: 0,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    "assets/images/img.png",
                    width: 200,
                    height: 200,
                  ),
                  Builder(
                    builder: (context) {
                      return SizedBox(
                        height: 56,
                        child: Marquee(
                          text: "  ${state.title}  ",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                              color: Colors.white
                          ),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          pauseAfterRound: const Duration(seconds: 1),
                          startPadding: 10.0,
                          accelerationDuration: const Duration(seconds: 1),
                          accelerationCurve: Curves.linear,
                          decelerationDuration: const Duration(milliseconds: 500),
                          decelerationCurve: Curves.easeOut,
                        ),
                      );
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ProgressBar(
                      progress: state.current,
                      buffered: state.buffered,
                      total: state.total,
                      onSeek: (value) => bloc.add(SeekEvent(value)),
                      thumbColor: Colors.white,
                      timeLabelTextStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                     Builder(
                        builder: (BuildContext context) {
                          Icon icon;
                          switch (state.repeatEnum.index) {
                            case 0:
                              print("RepeatEnum.OFF:${state.repeatEnum.index}");
                         return     IconButton(icon:const Icon(Icons.repeat, color: Colors.grey) , onPressed: () =>
                                  bloc.add(ChangeRepeatMode()) ,);

                              break;
                            case 1:
                              print("RepeatEnum.REPEAT_ONE:${state.repeatEnum.index}");
                           return   IconButton(icon:const Icon(Icons.repeat_one, color: Colors.white) , onPressed: () =>
                                  bloc.add(ChangeRepeatMode()) ,);

                              break;
                            case 2:
                              print("RepeatEnum.REPEAT_PLAYLIST:${state.repeatEnum.index}");
                          return    IconButton(icon:const Icon(Icons.repeat, color: Colors.white) , onPressed: () =>
                                  bloc.add(ChangeRepeatMode()) ,);

                              break;
                          }
                         return IconButton(icon:const Icon(Icons.repeat, color: Colors.white) , onPressed: () =>
                             bloc.add(ChangeRepeatMode()) ,);
                        },
                     ),
                      Builder(
                        builder: (context) {
                          if (state.isFirstSong) {
                            return IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.skip_previous_outlined,
                                    color: Colors.grey));
                          } else {
                            return IconButton(
                                onPressed: () =>
                                    bloc.add(PrevButtonEvent()),
                                icon: const Icon(Icons.skip_previous_outlined, color: Colors.white,));
                          }
                        },
                      ),
                      Builder(
                        builder: (context) {
                          switch (state.playButtonState) {
                            case PlayButtonEnum.LOADING:
                              return Container(
                                margin: const EdgeInsets.all(8.0),
                                width: 16.0,
                                height: 16.0,
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            case PlayButtonEnum.PAUSED:
                              return IconButton(
                                icon: const Icon(Icons.play_arrow, color: Colors.white),
                                iconSize: 32.0,
                                onPressed: () =>
                                    bloc.add(PlayButtonEvent()),
                              );
                            case PlayButtonEnum.PLAYING:
                              return IconButton(
                                icon: const Icon(Icons.pause, color: Colors.white),
                                iconSize: 32.0,
                                onPressed: () =>
                                    bloc.add(PauseButtonEvent()),
                              );
                          }
                        },
                      ),
                      Builder(
                        builder: (context) {
                          if (state.isLastSong) {
                            return IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.skip_next_outlined,
                                    color: Colors.grey));
                          } else {
                            return IconButton(
                                onPressed: () =>
                                    bloc.add( NextButtonEvent()),
                                icon: const Icon(Icons.skip_next_outlined, color: Colors.white));
                          }
                        },
                      ),
                      // IconButton(
                      //   icon: (state.isShuffle)
                      //       ? const Icon(Icons.shuffle, color: Colors.white,)
                      //       : const Icon(Icons.shuffle, color: Colors.grey),
                      //   onPressed: () => bloc.add(
                      //     const MPlayerEvent.changeShuffleMode(),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
