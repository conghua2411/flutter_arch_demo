import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  SplashEvent([List props = const []]): super(props);
}

class LoadingEvent extends SplashEvent {}

class SignInEvent extends SplashEvent {}