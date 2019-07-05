import 'package:equatable/equatable.dart';

import 'MainData.dart';

abstract class MainState extends Equatable {
  MainState([List props = const []]) : super(props);
}

class InitMain extends MainState {}

class LoadingMain extends MainState {}

class DataLoadFail extends MainState {
  String error;

  DataLoadFail({this.error = ""});
}

class DataLoaded extends MainState {
  MainData mainData;

  DataLoaded(this.mainData) : super([mainData]);

}

class ChangedNameSuccess extends MainState {
  String name;

  ChangedNameSuccess(this.name) : super([name]);
}

class SignOutState extends MainState {}