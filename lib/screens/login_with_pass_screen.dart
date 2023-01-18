import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:phone_number/phone_number.dart';
import 'package:sandav/commons/colors.dart';
import 'package:sandav/commons/images.dart';
import 'package:sandav/commons/widgets.dart';
import 'package:sandav/main.dart';
import 'package:sandav/screens/user_home_screen.dart';
import 'package:sandav/store/profile_ob.dart';
import 'package:sandav/store/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../controller/localization_controller.dart';
import '../controller/splash_controller.dart';
import '../helper/responsive_helper.dart';
import '../helper/route_helper.dart';
import '../util/dimensions.dart';
import '../view/base/custom_snackbar.dart';
import '../view/base/web_menu_bar.dart';

class LoginWithPassScreen extends StatefulWidget {
  final bool exitFromApp;
  const LoginWithPassScreen({@required this.exitFromApp = false, Key key})
      : super(key: key);

  @override
  State<LoginWithPassScreen> createState() => _LoginWithPassScreenState();
}

class _LoginWithPassScreenState extends State<LoginWithPassScreen> {
  TextEditingController _emailController = TextEditingController();
  ProfileOb pr_ob = ProfileOb();

  TextEditingController _passwordController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  FocusNode f5 = FocusNode();

  bool isIconTrue = false;
  bool isChecked = false;
  String _countryDialCode;
  bool _canExit = GetPlatform.isWeb ? true : false;

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f6 = FocusNode();

  final _formKey = GlobalKey<FormState>();
  var userinfo;

  bool checkBoxValue = false;

  @override
  void initState() {
    super.initState();

    _countryDialCode =
        Get.find<AuthController>().getUserCountryCode().isNotEmpty
            ? Get.find<AuthController>().getUserCountryCode()
            : CountryCode.fromCountryCode(
                    Get.find<SplashController>().configModel.country)
                .dialCode;
    _emailController.text = Get.find<AuthController>().getUserNumber() == null
        ? ' '
        : Get.find<AuthController>().getUserNumber();
    _passwordController.text =
        Get.find<AuthController>().getUserPassword() ?? '';
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // var userinfo = ModalRoute.of(context).settings.arguments as UserCreadential;
    // if (_emailController == null || _passwordController == null) {
    //   if (userinfo == null) {
    //     _emailController = TextEditingController();
    //     _passwordController = TextEditingController();
    //   } else {
    //     _emailController = TextEditingController(text: userinfo.user_email);
    //     _passwordController =
    //         TextEditingController(text: userinfo.user_password);
    //   }
    // }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // FocusScope.of(context).unfocus();
          // return true;
          if (widget.exitFromApp) {
            if (_canExit) {
              if (GetPlatform.isAndroid) {
                SystemNavigator.pop();
              } else if (GetPlatform.isIOS) {
                exit(0);
              } else {
                Navigator.pushNamed(context, RouteHelper.getInitialRoute());
              }
              return Future.value(false);
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
              return Future.value(false);
            }
          } else {
            return true;
          }
        },
        child: Scaffold(
            appBar: ResponsiveHelper.isDesktop(context)
                ? WebMenuBar()
                : !widget.exitFromApp
                    ? AppBar(
                        elevation: 0,
                        iconTheme: IconThemeData(color: Get.iconColor))
                    : null,
            body: Scaffold(
              resizeToAvoidBottomInset: false,
              // appBar:
              // AppBar(
              //     elevation: 0, iconTheme: IconThemeData(color: Get.iconColor)),

              body: SingleChildScrollView(
                child: Container(
                  // margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: GetBuilder<AuthController>(
                      builder: (authController) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                                height: 230,
                                width: 230,
                                fit: BoxFit.fitWidth,
                                image: AssetImage(car),
                                color: Get.iconColor),
                            Text('Login to Your Account',
                                style: boldTextStyle(size: 24)),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              focusNode: f5,
                              validator: (value) {
                                if (int.tryParse(value) == null) {
                                  return 'Phone number required!!';
                                }
                                return null;
                              },
                              onFieldSubmitted: (v) {
                                f5.unfocus();
                                FocusScope.of(context).requestFocus(f6);
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(0),
                                hintText: 'Phone number',
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0.0),
                                ),
                                filled: true,
                                fillColor: appStore.isDarkModeOn
                                    ? cardDarkColor
                                    : editTextBgColor,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 12),
                                  child: Observer(
                                    builder: (context) =>
                                        DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        value:
                                            pr_ob.pickedValuseOfDropDownMenu1,
                                        style: primaryTextStyle(),
                                        items: [
                                          DropdownMenuItem(
                                              child: Text('🇿🇦'), value: 0),
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
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: isIconTrue,
                              focusNode: f2,
                              validator: (value) {
                                return Validate.validate(value);
                              },
                              onFieldSubmitted: (v) {
                                f2.unfocus();
                                if (_formKey.currentState.validate()) {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => HomeScreen()));
                                  GetPlatform.isWeb &&
                                          authController.acceptTerms
                                      ? _login(authController, _countryDialCode)
                                      : null;
                                }
                              },
                              decoration: inputDecoration(
                                context,
                                prefixIcon: Icons.lock,
                                hintText: "Password",
                                suffixIcon: Theme(
                                  data: ThemeData(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent),
                                  child: IconButton(
                                    highlightColor: Colors.transparent,
                                    onPressed: () {
                                      setState(() {
                                        isIconTrue = !isIconTrue;
                                      });
                                    },
                                    icon: Icon(
                                      (isIconTrue)
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off,
                                      size: 16,
                                      color:
                                          appStore.isDarkModeOn ? white : gray,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: appStore.isDarkModeOn
                                      ? Colors.white
                                      : black),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(0),
                                title: Text("Remember Me",
                                    style: primaryTextStyle(
                                      color: appStore.isDarkModeOn
                                          ? Colors.white
                                          : Colors.black,
                                    )),
                                // value: checkBoxValue,
                                dense: true,
                                onTap: () => authController.toggleRememberMe(),
                                leading: Checkbox(
                                  activeColor: Theme.of(context).primaryColor,
                                  value: authController.isActiveRememberMe,
                                  onChanged: (bool isChecked) =>
                                      authController.toggleRememberMe(),
                                ),
                              ),
                            ),
                            //SizedBox(height: 8),
                            !authController.isLoading
                                ? GestureDetector(
                                    onTap: () {
                                      if (_formKey.currentState.validate()) {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) => HomeScreen()));
                                        _login(
                                            authController, _countryDialCode);
                                      }
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 16),
                                      decoration:
                                          boxDecorationWithRoundedCorners(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(45)),
                                        backgroundColor: appStore.isDarkModeOn
                                            ? cardDarkColor
                                            : black,
                                      ),
                                      child: Text('Sign in',
                                          style: boldTextStyle(color: white)),
                                    ),
                                  )
                                : Center(child: CircularProgressIndicator()),
                            SizedBox(height: 10),
                            TextButton(
                              onPressed: () => Get.toNamed(
                                  RouteHelper.getForgotPassRoute(false, null)),
                              child: Text('Forgot the password ?',
                                  style: boldTextStyle()),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              height: 30,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Container(
                                          height: 0.2, color: Colors.black26)),
                                  SizedBox(width: 10),
                                  Text('Or', style: secondaryTextStyle()),
                                  SizedBox(width: 10),
                                  Expanded(
                                      child: Container(
                                          height: 0.2, color: Colors.black26)),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            GestureDetector(
                              onTap: () {
                                //if (_formKey.currentState.validate()) {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => HomeScreen()));
                                // _login(authController, _countryDialCode);
                                Navigator.pushReplacementNamed(
                                    context, RouteHelper.getInitialRoute());

                                //}
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: boxDecorationWithRoundedCorners(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(45)),
                                  backgroundColor: appStore.isDarkModeOn
                                      ? cardDarkColor
                                      : black,
                                ),
                                child: Text('Continue As Guest',
                                    style: boldTextStyle(color: white)),
                              ),
                            ),
                            // SizedBox(
                            //   width: MediaQuery.of(context).size.width * 0.65,
                            //   child: Row(
                            //     crossAxisAlignment: CrossAxisAlignment.start,
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       GestureDetector(
                            //         onTap: () async {
                            //           await customDialoge(context);
                            //         },
                            //         child: Container(
                            //           padding: EdgeInsets.all(12),
                            //           width: 65,
                            //           alignment: Alignment.center,
                            //           decoration: BoxDecoration(
                            //             border:
                            //                 Border.all(color: Get.iconColor),
                            //             borderRadius: BorderRadius.circular(15),
                            //           ),
                            //           child: Image(
                            //               height: 24,
                            //               width: 24,
                            //               image: AssetImage(facebook)),
                            //         ),
                            //       ),
                            //       GestureDetector(
                            //         onTap: () async {
                            //           await customDialoge(context);
                            //         },
                            //         child: Container(
                            //           padding: EdgeInsets.all(12),
                            //           width: 65,
                            //           alignment: Alignment.center,
                            //           decoration: BoxDecoration(
                            //             border:
                            //                 Border.all(color: Get.iconColor),
                            //             borderRadius: BorderRadius.circular(15),
                            //           ),
                            //           child: Image(
                            //               height: 24,
                            //               width: 24,
                            //               image: AssetImage(google)),
                            //         ),
                            //       ),
                            //       GestureDetector(
                            //         onTap: () async {
                            //           await customDialoge(context);
                            //         },
                            //         child: Container(
                            //           padding: EdgeInsets.all(12),
                            //           width: 65,
                            //           alignment: Alignment.center,
                            //           decoration: BoxDecoration(
                            //             border:
                            //                 Border.all(color: Get.iconColor),
                            //             borderRadius: BorderRadius.circular(15),
                            //           ),
                            //           child: Image(
                            //               height: 24,
                            //               width: 24,
                            //               image: AssetImage(apple),
                            //               color: Get.iconColor),
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => SignUpScreen()),
                                // );
                                Get.toNamed(RouteHelper.getSignUpRoute());
                              },
                              child: Text.rich(
                                TextSpan(
                                  text: "Already have an account? ",
                                  style: secondaryTextStyle(),
                                  children: [
                                    TextSpan(
                                        text: ' Sign up',
                                        style: boldTextStyle(size: 14)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            )));
  }

  void _login(AuthController authController, String countryDialCode) async {
    String _phone = "+27" + _emailController.text.trim();
    String _password = _passwordController.text.trim();
    String _numberWithCountryCode = _phone;
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

    authController
        .login(_numberWithCountryCode, _password)
        .then((status) async {
      if (status.isSuccess) {
        if (authController.isActiveRememberMe) {
          authController.saveUserNumberAndPassword(
              _phone, _password, countryDialCode);
        } else {
          authController.clearUserNumberAndPassword();
        }
        String _token = status.message.substring(1, status.message.length);
        if (Get.find<SplashController>().configModel.customerVerification &&
            int.parse(status.message[0]) == 0) {
          List<int> _encoded = utf8.encode(_password);
          String _data = base64Encode(_encoded);
          Get.toNamed(RouteHelper.getVerificationRoute(
              _numberWithCountryCode, _token, RouteHelper.signUp, _data));
        } else {
          Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
        }
      } else {
        showCustomSnackBar(status.message);
      }
    });
  }
}
