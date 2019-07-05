import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_arch_demo/bloc_demo/service/aws/aws_cognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AuthEvent.dart';
import 'AuthState.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  AWSCognito awsCognito;

  AuthBloc(this.awsCognito);

  @override
  AuthState get initialState => InitAuth();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is SignIn) {
      yield Loading();
      yield await TrySignIn(event.username, event.password);
    } else {
      yield InitAuth();
    }
  }

  TrySignIn(String username, String password) async {
    // try sign in
    CognitoUser cognitoUser = CognitoUser(username, awsCognito.getCognitoUserPool());

    AuthenticationDetails authenticationDetails = AuthenticationDetails(username: username, password: password);

    try {
      awsCognito.setCognitoUserSession(
          await cognitoUser.authenticateUser(authenticationDetails)
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('currentUsername', username);
      prefs.setString('currentPassword', password);

      return SignInSuccess();
    } catch (e) {
      return SignInFail(e.toString());
    }
  }
}