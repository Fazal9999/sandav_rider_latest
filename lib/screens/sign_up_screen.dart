import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sandav/commons/AppTheme.dart';
import 'package:sandav/commons/app_component.dart';
import 'package:sandav/commons/colors.dart';
import 'package:sandav/commons/constants.dart';
import 'package:sandav/commons/widgets.dart';
import 'package:sandav/main.dart';
import 'package:sandav/model/user_info.dart';
import 'package:sandav/store/profile_ob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/util/styles.dart';

import '../commons/images.dart';
import '../controller/auth_controller.dart';
import '../controller/splash_controller.dart';
import '../data/model/body/signup_body.dart';
import '../helper/responsive_helper.dart';
import '../helper/route_helper.dart';
import '../store/AppStore.dart';
import '../store/user_signup.dart';
import '../util/dimensions.dart';
import '../view/base/custom_app_bar.dart';
import '../view/base/custom_snackbar.dart';
import '../view/base/custom_text_field.dart';
import '../view/base/web_menu_bar.dart';
import 'package:get/get.dart';
import 'package:phone_number/phone_number.dart';

class SignUpScreen extends StatefulWidget {
  SignUpScreen({Key key, this.isAppbarNeeded, this.appBar}) : super(key: key);
  bool isAppbarNeeded;
  final PreferredSizeWidget appBar;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile pickedFile;
  ProfileOb pr_ob = ProfileOb();
  UserInfo _userInfo;
  String imagePath;
  String UserImage;
  String dropdownValue = 'Male';
  bool isIconCheck1 = false;
  bool isIconCheck2 = false;
  final _form_state_key = GlobalKey<FormState>();
  double width;
  double height;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referCodeFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _referCodeController = TextEditingController();
  String _countryDialCode;

  DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel.country)
        .dialCode;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          return true;
        },
        child: Scaffold(
          appBar: ResponsiveHelper.isDesktop(context) ? WebMenuBar() : CustomAppBar(
              title: "Sign Up"),
          body: SingleChildScrollView(
            child: Container(
              //padding: EdgeInsets.all(16),
              alignment: Alignment.center,
              width: Get.width > 700 ? 700 : Get.width,
              padding: Get.width > 700
                  ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
                  : null,
              decoration: Get.width > 700
                  ? BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius:
                          BorderRadius.circular(Dimensions.RADIUS_SMALL),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey[Get.isDarkMode ? 700 : 300],
                            blurRadius: 5,
                            spreadRadius: 1)
                      ],
                    )
                  : null,
              child: GetBuilder<AuthController>(
                builder: (authController) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 50, horizontal: 10),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            car,
                            width: 200,
                            height: 200,
                            color: AppStore().isDarkModeOn ? white : black,
                          ),
                          //Image.asset(Images.logo_name, width: 100),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter first name';
                              }
                              return null;
                            },
                            onFieldSubmitted: (v) {
                              _firstNameFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_lastNameFocus);
                            },
                            decoration:
                                inputDecoration(context, hintText: "Full name"),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter last name';
                              }
                              return null;
                            },
                            onFieldSubmitted: (v) {
                              _firstNameFocus.unfocus();
                              FocusScope.of(context).requestFocus(_emailFocus);
                            },
                            decoration:
                                inputDecoration(context, hintText: "Last name"),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _emailController,
                            focusNode: _emailFocus,
                            validator: (value) {
                              if (value.isEmpty || !value.contains('@')) {
                                return 'Enter correct email';
                              }
                              return null;
                            },
                            onFieldSubmitted: (v) {
                              _emailFocus.unfocus();
                              FocusScope.of(context).requestFocus(_phoneFocus);
                            },
                            decoration: inputDecoration(
                              context,
                              hintText: "Email",
                              suffixIcon: Icon(Icons.mail_outline_rounded,
                                  size: 16,
                                  color: appStore.isDarkModeOn ? white : gray),
                            ),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            controller: _phoneController,
                            focusNode: _phoneFocus,
                            validator: (value) {
                              if (int.tryParse(value) == null) {
                                return 'Phone No required';
                              }
                              return null;
                            },
                            onFieldSubmitted: (v) {
                              _phoneFocus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_passwordFocus);
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
                                      value: pr_ob.pickedValuseOfDropDownMenu1,
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
                          SizedBox(height: 15),
                          Observer(
                            builder: (context) => TextFormField(
                              obscureText: isIconCheck2,
                              focusNode: _passwordFocus,
                              controller: _passwordController,
                              validator: (value) {
                                return Validate.validate(value);
                              },
                              onFieldSubmitted: (v) {
                                _passwordFocus.unfocus();
                                FocusScope.of(context)
                                    .requestFocus(_confirmPasswordFocus);
                              },
                              decoration: InputDecoration(
                                hintText: 'Enter new password',
                                filled: true,
                                fillColor: AppStore().isDarkModeOn
                                    ? cardDarkColor
                                    : editTextBgColor,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 0.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                errorMaxLines: 2,
                                errorStyle: primaryTextStyle(
                                    color: Colors.red, size: 12),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0.0),
                                ),
                                prefixIcon: Icon(Icons.lock,
                                    color: Get.iconColor, size: 22),
                                suffixIcon: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                  child: IconButton(
                                    highlightColor: Colors.transparent,
                                    color: Get.iconColor,
                                    onPressed: () {
                                      setState(() {
                                        isIconCheck2 = isIconCheck2;
                                      });
                                    },
                                    icon: Icon(
                                      (isIconCheck2)
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          Observer(
                            builder: (context) => TextFormField(
                              controller: _confirmPasswordController,
                              focusNode: _confirmPasswordFocus,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter The Password';
                                } else if (value.length > 16) {
                                  return 'password must be less than 16 digit';
                                } else if (value.length < 8) {
                                  return 'password must more than 8 digit';
                                } else if (value != _passwordController.text) {
                                  return 'password must match';
                                }
                                return null;
                              },
                              onFieldSubmitted: (v) {
                                _confirmPasswordFocus.unfocus();
                                (GetPlatform.isWeb ||
                                        authController.acceptTerms)
                                    ? _register(
                                        authController, _countryDialCode)
                                    : null;
                              },
                              obscureText: isIconCheck1,
                              decoration: InputDecoration(
                                hintText: 'Confirm Password',
                                filled: true,
                                fillColor: AppStore().isDarkModeOn
                                    ? cardDarkColor
                                    : editTextBgColor,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0.0),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 0.0),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide:
                                      BorderSide(color: Colors.red, width: 1.0),
                                ),
                                errorMaxLines: 2,
                                errorStyle: primaryTextStyle(
                                    color: Colors.red, size: 12),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: radius(defaultRadius),
                                  borderSide: BorderSide(
                                      color: Colors.transparent, width: 0.0),
                                ),
                                prefixIcon: Icon(Icons.lock,
                                    color: Get.iconColor, size: 22),
                                suffixIcon: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                  child: IconButton(
                                    highlightColor: Colors.transparent,
                                    color: Get.iconColor,
                                    onPressed: () {
                                      setState(
                                        () {
                                          isIconCheck1 = isIconCheck1;
                                        },
                                      );
                                    },
                                    icon: Icon(
                                        (isIconCheck1)
                                            ? Icons.visibility_rounded
                                            : Icons.visibility_off,
                                        size: 18),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          (Get.find<SplashController>()
                                      .configModel
                                      .refEarningStatus ==
                                  1)
                              ? CustomTextField(
                                  hintText: 'refer_code'.tr,
                                  controller: _referCodeController,
                                  focusNode: _referCodeFocus,
                                  inputAction: TextInputAction.done,
                                  inputType: TextInputType.text,
                                  capitalization: TextCapitalization.words,
                                  prefixIcon: refer_code,
                                  divider: false,
                                )
                              : SizedBox(),
                          SizedBox(height: 25),
                          !authController.isLoading
                              ? GestureDetector(
                                  child: Container(
                                    width: width,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    alignment: Alignment.center,
                                    decoration: CircularBlackDecoration,
                                    child: Text("Continue",
                                        style: boldTextStyle(
                                            color: primaryWhiteColor)),
                                  ),
                                  onTap: () async {
                                    if (_formKey.currentState.validate()) {
                                      // await customDialoge(context);
                                      await _register(
                                          authController, _countryDialCode);
                                    }
                                  },
                                )
                              : Center(child: CircularProgressIndicator()),
                          SizedBox(height: 25),
                          GestureDetector(
                            child: Container(
                              width: width,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              alignment: Alignment.center,
                              decoration: CircularBlackDecoration,
                              child: Text("Continue as Guest",
                                  style:
                                      boldTextStyle(color: primaryWhiteColor)),
                            ),
                            onTap: () async {
                              // if (_form_state_key.currentState.validate()) {
                              // await customDialoge(context);
                              await Navigator.pushReplacementNamed(
                                  context, RouteHelper.getInitialRoute());

                              // }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ));
  }

  void _register(AuthController authController, String countryCode) async {
    String _firstName = _firstNameController.text.trim();
    String _lastName = _lastNameController.text.trim();
    String _email = _emailController.text.trim();
    String _number = _phoneController.text.trim();
    String _password = _passwordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    String _referCode = _referCodeController.text.trim();

    String _numberWithCountryCode = countryCode + _number;
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

    if (_firstName.isEmpty) {
      showCustomSnackBar('enter_your_first_name'.tr);
    } else if (_lastName.isEmpty) {
      showCustomSnackBar('enter_your_last_name'.tr);
    } else if (_email.isEmpty) {
      showCustomSnackBar('enter_email_address'.tr);
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
    } else if (_number.isEmpty) {
      showCustomSnackBar('enter_phone_number'.tr);
    } else if (!_isValid) {
      showCustomSnackBar('invalid_phone_number'.tr);
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else if (_referCode.isNotEmpty && _referCode.length != 10) {
      showCustomSnackBar('invalid_refer_code'.tr);
    } else {
      SignUpBody signUpBody = SignUpBody(
        fName: _firstName,
        lName: _lastName,
        email: _email,
        phone: _numberWithCountryCode,
        password: _password,
        refCode: _referCode,
      );
      authController.registration(signUpBody).then((status) async {
        if (status.isSuccess) {
          if (Get.find<SplashController>().configModel.customerVerification) {
            List<int> _encoded = utf8.encode(_password);
            String _data = base64Encode(_encoded);
            Get.toNamed(RouteHelper.getVerificationRoute(_numberWithCountryCode,
                status.message, RouteHelper.signUp, _data));
          } else {
            Get.toNamed(RouteHelper.getAccessLocationRoute(RouteHelper.signUp));
          }
        } else {
          showCustomSnackBar(status.message);
        }
      });
    }
  }
}
