import 'package:flutter/material.dart';
import 'package:music_player/core/utils/my_audio_handler.dart';
import 'package:music_player/features/music_player/presentation/pages/music_player_home_screen.dart';
import 'package:music_player/service_locator.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await initAudioService();
  await init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}



