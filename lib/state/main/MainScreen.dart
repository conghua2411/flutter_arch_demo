import 'package:flutter/material.dart';
import 'package:flutter_arch_demo/data/ApiService.dart';
import 'package:flutter_arch_demo/data/model/badge.dart';
import 'package:flutter_arch_demo/data/model/creator.dart';
import 'package:graphql/client.dart';

class MainScreen extends StatefulWidget {
  @override
  State createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  ApiService apiService = ApiService();

  String pictureUrl = '';
  String name = '';
  int receivedCertificates = 0;
  int amountOfMinedCAT = 0;
  String description = '';

  List<Badge> badges = List();

  @override
  void initState() {
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: 100,),
          FlatButton(
            child: Text('edit profile'),
            onPressed: changeName,
          ),
          Container(
            width: 200.0,
            height: 200.0,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: pictureUrl == null || pictureUrl.isEmpty
                        ? NetworkImage(
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/1/12/User_icon_2.svg/220px-User_icon_2.svg.png")
                        : NetworkImage(pictureUrl))),
          ),
          Text(name),
          Text('$receivedCertificates : badges | $amountOfMinedCAT : CAT'),
          Expanded(
            child: ListView.builder(
                itemCount: badges.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      badges[index].toString(),
                      style: TextStyle(
                        color: Color(int.parse(
                                badges[index].textColor.substring(1, 7),
                                radix: 16) +
                            0xFF000000),
                        backgroundColor: Color(int.parse(
                                badges[index].backgroundColor.substring(1, 7),
                                radix: 16) +
                            0xFF000000),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future getData() async {
    QueryResult result = await apiService.getUserInfo();

    // parse data
    setState(() {
      pictureUrl = result.data['user']['picture'];
      name = result.data['user']['name'];

      receivedCertificates = result.data['user']['receivedCertificates'];
      amountOfMinedCAT = result.data['user']['amountOfMinedCAT'];

      description = result.data['user']['description'];

      for (var badge in result.data['user']['certifications']) {
        badges.add(Badge(
          id: badge['badge']['id'],
          name: badge['badge']['name'],
          backgroundColor: badge['badge']['backgroundColor'],
          textColor: badge['badge']['textColor'],
          imageUrl: badge['badge']['imageUrl'],
          description: badge['badge']['description'],
          creator: Creator(
              id: badge['badge']['creator']['id'],
              name: badge['badge']['creator']['name'],
              nickname: badge['badge']['creator']['nickname']),
        ));
      }
    });
  }

  Future changeName() async {
    QueryResult result = await apiService.changeUserName(name + "1");

    setState(() {
      name = result.data['updateUserSetting']['name'];
    });
  }
}
