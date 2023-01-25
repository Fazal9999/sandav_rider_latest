import 'dart:async';
import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/controller/cart_controller.dart';
import 'package:sandav/controller/coupon_controller.dart';
import 'package:sandav/helper/price_converter.dart';
import 'package:sandav/helper/responsive_helper.dart';
import 'package:sandav/helper/route_helper.dart';
import 'package:sandav/util/dimensions.dart';
import 'package:sandav/util/styles.dart';
import 'package:sandav/view/base/custom_app_bar.dart';
import 'package:sandav/view/base/custom_button.dart';
import 'package:sandav/view/base/custom_snackbar.dart';
import 'package:sandav/view/base/no_data_screen.dart';
import 'package:sandav/view/screens/cart/widget/cart_product_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/location_controller.dart';
import '../../../controller/order_controller.dart';
import '../../../controller/product_controller.dart';
import '../../../controller/restaurant_controller.dart';
import '../../../controller/user_controller.dart';
import '../../../data/model/body/place_order_body.dart';
import '../../../data/model/response/address_model.dart';
import '../../../data/model/response/availability_details_model.dart';
import '../../../data/model/response/cart_model.dart';
import '../../../util/app_constants.dart';

class CartScreen extends StatefulWidget {
  final fromNav;

  CartScreen({@required this.fromNav});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool error = false;
  bool requestSent = false;
  bool shouldShow = false;
  bool timeShow = false;

  bool _isWalletActive;
  bool _todayClosed = false;
  int minutesBy = 1;
  bool _tomorrowClosed = false;
  String response_text = "";
  String minutes = "";
  String seconds = "";

  @override
  void initState() {
    super.initState();

    Get.find<CartController>().calculationCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
          title: 'my_cart'.tr,
          isBackButtonExist:
              (ResponsiveHelper.isDesktop(context) || !widget.fromNav)),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          return cartController.cartList.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          physics: const BouncingScrollPhysics(),
                          child: Center(
                            child: SizedBox(
                              width: Dimensions.WEB_MAX_WIDTH,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Product
                                    ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: cartController.cartList.length,
                                      itemBuilder: (context, index) {
                                        return CartProductWidget(
                                            cart:
                                                cartController.cartList[index],
                                            cartIndex: index,
                                            addOns: cartController
                                                .addOnsList[index],
                                            isAvailable: cartController
                                                .availableList[index]);
                                      },
                                    ),
                                    const SizedBox(
                                        height: Dimensions.PADDING_SIZE_SMALL),

                                    // Total
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('item_price'.tr,
                                              style: robotoRegular),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  cartController.itemPrice),
                                              style: robotoRegular),
                                        ]),
                                    SizedBox(height: 10),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('addons'.tr,
                                              style: robotoRegular),
                                          Text(
                                              '(+) ${PriceConverter.convertPrice(cartController.addOns)}',
                                              style: robotoRegular),
                                        ]),

                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              Dimensions.PADDING_SIZE_SMALL),
                                      child: Divider(
                                          thickness: 1,
                                          color: Theme.of(context)
                                              .hintColor
                                              .withOpacity(0.5)),
                                    ),

                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('subtotal'.tr,
                                              style: robotoMedium),
                                          Text(
                                              PriceConverter.convertPrice(
                                                  cartController.subTotal),
                                              style: robotoMedium),
                                        ]),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: Dimensions.WEB_MAX_WIDTH,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Column(children: [
                        CustomButton(
                            buttonText: 'proceed_to_checkout'.tr,
                            onPressed: () {
                              if (!cartController
                                      .cartList.first.product.scheduleOrder &&
                                  cartController.availableList
                                      .contains(false)) {
                                showCustomSnackBar(
                                    'one_or_more_product_unavailable'.tr);
                              } else {
                                Get.find<CouponController>()
                                    .removeCouponData(false);
                                Get.toNamed(
                                    RouteHelper.getCheckoutRoute('cart'));
                              }
                            }),
                        const SizedBox(height: 10),
                        cartController.cartList.isNotEmpty
                            ? GetBuilder<OrderController>(
                                builder: (orderController) {
                                List<AddressModel> _addressList = [];
                                return GetBuilder<RestaurantController>(
                                    builder: (restController) {
                                  double _deliveryCharge = -1;

                                  if (restController.restaurant != null) {
                                    _todayClosed =
                                        restController.isRestaurantClosed(
                                            true,
                                            restController.restaurant.active,
                                            restController
                                                .restaurant.schedules);
                                    _tomorrowClosed =
                                        restController.isRestaurantClosed(
                                            false,
                                            restController.restaurant.active,
                                            restController
                                                .restaurant.schedules);
                                  }
                                  _addressList.add(
                                      Get.find<LocationController>()
                                          .getUserAddress());
                                  if (restController.restaurant != null) {
                                    if (Get.find<LocationController>()
                                            .addressList !=
                                        null) {
                                      for (int index = 0;
                                          index <
                                              Get.find<LocationController>()
                                                  .addressList
                                                  .length;
                                          index++) {
                                        if (Get.find<LocationController>()
                                            .addressList[index]
                                            .zoneIds
                                            .contains(restController
                                                .restaurant.zoneId)) {
                                          _addressList.add(
                                              Get.find<LocationController>()
                                                  .addressList[index]);
                                        }
                                      }
                                    }
                                  }
                                  return Container(
                                    width: double.infinity,
                                    height: 45,
                                    child: Get.find<AuthController>()
                                            .isLoggedIn()
                                        ? ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: requestSent
                                                  ? const Color.fromRGBO(
                                                      241, 157, 157, 1.0)
                                                  : Colors.red,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .RADIUS_SMALL),
                                                side: const BorderSide(
                                                    width: 2,
                                                    color: Colors.red),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (!requestSent) {
                                                await avail_request(
                                                    0.0,
                                                    _deliveryCharge,
                                                    0.0,
                                                    orderController,
                                                    Get.find<
                                                        ProductController>());
                                              }
                                            },
                                            child: !orderController.isLoading
                                                ? !orderController.isAvLoading
                                                    ? requestSent
                                                        ? const Text(
                                                            "Request Sent ",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                        : const Text(
                                                            "Check Availability",
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          )
                                                    : const Padding(
                                                        padding:
                                                            EdgeInsets.all(6.0),
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                      Color>(
                                                                  Colors.white),
                                                        ))
                                                : const CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            Colors.white)),
                                          )
                                        : SizedBox(),
                                  );
                                });
                              })
                            : const SizedBox(),
                      ]),
                    ),
                  ],
                )
              : NoDataScreen(isCart: true, text: '');
        },
      ),
    );
  }

  void _callback(
      bool isSuccess, int code, AvailabilityDetailsModel availability) async {
    if (availability != null) {
      print("ghrr ${availability}");
    }
  }

  Future<void> avail_request(
      double priceWithAddons,
      double _deliveryCharge,
      double _discount,
      OrderController orderController,
      ProductController productController) async {
    double _tax = 0;
    double _taxPercent = 0;
    double _addOns = 0;
    // _taxPercent = restController.restaurant.tax;
    double _subTotal = 0;
    _tax =
        PriceConverter.calculation(priceWithAddons, _taxPercent, 'percent', 1);
    _subTotal = priceWithAddons + _addOns;
    double _total = _subTotal +
        _deliveryCharge -
        _discount -
        Get.find<CouponController>().discount +
        _tax;
    AddressModel _address;
    String sharedAddress =
        sharedPreferences.getString(AppConstants.USER_ADDRESS);
    if (sharedAddress != null) {
      _address = AddressModel.fromJson(jsonDecode(sharedAddress));
      print("Fazal Address ${_address.toJson()}");
    } else {
      print(sharedAddress);
    }

    for (final value in Get.find<CartController>().cartList) {
      await Future.delayed(Duration(seconds: 1));
      print('Writing another word $value');

      int code = (await orderController.getAvailability(
          AvailabilityDetailsModel(
            userId: Get.find<UserController>().userInfoModel.id,
            food_id: value.product.id,
          ),
          _callback,
          false));

      if (code != 200) {
        error = true;
        //disable button
        response_text = "Already sent availability request";
        setState(() {
          shouldShow = true;
        });

        Timer timer = Timer(Duration(seconds: 3), () {
          setState(() {
            shouldShow = false;
          });
        });

        // showCustomSnackBar(
        //     "Already Sent Availability Request");
        // print("Fazalsmcfs ${code} ");
      } else {
        error = false;
        response_text = "Availability Request Sent";
        setState(() {
          shouldShow = true;
        });

        Timer timer = Timer(Duration(seconds: 3), () {
          setState(() {
            shouldShow = false;
          });
        });
        setState(() {
          requestSent = true;
        });
        orderController.placeAvailability(
          AvailabilityDetailsModel(
            food_id: value.product.id,
            restaurant_id: value.product.restaurantId,
            userId: Get.find<UserController>().userInfoModel.id,
            price: PriceConverter.convertPrice(priceWithAddons).toDouble(),
            status: "requested".toString(),
            foodDetails: value.product,
            deliveryAddress: _address,
            address: _address.address,
            latitude: _address.latitude,
            longitude: _address.longitude,
            contactPersonName: _address.contactPersonName ??
                '${Get.find<UserController>().userInfoModel.fName} '
                    '${Get.find<UserController>().userInfoModel.lName}',
            contactPersonNumber: _address.contactPersonNumber ??
                Get.find<UserController>().userInfoModel.phone,
            addressType: _address.addressType,
            deliveryCharge: _deliveryCharge,
            quantity: productController.quantity,
            order_amount: _total.toDouble(),
            deliveryAddressId: null,
          ),
          _callback,
        );
      }
    }
  }
}
