import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter_arch_demo/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AWSCognito {
  CognitoUserPool _cognitoUserPool = CognitoUserPool(Constants.AWS_USER_POOL_ID, Constants.AWS_CLIENT_ID);

  CognitoUserSession _cognitoUserSession;

  getCognitoUserPool() => _cognitoUserPool;

  setCognitoUserSession(CognitoUserSession cognitouserSession) {
    _cognitoUserSession = cognitouserSession;
  }

  getCognitoUserSession() => _cognitoUserSession;

  signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CognitoUser cognitoUser = CognitoUser(prefs.getString('currentUsername'), _cognitoUserPool);
    prefs.clear();
    return cognitoUser.signOut();
  }
}