import 'package:sandav/commons/AppTheme.dart';
import 'package:sandav/commons/constants.dart';
import 'package:sandav/screens/flash_screen.dart';
import 'package:sandav/store/AppStore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/screens/flash_screen.dart';

import 'commons/AppTheme.dart';
import 'commons/constants.dart';

import 'helper/get_di.dart' as di;

import 'dart:async';
import 'dart:io';
import 'package:sandav/controller/auth_controller.dart';
import 'package:sandav/controller/cart_controller.dart';
import 'package:sandav/controller/localization_controller.dart';
import 'package:sandav/controller/location_controller.dart';
import 'package:sandav/controller/splash_controller.dart';
import 'package:sandav/controller/theme_controller.dart';
import 'package:sandav/controller/wishlist_controller.dart';
import 'package:sandav/data/model/body/notification_body.dart';
import 'package:sandav/helper/notification_helper.dart';
import 'package:sandav/helper/responsive_helper.dart';
import 'package:sandav/helper/route_helper.dart';
// import 'package:sandav/theme/dark_theme.dart';
// import 'package:sandav/theme/light_theme.dart';
import 'package:sandav/util/app_constants.dart';
import 'package:sandav/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = new MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: 'AIzaSyCeaw_gVN0iQwFHyuF8pQ6PbVDmSVQw8AY',
      appId: '1:1049699819506:web:a4b5e3bedc729aab89956b',
      messagingSenderId: '1049699819506',
      projectId: 'stackfood-bd3ee',
    ));
  } else {
    await Firebase.initializeApp();
  }

  Map<String, Map<String, String>> _languages = await di.init();

  NotificationBody _body;

  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        _body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (e) {}

  // if (ResponsiveHelper.isWeb()) {
  //   FacebookAuth.i.webInitialize(
  //     appId: "452131619626499",
  //     cookie: true,
  //     xfbml: true,
  //     version: "v9.0",
  //   );
  // }

  //region Entry Point
  WidgetsFlutterBinding.ensureInitialized();

  await initialize();

  appStore.toggleDarkMode(value: getBoolAsync(isDarkModeOnPref));

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  ).then((_) {
    return runApp(MyApp(languages: _languages, body: _body));
  });
}

AppStore appStore = AppStore();

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>> languages;
  final NotificationBody body;
  const MyApp({Key key, this.body, this.languages}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState(languages, body);
}
//Latest Code Pushed By Fazal-ur-Rehman
class _MyAppState extends State<MyApp> {
  final Map<String, Map<String, String>> languages;
  final NotificationBody body;

  _MyAppState(this.languages, this.body);
  void _route() {
    Get.find<SplashController>().getConfigData().then((bool isSuccess) async {
      if (isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
          await Get.find<WishListController>().getWishList();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      if (Get.find<LocationController>().getUserAddress() != null &&
          (Get.find<LocationController>().getUserAddress().zoneIds == null ||
              Get.find<LocationController>().getUserAddress().zoneData ==
                  null)) {
        Get.find<AuthController>().clearSharedAddress();
      }
      Get.find<CartController>().getCartData();
      _route();
    }

    // return GetBuilder<ThemeController>(builder: (themeController) {
    return GetBuilder<LocalizationController>(builder: (localizeController) {
      return GetBuilder<SplashController>(builder: (splashController) {
        return (GetPlatform.isWeb && splashController.configModel == null)
            ? SizedBox()
            : GetMaterialApp(
                title: AppConstants.APP_NAME,
                debugShowCheckedModeBanner: false,
                navigatorKey: Get.key,
                scrollBehavior: MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.touch
                  },
                ),
                // theme: themeController.darkTheme ? dark : light,
                theme: AppThemeData.lightTheme,
                darkTheme: AppThemeData.darkTheme,
                themeMode:
                    appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
                locale: localizeController.locale,
                translations: Messages(languages: languages),
                fallbackLocale: Locale(AppConstants.languages[0].languageCode,
                    AppConstants.languages[0].countryCode),
                initialRoute: GetPlatform.isWeb
                    ? RouteHelper.getInitialRoute()
                    : RouteHelper.getSplashRoute(body),
                getPages: RouteHelper.routes,
                defaultTransition: Transition.topLevel,
                transitionDuration: Duration(milliseconds: 500),
              );
      });
    });
    // });

    // return Observer(
    //   builder: (_) => MaterialApp(
    //     scrollBehavior: SBehavior(),
    //     navigatorKey: navigatorKey,
    //     title: APP_NAME,
    //     debugShowCheckedModeBanner: false,
    //     theme: AppThemeData.lightTheme,
    //     darkTheme: AppThemeData.darkTheme,
    //     themeMode: appStore.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
    //     home: FlashScreen(),
    //   ),
    // );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
