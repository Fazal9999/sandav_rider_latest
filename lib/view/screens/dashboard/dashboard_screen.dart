import 'dart:async';

import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/controller/order_controller.dart';
import 'package:sandav/fragments/orders_fragment.dart';
import 'package:sandav/fragments/setting_fragment.dart';
import 'package:sandav/helper/responsive_helper.dart';
import 'package:sandav/screens/user_home_screen.dart';
import 'package:sandav/util/dimensions.dart';
import 'package:sandav/view/base/cart_widget.dart';
import 'package:sandav/view/screens/cart/cart_screen.dart';
import 'package:sandav/view/screens/chat/conversation_screen.dart';
import 'package:sandav/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:sandav/view/screens/dashboard/widget/running_order_view_widget.dart';
import 'package:sandav/view/screens/favourite/favourite_screen.dart';
import 'package:sandav/view/screens/home/home_screen.dart';
import 'package:sandav/view/screens/menu/menu_screen.dart';
import 'package:sandav/view/screens/order/order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sandav/view/screens/wallet/wallet_screen.dart';

import '../../../fragments/dashboard_fragment.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();
  bool _canExit = GetPlatform.isWeb ? true : false;
  int _selectedIndex = 0;
  var _pages = <Widget>[
    DashboardFragment(),
    OrderScreen(),
    ConversationScreen(),
    //InboxFragment(),
    CartScreen(fromNav: true),
    SettingFragment(),
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });
    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

//     _screens = [
//       DashboardFragment(),
//       OrderScreen(),
//       //InboxFragment(),
//       WalletScreen(
//         fromWallet: true,
//       ),
// //customer.jks
//       ConversationScreen(),
//       SettingFragment(),
//     ];

    Future.delayed(Duration(seconds: 1), () {
      setState(() {});
    });

    /*if(GetPlatform.isMobile) {
      NetworkInfo.checkConnectivity(_scaffoldKey.currentContext);
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (_canExit) {
            return true;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('back_press_again_to_exit'.tr,
                  style: TextStyle(color: Colors.white)),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
              margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            ));
            _canExit = true;
            Timer(Duration(seconds: 2), () {
              _canExit = false;
            });
            return false;
          }
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        // floatingActionButton:
        //     GetBuilder<OrderController>(builder: (orderController) {
        //   return ResponsiveHelper.isDesktop(context)
        //       ? SizedBox()
        //       : (orderController.isRunningOrderViewShow &&
        //               (orderController.runningOrderList != null &&
        //                   orderController.runningOrderList.length > 0))
        //           ? SizedBox.shrink()
        //           : FloatingActionButton(
        //               elevation: 5,
        //               backgroundColor: _pageIndex == 2
        //                   ? Theme.of(context).primaryColor
        //                   : Theme.of(context).cardColor,
        //               onPressed: () => _setPage(2),
        //               child: CartWidget(
        //                   color: _pageIndex == 2
        //                       ? Theme.of(context).cardColor
        //                       : Theme.of(context).disabledColor,
        //                   size: 30),
        //             );
        // }),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: ResponsiveHelper.isDesktop(context)
            ? SizedBox()
            : GetBuilder<OrderController>(builder: (orderController) {
                return (orderController.isRunningOrderViewShow &&
                        (orderController.runningOrderList != null &&
                            orderController.runningOrderList.length > 0))
                    ? RunningOrderViewWidget()
                    :
                    // BottomAppBar(
                    //     elevation: 5,
                    //     notchMargin: 5,
                    //     clipBehavior: Clip.antiAlias,
                    //     shape: CircularNotchedRectangle(),
                    //     child: Padding(
                    //       padding: EdgeInsets.all(0),
                    //       child: Row(children: [
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         BottomNavItem(
                    //           iconData: Icons.home_outlined,
                    //           isSelected: _pageIndex == 0,
                    //           onTap: () => _setPage(0),
                    //           label: "Home",
                    //         ),

                    //         BottomNavItem(
                    //           iconData: Icons.shopping_cart_outlined,
                    //           isSelected: _pageIndex == 1,
                    //           onTap: () => _setPage(1),
                    //           label: "Orders",
                    //         ),
                    //         BottomNavItem(
                    //           iconData: Icons.account_balance_wallet_outlined,
                    //           isSelected: _pageIndex == 2,
                    //           onTap: () => _setPage(2),
                    //           label: "Wallet",
                    //         ),
                    //         // Expanded(child: SizedBox()),
                    //         BottomNavItem(
                    //             iconData: Icons.message_outlined,
                    //             isSelected: _pageIndex == 3,
                    //             onTap: () => _setPage(3),
                    //             label: "Inbox"),
                    //         BottomNavItem(
                    //           iconData: Icons.person_outline,
                    //           isSelected: _pageIndex == 4,
                    //           onTap: () {
                    //             // Get.bottomSheet(MenuScreen(),
                    //             //     backgroundColor: Colors.transparent,
                    //             //     isScrollControlled: true);
                    //             _setPage(4);
                    //           },
                    //           label: "Profile",
                    //         ),
                    //       ]),
                    //     ),
                    //   );
                    _bottomTab();
              }),
        body: Center(child: _pages.elementAt(_selectedIndex)),
        // PageView.builder(
        //   controller: _pageController,
        //   itemCount: _screens.length,
        //   physics: NeverScrollableScrollPhysics(),
        //   itemBuilder: (context, index) {
        //     return _screens[index];
        //   },
        // ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _bottomTab() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(color: Get.iconColor),
      selectedItemColor: Get.iconColor,
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
            label: 'Chat'),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag),
          activeIcon: Icon(Icons.shopping_bag),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile'),
      ],
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
