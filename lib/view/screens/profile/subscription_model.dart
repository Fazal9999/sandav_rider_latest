import 'package:flutter/cupertino.dart';

class SubscriptionModel {
  String name;
  String country;
  String img;

  Color backgroundColor;
  Color bannerColor;
  String userImg;

  SubscriptionModel({this.name, this.img,
    this.backgroundColor, this.bannerColor, this.userImg, this.country});
}
