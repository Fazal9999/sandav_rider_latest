import 'package:delivery_man/controller/auth_controller.dart';
import 'package:delivery_man/controller/splash_controller.dart';
import 'package:delivery_man/controller/theme_controller.dart';
import 'package:delivery_man/helper/route_helper.dart';
import 'package:delivery_man/util/app_constants.dart';
import 'package:delivery_man/util/dimensions.dart';
import 'package:delivery_man/util/images.dart';
import 'package:delivery_man/util/styles.dart';
import 'package:delivery_man/view/base/confirmation_dialog.dart';
import 'package:delivery_man/view/screens/profile/subscription_model.dart';
import 'package:delivery_man/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:delivery_man/view/screens/profile/widget/profile_button.dart';
import 'package:delivery_man/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
List<SubscriptionModel> getSubscriptionList() {
  List<SubscriptionModel> subscriptionList = [];
  subscriptionList.add(
    SubscriptionModel(name: 'Alert', img: Images.t14_KingIcon,
        backgroundColor: Images.t14_colorPink, bannerColor: Images.t14_colorCream),
  );

  return subscriptionList;
}
class _ProfileScreenState extends State<ProfileScreen> {
  List<SubscriptionModel> subscriptionList = getSubscriptionList();
  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Images.db4_colorPrimary,
      body: GetBuilder<AuthController>(builder: (authController) {
        return authController.profileModel == null ? Center(child: CircularProgressIndicator()) :
        ProfileBgWidget(
          backButton: false,
          circularImage: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Theme.of(context).cardColor),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child:
            ClipOval(child: FadeInImage.assetNetwork(
              placeholder: Images.placeholder,
              image:
              '${Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}'
                  '/${authController.profileModel != null ? authController.profileModel.image : ''}',
              height: 100, width: 100, fit: BoxFit.cover,
              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder, height: 100, width: 100, fit: BoxFit.cover),
            )),
          ),
          mainWidget: SingleChildScrollView(
              physics: BouncingScrollPhysics(), child: Center(child: Container(
            width: 1170, color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child:
            Column(children: [

             authController.profileModel.is_agree_privacy==null
             || authController.profileModel.is_agree_terms==null ||
                 authController.profileModel.is_criminal_bg_check==null
                 ||
                 authController.profileModel.is_max_order==null
                 ||
                 authController.profileModel.is_max_waiting_period==null
                 ||
                 authController.profileModel.is_version_seven_plus==null
                 ||
                 authController.profileModel.is_vehicle_responsibility==null
                 ||
                 authController.profileModel.is_track_event==null
                 ||
                 authController.profileModel.is_total_amount==null
                 ||
                 authController.profileModel.is_paid_per_km==null
                 ||
                 authController.profileModel.vehicle_license_images==null


            ?  ListView.builder(
                  itemCount: subscriptionList.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16),
                  itemBuilder: (BuildContext context, int index) {
                    SubscriptionModel data = subscriptionList[index];
                    return Column(
                      children: [
                        Container(
                          width: Get.width,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10)), color: data.backgroundColor),
                          margin: EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topCenter,
                                child: CustomPaint(
                                  painter: ShapesPainter(color: data.bannerColor),
                                  child: Container(
                                    height: 90,
                                    width: 80,
                                    child: Column(
                                      children: [
                                        8.height,
                                        Text(data.name, style: primaryTextStyle(color: Colors.white)),
                                        8.height,
                                        Image.asset(data.img, height: 20, width: 20, color: Colors.white),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              15.height,


                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5), //apply padding to all four sides
                                child:  Text("Your Account is not fully registered! You need to register to get orders!",
                                    textAlign: TextAlign.center,
                                    style: boldTextStyle(color: Images.t14_SuccessTxtColor, size: 14,)),
                              ),

                              10.height,
                              Container(
                                width: 230,
                                margin: EdgeInsets.only(bottom: 16),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.white,
                                    elevation: 0.0,
                                    padding: EdgeInsets.all(12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                                  ),
                                  onPressed: () {
                                    Get.toNamed(RouteHelper.getDeliverymanReRegisterationRoute());
                                  },
                                  child: Text("Complete Now!!", style: primaryTextStyle(color: Images.t14_colorBlue)),
                                ),
                              ),

                              16.height,
                            ],
                          ),
                        )
                      ],
                    );
                  }
              ):SizedBox(),
              Text(
                '${authController.profileModel.fName} ${authController.profileModel.lName}',
                style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
              ),
              SizedBox(height: 30),
              Row(children: [
                ProfileCard(title: 'since_joining'.tr, data: '${authController.profileModel.memberSinceDays} ${'days'.tr}'),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                ProfileCard(title: 'total_order'.tr, data: authController.profileModel.orderCount.toString()),
              ]),
              SizedBox(height: 30),

              SizedBox(height: 30),
              ProfileButton(icon: Icons.dark_mode, title: 'dark_mode'.tr, isButtonActive: Get.isDarkMode, onTap: () {
                Get.find<ThemeController>().toggleTheme();
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ProfileButton(
                icon: Icons.notifications, title: 'notification'.tr,
                isButtonActive: authController.notification, onTap: () {
                  authController.setNotificationActive(!authController.notification);
                },
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ProfileButton(icon: Icons.chat_bubble, title: 'conversation'.tr, onTap: () {
                Get.toNamed(RouteHelper.getConversationListRoute());
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              // Get.find<SplashController>().configModel.toggleDmRegistration
              //     ? ProfileButton(icon: Icons.delivery_dining, title: 'join_as_a_delivery_man'.tr, onTap: () {
              //   Get.toNamed(RouteHelper.getDeliverymanRegistrationRoute());
              // }) : SizedBox(),
              // SizedBox(height: Get.find<SplashController>().configModel.toggleDmRegistration ? Dimensions.PADDING_SIZE_SMALL : 0.0),
              ProfileButton(icon: Icons.language, title: 'Language'.tr, onTap: () {
                Get.toNamed(RouteHelper.getLanguageRoute('profile'));
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ProfileButton(icon: Icons.lock, title: 'change_password'.tr, onTap: () {
                Get.toNamed(RouteHelper.getResetPasswordRoute('', '', 'password-change'));
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              ProfileButton(icon: Icons.edit, title: 'edit_profile'.tr, onTap: () {
                Get.toNamed(RouteHelper.getUpdateProfileRoute());
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ProfileButton(icon: Icons.list, title: 'terms_condition'.tr, onTap: () {
                Get.toNamed(RouteHelper.getTermsRoute());
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ProfileButton(icon: Icons.privacy_tip, title: 'privacy_policy'.tr, onTap: () {
                Get.toNamed(RouteHelper.getPrivacyRoute());
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

              ProfileButton(
                icon: Icons.delete, title: 'delete_account'.tr,
                onTap: () {
                  Get.dialog(ConfirmationDialog(icon: Images.warning, title: 'are_you_sure_to_delete_account'.tr,
                      description: 'it_will_remove_your_all_information'.tr, isLogOut: true,
                      onYesPressed: () => authController.removeDriver()),
                      useSafeArea: false);
                },
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              ProfileButton(icon: Icons.logout, title: 'logout'.tr, onTap: () {
                Get.back();
                Get.dialog(ConfirmationDialog(icon: Images.support, description: 'are_you_sure_to_logout'.tr, isLogOut: true, onYesPressed: () {
                  Get.find<AuthController>().clearSharedData();
                  Get.find<AuthController>().stopLocationRecord();
                  Get.offAllNamed(RouteHelper.getSignInRoute());
                }));
              }),
              SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('${'version'.tr}:', style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                Text(AppConstants.APP_VERSION.toString(), style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
              ]),

            ]),
          ))),
        );
      }),
    );
  }
}
class ShapesPainter extends CustomPainter {
  Color color;

  ShapesPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, size.height * 0.75);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(size.width, size.height * 0.75);
    path.lineTo(size.height / 1.1, 0);
    path.lineTo(0, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
