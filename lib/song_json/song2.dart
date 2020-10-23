import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../music_files/music2.dart';
import 'artist.dart';

class MyHomePage4 extends StatelessWidget {
  String hk;

  MyHomePage4(this.hk);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MusicCategory>>(
        future: fetchMusicCategory(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ?  MyApp5(this.hk, music: snapshot.data)
              : Center(child: CircularProgressIndicator());

        },
      ),
    );
  }
}