import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  AuthState([List props = const []]) : super(props);
}

class InitAuth extends AuthState {}

class Loading extends AuthState {}

class SignInSuccess extends AuthState {}

class SignInFail extends AuthState {
  String error;
  SignInFail(this.error) : super([error]);
}