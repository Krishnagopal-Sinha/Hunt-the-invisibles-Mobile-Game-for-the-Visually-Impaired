import 'dart:async';
import 'package:animated_background/animated_background.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

double objPosx = 100.0;
double objPosy = 100.0;

//V Smooth curve
// class ShakeCurve extends Curve {
//   @override
//   double transform(double t) => sin(t * pi / 3);
// }

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  final ValueNotifier<Color> _colour = ValueNotifier<Color>(Colors.orange);
  double posX = 100.0;
  double posY = 100.0;
  bool takeTheShot = false;
  late AnimationController _controller;
  late AnimationController _controller2;
  late AnimationController _explosionController;
  double distance = 100.0;
  int score = 0;
  bool truGameStart = false;
  Timer zoneTime =
      Timer.periodic(const Duration(milliseconds: 15000), (timer) {});

  bool _vibrate = false;

  bool _sound = true;
  final playerX = AudioPlayer();
  final playerY = AudioPlayer();
  bool winnerAudioPlaying = false;
  void _loadValues() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _vibrate = (prefs.getBool('vibrate') ?? false);
      _sound = (prefs.getBool('sound') ?? true);
      //_nightMode = (prefs.getBool('nightMode') ?? false);
    });
  }

  @override
  void initState() {
    _loadValues();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.1,
    );
    _explosionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.0,
    );

    //Orientation Support
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // navigation bar color
      statusBarColor: Colors.black,
    ));
    _controller.dispose();
    _controller2.dispose();
    _explosionController.dispose();

    //reinforcing orientation for start screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // void _startAnimation() {
  //   _controller.stop();
  //   _controller.reset();
  //   _controller.repeat(
  //     period: const Duration(seconds: 1),
  //   );
  //   // _controller.forward();
  // }

  @override
  Widget build(BuildContext context) {
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2100),
      lowerBound: 0.1,
    )..repeat(reverse: true);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: AnimatedBackground(
          vsync: this,
          behaviour: SpaceBehaviour(),
          child: Stack(children: [
            Visibility(
              visible: takeTheShot,
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CustomPaint(
                  foregroundPainter: LinePainter(_controller),
                ),
              ),
            ),
            Positioned(
              bottom: -5,
              left: 50.0,
              right: 50.0,
              child: RotationTransition(
                turns: Tween(begin: -0.008, end: 0.008).animate(_controller2),
                child: Container(
                  color: Colors.transparent,
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/spaceship.png'),
                ),
              ),
            ),
            ValueListenableBuilder<Color>(
              valueListenable: _colour,
              builder: (BuildContext context, Color clr, Widget? child) {
                SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                  systemNavigationBarColor: clr, // navigation bar color
                  statusBarColor: clr,
                ));

                void zoneTimer(int time, String msg) {
                  if (_vibrate) {
                    zoneTime.cancel();
                    zoneTime =
                        Timer.periodic(Duration(milliseconds: time), (timer) {
                      HapticFeedback.lightImpact();
                      // print('$msg');
                    });
                  }
                }

                void killZoneTimer() {
                  zoneTime.cancel();
                }

                void audioFeedback(String fileName) async {
                  playerX.play(AssetSource('$fileName.wav'));
                  playerX.setReleaseMode(ReleaseMode.loop);
                }

                if (_sound && truGameStart) {
                  if (clr == Colors.orange) {
                    audioFeedback('quite_far');
                  } else if (clr == Colors.yellow) {
                    audioFeedback('less_far');
                  } else if (clr == Colors.blue) {
                    audioFeedback('very_close');
                  } else if (clr == Colors.green) {
                    playerX.setReleaseMode(ReleaseMode.stop);
                    playerX.play(AssetSource('winner.wav'));
                    winnerAudioPlaying = true;
                  }
                } else {
                  if (winnerAudioPlaying) {
                    winnerAudioPlaying = false;
                  } else {
                    playerX.stop();
                  }
                }

                if (truGameStart && _vibrate) {
                  if (clr == Colors.orange) {
                    zoneTimer(
                        900, 'ORANGEORANGEORANGEORANGEORANGEORANGEORANGE');
                  } else if (clr == Colors.yellow) {
                    zoneTimer(700, 'YELLOWYELLOWYELLOWYELLOWYELLOW');
                  } else if (clr == Colors.blue) {
                    zoneTimer(500, 'BLUEBLUEBLUEBLUE');
                  } else if (clr == Colors.green) {
                    zoneTimer(250, 'GREEN');
                  }
                } else {
                  killZoneTimer();
                }

                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    void newObjPosition() async {
                      _controller.forward();

                      await Future.delayed(const Duration(milliseconds: 200));
                      setState(() {
                        takeTheShot = false;
                      });
                      _explosionController.forward(from: 0.00);

                      await Future.delayed(const Duration(milliseconds: 900));
                      Random random = Random();
                      double x1 = constraints.maxWidth - 10;
                      double y1 = constraints.maxHeight - 10;
                      objPosx = random.nextInt(x1.toInt()).toDouble();
                      objPosy = random.nextInt(y1.toInt()).toDouble();
                      //print('X: $objPosx, Y: $objPosy');
                      _controller.reset();
                      score++;
                    }

                    return GestureDetector(
                      //Winning Condition and Celebration Event
                      onLongPress: () {
                        if (distance <= 40) {
                          HapticFeedback.heavyImpact();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            playerY.play(AssetSource('nextone.wav'));
                          });

                          // const snackBar = SnackBar(
                          //     duration: Duration(milliseconds: 600),
                          //     content: Text('Locking on Target!'));
                          // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          const snackBar2 = SnackBar(
                              duration: Duration(milliseconds: 1000),
                              content: Text('Target destroyed, Good job!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar2);

                          const snackBar3 = SnackBar(
                              duration: Duration(milliseconds: 1000),
                              content: Text('Onwards to the next one!'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar3);

                          setState(() {
                            takeTheShot = true;
                          });

                          //Game reset
                          _colour.value = Colors.orange;
                          newObjPosition();
                          distance = 100.0;
                        }
                      },
                      onPanUpdate: (DragUpdateDetails details) {
                        posX = details.localPosition.dx;
                        posY = details.localPosition.dy;
                        // print('$posX $posY');

                        distance = sqrt(
                            pow(objPosx - posX, 2) + pow(objPosy - posY, 2));
                        //print('Distance: $distance');
//Visual feedback
                        if (distance <= 40 && _colour.value != Colors.green) {
                          _colour.value = Colors.green;
                        } else if (distance <= 100 &&
                            distance > 40 &&
                            _colour.value != Colors.blue) {
                          _colour.value = Colors.blue;
                        } else if (distance <= 300 &&
                            distance > 100 &&
                            _colour.value != Colors.yellow) {
                          _colour.value = Colors.yellow;
                        } else if (distance > 300 &&
                            _colour.value != Colors.orange) {
                          _colour.value = Colors.orange;
                        }
                      },
                      onPanStart: (DragStartDetails details) {
                        setState(() {
                          truGameStart = true;
                        });
                      },
                      onPanEnd: (DragEndDetails details) {
                        setState(() {
                          truGameStart = false;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Stack(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, right: 12.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Text(
                                  '$score',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Orbitron',
                                    fontSize: 21.0,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                left: objPosx,
                                top: objPosy,
                                child: Container(
                                  height: 40.0,
                                  width: 40.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    //color: Colors.white,
                                  ),
                                )),
                            Positioned(
                              left: objPosx - 210,
                              top: objPosy - 250,
                              child: SizedBox(
                                height: 500,
                                width: 500,
                                child: Lottie.asset(
                                  'assets/explosion.json',
                                  controller: _explosionController,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  late final Animation<double> _animation;
  Color laserClr = Colors.green;
  LinePainter(this._animation) : super(repaint: _animation);
  @override
  void paint(Canvas canvas, Size size) {
    if (_animation.value >= 0.15 && !_animation.isCompleted) {
      laserClr = Colors.red;
    } else {
      laserClr = Colors.green;
    }

    final paint = Paint()
      ..strokeWidth = 2
      ..color = laserClr
      ..strokeCap = StrokeCap.round;

    //bottom right line
    canvas.drawLine(Offset(objPosx / 1 - 35 + 80, objPosy / 1 - 35 + 80),
        Offset(size.width * 16 / 24, size.height * 1), paint);
    //bottom left line
    canvas.drawLine(Offset(objPosx / 1 - 35, objPosy / 1 - 35 + 80),
        Offset(size.width * 8 / 24, size.height * 1), paint);

    paint;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
