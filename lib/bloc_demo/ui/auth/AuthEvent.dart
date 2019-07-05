import 'package:equatable/equatable.dart';

class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

class SignIn extends AuthEvent {
  String username;
  String password;

  SignIn({this.username, this.password}) : super([username, password]);
}
