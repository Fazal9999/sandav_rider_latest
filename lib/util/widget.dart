import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../common/colors.dart';
import '../store/AppStore.dart';
import 'images.dart';

Widget indicator({@required bool isActive}) {
  return AnimatedContainer(
    duration: Duration(milliseconds: 150),
    margin: EdgeInsets.symmetric(horizontal: 4.0),
    height: isActive ? 6.0 : 4.0,
    width: isActive ? 6.0 : 4.0,
    decoration: BoxDecoration(
      color: isActive ? Colors.white : Color(0xFF929794),
      borderRadius: BorderRadius.all(Radius.circular(50)),
    ),
  );
}
const opBackgroundColor = Color(0xFFFFFFFF);
Widget applogo() {
  return Image.asset(
    Images.logo,
    color: Colors.black,
    width: 36,
    height: 36,
    fit: BoxFit.fill,
  );
}
Widget textField({String title, IconData image, TextInputType textInputType}) {
  return TextField(
    keyboardType: textInputType,
    style: primaryTextStyle(),
    decoration: InputDecoration(
      hintText: title,
      hintStyle: secondaryTextStyle(size: 16),
      fillColor: Colors.grey,
      suffixIcon: Icon(image, color: Colors.grey, size: 20),
    ),
  );
}

InputDecoration inputDecoration(
    BuildContext context, {
      IconData prefixIcon,
      Widget suffixIcon,
      String labelText,
      double borderRadius,
      String hintText,
    }
    )
{
  var appStore = AppStore();

  return InputDecoration(
    counterText: "",
    contentPadding: EdgeInsets.only(left: 2, bottom: 2, top: 2, right: 2),
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    hintText: hintText.validate(),
    hintStyle: secondaryTextStyle(),

    isDense: true,
    prefixIcon: prefixIcon == null
        ?
    Icon(prefixIcon,
        size: 16, color: appStore.isDarkModeOn ? white : gray)
        :
    Icon(prefixIcon,
        size: 16, color: appStore.isDarkModeOn ? white : gray)
    ,
    suffixIcon: suffixIcon.validate(),
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    filled: true,
    fillColor: appStore.isDarkModeOn ? cardDarkColor : editTextBgColor,
  );
}


