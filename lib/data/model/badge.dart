import 'package:meta/meta.dart';

import 'creator.dart';

class Badge {
  String id;
  String name;
  String backgroundColor;
  String textColor;
  String imageUrl;
  String description;
  Creator creator;

  Badge(
      {@required this.id,
      @required this.name,
      @required this.backgroundColor,
      @required this.textColor,
      @required this.imageUrl,
      @required this.description,
      @required this.creator});
}
