import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/state/confirm/ConfirmScreen.dart';
import 'package:flutter_arch_demo/state/main/MainScreen.dart';
import 'package:flutter_arch_demo/utils/AWSCognito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  @override
  State createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  double opacityIndicator = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("AuthScreen"),
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: 'username',
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: 'password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  RaisedButton(
                    child: Text('signin'),
                    onPressed: signIn,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  RaisedButton(
                    child: Text('signup'),
                    onPressed: signUp,
                  ),
                ],
              ),
            ),
            Center(
              child: Opacity(
                opacity: opacityIndicator,
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ));
  }

  Future signIn() async {

    setState(() {
      opacityIndicator = 1.0;
    });

    CognitoUser cognitoUser =
        CognitoUser(_usernameController.text, AWSCognito.AWSUserPool);

    AuthenticationDetails authenticationDetails = AuthenticationDetails(
        username: _usernameController.text, password: _passwordController.text);

    try {
      AWSCognito.setCognitoUserSession(
          await cognitoUser.authenticateUser(authenticationDetails));

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('currentUsername', _usernameController.text);
      prefs.setString('currentPassword', _passwordController.text);

      prefs.setString('currentIdToken',
          AWSCognito.getCognitoUserSession().idToken.getJwtToken());
      prefs.setString('currentAccessToken',
          AWSCognito.getCognitoUserSession().accessToken.getJwtToken());

      // goto main
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
    } catch (e) {
      print(e.toString());
      setState(() {
        opacityIndicator = 0.0;
      });
    }
  }

  Future signUp() async {
    setState(() {
      opacityIndicator = 1.0;
    });

    CognitoUserPoolData data;
    try {
      data = await AWSCognito.AWSUserPool.signUp(
          _usernameController.text, _passwordController.text);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('currentUsername', _usernameController.text);
      prefs.setString('currentPassword', _passwordController.text);

      if (data.userConfirmed) {
        //goto main
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      } else {
        //goto confirm
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ConfirmScreen()));
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        opacityIndicator = 0.0;
      });
    }
  }
}
