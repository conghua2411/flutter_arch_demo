import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/state/splash/SplashScreen.dart';

void main() {
  runApp(StateApp());
}

class StateApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StateArch',
      home: SplashScreen(),
    );
  }
}