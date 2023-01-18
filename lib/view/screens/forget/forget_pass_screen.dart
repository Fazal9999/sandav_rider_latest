import 'package:country_code_picker/country_code.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/commons/colors.dart';
import 'package:sandav/commons/images.dart';
import 'package:sandav/controller/auth_controller.dart';
import 'package:sandav/controller/splash_controller.dart';
import 'package:sandav/data/model/body/social_log_in_body.dart';
import 'package:sandav/helper/route_helper.dart';
import 'package:sandav/main.dart';
import 'package:sandav/store/profile_ob.dart';
import 'package:sandav/util/dimensions.dart';
import 'package:sandav/util/styles.dart';
import 'package:sandav/view/base/custom_app_bar.dart';
import 'package:sandav/view/base/custom_button.dart';
import 'package:sandav/view/base/custom_snackbar.dart';
import 'package:sandav/view/base/custom_text_field.dart';
import 'package:sandav/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class ForgetPassScreen extends StatefulWidget {
  final bool fromSocialLogin;
  final SocialLogInBody socialLogInBody;
  ForgetPassScreen(
      {@required this.fromSocialLogin, @required this.socialLogInBody});

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final TextEditingController _numberController = TextEditingController();
  ProfileOb pr_ob = ProfileOb();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();
  final _formKey = GlobalKey<FormState>();

  String _countryDialCode = CountryCode.fromCountryCode(
          Get.find<SplashController>().configModel.country)
      .dialCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.fromSocialLogin ? 'phone'.tr : 'forgot_password'.tr),
      body: SafeArea(
          child: Center(
              child: Scrollbar(
                  child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
        child: Center(
            child: Container(
          width: Get.width > 700 ? 700 : Get.width,
          padding: Get.width > 700
              ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
              : null,
          decoration: Get.width > 700
              ? BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[Get.isDarkMode ? 700 : 300],
                        blurRadius: 5,
                        spreadRadius: 1)
                  ],
                )
              : null,
          child: Column(children: [
            Image.asset(forget, height: 220),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text('please_enter_mobile'.tr,
                  style: robotoRegular, textAlign: TextAlign.center),
            ),
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  color: Theme.of(context).cardColor,
                ),
                child: Column(children: [
                  TextFormField(
                    controller: _numberController,
                    focusNode: f5,
                    validator: (value) {
                      if (int.tryParse(value) == null) {
                        return 'Phone Number is required';
                      }
                      return null;
                    },
                    onFieldSubmitted: (v) {
                      f5.unfocus();
                      FocusScope.of(context).requestFocus(f6);
                      GetPlatform.isWeb ? _forgetPass(_countryDialCode) : null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      hintText: 'Phone number',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: radius(defaultRadius),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: radius(defaultRadius),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      filled: true,
                      fillColor: appStore.isDarkModeOn
                          ? cardDarkColor
                          : editTextBgColor,
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Observer(
                          builder: (context) => DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: pr_ob.pickedValuseOfDropDownMenu1,
                              style: primaryTextStyle(),
                              items: [
                                DropdownMenuItem(child: Text('🇿🇦'), value: 0),
                              ],
                              onChanged: (val) {
                                pr_ob.pickedValuseOfDropDownMenu1 =
                                    val.toDouble();
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ])),
            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            GetBuilder<AuthController>(builder: (authController) {
              return !authController.isLoading
                  ? GestureDetector(
                      onTap: () {
                        // if (_formKey.currentState.validate()) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomeScreen()));
                        _forgetPass(_countryDialCode);
                        // }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: boxDecorationWithRoundedCorners(
                          borderRadius: BorderRadius.all(Radius.circular(45)),
                          backgroundColor:
                              appStore.isDarkModeOn ? cardDarkColor : black,
                        ),
                        child: Text('Next', style: boldTextStyle(color: white)),
                      ),
                    )
                  : Center(child: CircularProgressIndicator());
            }),
          ]),
        )),
      )))),
    );
  }

  void _forgetPass(String countryCode) async {
    String _phone = _numberController.text.trim();

    String _numberWithCountryCode = countryCode + _phone;
    log(_numberWithCountryCode);
    bool _isValid = GetPlatform.isWeb ? true : false;
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }

    if (_phone.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else {
      if (widget.fromSocialLogin) {
        widget.socialLogInBody.phone = _numberWithCountryCode;
        Get.find<AuthController>()
            .registerWithSocialMedia(widget.socialLogInBody);
      } else {
        Get.find<AuthController>()
            .forgetPassword(_numberWithCountryCode)
            .then((status) async {
          if (status.isSuccess) {
            Get.toNamed(RouteHelper.getVerificationRoute(
                _numberWithCountryCode, '', RouteHelper.forgotPassword, ''));
          } else {
            showCustomSnackBar(status.message);
          }
        });
      }
    }
  }
}
