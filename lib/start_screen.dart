import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  bool _vibrate = false;
  bool _sound = true;

  void _loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vibrate = (prefs.getBool('vibrate') ?? false);
      _sound = (prefs.getBool('sound') ?? true);
      //_nightMode = (prefs.getBool('nightMode') ?? false);
    });
  }

  void toggleVibrationMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vibrate = !_vibrate;
      prefs.setBool('vibrate', _vibrate);
      //print(_vibrate);
    });
  }

  void toggleSoundMode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sound = !_sound;
      prefs.setBool('sound', _sound);
      //print(_sound);
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //setupAll();
    _loadValues();
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final Color kBgColor = _nightMode ? Colors.black : Colors.white;
    double screenWidth = MediaQuery.of(context).size.width / 100;
    const Color kTextColor = Colors.white;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBackground(
        behaviour: BubblesBehaviour(),
        vsync: this,
        child: Padding(
          padding: const EdgeInsets.only(top: 13.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: () {
                      toggleSoundMode();
                    },
                    icon: _sound
                        ? const Icon(
                            Icons.volume_up,
                            color: kTextColor,
                          )
                        : const Icon(
                            Icons.volume_off,
                            color: kTextColor,
                          ),
                    tooltip: 'Toggle Sound',
                  ),
                  IconButton(
                      onPressed: () {
                        toggleVibrationMode();
                      },
                      icon: _vibrate
                          ? const Icon(
                              Icons.vibration,
                              color: kTextColor,
                            )
                          : const Icon(
                              Icons.smartphone,
                              color: kTextColor,
                            ),
                      tooltip: 'Toggle Vibration'),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/about');
                      },
                      icon: const Icon(
                        Icons.info_outline,
                        color: kTextColor,
                      ),
                      tooltip: 'About App'),
                ],
              ),
              const Divider(
                color: Colors.white,
                endIndent: 20.0,
                indent: 20.0,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/second');
                  },
                  child: Column(
                    children: [
                      const SizedBox(height: 20.0),
                      const Text(
                        'Instructions:',
                        style: TextStyle(
                            color: kTextColor,
                            fontSize: 21.0,
                            letterSpacing: 2.0,
                            overflow: TextOverflow.ellipsis,
                            fontFamily: 'Orbitron',
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10.0),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  '>Enemies of humanity are trying to escape into the wide Universe using advanced Camouflage tech! They are effectively invisible!!\n\n'
                                  '>We need you to use your AI Augmented Brain\'s mutated sense to help us hunt our enemies, So that we can bring them down!\n\n'
                                  '>Pan with your finger and try to find the camouflaged ship, upon finding, long press to fire laser canon at it.\n\n'
                                  '>You can choose to have haptics and/or audio feedback for your power-up or just stick to visual feedback from options available above.\n\n'
                                  'Happy hunting, space ranger!',
                                  maxLines: 40,
                                  style: TextStyle(
                                      color: kTextColor,
                                      fontSize:
                                          MediaQuery.of(context).orientation ==
                                                  Orientation.portrait
                                              ? screenWidth * 4.3
                                              : 8,
                                      wordSpacing: 2.0,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'Orbitron',
                                      letterSpacing: 1.0),
                                ),
                              ),
                              Align(
                                child: Text(
                                  '...press anywhere to play...',
                                  style: TextStyle(
                                    letterSpacing: 2.0,
                                    color: kTextColor,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                alignment: Alignment.bottomCenter,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
