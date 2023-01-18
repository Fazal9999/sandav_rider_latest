import 'dart:async';
import 'dart:convert';

import 'package:google_fonts/google_fonts.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/commons/images.dart';
import 'package:sandav/controller/auth_controller.dart';
import 'package:sandav/controller/cart_controller.dart';
import 'package:sandav/controller/coupon_controller.dart';
import 'package:sandav/controller/location_controller.dart';
import 'package:sandav/controller/order_controller.dart';
import 'package:sandav/controller/product_controller.dart';
import 'package:sandav/controller/splash_controller.dart';
import 'package:sandav/controller/wishlist_controller.dart';
import 'package:sandav/data/model/response/availability_details_model.dart';
import 'package:sandav/data/model/response/cart_model.dart';
import 'package:sandav/data/model/response/product_model.dart';
import 'package:sandav/helper/date_converter.dart';
import 'package:sandav/helper/price_converter.dart';
import 'package:sandav/helper/responsive_helper.dart';
import 'package:sandav/helper/route_helper.dart';
import 'package:sandav/util/dimensions.dart';
import 'package:sandav/util/styles.dart';
import 'package:sandav/view/base/confirmation_dialog.dart';
import 'package:sandav/view/base/custom_button.dart';
import 'package:sandav/view/base/custom_image.dart';
import 'package:sandav/view/base/custom_snackbar.dart';
import 'package:sandav/view/base/discount_tag.dart';
import 'package:sandav/view/base/discount_tag_without_image.dart';
import 'package:sandav/view/base/quantity_button.dart';
import 'package:sandav/view/base/rating_bar.dart';
import 'package:sandav/view/screens/checkout/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/restaurant_controller.dart';
import '../../controller/user_controller.dart';
import '../../data/model/body/place_order_body.dart';
import '../../data/model/response/address_model.dart';
import '../../main.dart';
import '../../util/app_constants.dart';

class ProductBottomSheet extends StatefulWidget {
  final Product product;
  final bool isCampaign;
  final CartModel cart;
  final int cartIndex;

  final bool inRestaurantPage;
  ProductBottomSheet(
      {@required this.product,
      this.isCampaign = false,
      this.cart,
      this.cartIndex,
      this.inRestaurantPage = false});

  @override
  State<ProductBottomSheet> createState() => _ProductBottomSheetState();
}

class _ProductBottomSheetState extends State<ProductBottomSheet> {
  bool _isCashOnDeliveryActive;
  bool _isDigitalPaymentActive;
  bool error = false;
  bool shouldShow = false;
  bool _isWalletActive;
  bool _todayClosed = false;
  bool _tomorrowClosed = false;
  String response_text = "";

  @override
  Future<void> initState()  {
    super.initState();

    _isCashOnDeliveryActive =
        Get.find<SplashController>().configModel.cashOnDelivery;
    _isDigitalPaymentActive =
        Get.find<SplashController>().configModel.digitalPayment;
    _isWalletActive =
        Get.find<SplashController>().configModel.customerWalletStatus == 1;
    Get.find<ProductController>().initData(widget.product, widget.cart);
  ///avail_availability();

  }
  Future<int> avail_availability() async {
    int code =   (await Get.find<OrderController>().getAvailability(
        AvailabilityDetailsModel(
        userId: Get.find<UserController>()
            .userInfoModel
            .id,
        food_id: widget.product.id,
    ),
    _callback , true  ));
      print("ghhl  ${code}");


  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      margin: EdgeInsets.only(top: GetPlatform.isWeb ? 0 : 30),
      padding: EdgeInsets.only(
          left: Dimensions.PADDING_SIZE_DEFAULT,
          bottom: Dimensions.PADDING_SIZE_DEFAULT),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: ResponsiveHelper.isMobile(context)
            ? BorderRadius.vertical(
                top: Radius.circular(Dimensions.RADIUS_EXTRA_LARGE))
            : BorderRadius.all(Radius.circular(Dimensions.RADIUS_EXTRA_LARGE)),
      ),
      child: GetBuilder<ProductController>(builder: (productController) {
        double _startingPrice;
        double _endingPrice;
        if (widget.product.choiceOptions.length != 0) {
          List<double> _priceList = [];
          widget.product.variations
              .forEach((variation) => _priceList.add(variation.price));
          _priceList.sort((a, b) => a.compareTo(b));
          _startingPrice = _priceList[0];
          if (_priceList[0] < _priceList[_priceList.length - 1]) {
            _endingPrice = _priceList[_priceList.length - 1];
          }
        } else {
          _startingPrice = widget.product.price;
        }

        List<String> _variationList = [];
        for (int index = 0;
            index < widget.product.choiceOptions.length;
            index++) {
          _variationList.add(widget.product.choiceOptions[index]
              .options[productController.variationIndex[index]]
              .replaceAll(' ', ''));
        }
        String variationType = '';
        bool isFirst = true;
        _variationList.forEach((variation) {
          if (isFirst) {
            variationType = '$variationType$variation';
            isFirst = false;
          } else {
            variationType = '$variationType-$variation';
          }
        });

        double price = widget.product.price;
        Variation _variation;
        for (Variation variation in widget.product.variations) {
          if (variation.type == variationType) {
            price = variation.price;
            _variation = variation;
            break;
          }
        }

        double _discount =
            (widget.isCampaign || widget.product.restaurantDiscount == 0)
                ? widget.product.discount
                : widget.product.restaurantDiscount;
        String _discountType =
            (widget.isCampaign || widget.product.restaurantDiscount == 0)
                ? widget.product.discountType
                : 'percent';
        double priceWithDiscount =
            PriceConverter.convertWithDiscount(price, _discount, _discountType);
        double priceWithQuantity =
            priceWithDiscount * productController.quantity;
        double addonsCost = 0;
        List<AddOn> _addOnIdList = [];
        List<AddOns> _addOnsList = [];
        for (int index = 0; index < widget.product.addOns.length; index++) {
          if (productController.addOnActiveList[index]) {
            addonsCost = addonsCost +
                (widget.product.addOns[index].price *
                    productController.addOnQtyList[index]);
            _addOnIdList.add(AddOn(
                id: widget.product.addOns[index].id,
                quantity: productController.addOnQtyList[index]));
            _addOnsList.add(widget.product.addOns[index]);
          }
        }
        double priceWithAddons = priceWithQuantity + addonsCost;
        // bool _isRestAvailable = DateConverter.isAvailable(widget.product.restaurantOpeningTime, widget.product.restaurantClosingTime);
        bool _isAvailable = DateConverter.isAvailable(
            widget.product.availableTimeStarts,
            widget.product.availableTimeEnds);

        CartModel _cartModel = CartModel(
          price,
          priceWithDiscount,
          _variation != null ? [_variation] : [],
          (price -
              PriceConverter.convertWithDiscount(
                  price, _discount, _discountType)),
          productController.quantity,
          _addOnIdList,
          _addOnsList,
          widget.isCampaign,
          widget.product,
        );
        //bool isExistInCart = Get.find<CartController>().isExistInCart(_cartModel, fromCart, cartIndex);

        return SingleChildScrollView(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                InkWell(
                    onTap: () => Get.back(),
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: Dimensions.PADDING_SIZE_DEFAULT,
                        top: Dimensions.PADDING_SIZE_SMALL,
                      ),
                      child: Icon(Icons.close),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                    right: Dimensions.PADDING_SIZE_DEFAULT,
                    top: ResponsiveHelper.isDesktop(context)
                        ? 0
                        : Dimensions.PADDING_SIZE_DEFAULT,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Product
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (widget.product.image != null &&
                                      widget.product.image.isNotEmpty)
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: InkWell(
                                        onTap: widget.isCampaign
                                            ? null
                                            : () {
                                                if (!widget.isCampaign) {
                                                  Get.toNamed(RouteHelper
                                                      .getItemImagesRoute(
                                                          widget.product));
                                                }
                                              },
                                        child: Stack(children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL),
                                            child: CustomImage(
                                              image:
                                                  '${widget.isCampaign ? Get.find<SplashController>().configModel.baseUrls.campaignImageUrl : Get.find<SplashController>().configModel.baseUrls.productImageUrl}/${widget.product.image}',
                                              width: ResponsiveHelper.isMobile(
                                                      context)
                                                  ? 100
                                                  : 140,
                                              height: ResponsiveHelper.isMobile(
                                                      context)
                                                  ? 100
                                                  : 140,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          DiscountTag(
                                              discount: _discount,
                                              discountType: _discountType,
                                              fromTop: 20),
                                        ]),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        // widget.product.status==1 ? widget.product.name : "${widget.product.name}  (Out Of Stock)"
                                        // ,
                                        widget.product.name,
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge),
                                        maxLines: 2,

                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (widget.inRestaurantPage) {
                                            Get.back();
                                          } else {
                                            Get.offNamed(
                                                RouteHelper.getRestaurantRoute(
                                                    widget
                                                        .product.restaurantId));
                                          }
                                        },
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 5, 5),
                                          child: Text(
                                            widget.product.restaurantName,
                                            style: robotoRegular.copyWith(
                                                fontSize:
                                                    Dimensions.fontSizeSmall,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                        ),
                                      ),
                                      RatingBar(
                                          rating: widget.product.avgRating,
                                          size: 15,
                                          ratingCount:
                                              widget.product.ratingCount),
                                      Text(
                                        '${PriceConverter.convertPrice(_startingPrice, discount: _discount, discountType: _discountType)}'
                                        '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice, discount: _discount, discountType: _discountType)}' : ''}',
                                        style: robotoMedium.copyWith(
                                            fontSize: Dimensions.fontSizeLarge),
                                      ),
                                      Row(children: [
                                        price > priceWithDiscount
                                            ? Text(
                                                '${PriceConverter.convertPrice(_startingPrice)}'
                                                '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(_endingPrice)}' : ''}',
                                                style: robotoMedium.copyWith(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    decoration: TextDecoration
                                                        .lineThrough),
                                              )
                                            : SizedBox(),
                                        SizedBox(
                                            width: Dimensions
                                                .PADDING_SIZE_EXTRA_SMALL),
                                        (widget.product.image != null &&
                                                widget.product.image.isNotEmpty)
                                            ? SizedBox.shrink()
                                            : DiscountTagWithoutImage(
                                                discount: _discount,
                                                discountType: _discountType),
                                      ]),
                                    ]),
                              ),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Get.find<SplashController>()
                                            .configModel
                                            .toggleVegNonVeg
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                                horizontal: Dimensions
                                                    .PADDING_SIZE_SMALL),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: Text(
                                              widget.product.veg == 0
                                                  ? 'non_veg'.tr
                                                  : 'veg'.tr,
                                              style: robotoRegular.copyWith(
                                                  fontSize: Dimensions
                                                      .fontSizeExtraSmall,
                                                  color: Colors.white),
                                            ),
                                          )
                                        : SizedBox(),
                                    SizedBox(
                                        height: Get.find<SplashController>()
                                                .configModel
                                                .toggleVegNonVeg
                                            ? 50
                                            : 0),
                                    widget.isCampaign
                                        ? SizedBox(height: 25)
                                        : GetBuilder<WishListController>(
                                            builder: (wishList) {
                                            return InkWell(
                                              onTap: () {
                                                if (Get.find<AuthController>()
                                                    .isLoggedIn()) {
                                                  wishList.wishProductIdList
                                                          .contains(
                                                              widget.product.id)
                                                      ? wishList
                                                          .removeFromWishList(
                                                              widget.product.id,
                                                              false)
                                                      : wishList.addToWishList(
                                                          widget.product,
                                                          null,
                                                          false);
                                                } else {
                                                  showCustomSnackBar(
                                                      'you_are_not_logged_in'
                                                          .tr);
                                                }
                                              },
                                              child: Icon(
                                                wishList.wishProductIdList
                                                        .contains(
                                                            widget.product.id)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: wishList
                                                        .wishProductIdList
                                                        .contains(
                                                            widget.product.id)
                                                    ? Theme.of(context)
                                                        .primaryColor
                                                    : Theme.of(context)
                                                        .disabledColor,
                                              ),
                                            );
                                          }),
                                  ]),
                            ]),

                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        (widget.product.description != null &&
                                widget.product.description.isNotEmpty)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('description'.tr, style: robotoMedium),
                                  SizedBox(
                                      height:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  Text(widget.product.description,
                                      style: robotoRegular),
                                  SizedBox(
                                      height: Dimensions.PADDING_SIZE_LARGE),
                                ],
                              )
                            : SizedBox(),

                        // Variation
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.product.choiceOptions.length,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      widget.product.choiceOptions[index].title,
                                      style: robotoMedium),
                                  SizedBox(
                                      height:
                                          Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                  GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          ResponsiveHelper.isMobile(context)
                                              ? 3
                                              : 4,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: (1 / 0.25),
                                    ),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: widget.product
                                        .choiceOptions[index].options.length,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        onTap: () {
                                          print(
                                              '---check for update  ${widget.cart != null ? widget.cart.toJson() : null} and ${productController.cartIndex}-----');
                                          print(
                                              '-----and ${productController.cartIndex}///-----');
                                          productController
                                              .setCartVariationIndex(
                                                  index, i, widget.product);
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          decoration: BoxDecoration(
                                            color: productController
                                                            .variationIndex[
                                                        index] !=
                                                    i
                                                ? Theme.of(context)
                                                    .backgroundColor
                                                : Theme.of(context)
                                                    .primaryColor,
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL),
                                            border: productController
                                                            .variationIndex[
                                                        index] !=
                                                    i
                                                ? Border.all(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    width: 2)
                                                : null,
                                          ),
                                          child: Text(
                                            widget.product.choiceOptions[index]
                                                .options[i]
                                                .trim(),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: robotoRegular.copyWith(
                                              color: productController
                                                              .variationIndex[
                                                          index] !=
                                                      i
                                                  ? Colors.black
                                                  : Colors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(
                                      height: index !=
                                              widget.product.choiceOptions
                                                      .length -
                                                  1
                                          ? Dimensions.PADDING_SIZE_LARGE
                                          : 0),
                                ]);
                          },
                        ),
                        SizedBox(
                            height: widget.product.choiceOptions.length > 0
                                ? Dimensions.PADDING_SIZE_LARGE
                                : 0),

                        // Quantity
                        Row(children: [
                          Text('quantity'.tr, style: robotoMedium),
                          Expanded(child: SizedBox()),
                          Row(children: [
                            QuantityButton(
                              onTap: () {
                                if (productController.quantity > 1) {
                                  productController.setQuantity(false);
                                }
                              },
                              isIncrement: false,
                            ),
                            Text(productController.quantity.toString(),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge)),
                            QuantityButton(
                              onTap: () => productController.setQuantity(true),
                              isIncrement: true,
                            ),
                          ]),
                        ]),
                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        // Addons
                        widget.product.addOns.length > 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                    Text('addons'.tr, style: robotoMedium),
                                    SizedBox(
                                        height: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                    GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 10,
                                        childAspectRatio: (1 / 1.1),
                                      ),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: widget.product.addOns.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            if (!productController
                                                .addOnActiveList[index]) {
                                              productController.addAddOn(
                                                  true, index);
                                            } else if (productController
                                                    .addOnQtyList[index] ==
                                                1) {
                                              productController.addAddOn(
                                                  false, index);
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                bottom: productController
                                                        .addOnActiveList[index]
                                                    ? 2
                                                    : 20),
                                            decoration: BoxDecoration(
                                              color: productController
                                                      .addOnActiveList[index]
                                                  ? Theme.of(context)
                                                      .primaryColor
                                                  : Theme.of(context)
                                                      .backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              border: productController
                                                      .addOnActiveList[index]
                                                  ? null
                                                  : Border.all(
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                      width: 2),
                                              boxShadow: productController
                                                      .addOnActiveList[index]
                                                  ? [
                                                      BoxShadow(
                                                          color: Colors.grey[
                                                              Get.isDarkMode
                                                                  ? 700
                                                                  : 300],
                                                          blurRadius: 5,
                                                          spreadRadius: 1)
                                                    ]
                                                  : null,
                                            ),
                                            child: Column(children: [
                                              Expanded(
                                                child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        widget.product
                                                            .addOns[index].name,
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: robotoMedium
                                                            .copyWith(
                                                          color: productController
                                                                      .addOnActiveList[
                                                                  index]
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Dimensions
                                                              .fontSizeSmall,
                                                        ),
                                                      ),
                                                      SizedBox(height: 5),
                                                      Text(
                                                        widget
                                                                    .product
                                                                    .addOns[
                                                                        index]
                                                                    .price >
                                                                0
                                                            ? PriceConverter
                                                                .convertPrice(
                                                                    widget
                                                                        .product
                                                                        .addOns[
                                                                            index]
                                                                        .price)
                                                            : 'free'.tr,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: robotoRegular
                                                            .copyWith(
                                                          color: productController
                                                                      .addOnActiveList[
                                                                  index]
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: Dimensions
                                                              .fontSizeExtraSmall,
                                                        ),
                                                      ),
                                                    ]),
                                              ),
                                              productController
                                                      .addOnActiveList[index]
                                                  ? Container(
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius
                                                              .circular(Dimensions
                                                                  .RADIUS_SMALL),
                                                          color:
                                                              Theme.of(context)
                                                                  .cardColor),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () {
                                                                  if (productController
                                                                              .addOnQtyList[
                                                                          index] >
                                                                      1) {
                                                                    productController
                                                                        .setAddOnQuantity(
                                                                            false,
                                                                            index);
                                                                  } else {
                                                                    productController
                                                                        .addAddOn(
                                                                            false,
                                                                            index);
                                                                  }
                                                                },
                                                                child: Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .remove,
                                                                        size:
                                                                            15)),
                                                              ),
                                                            ),
                                                            Text(
                                                              productController
                                                                  .addOnQtyList[
                                                                      index]
                                                                  .toString(),
                                                              style: robotoMedium
                                                                  .copyWith(
                                                                      fontSize:
                                                                          Dimensions
                                                                              .fontSizeSmall),
                                                            ),
                                                            Expanded(
                                                              child: InkWell(
                                                                onTap: () =>
                                                                    productController
                                                                        .setAddOnQuantity(
                                                                            true,
                                                                            index),
                                                                child: Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .add,
                                                                        size:
                                                                            15)),
                                                              ),
                                                            ),
                                                          ]),
                                                    )
                                                  : SizedBox(),
                                            ]),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                        height: Dimensions
                                            .PADDING_SIZE_EXTRA_SMALL),
                                  ])
                            : SizedBox(),
                        GetBuilder<OrderController>(builder: (orderController) {
                          List<AddressModel> _addressList = [];
                          return GetBuilder<RestaurantController>(
                              builder: (restController) {
                            double _deliveryCharge = -1;

                            if (restController.restaurant != null) {
                              _todayClosed = restController.isRestaurantClosed(
                                  true,
                                  restController.restaurant.active,
                                  restController.restaurant.schedules);
                              _tomorrowClosed =
                                  restController.isRestaurantClosed(
                                      false,
                                      restController.restaurant.active,
                                      restController.restaurant.schedules);
                            }
                            _addressList.add(Get.find<LocationController>()
                                .getUserAddress());
                            if (restController.restaurant != null) {
                              if (Get.find<LocationController>().addressList !=
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
                                      .contains(
                                          restController.restaurant.zoneId)) {
                                    _addressList.add(
                                        Get.find<LocationController>()
                                            .addressList[index]);
                                  }
                                }
                              }
                            }
                            return
                              Row(children: [
                              Text('${'total_amount'.tr}:',
                                  style: robotoMedium),
                              SizedBox(
                                  width: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                              Text(PriceConverter.convertPrice(priceWithAddons),
                                  style: robotoBold.copyWith(
                                      color: Theme.of(context).primaryColor)),
                              SizedBox(width: Dimensions.PADDING_SIZE_LARGE),
                              Expanded(child: SizedBox()),
                                Get.find<AuthController>()
                                    .isLoggedIn() ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(40, 40),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    side:
                                        BorderSide(width: 2, color: Colors.red),
                                  ),
                                ),
                                onPressed: () async {
                                  await avail_request(priceWithAddons, _deliveryCharge, _discount, orderController, productController);
                                  },
                                child: !orderController.isLoading
                                    ? Text(
                                        "Check Availability",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        )),
                              ):SizedBox(),
                            ]);
                          });
                        }),

                        SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                        Container(
                          alignment: Alignment.center,
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          margin: EdgeInsets.only(
                              bottom: Dimensions.PADDING_SIZE_SMALL),
                          child: shouldShow
                              ? Text(
                                  response_text,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: error ? Colors.red : Colors.green,


                                      fontWeight: FontWeight.bold),
                                )
                              : Text(""),
                        ),
                        _isAvailable
                            ? SizedBox()
                            : Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                margin: EdgeInsets.only(
                                    bottom: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.1),
                                ),
                                child: Column(children: [
                                  Text('not_available_now'.tr,
                                      style: robotoMedium.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Dimensions.fontSizeLarge,
                                      )),
                                  Text(
                                    '${'available_will_be'.tr} ${DateConverter.convertTimeToTime(widget.product.availableTimeStarts)} '
                                    '- ${DateConverter.convertTimeToTime(widget.product.availableTimeEnds)}',
                                    style: robotoRegular,
                                  ),
                                ]),
                              ),

                        (!widget.product.scheduleOrder && !_isAvailable)
                            ? SizedBox()
                            : Row(children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(50, 50),
                                    primary: Theme.of(context).cardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      side: BorderSide(
                                          width: 2,
                                          color:
                                              Theme.of(context).primaryColor),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (widget.inRestaurantPage) {
                                      Get.back();
                                    } else {
                                      Get.offNamed(
                                          RouteHelper.getRestaurantRoute(
                                              widget.product.restaurantId));
                                    }
                                  },
                                  child: Image.asset(house,
                                      height: 30,
                                      color: Colors.black,
                                      width: 30),
                                ),
                                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                Expanded(
                                    child: CustomButton(
                                  width: ResponsiveHelper.isDesktop(context)
                                      ? MediaQuery.of(context).size.width / 2.0
                                      : null,
                                  /*buttonText: isCampaign ? 'order_now'.tr : isExistInCart ? 'already_added_in_cart'.tr : fromCart
                                  ? 'update_in_cart'.tr : 'add_to_cart'.tr,*/
                                  buttonText: widget.isCampaign
                                      ? 'order_now'.tr
                                      : (widget.cart != null ||
                                              productController.cartIndex != -1)
                                          ? 'update_in_cart'.tr
                                          : 'add_to_cart'.tr,
                                  onPressed: () {
                                    Get.back();
                                    if (widget.isCampaign) {
                                      Get.toNamed(
                                          RouteHelper.getCheckoutRoute(
                                              'campaign'),
                                          arguments: CheckoutScreen(
                                            fromCart: false,
                                            cartList: [_cartModel],
                                          ));
                                    } else {
                                      if (Get.find<CartController>()
                                          .existAnotherRestaurantProduct(
                                              _cartModel
                                                  .product.restaurantId)) {
                                        Get.dialog(
                                            ConfirmationDialog(
                                              icon: warning,
                                              title: 'are_you_sure_to_reset'.tr,
                                              description: 'if_you_continue'.tr,
                                              onYesPressed: () {
                                                Get.back();
                                                Get.find<CartController>()
                                                    .removeAllAndAddToCart(
                                                        _cartModel);
                                                _showCartSnackBar();
                                              },
                                            ),
                                            barrierDismissible: false);
                                      } else {
                                        Get.find<CartController>().addToCart(
                                            _cartModel,
                                            widget.cartIndex != null
                                                ? widget.cartIndex
                                                : productController.cartIndex);
                                        _showCartSnackBar();
                                      }
                                    }
                                  },
                                )),
                              ]),
                      ]),
                ),
              ]),
        );
      }),
    );
  }

  Future<void> avail_request(double priceWithAddons, double _deliveryCharge, double _discount, OrderController orderController, ProductController productController) async {
     double _tax = 0;
    double _taxPercent = 0;
    double _addOns = 0;
    // _taxPercent = restController.restaurant.tax;
    double _subTotal = 0;
    _tax = PriceConverter.calculation(
        priceWithAddons,
        _taxPercent,
        'percent',
        1);
    _subTotal = priceWithAddons + _addOns;
    double _total = _subTotal +
        _deliveryCharge -
        _discount -
        Get.find<CouponController>().discount +
        _tax;
    AddressModel _address;
    String sharedAddress = sharedPreferences
        .getString(AppConstants.USER_ADDRESS);
    if (sharedAddress != null) {
      _address = AddressModel.fromJson(
          jsonDecode(sharedAddress));
      print("Fazal Address ${_address.toJson()}");
    } else {
      print(sharedAddress);
    }
    
    int code =
        (await orderController.getAvailability(
            AvailabilityDetailsModel(
              userId: Get.find<UserController>()
                  .userInfoModel
                  .id,
              food_id: widget.product.id,
            ),
            _callback,false));
    
    if (code != 200) {
      error = true;
      //disable button
      response_text =
          "Already sent availability request";
      setState(() {
        shouldShow = true;
      });
    
      Timer timer =
          Timer(Duration(seconds: 3), () {
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
    
      Timer timer =
          Timer(Duration(seconds: 3), () {
        setState(() {
          shouldShow = false;
        });
      });
    
      orderController.placeAvailability(
        AvailabilityDetailsModel(
          food_id: widget.product.id,
          restaurant_id:
              widget.product.restaurantId,
          userId: Get.find<UserController>()
              .userInfoModel
              .id,
          price: PriceConverter.convertPrice(
                  priceWithAddons)
              .toDouble(),
          status: "requested".toString(),
          foodDetails: widget.product,
          deliveryAddress: _address,
          address: _address.address,
          latitude: _address.latitude,
          longitude: _address.longitude,
          contactPersonName: _address
                  .contactPersonName ??
              '${Get.find<UserController>().userInfoModel.fName} '
                  '${Get.find<UserController>().userInfoModel.lName}',
          contactPersonNumber:
              _address.contactPersonNumber ??
                  Get.find<UserController>()
                      .userInfoModel
                      .phone,
          addressType: _address.addressType,
          deliveryCharge: _deliveryCharge,
          quantity: productController.quantity,
          order_amount: _total.toDouble(),
          deliveryAddressId: null,
        ),
        _callback,
      );
    }
    bool _isAvailable = true;
    if (!_isCashOnDeliveryActive &&
        !_isDigitalPaymentActive &&
        !_isWalletActive) {
      showCustomSnackBar(
          'no_payment_method_is_enabled'.tr);
    }
    else if ((orderController.selectedDateSlot ==
                0 &&
            _todayClosed) ||
        (orderController.selectedDateSlot == 1 &&
            _tomorrowClosed)) {
      showCustomSnackBar(
          'restaurant_is_closed'.tr);
    } else if (orderController.timeSlots ==
            null ||
        orderController.timeSlots.length == 0) {

    } else if (!_isAvailable) {
      showCustomSnackBar(
          'one_or_more_products_are_not_available_for_this_selected_time'
              .tr);
    } else if (orderController.orderType !=
            'take_away' &&
        orderController.distance == -1 &&
        _deliveryCharge == -1) {
      showCustomSnackBar(
          'delivery_fee_not_set_yet'.tr);
    } else {
      List<Cart> carts = [];
      for (int index = 0;
          index <
              Get.find<CartController>()
                  .cartList
                  .length;
          index++) {
        CartModel cart =
            Get.find<CartController>()
                .cartList[index];
        List<int> _addOnIdList = [];
        List<int> _addOnQtyList = [];
        cart.addOnIds.forEach((addOn) {
          _addOnIdList.add(addOn.id);
          _addOnQtyList.add(addOn.quantity);
        });
        carts.add(Cart(
          cart.isCampaign
              ? null
              : cart.product.id,
          cart.isCampaign
              ? cart.product.id
              : null,
          cart.discountedPrice.toString(),
          '',
          cart.variation,
          cart.quantity,
          _addOnIdList,
          cart.addOns,
          _addOnQtyList,
        ));
      }
    
    }
                                     
  }

  void _showCartSnackBar() {
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      dismissDirection: DismissDirection.horizontal,
      margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.green,
      action: SnackBarAction(
          label: 'view_cart'.tr,
          textColor: Colors.white,
          onPressed: () {
            Get.toNamed(RouteHelper.getCartRoute());
          }),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      content: Text(
        'item_added_to_cart'.tr,
        style: robotoMedium.copyWith(color: Colors.white),
      ),
    ));
    // Get.showSnackbar(GetSnackBar(
    //   backgroundColor: Colors.green,
    //   message: 'item_added_to_cart'.tr,
    //   mainButton: TextButton(
    //     onPressed: () => Get.toNamed(RouteHelper.getCartRoute()),
    //     child: Text('view_cart'.tr, style: robotoMedium.copyWith(color: Theme.of(context).cardColor)),
    //   ),
    //   onTap: (_) => Get.toNamed(RouteHelper.getCartRoute()),
    //   duration: Duration(seconds: 3),
    //   maxWidth: Dimensions.WEB_MAX_WIDTH,
    //   snackStyle: SnackStyle.FLOATING,
    //   margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
    //   borderRadius: 10,
    //   isDismissible: true,
    //   dismissDirection: DismissDirection.horizontal,
    // ));
  }

  void _callback(bool isSuccess, int code , AvailabilityDetailsModel availability) async {
     if(availability!=null){
       print("ghrr ${availability}");
     }
  }
}
