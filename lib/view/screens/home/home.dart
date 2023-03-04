import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/notification_controller.dart';
import '../../../controller/order_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../data/model/body/db4category.dart';
import '../../../helper/route_helper.dart';
import '../../../util/T13Constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/confirmation_dialog.dart';
import '../../base/custom_alert_dialog.dart';
import '../../base/custom_snackbar.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  static String tag = '/Home';
  @override
  HomeState createState() => HomeState();
}
class HomeState extends State<Home> {
  bool passwordVisible = false;
  bool isRemember = false;
  var currentIndexPage = 0;
  List<Db4Category> mFavouriteList;
  List<Db4Slider> mSliderList;
  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    width = width - 50;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Images.db4_colorPrimary,
        leading: Container(
          padding: EdgeInsets.all(10),
          child:
          Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: Image.network(
                  '${Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}'
                      '/${Get.find<AuthController>().profileModel != null ?
                  Get.find<AuthController>().profileModel.image : ''}',

                ),
              ),

            ],
          ),
        ),
        titleSpacing: 0, elevation: 0,
        /*title: Text(AppConstants.APP_NAME, maxLines: 1, overflow: TextOverflow.ellipsis, style: robotoMedium.copyWith(
          color: Theme.of(context).textTheme.bodyText1.color, fontSize: Dimensions.FONT_SIZE_DEFAULT,
        )),*/
        //title: Image.asset(Images.logo_name, width: 120),
        actions: [
          IconButton(
            icon: GetBuilder<NotificationController>(builder: (notificationController) {
              bool _hasNewNotification = false;
              if(notificationController.notificationList != null) {
                _hasNewNotification = notificationController.notificationList.length
                    != notificationController.getSeenNotificationCount();
              }
              return Stack(children: [
                Icon(Icons.notifications, size: 25, color:Colors.white),
                _hasNewNotification ? Positioned(top: 0, right: 0, child: Container(
                  height: 10, width: 10, decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, shape: BoxShape.circle,
                  border: Border.all(width: 1, color: Theme.of(context).cardColor),
                ),
                )) : SizedBox(),
              ]);
            }),
            onPressed: () => Get.toNamed(RouteHelper.getNotificationRoute()),
          ),
          GetBuilder<AuthController>(builder: (authController) {
            return GetBuilder<OrderController>(builder: (orderController) {
              return (authController.profileModel != null && orderController.currentOrderList != null) ?
              FlutterSwitch(
                width: 75, height: 30, valueFontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, showOnOff: true,
                activeText: 'online'.tr, inactiveText: 'offline'.tr, activeColor: Theme.of(context).primaryColor,
                value: authController.profileModel.active == 1, onToggle: (bool isActive) async {
                if(!isActive && orderController.currentOrderList.length > 0) {
                  showCustomSnackBar('you_can_not_go_offline_now'.tr);
                }else {
                  if(!isActive) {
                    Get.dialog(ConfirmationDialog(
                      icon: Images.warning, description: 'are_you_sure_to_offline'.tr,
                      onYesPressed: () {
                        Get.back();
                        authController.updateActiveStatus();
                      },
                    ));
                  }else {
                    LocationPermission permission = await Geolocator.checkPermission();
                    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever
                        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
                      if(GetPlatform.isAndroid) {
                        Get.dialog(ConfirmationDialog(
                          icon: Images.location_permission,
                          iconSize: 200,
                          hasCancel: false,
                          description: 'this_app_collects_location_data'.tr,
                          onYesPressed: () {
                            Get.back();
                            _checkPermission(() => authController.updateActiveStatus());
                          },
                        ), barrierDismissible: false);
                      }else {
                        _checkPermission(() => authController.updateActiveStatus());
                      }
                    }else {
                      authController.updateActiveStatus();
                    }
                  }
                }
              },
              ) : SizedBox();
            });
          }),
          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        ],
      ),
      backgroundColor: Images.db4_colorPrimary,
      key: _scaffoldKey,
      body:
      SafeArea(
        child:
        Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(top: 8),
                alignment: Alignment.topLeft,
                height: MediaQuery.of(context).size.height - 100,
                decoration: BoxDecoration(color: db4_LayoutBackgroundWhite, borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 5),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(1.0),
                        child: HomeScreen(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

    );
  }

  void _checkPermission(Function callback) async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied
        || (GetPlatform.isIOS ? false : permission == LocationPermission.whileInUse)) {
      Get.dialog(CustomAlertDialog(description: 'you_denied'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.requestPermission();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else if(permission == LocationPermission.deniedForever) {
      Get.dialog(CustomAlertDialog(description: 'you_denied_forever'.tr, onOkPressed: () async {
        Get.back();
        await Geolocator.openAppSettings();
        _checkPermission(callback);
      }), barrierDismissible: false);
    }else {
      callback();
    }
  }
}
