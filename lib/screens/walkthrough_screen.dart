import 'package:get/get_core/src/get_main.dart';
import 'package:sandav/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../commons/app_component.dart';
import '../commons/images.dart';
import '../controller/splash_controller.dart';
import '../helper/route_helper.dart';
import '../main.dart';
import '../store/AppStore.dart';
import '../util/styles.dart';
import 'package:get/get.dart';

class WalkThroughScreen extends StatefulWidget {
  const WalkThroughScreen({Key key}) : super(key: key);

  @override
  State<WalkThroughScreen> createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen>
    with SingleTickerProviderStateMixin {
  PageController pageController = PageController();
  int currentPage = 0;
  List<WalkThroughModelClass> list = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    list.add(WalkThroughModelClass(
        title: 'Select Store and get your Favorite Products', image: fav));
    list.add(WalkThroughModelClass(
        title: 'Order your product using card or one voucher payment method',
        image: easy));
    list.add(WalkThroughModelClass(
        title: 'Get your product delivered in less then 60 minutes.',
        image: delivery));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topRight,
        children: [
          PageView(
            controller: pageController,
            children: list.map((e) {
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      e.image.validate(),
                      // color: AppStore().isDarkModeOn? white : black,
                    ),
                    SizedBox(height: 20),
                    Text(e.title.validate(),
                        style: boldTextStyle(
                            size: 20, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center),
                  ],
                ),
              );
            }).toList(),
          ),
          Positioned(
            top: 24,
            child: TextButton(
              onPressed: () {
                // RegistrationScreen().launch(context, isNewTask: true);
                Get.find<SplashController>().disableIntro();
                // Get.offNamed(
                //     RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                RegistrationScreen().launch(context, isNewTask: true);
              },
              child: Text('Skip', style: primaryTextStyle()),
            ),
          ),
          Positioned(
            bottom: 130,
            right: 0,
            left: 0,
            child: DotIndicator(
              indicatorColor: AppStore().isDarkModeOn ? white : Colors.black,
              pageController: pageController,
              pages: list,
              currentDotSize: 24,
              boxShape: BoxShape.circle,
              currentDotWidth: 60,
              currentBoxShape: BoxShape.rectangle,
              unselectedIndicatorColor: Colors.grey.shade400,
              onPageChanged: (index) {
                setState(
                  () {
                    currentPage = index;
                  },
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 32,
            child: GestureDetector(
              onTap: () {
                if (currentPage == 2) {
                  // Get.find<SplashController>().disableIntro();
                  // Get.offNamed(
                  //     RouteHelper.getSignInRoute(RouteHelper.onBoarding));

                  Get.find<SplashController>().disableIntro();
                  // Get.offNamed(
                  //     RouteHelper.getSignInRoute(RouteHelper.onBoarding));
                  RegistrationScreen().launch(context, isNewTask: true);
                } else {
                  pageController.animateToPage(
                    currentPage + 1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                }
              },
              child: Visibility(
                visible: currentPage == 2 ? true : false,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: CircularBlackDecoration,
                  child:
                      Text("Get Started", style: boldTextStyle(color: white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
