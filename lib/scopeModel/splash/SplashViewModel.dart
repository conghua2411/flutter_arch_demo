import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter_arch_demo/data/ApiService.dart';
import 'package:flutter_arch_demo/utils/AWSCognito.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel extends Model {
  String nextScreen = 'SplashScreen';

  ApiService apiService;

  SplashViewModel() {
    apiService = ApiService();
  }

  Future choseNextScreen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String username = prefs.get('currentUsername') ?? '';
    String password = prefs.get('currentPassword') ?? '';

    if (username.isEmpty || password.isEmpty) {
      nextScreen = 'AuthScreen';
    } else {
      // try signin
      CognitoUser cognitoUser = CognitoUser(username, AWSCognito.AWSUserPool);

      AuthenticationDetails authenticationDetails =
          AuthenticationDetails(username: username, password: password);

      try {
        AWSCognito.setCognitoUserSession(
            await cognitoUser.authenticateUser(authenticationDetails));

        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString('currentIdToken',
            AWSCognito.getCognitoUserSession().idToken.getJwtToken());
        prefs.setString('currentAccessToken',
            AWSCognito.getCognitoUserSession().accessToken.getJwtToken());

        // goto main
        nextScreen = 'MainScreen';
      } catch (e) {
        if (e is CognitoClientException) {
          switch (e.code) {
            case "UserNotConfirmedException":
              // goto confirm screen
              nextScreen = 'ConfirmScreen';
              break;
            case "UserNotFoundException":
              //goto signin
              nextScreen = 'AuthScreen';
              break;
            case "NotAuthorizedException":
              //goto signin
              nextScreen = 'AuthScreen';
              break;
            default:
              print(e.message);
              break;
          }
        } else {
          print(e.toString());
        }
        notifyListeners();
        return;
      }
      notifyListeners();
    }
  }
}
