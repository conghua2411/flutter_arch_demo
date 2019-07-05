import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/scopeModel/splash/SplashScreen.dart';
import 'di/service_locator.dart';


void main() {

  setupLocator();

  runApp(
      ScopeModelApp()
  );
}
class ScopeModelApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ScopeModel',
      home: SplashScreen(),
    );
  }
}