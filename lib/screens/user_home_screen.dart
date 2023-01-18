import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:get/get_utils/src/platform/platform.dart';
import 'package:sandav/controller/splash_controller.dart';
import 'package:sandav/fragments/dashboard_fragment.dart';
import 'package:sandav/fragments/inbox_fragment.dart';
import 'package:sandav/fragments/orders_fragment.dart';
import 'package:sandav/fragments/setting_fragment.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/view/screens/cart/cart_screen.dart';
import 'package:sandav/view/screens/chat/conversation_screen.dart';
import 'package:sandav/view/screens/wallet/wallet_screen.dart';

import '../controller/order_controller.dart';
import '../helper/responsive_helper.dart';

class UserScreenHome extends StatefulWidget {
  final int pageIndex;

  const UserScreenHome({@required this.pageIndex, Key key}) : super(key: key);

  @override
  State<UserScreenHome> createState() => _UserScreenHomeState();
}

class _UserScreenHomeState extends State<UserScreenHome> {
  int _selectedIndex = 0;
  var _pages = <Widget>[
    DashboardFragment(),
    OrderFragment(),
    //InboxFragment(),
    CartScreen(fromNav: true),
    ConversationScreen(),
    SettingFragment(),
  ];

  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
  }

  // if(GetPlatform.isMobile) {
  //     NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
  //   }

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(color: context.iconColor),
      selectedItemColor: context.iconColor,
      unselectedLabelStyle: TextStyle(color: gray),
      iconSize: 20,
      unselectedItemColor: gray,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Orders'),
        BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message_sharp),
            label: 'Inbox'),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet_outlined),
          activeIcon: Icon(Icons.account_balance_wallet),
          label: 'Wallet',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile'),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
        child: Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: GetBuilder<OrderController>(
        builder: (orderController) {
          return ResponsiveHelper.isDesktop(context)
              ? SizedBox()
              : (orderController.isRunningOrderViewShow &&
                      (orderController.runningOrderList != null &&
                          orderController.runningOrderList.length > 0))
                  ? SizedBox.shrink()
                  : _bottomTab();
        },
      ),
      body: Center(child: _pages.elementAt(_selectedIndex)),
    ));
  }
}
