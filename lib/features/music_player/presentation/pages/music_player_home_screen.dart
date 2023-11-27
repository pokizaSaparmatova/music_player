import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:music_player/core/utils/enums/page_statuses.dart';
import 'package:music_player/features/music_player/presentation/bloc/music_player_bloc.dart';
import 'package:music_player/features/music_player/presentation/widgets/widget_music_item.dart';

import '../../../../core/utils/enums/play_button_enum.dart';
import '../../../../service_locator.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final bloc = di<MusicPlayerBloc>();
  int index=-1;

  Future<void> load() async {
    bloc.add(LoadPlayList());
  }

  @override
  void initState() {
    print("inittttttttt");
    load;
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<MusicPlayerBloc, MusicPlayerState>(
        builder: (context, state) {
          return Scaffold(
              backgroundColor: Color(0xFF091227),
              extendBodyBehindAppBar: true,
              endDrawerEnableOpenDragGesture: false,
              extendBody: true,
              appBar: AppBar(
                shadowColor: Color(0xFF091227),
                elevation: 20,
                title: Text(
                  "Music Player",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              body: Builder(
                builder: (context) {
                  if (state.status == Status.loading) {
                    print("Status.Loadingggggg");
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.status == Status.fail) {
                    print("Status.Errorrrrrrrrrrrrr");
                    return const Center(
                        child: Text(
                      "ERROR",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20),
                    ));
                  }
                  return LiquidPullToRefresh(
                      color: Colors.white,
                      height: 100,
                      backgroundColor: const Color(0xFF091227),
                      animSpeedFactor: 3,
                      onRefresh: load,
                      child:
                      ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          print("Status.Success:${state.list[index].title}");
                          print("refreshhhhh");
                          return
                            GestureDetector(
                            onTap: () {
                              bloc.add(PlayMusicEvent(state.list[index]));

                              print("indexxxxxx:${state.list[index]}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>  DetailPage(),
                              settings: RouteSettings(
                              arguments:state.list[index],
                                  )));
                            },
                            child: MusicItem(
                              title: state.list[index].title,
                              color: Colors.white,
                            ),
                          );
                        },
                        itemCount: state.list.length,
                      ));
                },
              ),
              bottomNavigationBar: Container(
                width: double.infinity,
                height: 72,
                color: Color(0xFF091227),
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.music_note_outlined,
                        color: Colors.white,
                      ),
                      Text(
                        state.title,
                        style: const TextStyle(color: Colors.white),
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
                                onPressed: () => bloc.add(PrevButtonEvent()),
                                icon: const Icon(
                                  Icons.skip_previous_outlined,
                                  color: Colors.white,
                                ));
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
                                    color: Colors.white),
                              );
                            case PlayButtonEnum.PAUSED:
                              return IconButton(
                                icon: const Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                ),
                                iconSize: 32.0,
                                onPressed: () => bloc.add(PlayButtonEvent()),
                              );
                            case PlayButtonEnum.PLAYING:
                              return IconButton(
                                icon: const Icon(
                                  Icons.pause,
                                  color: Colors.white,
                                ),
                                iconSize: 32.0,
                                onPressed: () => bloc.add(PauseButtonEvent()),
                              );
                          }
                        },
                      ),
                      Builder(
                        builder: (context) {
                          if (state.isLastSong) {
                            print("lasttt:${state.isLastSong}");
                            return IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.skip_next_outlined,
                                    color: Colors.grey));
                          } else {
                            return IconButton(
                                onPressed: () => bloc.add(NextButtonEvent()),
                                icon: const Icon(
                                  Icons.skip_next_outlined,
                                  color: Colors.white,
                                ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
