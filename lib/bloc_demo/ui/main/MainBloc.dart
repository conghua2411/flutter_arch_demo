import 'package:bloc/bloc.dart';
import 'package:flutter_arch_demo/bloc_demo/service/api/ApiBlocService.dart';
import 'package:flutter_arch_demo/bloc_demo/service/aws/aws_cognito.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'MainData.dart';
import 'MainEvent.dart';
import 'MainState.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  ApiBlocService _apiService;
  AWSCognito _awsCognito;

  MainBloc(this._apiService, this._awsCognito);

  MainData _mainData;

  @override
  MainState get initialState => InitMain();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is GetDataUser) {
      yield await getUser();
    } else if (event is ChangeName) {
      yield LoadingMain();
      yield await changeName(event.name);
    } else if (event is SignOut) {
      yield signOut();
    } else {
      yield DataLoadFail(error: 'not handle event : $event');
    }
  }

  getUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      QueryResult result =
          await _apiService.getUserInfo(prefs.get('currentUsername'));

      Map<String, dynamic> picture = jsonDecode(_mainData.pictureUrl);

      print('picture : ${result.data['user']['picture']}');

      _mainData = MainData(
          result.data['user']['name'] ?? "",
          result.data['user']['picture'] ?? "",
          result.data['user']['receivedCertificates'] ?? 0,
          result.data['user']['amountOfMinedCAT'] ?? 0,
          result.data['user']['description'] ?? "");

      return DataLoaded(_mainData);
    } catch (e) {
      return DataLoadFail(error: e.toString());
    }
  }

  Future<MainState> changeName(String name) async {
    try {
      QueryResult result = await _apiService.changeUserName(name);

      _mainData.name = result.data['updateUserSetting']['name'] ?? "";

      return DataLoaded(_mainData);
    } catch (e) {
      return DataLoadFail(error: e.toString());
    }
  }

  signOut() {
    _awsCognito.signOut();
    return SignOutState();
  }
}
