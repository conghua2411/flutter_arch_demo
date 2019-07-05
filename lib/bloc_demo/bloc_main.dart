import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/bloc_demo/service/api/ApiBlocService.dart';
import 'package:flutter_arch_demo/bloc_demo/service/aws/aws_cognito.dart';
import 'package:flutter_arch_demo/bloc_demo/ui/splash/SplashScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(BlocApp());

class BlocApp extends StatefulWidget {
  @override
  State createState() => AppState();
}

class AppState extends State<BlocApp> {

  AWSCognito awsCognito;
  ApiBlocService apiBlocService;

  @override
  void initState() {
    super.initState();
    awsCognito = AWSCognito();
    apiBlocService = ApiBlocService(awsCognito);
  }

  @override
  Widget build(BuildContext context) {
    return ImmutableProviderTree(
      immutableProviders: [
        ImmutableProvider<ApiBlocService>(value: apiBlocService),
        ImmutableProvider<AWSCognito>(value: awsCognito)
      ],
      child: MaterialApp(
        home: SplashScreen(),
      ),
    );
  }
}
