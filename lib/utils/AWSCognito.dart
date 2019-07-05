import 'package:amazon_cognito_identity_dart/cognito.dart';

import 'Constants.dart';

class AWSCognito {
  static CognitoUserPool AWSUserPool = CognitoUserPool(Constants.AWS_USER_POOL_ID, Constants.AWS_CLIENT_ID);

  static CognitoUserSession _AWSCognitoUserSession;

  static CognitoUserSession getCognitoUserSession() {
    if (_AWSCognitoUserSession == null) {
      return null;
    }
    return _AWSCognitoUserSession;
  }

  static void setCognitoUserSession(CognitoUserSession cognitoUserSession) {
    _AWSCognitoUserSession = cognitoUserSession;
  }
}