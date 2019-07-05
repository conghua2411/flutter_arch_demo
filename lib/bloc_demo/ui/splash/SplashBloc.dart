import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_arch_demo/bloc_demo/service/aws/aws_cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SplashEvent.dart';
import 'SplashState.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {

  AWSCognito awsCognito;

  SplashBloc({this.awsCognito});

  @override
  SplashState get initialState => Init();

  @override
  Stream<SplashState> mapEventToState(SplashEvent event) async* {
    if (event is SignInEvent) {
      yield await checkLogin();
    }
  }

  checkLogin() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.get('currentUsername') ?? '';
    String password = prefs.get('currentPassword') ?? '';

    if (username.isEmpty || password.isEmpty) {
      return SignInFailed(error: "Have no user info");
    } else {
      // try sign in
      CognitoUser cognitoUser = CognitoUser(username, awsCognito.getCognitoUserPool());

      AuthenticationDetails authenticationDetails = AuthenticationDetails(username: username, password: password);

      try {
        awsCognito.setCognitoUserSession(
          await cognitoUser.authenticateUser(authenticationDetails)
        );

        return SignInSuccess();
      } catch (e) {
        if (e is CognitoClientException) {
          switch (e.code) {
            case "UserNotConfirmedException":
              return NeedConfirm();
            case "UserNotFoundException":
              return SignInFailed();
            case "NotAuthorizedException":
              return SignInFailed();
            default:
              print('SplashScreen: error: ${e.message}');
              return SignInFailed();
          }
        } else {
          print('SplashScreen: error: ${e.toString()}');
          return SignInFailed();
        }
      }
    }
  }
}