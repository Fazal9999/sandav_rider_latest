import 'dart:async';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:delivery_man/controller/auth_controller.dart';
import 'package:delivery_man/controller/order_controller.dart';
import 'package:delivery_man/helper/notification_helper.dart';
import 'package:delivery_man/helper/route_helper.dart';
import 'package:delivery_man/util/dimensions.dart';
import 'package:delivery_man/view/base/custom_alert_dialog.dart';
import 'package:delivery_man/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:delivery_man/view/screens/dashboard/widget/new_request_dialog.dart';
import 'package:delivery_man/view/screens/home/home_screen.dart';
import 'package:delivery_man/view/screens/profile/profile_screen.dart';
import 'package:delivery_man/view/screens/request/order_request_screen.dart';
import 'package:delivery_man/view/screens/order/order_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../../../main.dart';
import '../home/home.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({ this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
   List<Widget> _screens;
  final _channel = const MethodChannel('sandav.delivery.man');
  StreamSubscription _stream;
  //Timer _timer;
  //int _orderCount;


  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    // _screens = [
    //   HomeScreen(),
    //   OrderRequestScreen(onTap: () => _setPage(0)),
    //   OrderScreen(),
    //   ProfileScreen(),
    // ];


    print('dashboard call');
     _stream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // if(Get.find<OrderController>().latestOrderList != null) {
      //   _orderCount = Get.find<OrderController>().latestOrderList.length;
      // }
      print("dashboard onMessage: ${message.data}/ ${message.data['type']}");
      String _type = message.notification.bodyLocKey;
      String _orderID = message.notification.titleLocKey;
      if(_type != 'assign' && _type != 'new_order' && _type != 'message' && _type != 'order_request'&& _type != 'order_status') {
        NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin);
      }
      /*Get.find<OrderController>().getCurrentOrders();
      Get.find<OrderController>().getLatestOrders();*/
      //Get.find<OrderController>().getAllOrders();
      if(_type == 'new_order') {
        //_orderCount = _orderCount + 1;
        Get.find<OrderController>().getCurrentOrders();
        Get.find<OrderController>().getLatestOrders();
        Get.dialog(NewRequestDialog(isRequest: true, onTap: () => _navigateRequestPage()));
      }else if(_type == 'assign' && _orderID != null && _orderID.isNotEmpty) {
        Get.find<OrderController>().getCurrentOrders();
        Get.find<OrderController>().getLatestOrders();
        Get.dialog(NewRequestDialog(isRequest: false, onTap: () => _setPage(0)));
      }else if(_type == 'block') {
        Get.find<AuthController>().clearSharedData();
        Get.find<AuthController>().stopLocationRecord();
        Get.offAllNamed(RouteHelper.getSignInRoute());
      }
    });

    // _timer = Timer.periodic(Duration(seconds: 30), (timer) async {
    //   await Get.find<OrderController>().getLatestOrders();
    //   int _count = Get.find<OrderController>().latestOrderList.length;
    //   if(_orderCount != null && _orderCount < _count) {
    //     Get.dialog(NewRequestDialog(isRequest: true, onTap: () => _navigateRequestPage()));
    //   }else {
    //     _orderCount = Get.find<OrderController>().latestOrderList.length;
    //   }
    // });

  }
  void changePage(int index) {
    setState(() {
      _pageIndex = index;
    });
  }
  //
  // HomeScreen(),
  // OrderRequestScreen(onTap: () => _setPage(0)),
  // OrderScreen(),
  // ProfileScreen(),
  Widget _getWidget() {
    if (_pageIndex == 0) {

      return Home();
    } else if (_pageIndex == 1) {
      return OrderRequestScreen(onTap: () => _setPage(0));
    }
    else if (_pageIndex == 2) {
      return OrderScreen();
    }
    else if (_pageIndex == 3) {
      return ProfileScreen();
    }

    return Home();
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   _timer?.cancel();
  // }

  void _navigateRequestPage() {
    if(Get.find<AuthController>().profileModel != null && Get.find<AuthController>().profileModel.active == 1
        && Get.find<OrderController>().currentOrderList != null && Get.find<OrderController>().currentOrderList.length < 1) {
      _setPage(1);
    }else {
      if(Get.find<AuthController>().profileModel == null || Get.find<AuthController>().profileModel.active == 0) {
        Get.dialog(CustomAlertDialog(description: 'you_are_offline_now'.tr, onOkPressed: () => Get.back()));
      }else {
        //Get.dialog(CustomAlertDialog(description: 'you_have_running_order'.tr, onOkPressed: () => Get.back()));
        _setPage(1);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();

    _stream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(_pageIndex != 0) {
          _setPage(0);
          return false;
        }else {
          if (GetPlatform.isAndroid && Get.find<AuthController>().profileModel.active == 1) {
            _channel.invokeMethod('sendToBackground');
            return false;
          } else {
            return true;
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: GetPlatform.isDesktop ? SizedBox() :
          BubbleBottomBar(
            opacity: .2,
            currentIndex: _pageIndex,
            onTap: changePage,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16),
            ), //border radius doesn't work when the notch is enabled.
            elevation: 8,
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.home,
                    color: Colors.black,
                  ),
                  title: Text("Home")

              ),
              BubbleBottomBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(
                    Icons.list_alt_rounded,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.list_alt_rounded,
                    color: Colors.black,
                  ),
                  title: Text("Request")),
              BubbleBottomBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(
                    Icons.shopping_bag,
                    color: Colors.black,
                  ),
                  activeIcon: Icon(
                    Icons.shopping_bag,
                    color: Colors.black,
                  ),
                  title: Text("Orders")),
              BubbleBottomBarItem(
                  backgroundColor: Colors.black,
                  icon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),

                  activeIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Text("Profile"))
            ],
          ),

        body: _getWidget(),

      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
