import 'package:googleapis/games/v1.dart';
import 'package:sandav/commons/widgets.dart';
import 'package:sandav/controller/cart_controller.dart';
import 'package:sandav/controller/wishlist_controller.dart';
import 'package:sandav/helper/responsive_helper.dart';
import 'package:sandav/helper/route_helper.dart';
import 'package:sandav/main.dart';
import 'package:sandav/controller/auth_controller.dart';
import 'package:sandav/screens/login_with_pass_screen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/util/app_constants.dart';
import 'package:sandav/util/styles.dart';
import 'package:sandav/view/base/confirmation_dialog.dart';
import 'package:sandav/view/base/custom_image.dart';
import 'package:sandav/view/screens/address/address_screen.dart';
import 'package:sandav/view/screens/auth/restaurant_registration_screen.dart';
import 'package:sandav/view/screens/coupon/coupon_screen.dart';
import 'package:sandav/view/screens/html/html_viewer_screen.dart';
import 'package:sandav/view/screens/profile/widget/profile_button.dart';
import 'package:sandav/view/screens/profile/widget/profile_card.dart';
import 'package:sandav/view/screens/refer_and_earn/refer_and_earn_screen.dart';
import 'package:sandav/view/screens/support/support_screen.dart';
import 'package:sandav/view/screens/wallet/wallet_screen.dart';

import '../commons/images.dart';
import '../controller/splash_controller.dart';
import '../controller/user_controller.dart';
import '../helper/price_converter.dart';
import '../store/AppStore.dart';
import 'package:get/get.dart';

import '../util/dimensions.dart';
import '../util/html_type.dart';
import '../view/screens/auth/registration_details_screen.dart';

class SettingFragment extends StatefulWidget {
  @override
  _SettingFragmentState createState() => _SettingFragmentState();
}

class _SettingFragmentState extends State<SettingFragment> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isLoggedIn = Get.find<AuthController>().isLoggedIn();

    if (_isLoggedIn && Get.find<UserController>().userInfoModel == null) {
      Get.find<UserController>().getUserInfo();
    }
  }

  void init() async {
    //
  }
  var appStore = AppStore();

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    final bool _showWalletCard =
        Get.find<SplashController>().configModel.customerWalletStatus == 1 ||
            Get.find<SplashController>().configModel.loyaltyPointStatus == 1;

    return Scaffold(
        // appBar: careaAppBarWidget(
        //   context,
        //   titleText: "Profile",
        //   actionWidget: IconButton(
        //       onPressed: () {}, icon: Icon(Icons.chat, color: Get.iconColor)),
        // ),
        body: GetBuilder<UserController>(builder: (userController) {
        return (_isLoggedIn && userController.userInfoModel == null)
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    _isLoggedIn
                        ? Stack(
                            children: [
                              CustomImage(
                                      image:
                                          '${Get.find<SplashController>().configModel.baseUrls.customerImageUrl}'
                                          '/${(userController.userInfoModel != null && _isLoggedIn) ? userController.userInfoModel.image : ''}',
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover)
                                  .cornerRadiusWithClipRRect(60),
                              // Positioned(
                              //   right: 0,
                              //   bottom: 0,
                              //   child: Container(
                              //     alignment: Alignment.center,
                              //     padding: EdgeInsets.all(6),
                              //     decoration: BoxDecoration(
                              //       color: Colors.black,
                              //       border: Border.all(
                              //           color: Colors.black.withOpacity(0.3)),
                              //       borderRadius: BorderRadius.circular(8),
                              //     ),
                              //     child:
                              //         Icon(Icons.edit, color: white, size: 16),
                              //   ).onTap(() {
                              //     // ProfileScreen().launch(context);
                              //       userController.pickImage();
                              //   }
                              //   ),
                              //),
                            ],
                          )
                        : SizedBox(),
                    SizedBox(height: 16),
                    Text(
                        _isLoggedIn
                            ? '${userController.userInfoModel.fName} ${userController.userInfoModel.lName}'
                            : 'Guest'.tr,
                        style: boldTextStyle(size: 18)),
                    SizedBox(height: 8),
                    Text(
                        _isLoggedIn
                            ? '${userController.userInfoModel.phone}'
                            : 'No Phone Found'.tr,
                        style: secondaryTextStyle()),
                    SizedBox(height: 16),
                    Divider(height: 0),
                    SizedBox(height: 30),
                    _isLoggedIn
                        ? Column(children: [
                            Row(children: [
                              ProfileCard(
                                  title: 'since_joining'.tr,
                                  data:
                                      '${userController.userInfoModel.memberSinceDays} ${'days'.tr}'),
                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                              ProfileCard(
                                  title: 'total_order'.tr,
                                  data: userController.userInfoModel.orderCount
                                      .toString()),
                            ]),
                            SizedBox(
                                height: _showWalletCard
                                    ? Dimensions.PADDING_SIZE_SMALL
                                    : 0),
                            _showWalletCard
                                ? Row(children: [
                                    Get.find<SplashController>()
                                                .configModel
                                                .customerWalletStatus ==
                                            1
                                        ? ProfileCard(
                                            title: 'wallet_amount'.tr,
                                            data: PriceConverter.convertPrice(
                                                userController.userInfoModel
                                                    .walletBalance),
                                          )
                                        : SizedBox.shrink(),
                                    SizedBox(
                                        width: Get.find<SplashController>()
                                                        .configModel
                                                        .customerWalletStatus ==
                                                    1 &&
                                                Get.find<SplashController>()
                                                        .configModel
                                                        .loyaltyPointStatus ==
                                                    1
                                            ? Dimensions.PADDING_SIZE_SMALL
                                            : 0.0),
                                    Get.find<SplashController>()
                                                .configModel
                                                .loyaltyPointStatus ==
                                            1
                                        ? ProfileCard(
                                            title: 'loyalty_points'.tr,
                                            data: userController.userInfoModel
                                                        .loyaltyPoint !=
                                                    null
                                                ? userController
                                                    .userInfoModel.loyaltyPoint
                                                    .toString()
                                                : '0',
                                          )
                                        : SizedBox.shrink(),
                                  ])
                                : SizedBox(),
                          ])
                        : SizedBox(),
                    SizedBox(height: _isLoggedIn ? 30 : 0),
                    SizedBox(height: 16),
                    _isLoggedIn
                        ? SettingItemWidget(
                            leading: Icon(Icons.person_outline,
                                color: Get.iconColor),
                            title: "Edit Profile",
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              // ProfileScreen().launch(context);
                              Get.toNamed(RouteHelper.getUpdateProfileRoute());
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),
                    //SizedBox(height: 16),
                    _isLoggedIn
                        ? SettingItemWidget(
                            leading: Icon(Icons.person_outline,
                                color: Get.iconColor),
                            title: "Delete Account",
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              Get.dialog(
                                  ConfirmationDialog(
                                    icon:  support,
                                    title: 'are_you_sure_to_delete_account'.tr,
                                    description:
                                        'it_will_remove_your_all_information'
                                            .tr,
                                    isLogOut: true,
                                    onYesPressed: () =>
                                        userController.removeUser(),
                                  ),
                                  useSafeArea: false);
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),
                    _isLoggedIn
                        ? SettingItemWidget(
                            leading: Icon(Icons.lock, color: Get.iconColor),
                            title: "Change Password",
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              //ProfileScreen().launch(context);
                              Get.toNamed(RouteHelper.getResetPasswordRoute(
                                  '', '', 'password-change'));
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),
                    _isLoggedIn
                        ? SettingItemWidget(
                            leading: Icon(Icons.location_on_outlined,
                                color: Get.iconColor),
                            title: "Address",
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              //
                              // Get.offNamed(RouteHelper.getAddressRoute());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddressScreen()));
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),
                    // SettingItemWidget(
                    //   leading:
                    //       Icon(Icons.wb_sunny_outlined, color: Get.iconColor),
                    //   title: "Dark Mode",
                    //   titleTextStyle: boldTextStyle(),
                    //   onTap: () async {
                    //     if (appStore.isDarkModeOn) {
                    //       appStore.toggleDarkMode(value: false);
                    //     } else {
                    //       appStore.toggleDarkMode(value: true);
                    //     }
                    //   },
                    //   trailing: SizedBox(
                    //     height: 20,
                    //     width: 30,
                    //     child: Switch(
                    //       materialTapTargetSize:
                    //           MaterialTapTargetSize.shrinkWrap,
                    //       value: appStore.isDarkModeOn,
                    //       onChanged: (bool value) {
                    //         appStore.toggleDarkMode(value: value);
                    //         setState(() {});
                    //       },
                    //     ),
                    //   ),
                    // ),
                    _isLoggedIn
                        ? GetBuilder<AuthController>(builder: (authController) {
                            return SettingItemWidget(
                              leading: Icon(Icons.wb_sunny_outlined,
                                  color: Get.iconColor),
                              title: "Notification",
                              titleTextStyle: boldTextStyle(),
                              onTap: () async {
                                authController.setNotificationActive(
                                    !authController.notification);
                              },
                              trailing: SizedBox(
                                height: 20,
                                width: 30,
                                child: Switch(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  value: authController.notification,
                                  onChanged: (bool isActive) =>
                                      authController.setNotificationActive(
                                          !authController.notification),
                                ),
                              ),
                            );
                          })
                        : SizedBox(),
                    // SettingItemWidget(
                    //   leading:
                    //       Icon(Icons.payment_rounded, color: Get.iconColor),
                    //   title: "Payment",
                    //   titleTextStyle: boldTextStyle(),
                    //   onTap: () {
                    //     PaymentScreen().launch(context);
                    //   },
                    //   trailing: Icon(Icons.arrow_forward_ios_rounded,
                    //       size: 18, color: Get.iconColor),
                    // ),
                    SettingItemWidget(
                      leading: Icon(Icons.help, color: Get.iconColor),
                      title: 'help_support'.tr,
                      titleTextStyle: boldTextStyle(),
                      onTap: () {
                        //
                        //Get.offNamed(RouteHelper.getSupportRoute());
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SupportScreen()));
                      },
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 18, color: Get.iconColor),
                    ),
                    SettingItemWidget(
                      leading: Icon(Icons.lock_outline, color: Get.iconColor),
                      title: "Privacy Policy",
                      titleTextStyle: boldTextStyle(),
                      onTap: () {
                        //
                        // Get.offNamed(
                        //     RouteHelper.getHtmlRoute('privacy-policy'));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HtmlViewerScreen(
                                    htmlType: HtmlType.PRIVACY_POLICY)));
                      },
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 18, color: Get.iconColor),
                    ),

                    _isLoggedIn &&
                            Get.find<SplashController>()
                                    .configModel
                                    .customerWalletStatus ==
                                1
                        ? SettingItemWidget(
                            leading: Icon(Icons.wallet_outlined,
                                color: Get.iconColor),
                            title: "Wallet",
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              //
                              // Get.offNamed(
                              //     RouteHelper.getHtmlRoute('privacy-policy'));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WalletScreen(
                                            fromWallet: true,
                                          )));
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),

                    SettingItemWidget(
                      leading: Icon(Icons.shopping_bag, color: Get.iconColor),
                      title: "About Us",
                      titleTextStyle: boldTextStyle(),
                      onTap: () {
                        //
                        // Get.offNamed(RouteHelper.getHtmlRoute('about-us'));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HtmlViewerScreen(
                                    htmlType: HtmlType.ABOUT_US)));
                      },
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 18, color: Get.iconColor),
                    ),
                    SettingItemWidget(
                      leading: Icon(Icons.lock_person, color: Get.iconColor),
                      title: 'terms_conditions'.tr,
                      titleTextStyle: boldTextStyle(),
                      onTap: () {
                        //
                        // Get.offNamed(
                        //     RouteHelper.getHtmlRoute('terms-and-condition'));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HtmlViewerScreen(
                                    htmlType: HtmlType.TERMS_AND_CONDITION)));
                      },
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 18, color: Get.iconColor),
                    ),
                    Get.find<SplashController>().configModel.refEarningStatus ==
                            1
                        ? SettingItemWidget(
                            leading: Icon(Icons.group_outlined,
                                color: Get.iconColor),
                            title: 'refer'.tr,
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              //
                              // Get.offNamed(RouteHelper.getReferAndEarnRoute());

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ReferAndEarnScreen()));
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),
                    SettingItemWidget(
                      leading: Icon(Icons.help_center_outlined,
                          color: Get.iconColor),
                      title: "coupon",
                      titleTextStyle: boldTextStyle(),
                      onTap: () {
                        //
                        // Get.offNamed(
                        //     RouteHelper.getCouponRoute(fromCheckout: false));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CouponScreen(
                                      fromCheckout: false,
                                    )));
                      },
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 18, color: Get.iconColor),
                    ),
                    Get.find<SplashController>()
                                .configModel
                                .loyaltyPointStatus ==
                            1
                        ? SettingItemWidget(
                            leading: Image.asset(
                              loyalty,
                              height: 30,
                              width: 30,
                            ),
                            title: 'loyalty_points'.tr,
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              //
                              //  Get.offNamed(RouteHelper.getWalletRoute(false));
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WalletScreen(
                                            fromWallet: false,
                                          )));
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),
                    Get.find<SplashController>()
                                .configModel
                                .toggleDmRegistration &&
                            !ResponsiveHelper.isDesktop(context)
                        ? SettingItemWidget(
                            leading: Image.asset(
                              joinmen,
                              height: 30,
                              width: 30,
                              color: Colors.black,
                            ),
                            title: 'join_as_a_delivery_man'.tr,
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              //
                              // Get.offNamed(RouteHelper
                              //     .getDeliverymanRegistrationRoute());

                              //DeliveryManRegistrationScreen()
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationDetailsScreen()));
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),
                    Get.find<SplashController>()
                                .configModel
                                .toggleRestaurantRegistration &&
                            !ResponsiveHelper.isDesktop(context)
                        ? SettingItemWidget(
                            leading: Image.asset(
                              location,
                              height: 30,
                              width: 30,
                              color: Colors.black,
                            ),
                            title: 'join_as_a_restaurant'.tr,
                            titleTextStyle: boldTextStyle(),
                            onTap: () {
                              //
                              // Get.offNamed(
                              //     RouteHelper.getRestaurantRegistrationRoute());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RestaurantRegistrationScreen()));
                            },
                            trailing: Icon(Icons.arrow_forward_ios_rounded,
                                size: 18, color: Get.iconColor),
                          )
                        : SizedBox(),
                    SettingItemWidget(
                      leading: Icon(Icons.login, color: Get.iconColor),
                      title: _isLoggedIn ? 'logout'.tr : 'sign_in'.tr,
                      titleTextStyle: boldTextStyle(),
                      onTap: () {
                        // showConfirmDialogCustom(context, onAccept: (c) {
                        //   LoginWithPassScreen()
                        //       .launch(context, isNewTask: true);
                        // }, dialogType: DialogType.CONFIRMATION);

                        Get.back();
                        if (Get.find<AuthController>().isLoggedIn()) {
                          Get.dialog(
                              ConfirmationDialog(
                                  icon:  support,
                                  description: 'are_you_sure_to_logout'.tr,
                                  isLogOut: true,
                                  onYesPressed: () {
                                    Get.find<AuthController>()
                                        .clearSharedData();
                                    Get.find<CartController>().clearCartList();
                                    Get.find<WishListController>()
                                        .removeWishes();
                                    Get.offAllNamed(RouteHelper.getSignInRoute(
                                        RouteHelper.splash));
                                  }),
                              useSafeArea: false);
                        } else {
                          Get.find<WishListController>().removeWishes();
                          Get.toNamed(
                              RouteHelper.getSignInRoute(RouteHelper.main));
                        }
                      },
                      trailing: Icon(Icons.arrow_forward_ios_rounded,
                          size: 18, color: Get.iconColor),
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('${'version'.tr}:',
                          style: robotoRegular.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall)),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                      Text(AppConstants.APP_VERSION.toString(),
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeExtraSmall)),
                    ]),
                  ],
                ),
              );
      },
    ));
  }
}
