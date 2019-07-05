import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/bloc_demo/service/aws/aws_cognito.dart';
import 'package:flutter_arch_demo/bloc_demo/ui/auth/AuthScreen.dart';
import 'package:flutter_arch_demo/bloc_demo/ui/main/MainScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'SplashBloc.dart';
import 'SplashEvent.dart';
import 'SplashState.dart';

class SplashScreen extends StatefulWidget {
  @override
  State createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  SplashBloc _splashBloc;

  @override
  void initState() {
    super.initState();
    _splashBloc =
        SplashBloc(awsCognito: ImmutableProvider.of<AWSCognito>(context));

    Future.delayed(Duration(seconds: 1), () {
      _splashBloc.dispatch(SignInEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
          bloc: _splashBloc,
          listener: (context, state) {
            if (state is SignInSuccess) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => MainScreen()),
                  (Route<dynamic> route) => false);
            } else {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => AuthScreen()),
                  (Route<dynamic> route) => false);
            }
          },
          child: Center(
            child: Text('splashScreen'),
          )),
    );
  }
}
