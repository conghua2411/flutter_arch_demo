import 'package:equatable/equatable.dart';

abstract class  SplashState extends Equatable {
  SplashState([List props = const []]) : super(props);
}

class Init extends SplashState {}

class Waiting extends SplashState {}

class SignInSuccess extends SplashState {}

class SignInFailed extends SplashState {
  String error;
  SignInFailed({this.error}): super([error]);
}

class NeedConfirm extends SplashState {}