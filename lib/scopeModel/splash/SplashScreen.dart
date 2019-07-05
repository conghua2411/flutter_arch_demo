import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/data/ApiService.dart';
import 'package:flutter_arch_demo/scopeModel/di/service_locator.dart';
import 'package:scoped_model/scoped_model.dart';

import 'SplashViewModel.dart';

class SplashScreen extends StatelessWidget {

  final SplashViewModel splashViewModel = SplashViewModel();

  @override
  Widget build(BuildContext context) {

    ApiService apiService = locator<ApiService>();

    return ScopedModel (
      model: splashViewModel,
      child: Scaffold(
        body: Center(
          child: Text('splashScreen model'),
        ),
      ),
    );
  }
}