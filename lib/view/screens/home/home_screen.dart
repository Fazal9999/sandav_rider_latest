import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:delivery_man/controller/auth_controller.dart';
import 'package:delivery_man/controller/notification_controller.dart';
import 'package:delivery_man/controller/order_controller.dart';
import 'package:delivery_man/helper/price_converter.dart';
import 'package:delivery_man/helper/route_helper.dart';
import 'package:delivery_man/util/dimensions.dart';
import 'package:delivery_man/util/images.dart';
import 'package:delivery_man/util/styles.dart';
import 'package:delivery_man/view/base/confirmation_dialog.dart';
import 'package:delivery_man/view/base/custom_alert_dialog.dart';
import 'package:delivery_man/view/base/custom_snackbar.dart';
import 'package:delivery_man/view/base/order_shimmer.dart';
import 'package:delivery_man/view/base/order_widget.dart';
import 'package:delivery_man/view/base/title_widget.dart';
import 'package:delivery_man/view/screens/home/widget/count_card.dart';
import 'package:delivery_man/view/screens/home/widget/earning_widget.dart';
import 'package:delivery_man/view/screens/order/running_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  bool serviceEnabled;
  LocationPermission permission;
  Future<void> _loadData() async {
    check_location();
    Get.find<OrderController>().getIgnoreList();
    Get.find<OrderController>().removeFromIgnoreList();
    await Get.find<AuthController>().getProfile();
    await Get.find<OrderController>().getCurrentOrders();
    await Get.find<NotificationController>().getNotificationList();
    bool _isBatteryOptimizationDisabled = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    if(!_isBatteryOptimizationDisabled) {
      DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
    }
  }
Future<void> check_location() async {
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Get.snackbar('', 'Location Permission Denied');
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }
  return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}
  @override
  Widget build(BuildContext context) {
    _loadData();
    return Scaffold(

      body:
      RefreshIndicator(
        onRefresh: () async {
          return await _loadData();
        },
        child:
        SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 3,horizontal: 20),
          child: GetBuilder<AuthController>(builder: (authController) {
            return Column(children: [
              GetBuilder<OrderController>(builder: (orderController) {
                bool _hasActiveOrder = orderController.currentOrderList == null || orderController.currentOrderList.length > 0;
                bool _hasMoreOrder = orderController.currentOrderList != null && orderController.currentOrderList.length > 1;
                return Column(children: [
                  _hasActiveOrder ? TitleWidget(
                    title: 'active_order'.tr, onTap: _hasMoreOrder ? () {
                      Get.toNamed(RouteHelper.getRunningOrderRoute(), arguments: RunningOrderScreen());
                    } : null,
                  ) : SizedBox(),
                  SizedBox(height: _hasActiveOrder ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0),
                  orderController.currentOrderList == null ? OrderShimmer(
                    isEnabled: orderController.currentOrderList == null,
                  ) : orderController.currentOrderList.length > 0 ? OrderWidget(
                    orderModel: orderController.currentOrderList[0], isRunningOrder: true, orderIndex: 0,
                  ) : SizedBox(),
                  SizedBox(height: _hasActiveOrder ? Dimensions.PADDING_SIZE_DEFAULT : 0),
                ]);
              }),

              (authController.profileModel != null && authController.profileModel.earnings == 1) ? Column(children: [
               // TitleWidget(title: 'earnings'.tr),
                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Container(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Image.asset(Images.wallet, width: 60, height: 60),
                      SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          'balance'.tr,
                          style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).cardColor),
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        authController.profileModel != null ? Text(
                          PriceConverter.convertPrice(authController.profileModel.balance),
                          style: robotoBold.copyWith(fontSize: 24, color: Theme.of(context).cardColor),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ) : Container(height: 30, width: 60, color: Colors.white),
                      ]),
                    ]),
                    SizedBox(height: 30),
                    Row(children: [
                      EarningWidget(
                        title: 'today'.tr,
                        amount: authController.profileModel != null ? authController.profileModel.todaysEarning : null,
                      ),
                      Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                      EarningWidget(
                        title: 'this_week'.tr,
                        amount: authController.profileModel != null ? authController.profileModel.thisWeekEarning : null,
                      ),
                      Container(height: 30, width: 1, color: Theme.of(context).cardColor),
                      EarningWidget(
                        title: 'this_month'.tr,
                        amount: authController.profileModel != null ? authController.profileModel.thisMonthEarning : null,
                      ),
                    ]),
                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
              ]) : SizedBox(),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Row(children: [
                Expanded(child: CountCard(
                  title: 'todays_orders'.tr, backgroundColor: Theme.of(context).secondaryHeaderColor, height: 180,
                  value: authController.profileModel != null ? authController.profileModel.todaysOrderCount.toString() : null,
                )),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Expanded(child: CountCard(
                  title: 'this_week_orders'.tr, backgroundColor: Theme.of(context).errorColor, height: 180,
                  value: authController.profileModel != null ? authController.profileModel.thisWeekOrderCount.toString() : null,
                )),
              ]),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              CountCard(
                title: 'total_orders'.tr, backgroundColor: Theme.of(context).primaryColor, height: 140,
                value: authController.profileModel != null ? authController.profileModel.orderCount.toString() : null,
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              CountCard(
                title: 'cash_in_your_hand'.tr, backgroundColor: Colors.green, height: 140,
                value: authController.profileModel != null
                    ? PriceConverter.convertPrice(authController.profileModel.cashInHands) : null,
              ),

              /*TitleWidget(title: 'ratings'.tr),
              SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
              Container(
                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Text('my_ratings'.tr, style: robotoMedium.copyWith(
                    fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white,
                  ))),
                  GetBuilder<AuthController>(builder: (authController) {
                    return Shimmer(
                      duration: Duration(seconds: 2),
                      enabled: authController.profileModel == null,
                      color: Colors.grey[500],
                      child: Column(children: [
                        Row(children: [
                          authController.profileModel != null ? Text(
                            authController.profileModel.avgRating.toString(),
                            style: robotoBold.copyWith(fontSize: 30, color: Colors.white),
                          ) : Container(height: 25, width: 40, color: Colors.white),
                          Icon(Icons.star, color: Colors.white, size: 35),
                        ]),
                        authController.profileModel != null ? Text(
                          '${authController.profileModel.ratingCount} ${'reviews'.tr}',
                          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white),
                        ) : Container(height: 10, width: 50, color: Colors.white),
                      ]),
                    );
                  }),
                ]),
              ),*/

            ]);
          }),
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
