import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/bloc_demo/service/aws/aws_cognito.dart';
import 'package:flutter_arch_demo/bloc_demo/ui/main/MainScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'AuthBloc.dart';
import 'AuthEvent.dart';
import 'AuthState.dart';

class AuthScreen extends StatefulWidget {
  @override
  State createState() => AuthScreenState();
}

class AuthScreenState extends State<AuthScreen> {
  AuthBloc _authBloc;

  TextEditingController _usernameController, _passwordController;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController();
    _passwordController = TextEditingController();

    _authBloc = AuthBloc(ImmutableProvider.of<AWSCognito>(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth'),
      ),
      body: BlocListener(
        bloc: _authBloc,
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MainScreen()),
                (Route<dynamic> route) => false);
          } else if (state is Loading) {
            print('loading');
          } else {
            print('hello');
          }
        },
        child: BlocBuilder(
            bloc: _authBloc,
            builder: (context, state) {
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Flexible(
                        child: TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(hintText: 'username'),
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(hintText: 'password'),
                        ),
                      ),
                      FlatButton(
                        child: Text('signin'),
                        onPressed: () {
                          _authBloc.dispatch(SignIn(
                              username: _usernameController.text,
                              password: _passwordController.text));
                        },
                      ),
                    ],
                  ),
                  Opacity(
                    opacity: state is Loading ? 1.0 : 0.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
