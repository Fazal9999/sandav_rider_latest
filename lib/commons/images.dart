import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


const car = 'assets/logo.png';
const home_delivery = 'assets/home_delivery.png';
const take_away = 'assets/takeaway.png';
const bike = 'assets/bike.png';
const cash_on_delivery='assets/cash_on_delivery.png';
const image = 'assets/image.png';
const digital_payment='assets/digital_payment.png';
const house = 'assets/house.png';
const my_location_marker = 'assets/my_location_marker.png';
const support = 'assets/support.png';
const loyalty = 'assets/loyal.png';
const tracking = 'assets/tracking.png';
const route = 'assets/route.png';

const wallet = 'assets/wallet.png';
const empty_cart = 'assets/empty_cart.png';
const empty_box = 'assets/empty_box.png';
const joinmen = 'assets/delivery_man_join.png';
const logout = 'assets/log_out.png';

const location = 'assets/restaurant_join.png';
const pending_gif = 'assets/pending.gif';
const pin = 'assets/pin.png';
const no_internet = 'assets/no_internet.png';
const placeholderimg = 'assets/placeholder.png';
const String animate_delivery_man = 'assets/delivery-man.gif';
const handover_gif='assets/handover_gif.gif';
const on_the_way_gif='assets/on_the_way.gif';
const delivery_location = 'assets/delivery_location.png';
const refer_code = 'assets/refer_code';
const restaurant_cover='assets/restaurant_cover.png';
const refer_image='assets/refer_image.png';
const earn_money='assets/earn_money.png';
const restaurant_placeholder='assets/l_restaurant';
const forget = 'assets/forgot.png';
const checked = 'assets/checked.png';
const lock = 'assets/lock.png';
const warning = 'assets/warning.png';
const gift_box1='assets/gift_box1.png';
const coupon='assets/coupon.png';
const support_image ='assets/support_image.png';
const update_s='assets/update.png';
const maintenance='assets/maintenance.png';
const processing_gif='assets/processing.gif';
const user_marker="assets/user_marking.png";
const cooking_gif='assets/cooking.gif';
const gift_box='assets/gift_box.png';
const coupon_bg='assets/coupon_bg';
const store = 'assets/store.png';
const location_marker = 'assets/location_marker.png';
const delivery_man_marker = 'assets/delivery_man_marker.png';
const loding = 'assets/loading.png';
const bugati = 'assets/bugati.jpeg';
const whiteCar = 'assets/white_car.jpg';
const whiteCar1 = 'assets/white_car1.jpg';
const whiteCar2 = 'assets/white_car2.jpg';
const google = 'assets/google.png';
const facebook = 'assets/facebook-logo.png';
const apple = 'assets/apple.png';
const fingerprint = 'assets/fingerprint.png';
const profile = 'assets/profile.png';
const forgotpass = 'assets/forgotpass.png';
const createpassimg = 'assets/createpassimg.png';

// list of car name
const car_gif = 'assets/car_gif.gif';
const fav = 'assets/fav.gif';
const easy = 'assets/easy.gif';
const delivery = 'assets/delivery.gif';
const wrongkeyword = 'assets/wrongkeyword.png';

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
    car,
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


