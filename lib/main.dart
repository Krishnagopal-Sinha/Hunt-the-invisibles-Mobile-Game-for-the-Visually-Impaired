import 'start_screen.dart';
import 'package:flutter/material.dart';
import 'about_screen.dart';
import 'game_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: Colors.white)),
      initialRoute: '/first',
      routes: {
        '/about': (context) => const AboutApp(),
        '/second': (context) => const GamePage(),
        '/first': (context) => const StartScreen()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
