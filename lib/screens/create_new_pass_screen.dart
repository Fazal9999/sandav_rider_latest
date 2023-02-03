import 'package:get/get.dart';
import 'package:sandav/commons/app_component.dart';
import 'package:sandav/commons/colors.dart';
import 'package:sandav/commons/widgets.dart';
import 'package:sandav/main.dart';
import 'package:sandav/screens/user_home_screen.dart';
import 'package:sandav/store/user_signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../commons/images.dart';
import '../controller/auth_controller.dart';
import '../controller/user_controller.dart';
import '../data/model/response/userinfo_model.dart';
import '../helper/route_helper.dart';
import '../store/AppStore.dart';
import '../view/base/custom_app_bar.dart';
import '../view/base/custom_snackbar.dart';

class CreateNewPassScreen extends StatefulWidget {
  final String resetToken;
  final String number;
  final bool fromPasswordChange;

  const CreateNewPassScreen(
      {@required this.resetToken,
      @required this.number,
      @required this.fromPasswordChange,
      Key key})
      : super(key: key);

  @override
  State<CreateNewPassScreen> createState() => _CreateNewPassScreenState();
}

class _CreateNewPassScreenState extends State<CreateNewPassScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  final _form_state_key = GlobalKey<FormState>();

  bool isIconCheck1 = false;
  bool isIconCheck2 = false;

  bool is2IconCheck1 = false;
  bool is2IconCheck2 = false;


  bool isLoading = false;
  // void toggleSubmitState() {
  //   setState(() {
  //     isLoading = !isLoading;
  //   });
  // }

  double progress = 0.2;
  double width;
  double height;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  @override
  Widget build(BuildContext context) {
    // return WillPopScope(
    //   onWillPop: () async {
    //     FocusScope.of(context).unfocus();
    //     return true;
    //   },
    return Scaffold(
      appBar: CustomAppBar(
          title: widget.fromPasswordChange
              ? 'change_password'.tr
              : 'reset_password'.tr),
      body: SingleChildScrollView(
        dragStartBehavior: DragStartBehavior.start,
        child: Container(
          height: height,
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(16),
          child: Form(
            key: _form_state_key,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(createpassimg,
                        color: Get.iconColor,
                        fit: BoxFit.cover,
                        width: 170,
                        height: 170)
                    .center(),
                SizedBox(height: 40),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text("Create Your New Password",
                      style: primaryTextStyle()),
                ),
                SizedBox(height: 25),
                Observer(
                  builder: (context) => TextFormField(
                    obscureText: isIconCheck2,
                    focusNode: _newPasswordFocus,
                    controller: _newPasswordController,
                    validator: (value) {
                      return Validate.validate(value);
                    },
                    onFieldSubmitted: (v) {
                      _newPasswordFocus.unfocus();
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
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: radius(defaultRadius),
                        borderSide: BorderSide(color: Colors.red, width: 0.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: radius(defaultRadius),
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      errorMaxLines: 2,
                      errorStyle: primaryTextStyle(color: Colors.red, size: 12),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: radius(defaultRadius),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      prefixIcon:
                          Icon(Icons.lock, color: Get.iconColor, size: 22),
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
                      } else if (value != _newPasswordController.text) {
                        return 'password must match';
                      }
                      return null;
                    },
                    onFieldSubmitted: (v) {
                      _confirmPasswordFocus.unfocus();
                      if (_form_state_key.currentState.validate()) {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => HomeScreen()),
                        // );

                        GetPlatform.isWeb ? _resetPassword() : null;
                      }
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
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: radius(defaultRadius),
                        borderSide: BorderSide(color: Colors.red, width: 0.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: radius(defaultRadius),
                        borderSide: BorderSide(color: Colors.red, width: 1.0),
                      ),
                      errorMaxLines: 2,
                      errorStyle: primaryTextStyle(color: Colors.red, size: 12),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: radius(defaultRadius),
                        borderSide:
                            BorderSide(color: Colors.transparent, width: 0.0),
                      ),
                      prefixIcon:
                          Icon(Icons.lock, color: Get.iconColor, size: 22),
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
                SizedBox(height: 25),
                SizedBox(height: 40),
                isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GestureDetector(
                        child: Container(
                          width: width,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          alignment: Alignment.center,
                          decoration: CircularBlackDecoration,
                          child: Text("Continue",
                              style: boldTextStyle(color: primaryWhiteColor)),
                        ),
                        onTap: () async {
                          if (_form_state_key.currentState.validate()) {
                            // await customDialoge(context);
                            await _resetPassword();
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resetPassword() {
    setState(() {
      isLoading = true;
    });
    String _password = _newPasswordController.text.trim();
    String _confirmPassword = _confirmPasswordController.text.trim();
    if (_password.isEmpty) {
      showCustomSnackBar('enter_password'.tr);
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
    } else if (_password != _confirmPassword) {
      showCustomSnackBar('confirm_password_does_not_matched'.tr);
    } else {
      if (widget.fromPasswordChange) {
        UserInfoModel _user = Get.find<UserController>().userInfoModel;
        _user.password = _password;
        Get.find<UserController>().changePassword(_user).then((response) {
          if (response.isSuccess) {
            showCustomSnackBar('password_updated_successfully'.tr,
                isError: false);
            // customDialoge(context);
            setState(() {
              isLoading = false;
            });
          } else {
            showCustomSnackBar(response.message);
            setState(() {
              isLoading = false;
            });
          }
        });
      } else {
        Get.find<AuthController>()
            .resetPassword(widget.resetToken, '+' + widget.number.trim(),
                _password, _confirmPassword)
            .then((value) {
          if (value.isSuccess) {
            Get.find<AuthController>()
                .login('+' + widget.number.trim(), _password)
                .then((value) async {
              Get.offAllNamed(
                  RouteHelper.getAccessLocationRoute('reset-password'));
            });
          } else {
            showCustomSnackBar(value.message);
          }
        });
      }
    }
  }
}
