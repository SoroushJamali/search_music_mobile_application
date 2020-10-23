import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/song_json/song-data.dart';
import 'package:flutter_app/song_json/artist.dart';
import 'package:just_audio/just_audio.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../main/main.dart';

class MyApp2 extends StatefulWidget {
  List<MusicCategory>music;
  String title;
  String album;
  MyApp2( this.album,this.title,{Key key,  this.music});

  @override
  _MyAppState createState() => _MyAppState(this.music,this.album,this.title);
}

class _MyAppState extends State<MyApp2> {
  List<MusicCategory> music2=new List<MusicCategory>();
  List<MusicCategory>music;
  List<AudioSource> list = new List<AudioSource>();
  String title;
  String album;
  _MyAppState(this.music,this.album,this.title);
  AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    AudioPlayer.setIosCategory(IosCategory.playback);
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _loadAudio();
  }

  _loadAudio() async {
    mainy();
    try {
      await _player.load( getTextWidgets(music2),);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }
  ConcatenatingAudioSource getTextWidgets(List<MusicCategory> strings)
  {
     for(var i=0; i<strings.length; i++) {
       list.add(AudioSource.uri(
         Uri.parse(
             music2[i].assetUrl),
         tag: AudioMetadata(
           album: music2[i].artist,
           title: music2[i].album,
           artwork:
           music2[i].image,
         ),
       ));
     }
     return ConcatenatingAudioSource(// gap between lines
         children: list);
  }
  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =  GlobalKey<ScaffoldState>();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Container(
                    height: 200,
                    child: StreamBuilder<MusicCategory>(
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          final sequence = music2 ?? [];
                          return ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: sequence.length,
                              itemBuilder: (context, index) => Material(
                                child:DrawerHeader(
                                  child: Align(alignment: Alignment.centerLeft,child:Text( sequence[index].title,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 25),)),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                ),
                              ));})),
                Container(
                  height: 2000,
                  child: StreamBuilder<SequenceState>(
                    stream: _player.sequenceStateStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final sequence = state?.sequence ?? [];
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: sequence.length,
                        itemBuilder: (context, index) => Material(
                          color: index == state.currentIndex
                              ? Colors.black12
                              : null,
                          child: ListTile(
                            title:Column(
                              children: [
                                Image.network(sequence[index].tag.artwork,width: 100,height: 100,),
                                SizedBox(height: 15.0),
                                Text('  '+sequence[index].tag.album+"-"+sequence[index].tag.title,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                                SizedBox(height: 15.0),
                              ],),
                            onTap: () {
                              _player.seek(Duration.zero, index: index);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),),
        body:Container(
            child:Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<SequenceState>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence?.isEmpty ?? true) return SizedBox();
                    final metadata = state.currentSource.tag as AudioMetadata;
                    return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(metadata.artwork),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child:Column(

                          children:

                          ((){
                            if(metadata.album=="Radios" ){
                              return [

                                Expanded(child:Image.network(metadata.artwork,fit: BoxFit.cover)),
                                SizedBox(height: 16.0,),
                                Text(metadata.title ?? '',
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black) ),
                                RaisedButton(
                                  onPressed: (){
                                    _settingModalBottomSheet(context,metadata.title);
                                  },
                                  color: Colors.black,
                                  child: new Text('Show the current song',style: TextStyle(color: Colors.white),),
                                ),
                                SizedBox(height: 16.0,),];
                            }
                            else{
                              return  [

                                Expanded(child:Image.network(metadata.artwork,fit: BoxFit.cover,)),
                                SizedBox(height: 16.0,),
                                Text(metadata.album ?? '',
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white) ),
                                Text(metadata.title ?? '',style: TextStyle(fontSize: 15,color: Colors.white),),
                                SizedBox(height: 16.0,),];
                            }
                          }()),


                        ));
                  },
                ),
              ),

             Container(
              color: Colors.black,
              child:
              Column(children:[
                Row(children:[
                  Padding(padding: EdgeInsets.only(right: 20.0),
                  child: IconButton(
                      icon: Icon(Icons.queue_music ,color: Colors.red,),
                      onPressed: () {
                        _scaffoldKey.currentState.openDrawer();
                      })),
                ControlButtons(_player),
                ]),
              StreamBuilder<Duration>(
                stream: _player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<Duration>(
                    stream: _player.positionStream,
                    builder: (context, snapshot) {
                      var position = snapshot.data ?? Duration.zero;
                      if (position > duration) {
                        position = duration;
                      }
                      return SeekBar(
                        duration: duration,
                        position: position,
                        onChangeEnd: (newPosition) {
                          _player.seek(newPosition);
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.white),
                        Icon(Icons.repeat, color: Colors.red),
                        Icon(Icons.repeat_one, color: Colors.amberAccent),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          _player.setLoopMode(cycleModes[
                          (cycleModes.indexOf(loopMode) + 1) %
                              cycleModes.length]);
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      lastWords,
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(Icons.shuffle, color: Colors.red)
                            : Icon(Icons.shuffle, color: Colors.white),
                        onPressed: () {
                          _player.setShuffleModeEnabled(!shuffleModeEnabled);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
             )])
      )));
  }
  mainy() async{
    for(var i=0; i<music.length; i++){
      if(music[i].category==this.album && music[i].title==this.title){
        music2.add(music[i]);
      }
    }
  }
  WebViewController _controller;
  void _settingModalBottomSheet(context,b){

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
              height: 300,
              child:MyWebView(b));
        }
    );
  }

}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up,color: Colors.white),
          onPressed: () {
            _showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous,color: Colors.white,),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 80.0,
                height: 80.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_circle_filled,color: Colors.white,),
                iconSize: 80.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause_circle_filled,color: Colors.white,),
                iconSize: 80.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay,color: Colors.white,),
                iconSize: 80.0,
                onPressed: () => player.seek(Duration.zero, index: 0),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next,color: Colors.white,),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,)),
            onPressed: () {
              _showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;

  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
    SliderTheme(
    data: SliderThemeData(
    trackHeight: 6,

    ),
    child:Slider(
          activeColor: Colors.red,
          inactiveColor: Colors.white,
          min: 0.0,
          max: widget.duration.inMilliseconds.toDouble(),
          value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
              widget.duration.inMilliseconds.toDouble()),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
            });
            if (widget.onChanged != null) {
              widget.onChanged(Duration(milliseconds: value.round()));
            }
          },
          onChangeEnd: (value) {
            if (widget.onChangeEnd != null) {
              widget.onChangeEnd(Duration(milliseconds: value.round()));
            }
            _dragValue = null;
          },
        )),
        Positioned(
          right: 20.0,
          bottom: -4.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                  .firstMatch("$_remaining")
                  ?.group(1) ??
                  '$_remaining',
              style: TextStyle(fontSize: 14,color: Colors.white) ),
        ),
    ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

_showSliderDialog({
  BuildContext context,
  String title,
  int divisions,
  double min,
  double max,
  String valueSuffix = '',
  Stream<double> stream,
  ValueChanged<double> onChanged,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      title: Text(title, textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,color: Colors.white)),
           SliderTheme(
            data: SliderThemeData(
            trackHeight: 6,),
              child:
              Slider(
                activeColor: Colors.red,
                inactiveColor: Colors.white,
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
           ),],
          ),
        ),
      ),
    ),
  );
}

class AudioMetadata {
  final String album;
  final String title;
  final String artwork;

  AudioMetadata({this.album, this.title, this.artwork});
}