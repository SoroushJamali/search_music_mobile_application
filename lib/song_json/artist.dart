import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/music_files/music.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:solid_bottom_sheet/solid_bottom_sheet.dart';
import '../main/main.dart';

Future<List<ArtistCategory>> fetchartistcategory(http.Client client) async {
  final response = await client.get('https://m.feelapp.website/artist.json');
  return compute(parseArtistCategory, response.body);

}

List<ArtistCategory> parseArtistCategory(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ArtistCategory>((json) => ArtistCategory.fromJson(json)).toList();
}
class ArtistCategory {
  final String title;
  final String image;
  final String emotion;

  ArtistCategory({ this.title, this.image,this.emotion});

  factory ArtistCategory.fromJson(Map<String, dynamic> json) {
    return ArtistCategory(
      title: json['title'],
      image: json['image'],
      emotion: json['emotion'],
    );
  }
}

class Artist extends StatelessWidget {

  String title;
  Artist( this.title, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<ArtistCategory>>(
        future: fetchartistcategory(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MyHomePage2(this.title,category: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
class MyHomePage2 extends StatefulWidget {
  String title;
  List<ArtistCategory> category;
  MyHomePage2(this.title, {this.category});

  @override
  State<StatefulWidget> createState() {
    return ArtistCategoryList(this.title,this.category);
  }
}
class ArtistCategoryList extends State<MyHomePage2> {

  final List<ArtistCategory> category;
  String title;
  ArtistCategoryList(this.title,this.category);
  SolidController _controller = SolidController();
  double level = 0.0;
  String p='';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: Scaffold(
            body: ListView.builder(
                  itemCount: category == null ? 0 : category.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (category[index].emotion.toUpperCase() == this.title) {
                      return Padding(padding: EdgeInsets.all(50.0), child:InkWell(
                        onTap: () {
                          setState(() {
                            p = category[index].title;
                          });
                        },
                        child: Container(
                          height: 250,
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(category[index].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: ClipRRect( // make sure we apply clip it properly
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.grey.withOpacity(0.05),
                                child: Text(
                                  category[index].title,
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),));
                    }
                    else {
                      return new Container();
                    }
                  }
              ),
            bottomSheet: (){if(p!=''){ return SolidBottomSheet(
              controller: _controller,
              draggableBody: true,
              maxHeight: 800,
              headerBar: Container(
                color: Theme.of(context).primaryColor,
                height: 50,
                child: Center(
                  child: Text(p.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                ),
              ),
              body: Album(p)
            );} else{
            };}(),
            floatingActionButton:  FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp_2()),
              );
    },
      child: Icon(Icons.assignment_return),
      backgroundColor: Colors.green,
    ),
        )
    );
  }

}


Future<List<Category>> fetchcategory(http.Client client) async {
  final response = await client.get('https://m.feelapp.website/album.json');
  return compute(parseCategory, response.body);

}

List<Category> parseCategory(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Category>((json) => Category.fromJson(json)).toList();
}
class Category {
  final String title;
  final String image;
  final String album;

  Category({ this.title, this.image,this.album});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      title: json['title'],
      image: json['image'],
      album: json['album'],
    );
  }
}

class Album extends StatelessWidget {

  String title;
  Album( this.title, {Key key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Category>>(
        future: fetchcategory(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? MyHomePage(this.title,category: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
class MyHomePage extends StatefulWidget {
  String title;
  List<Category> category;
  MyHomePage(this.title, {this.category});
  String p='';
  String a='';

  @override
  State<StatefulWidget> createState() {
    return CategoryList(this.title,this.category);
  }
}
class CategoryList extends State<MyHomePage> {
  SolidController _controller = SolidController();
  final List<Category> category;
  String title;
  CategoryList(this.title, this.category);
  double level = 0.0;
  bool open=false;
  String p='';
  String a='';

  @override
  Widget build(BuildContext context) {
      return new MaterialApp(
        home: Scaffold(

    body:  ListView.builder(
          itemCount: category == null ? 0 : category.length,
          itemBuilder: (BuildContext context, int index) {
            if (category[index].album.toUpperCase() == this.title.toUpperCase()) {
              return Padding(padding: EdgeInsets.all(50.0), child:InkWell(
                  onTap: () {
                    setState(() {
                        open=true;
                        p = category[index].album;
                        a = category[index].title;
                    });
                  },
                  child: Container(
                    height: 250,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(category[index].image),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ClipRRect( // make sure we apply clip it properly
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.grey.withOpacity(0.05),
                          child: Text(
                            category[index].title,
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),));
            }
            else {
              return new Container();
            }
          }
          ),
          bottomSheet: (){
            if(open!=false){
              return SolidBottomSheet(
                controller: _controller,
                draggableBody: true,
                maxHeight: 700,
                headerBar: Container(
                color: Theme.of(context).primaryColor,
                height: 50,
                child:
                  Center(
                    child: Text("Swipe me to Listen!",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                ),
                body: MyHomePage3(p,a)
            );
          }
          else{};}(),
        )

      );

  }
  }
class BlurryDialog extends StatelessWidget {

  String content;

  BlurryDialog(this.content);
  TextStyle textStyle = TextStyle (color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Container(child:_onBasicAlertPressed(context),);
  }
  _onBasicAlertPressed(context) {
    Alert(
      context: context,
      type: AlertType.error,
      style: AlertStyle(isCloseButton: false,isOverlayTapDismiss: false,),
      title: "Sorry",
      desc: "We could not find any music!!!",
      buttons: [
        DialogButton(
          child: Text(
            "OKAY",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () =>  Navigator.pop(context),
          color: Color.fromRGBO(91, 55, 185, 1.0),
          radius: BorderRadius.circular(10.0),
        ),
      ],
    ).show();
  }
}
Future<List<MusicCategory>> fetchMusicCategory(http.Client client) async {
  final response = await client.get('https://m.feelapp.website/songs.json');
  return compute(parseMusicCategory, response.body);

}

List<MusicCategory> parseMusicCategory(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<MusicCategory>((json) => MusicCategory.fromJson(json)).toList();
}

class MusicCategory {
  final String title;
  final String image;
  final String emotion;
  final String artist;
  final String category;
  final String album;
  final String assetUrl;

  MusicCategory({ this.title, this.image, this.emotion,this.album,this.artist,this.assetUrl,this.category});

  factory MusicCategory.fromJson(Map<String, dynamic> json) {
    return MusicCategory(
      title: json['title'],
      assetUrl: json['assetUrl'],
      category: json['category'],
      image: json['image'],
      emotion: json['emotion'],
      album: json['album'],
      artist: json['artist'],
    );
  }
}

class MyHomePage3 extends StatelessWidget {
  String album;
  String title;

  MyHomePage3(this.album,this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<MusicCategory>>(
        future: fetchMusicCategory(http.Client()),
        builder: (context, snapshot2) {
          if (snapshot2.hasError) print(snapshot2.error);

          return snapshot2.hasData
              ? MyApp2(this.album,this.title,music: snapshot2.data)
              : Center(child: CircularProgressIndicator());

        },
      ),
    );
  }
}




