import 'dart:async';

import 'package:sandav/data/model/body/notification_body.dart';
import 'package:sandav/screens/walkthrough_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../commons/images.dart';
import '../store/AppStore.dart';
 
class FlashScreen extends StatefulWidget {
  const FlashScreen({Key key, NotificationBody body}) : super(key: key);

  @override
  State<FlashScreen> createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 2),
      () {
        WalkThroughScreen().launch(context, isNewTask: true);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image.asset(
                      car,
                       color: AppStore().isDarkModeOn? white : black,
                    ),),
    );
  }
}
