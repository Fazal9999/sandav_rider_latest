import 'dart:async';
import 'package:delivery_man/controller/auth_controller.dart';
import 'package:delivery_man/controller/splash_controller.dart';
import 'package:delivery_man/data/model/body/notification_body.dart';
import 'package:delivery_man/helper/route_helper.dart';
import 'package:delivery_man/util/app_constants.dart';
import 'package:delivery_man/util/dimensions.dart';
import 'package:delivery_man/util/images.dart';
import 'package:delivery_man/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../store/AppStore.dart';
import '../../../util/no_internet_screen.dart';


class SplashScreen extends StatefulWidget {
  final NotificationBody body;
  SplashScreen({ this.body});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection' : 'connected',
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    Get.find<SplashController>().initSharedData();
    _route();

  }

  @override
  void dispose() {
    super.dispose();

    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) {
      if(isSuccess) {
        Timer(Duration(seconds: 1), () async {
          if(Get.find<SplashController>().configModel.maintenanceMode) {
            Get.offNamed(RouteHelper.getUpdateRoute(false));
          }else {
            if(widget.body != null) {
              if (widget.body.notificationType == NotificationType.order) {
                Get.offNamed(RouteHelper.getOrderDetailsRoute(widget.body.orderId));
              }else if(widget.body.notificationType == NotificationType.order_request){
                Get.toNamed(RouteHelper.getMainRoute('order-request'));
              }else if(widget.body.notificationType == NotificationType.general){
                Get.toNamed(RouteHelper.getNotificationRoute());
              } else {
                Get.toNamed(RouteHelper.getChatRoute(notificationBody: widget.body, conversationId: widget.body.conversationId));
              }
            }else{
              if (Get.find<AuthController>().isLoggedIn()) {
                Get.find<AuthController>().updateToken();
                await Get.find<AuthController>().getProfile();
                Get.offNamed(RouteHelper.getInitialRoute());
              } else {
                // if(AppConstants.languages.length > 1 && Get.find<SplashController>().showLanguageIntro()){
                //   Get.offNamed(RouteHelper.getLanguageRoute('splash'));
                // }else{
                //   Get.offNamed(RouteHelper.getSignInRoute());
                // }
                Get.offNamed(RouteHelper.getSignInRoute());
              }
            }
          }
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.logo, width: 150,
                color: Colors.black,
                

              ),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              //Image.asset(Images.logo_name, width: 150),
              /*SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
            Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),*/
            ],
          )
              : NoInternetScreen(child: SplashScreen(body: widget.body)),
        );
      }),
    );
  }
}