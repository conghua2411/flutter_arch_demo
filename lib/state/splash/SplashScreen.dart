import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/state/Auth/AuthScreen.dart';
import 'package:flutter_arch_demo/state/confirm/ConfirmScreen.dart';
import 'package:flutter_arch_demo/state/main/MainScreen.dart';
import 'package:flutter_arch_demo/utils/AWSCognito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:amazon_cognito_identity_dart/cognito.dart';

class SplashScreen extends StatefulWidget {
  @override
  State createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      decideNextScreen();
    });
  }

  Future decideNextScreen() async {
    await Future.delayed(Duration(seconds: 2));

    // check login
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.get('currentUsername') ?? "";
    String password = prefs.get('currentPassword') ?? "";

    if (username.isEmpty || password.isEmpty) {
      // goto SignIn-SignUp
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => AuthScreen()));
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
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      } catch (e) {
        if (e is CognitoClientException) {
          switch (e.code) {
            case "UserNotConfirmedException":
              // goto confirm screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ConfirmScreen()));
              break;
            case "UserNotFoundException":
              //goto signin
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AuthScreen()));
              break;
            case "NotAuthorizedException":
              //goto signin
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => AuthScreen()));
              break;
            default:
              print(e.message);
              break;
          }
        } else {
          print(e.toString());
        }
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('plashScreen123'),
      ),
    );
  }
}
