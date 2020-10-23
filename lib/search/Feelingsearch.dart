import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/song_json/artist.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../info_files/ColorsSys.dart';
import '../info_files/Strings.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp2(),
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

class MyApp2 extends StatefulWidget {

  @override
  _MyAppState2 createState() => _MyAppState2();
}

class _MyAppState2 extends State<MyApp2> {
  bool _hasSpeech = false;
  String usernameController='Energetic';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20),
            child:new Container(
                width: 370,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: .26,
                        spreadRadius: 0.0 * 1.5,
                        color: Colors.black.withOpacity(1))
                  ],
                  color: Colors.white30,
                  borderRadius:
                  BorderRadius.all(Radius.circular(20)),
                ),
                child: DropdownButton<String>(
                  value: this.usernameController,
                  icon: Icon(Icons.arrow_downward,color: Colors.white,),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  isDense: true,
                  itemHeight: 500,
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.black12,
                  onChanged: (String newValue) {
                    usernameController=newValue.toUpperCase();
                    if(newValue=="Happy"||newValue=="Good"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Artist("Energetic".toUpperCase())),
                      );
                    }
                    if(newValue=="Tired"||newValue=="Bad"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Artist("Calm".toUpperCase())),
                      );
                    }
                    if(newValue=="Sad"){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Artist("Dreamy".toUpperCase())),
                      );
                    }
                    if(newValue=="Energetic"||newValue=="Dreamy"||newValue=="Calm"||newValue=="Joyful") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Artist(usernameController)),
                      );
                    }
                  },
                  items: <String>['Dreamy', 'Joyful', 'Energetic', 'Calm','Bad','Good','Happy','Sad']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text("        "+value+"  ",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold),),
                    );
                  }).toList(),
                )),
          ),
        ],
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
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.center ,
                          children:<Widget> [
                            InkWell(child:
                            Text(
                              "I feel like   ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            ),
                            InkWell(child:
                            Text(
                              lastWords,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,color: Colors.red,decoration: TextDecoration.underline,
                              ),
                            ),
                              onTap: () {
                                var s=lastWords;
                                if(s=="Happy"||s=="Good"){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Artist("Energetic".toLowerCase())),
                                  );
                                }
                                if(s=="Tired"||s=="Bad"){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Artist("Calm".toLowerCase())),
                                  );
                                }
                                if(s=="Sad"){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Artist("Dreamy".toLowerCase())),
                                  );
                                }
                                if(s=="Energetic"||s=="Dreamy"||s=="Calm"||s=="Joyful") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Artist(s.toLowerCase())),
                                  );
                                }
                                else{
                                  _onAlertButtonPressed(context);
                                }
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
                          child: IconButton(icon: Icon(Icons.adjust),onPressed: _hasSpeech ? null : initSpeechState,iconSize: 50,color: Colors.red,),
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
                          child: IconButton(icon: Icon(Icons.mic),onPressed: !_hasSpeech || speech.isListening
                              ? null
                              : startListening,iconSize: 50,),
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
                          child: IconButton(icon: Icon(Icons.cancel),onPressed: speech.isListening ? stopListening : null,iconSize: 50,color: Colors.red,),
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
          color: Theme.of(context).backgroundColor,
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
  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "ALLOWED WORDS",
      desc: """
Happy
Sad
Energetic
Dreamy
Calm
Tired
Joyful
Good/Bad
      """,
      buttons: [
        DialogButton(
          child: Text(
            "COOL",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}