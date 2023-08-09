import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:music_application/musicPlayerScreen.dart';
import 'package:path_provider/path_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  setUp();

  Directory dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);
  await Hive.openBox<String>('myBox');

  Box box=Hive.box<String>('myox');

  if(box.get('playedOnce')==null){
    box.put('playedOnce', 'false');
  }
  runApp(const MyApp());
}

final getIt = GetIt.instance;

class BaDumTss{
  AudioPlayer _audio = AudioPlayer();

  AudioPlayer get audio => _audio;
}

void setUp(){
  getIt.registerFactory(() => BaDumTss());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MusicPlayerScreen(), 
    );
  }
}