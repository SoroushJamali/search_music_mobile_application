import 'package:flutter/material.dart';
import '../search/Feelingsearch.dart';
import '../search/SongSearch.dart';

String lastWords='';

void main() => runApp(MaterialApp(home: MyApp_2()));

class MyApp_2 extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp_2> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    MyApp2(),
    MyApp3()
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.insert_emoticon,color: Colors.white,),
            title: Text('Emotion',style: TextStyle(color: Colors.white),),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.library_music,color: Colors.white),
            title: Text('Song Name',style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }

}


class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}