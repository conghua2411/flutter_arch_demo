import 'package:equatable/equatable.dart';

abstract class MainEvent extends Equatable {
  MainEvent([List props = const []]) : super(props);
}

class GetDataUser extends MainEvent {}

class ChangeName extends MainEvent {
  String name;

  ChangeName(this.name) : super([name]);
}

class SignOut extends MainEvent {}