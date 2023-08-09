import 'dart:html';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:music_application/customListItem_widget.dart';
import 'package:music_application/main.dart';

class MusicPlayerScreen extends StatefulWidget {
  const MusicPlayerScreen({super.key});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> 
with WidgetsBindingObserver
{


  late Duration duration;
  late Duration position;
  bool isPlaying = false;
  IconData btnIcon = Icons.play_arrow;

  late BaDumTss instance;
  late AudioPlayer audioPlayer;

  Box box = Hive.box<String>('myBox');

  String currentSong = "";
  String currentCover = "";
  String currentTitle = "";
  String currentSinger = "";
  String url = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    instance=getIt<BaDumTss>();
    audioPlayer = instance.audio;
    duration = new Duration();
    position = new Duration();

    if(box.get('playedOnce')=="false"){
      setState(() {
        currentCover="https://i.pinimg.com/originals/25/0c/e1/250ce1e27b85c49afd1c745d8cb2Ffa.png";
        currentTitle = "Choose a song to play";

 
      });
    }
    else if(box.get('playedOnce') == "true"){
      currentCover = box.get('currentCover');
      currentCover = box.get('currentSinger');
      currentTitle  = box.get("currentTitle");
      url = box.get('url');
    }
  }


  @override

  void didChangeAppLifecycleStste(AppLifecycleState state){
    super.didChangeAppLifecycleState(state);
    if(state == AppLifecycleState.inactive || state == AppLifecycleState.paused)
    {
      audioPlayer.pause();
      setState(() {
        btnIcon=Icons.pause;
      });
    }
    else if(state == AppLifecycleState.resumed){
      if(isPlaying == true){
        audioPlayer.resume();
        setState(() {
          btnIcon=Icons.play_arrow;
        });
      }
    }
    else if(state == AppLifecycleState.detached){
      audioPlayer.stop();
      audioPlayer.release();

    }
  }




  @override
  void dispose() {
    // TODO: implement dispose

    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void playMusic(String url)async{
    if(isPlaying && currentSong!=url){
      audioPlayer.pause();
      int result=await audioPlayer.play(url);
      if(result==1){
        setState(() {
          currentSong = url;
        });
      }
    }
    else if(!isPlaying){
      int result = await audioPlayer.play(url);
      if(result==1)
      {
        setState(() {
          isPlaying = true;
          btnIcon=Icons.play_arrow;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration=event;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((event){
      setState(() {
        position=event;
      });
    });

 
  }
  void seekToSecond(int second)
  {
    Duration newDuration = Duration(seconds:second);
    audioPlayer.seek(newDuration);


  }




  List music = [
  {
    "title": "Death Bed",
    "singer": "Powfu",
    "url": "https://samplesongs.netlify.app/Death%20Bed.mp3",
    "coverUrl": "https://samplesongs.netlify.app/album-arts/death-bed.jpg"
  },
  {
    "title": "Bad Liar",
    "singer": "Imagine Dragons",
    "url": "https://samplesongs.netlify.app/Bad%20Liar.mp3",
    "coverUrl": "https://samplesongs.netlify.app/album-arts/bad-liar.jpg"
  },
  {
    "title": "Faded",
    "singer": "Alan Walker",
    "url": "https://samplesongs.netlify.app/Faded.mp3",
    "coverUrl": "https://samplesongs.netlify.app/album-arts/faded.jpg"
  },
  {
    "title": "Hate Me",
    "singer": "Ellie Goulding",
    "url": "https://samplesongs.netlify.app/Hate%20Me.mp3",
    "coverUrl": "https://samplesongs.netlify.app/album-arts/hate-me.jpg"
  },
  {
    "title": "Solo",
    "singer": "Clean Bandit",
    "url": "https://samplesongs.netlify.app/Solo.mp3",
    "coverUrl": "https://samplesongs.netlify.app/album-arts/solo.jpg"
  },
  {
    "title": "Without Me",
    "singer": "Halsey",
    "url": "https://samplesongs.netlify.app/Without%20Me.mp3",
    "coverUrl": "https://samplesongs.netlify.app/album-arts/without-me.jpg"
  }
];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text(
          "Music player",
        ), 
        elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(child: 
            ListView.builder(itemBuilder: (context,index)=>customListItem(
              title:music[index]['title'],
              singer: music[index]['singer'],
              cover: music[index]['coverUrl'],
              onTap: ()async{
                setState((){
                 currentTitle:music[index]['title'];
                currentSinger: music[index]['singer'];
                currentCover: music[index]['coverUrl'];
                url = music[index]['url'];
                });
                playMusic(url);
                
                box.put(
                  'playdOnce', 
                  'true',
                  );
                box.put('currentCover', currentCover);
                box.put('currentSinger', currentSinger);
                box.put('currentTitle', currentTitle);
                box.put('url', url);

              }
            ),
            itemCount: music.length,
            )),
            Container(
              decoration: BoxDecoration(
              color: Colors.white,
              boxShadow:[
                BoxShadow(
                  color: Color(
                    0x55212121,
                  ),
                blurRadius: 8,
            )
          ],
          ),
          child: Column(
            children: [
              Slider(
                value: position.inSeconds.toDouble(), 
                min: 0,
                max: duration.inSeconds.toDouble(),
                onChanged: (value){
                  seekToSecond(value.toInt());
                  }),
                  Padding(
                    padding: const EdgeInsets.only(left:8,right:8.0,),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      Text(
                        position.inSeconds.toDouble().toString(),
                        ),
                      Text(
                        duration.inSeconds.toDouble().toString(),
                      ),
                    ],),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 60,
                        width: 60, 
                        decoration:BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            16
                            ),
                            image: DecorationImage(
                              image: NetworkImage(
                                currentCover,
                                ),
                              ),
                            ),),
                            SizedBox(width: 10,),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                                Text(currentTitle,
                                style:TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                )
                                ),
                                SizedBox(height: 5,),
                                Text(currentSinger,
                                  style: TextStyle(
                                  color:Colors.grey,
                                  fontSize:14,
                                  ),
                                )
                             ],
                             ),
                             ),
                             IconButton(icon: Icon(
                              btnIcon,
                              size: 42,
                             ),
                             onPressed: (){
                              if(box.get('playedOnce')=="true" && isPlaying=="false"){
                                playMusic(url);
                              }
                              else{
                                if(isPlaying){
                                  audioPlayer.pause();
                                  setState(() {
                                    btnIcon=Icons.pause;
                                    isPlaying=false;
                                  });
                                }
                                else
                                {
                                  audioPlayer.resume();
                                  setState(() {
                                    btnIcon = Icons.play_arrow;
                                    isPlaying = true;
                                  });
                                }
                              }
                             },
                             )
                    ],
                  )
            ],
          ),
          )
        ],)
    );
  }
}