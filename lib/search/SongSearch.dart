import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import '../info_files/ColorsSys.dart';
import '../info_files/Strings.dart';
import '../song_json/artist.dart';
import '../song_json/song2.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp3(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    _pageController = PageController(
        initialPage: 0
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20, top: 20),
              child: new InkWell(
                onTap: (){Navigator.pop(context);},
                child: new Text('Skip', style: TextStyle(
                    color: ColorSys.gray,
                    fontSize: 18,
                    fontWeight: FontWeight.w400
                ),
                ),
              )
          ),],
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          PageView(
            onPageChanged: (int page) {
              setState(() {
                currentIndex = page;
              });
            },
            controller: _pageController,
            children: <Widget>[
              makePage(
                  image: 'images/mood.png',
                  title: Strings.stepOneTitle,
                  content: Strings.stepOneContent
              ),
              makePage(
                  reverse: true,
                  image: 'images/say.png',
                  title: Strings.stepTwoTitle,
                  content: Strings.stepTwoContent
              ),
              makePage(
                  image: 'images/radio.png',
                  title: Strings.stepThreeTitle,
                  content: Strings.stepThreeContent
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 60),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicator(),
            ),
          )
        ],
      ),
    );
  }

  Widget makePage({image, title, content, reverse = false}) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !reverse ?
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(image),
              ),
              SizedBox(height: 30,),
            ],
          ) : SizedBox(),
          Text(title, style: TextStyle(
              color: ColorSys.primary,
              fontSize: 30,
              fontWeight: FontWeight.bold
          ),),
          SizedBox(height: 20,),
          Text(content, textAlign: TextAlign.center, style: TextStyle(
              color: ColorSys.gray,
              fontSize: 20,
              fontWeight: FontWeight.w400
          ),),
          reverse ?
          Column(
            children: <Widget>[
              SizedBox(height: 30,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Image.asset(image),
              ),
            ],
          ) : SizedBox(),
        ],
      ),
    );
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: ColorSys.secoundry,
          borderRadius: BorderRadius.circular(5)
      ),
    );
  }

  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i<3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }

    return indicators;
  }
}

String lastWords='';

class MyApp3 extends StatefulWidget {

  @override
  _MyAppState3 createState() => _MyAppState3();
}

class _MyAppState3 extends State<MyApp3> {
  bool _hasSpeech = false;
  String usernameController = 'Energetic';
  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();


  @override
  void initState() {
    super.initState();
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!mounted) return;

    setState(() {
      _hasSpeech = hasSpeech;
    });
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
         Padding(
          padding: EdgeInsets.only(right: 20),
          child: new Container(
            width: 370,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                boxShadow: [
                BoxShadow(
                    blurRadius: .26,
                    spreadRadius: level * 1.5,
                    color: Colors.black.withOpacity(1))
                ],
            color: Colors.white30,
            borderRadius:
            BorderRadius.all(Radius.circular(20)),
            ),
            child:Container(
              width: 335.0,
              height: 335.0,
              child: new TextField(
                cursorColor: Colors.white ,
                decoration: new InputDecoration(
                  icon: new Icon(Icons.search,color:Colors.white)),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    if(value.isNotEmpty && value !=" ") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage4(value)),
                      );
                    }
                    else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BlurryDialog(value)),
                      );
                    }
                  },
                     style: TextStyle(
                      fontSize: 15.0,
                      height: 3.0,
                      color: Colors.white
                  )
              )
          ),
                      ))],
      ),
      body: Column(children: [

        Expanded(
          flex: 4,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              child:
                            Text(
                              "What song do you listen?",
                              style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            ),
                            SizedBox(height: 8.0,),
                            InkWell(child:
                            Text(
                              lastWords,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                              onTap: () {
                                var word = lastWords;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                    builder: (context) => MyHomePage4(word.toUpperCase())),
                                  );
                              },
                            ),
                          ],),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: .26,
                                  spreadRadius: level * 1.5,
                                  color: Colors.black.withOpacity(.05))
                            ],
                            color: Colors.white30,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.adjust),
                            onPressed: _hasSpeech ? null : initSpeechState,
                            iconSize: 50,
                            color: Colors.red,),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: .26,
                                  spreadRadius: level * 1.5,
                                  color: Colors.black.withOpacity(.05))
                            ],
                            color: Colors.white30,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(icon: Icon(Icons.mic),
                            onPressed: !_hasSpeech || speech.isListening
                                ? null
                                : startListening,
                            iconSize: 50,),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      bottom: 10,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: .26,
                                  spreadRadius: level * 1.5,
                                  color: Colors.black.withOpacity(.05))
                            ],
                            color: Colors.white30,
                            borderRadius:
                            BorderRadius.all(Radius.circular(50)),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: speech.isListening
                                ? stopListening
                                : null,
                            iconSize: 50,
                            color: Colors.red,),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 30),
          color: Theme
              .of(context)
              .backgroundColor,
          child: Center(
            child: speech.isListening
                ? Text(
              "I'm listening...",
              style: TextStyle(fontWeight: FontWeight.bold),
            )
                : Text(
              'Not listening',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );},
          child: Icon(Icons.info),
      backgroundColor: Colors.red,
      ),
    );
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void startListening() {
    lastWords = "";
    lastError = "";
    speech.listen(
      onResult: resultListener,
      localeId: _currentLocaleId,
      cancelOnError: true,
      partialResults: true,
    );
    setState(() {});
  }

  void stopListening() {
    speech.stop();
    setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result) {
    setState(() {
      lastWords = "${result.recognizedWords}";
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // print("sound level $level: $minSoundLevel - $maxSoundLevel ");
    setState(() {
      this.level = level;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    // print("Received error status: $error, listening: ${speech.isListening}");
    setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    // print(
    // "Received listener status: $status, listening: ${speech.isListening}");
    setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
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
