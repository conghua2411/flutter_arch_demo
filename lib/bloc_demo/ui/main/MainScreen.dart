import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/bloc_demo/service/api/ApiBlocService.dart';
import 'package:flutter_arch_demo/bloc_demo/service/aws/aws_cognito.dart';
import 'package:flutter_arch_demo/bloc_demo/ui/auth/AuthScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'MainBloc.dart';
import 'MainEvent.dart';
import 'MainState.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  MainBloc _mainBloc;

  TextEditingController _changeNameController;

  @override
  void initState() {
    super.initState();

    _mainBloc = MainBloc(
        ImmutableProvider.of<ApiBlocService>(context),
        ImmutableProvider.of<AWSCognito>(context));

    _mainBloc.dispatch(GetDataUser());

    _changeNameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MAIN'),
      ),
      body: BlocListener(
        bloc: _mainBloc,
        listener: (context, state) {
          if (state is SignOutState) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => AuthScreen()),
                (Route<dynamic> route) => false);
          }
        },
        child: BlocBuilder(
            bloc: _mainBloc,
            builder: (context, state) {
              if (state is InitMain || state is LoadingMain) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is DataLoadFail) {
                return Center(
                  child: Text(state.error),
                );
              } else if (state is DataLoaded) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Flexible(
                      child: TextField(
                        controller: _changeNameController,
                        decoration: InputDecoration(hintText: 'change name'),
                      ),
                    ),
                    FlatButton(
                      color: Colors.blue,
                      child: Text('changeName'),
                      onPressed: () {
                        _mainBloc
                            .dispatch(ChangeName(_changeNameController.text));
                      },
                    ),

                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(state.mainData.pictureUrl ==
                                          null ||
                                      state.mainData.pictureUrl.isEmpty
                                  ? "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/220px-User_icon_2.svg.png"
                                  : state.mainData.pictureUrl))),
                    ),
                    Text(state.mainData.name),
                    Text(state.mainData.description),
                    Text(
                        '${state.mainData.receivedCertificates} : badges | ${state.mainData.amountOfMinedCAT} : CAT'),
                    FlatButton(
                      color: Colors.blue,
                      child: Text('signOut'),
                      onPressed: () {
                        _mainBloc.dispatch(SignOut());
                      },
                    ),
                  ],
                );
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
