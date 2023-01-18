import 'package:carousel_slider/carousel_slider.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/controller/banner_controller.dart';
import 'package:sandav/controller/splash_controller.dart';
import 'package:sandav/controller/theme_controller.dart';
import 'package:sandav/data/model/response/basic_campaign_model.dart';
import 'package:sandav/data/model/response/product_model.dart';
import 'package:sandav/data/model/response/restaurant_model.dart';
import 'package:sandav/helper/responsive_helper.dart';
import 'package:sandav/helper/route_helper.dart';
import 'package:sandav/util/dimensions.dart';
import 'package:sandav/view/base/custom_image.dart';
import 'package:sandav/view/base/product_bottom_sheet.dart';
import 'package:sandav/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../commons/app_component.dart';
import '../../../../commons/colors.dart';
import '../../../../main.dart';
import '../../../../store/AppStore.dart';

class DiscountBanners extends StatelessWidget {
  PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BannerController>(builder: (bannerController) {
      return (bannerController.bannerImageList != null &&
              bannerController.bannerImageList.length == 0)
          ? SizedBox()
          : Container(
              width: MediaQuery.of(context).size.width,
              height: GetPlatform.isDesktop
                  ? 500
                  : MediaQuery.of(context).size.width * 0.65,
              padding: EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
              child: bannerController.bannerImageList != null
                  ? GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => TopDealsScreen()));
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 230,
                        child: Stack(
                          children: [
                            PageView.builder(
                                controller: pageController,
                                itemCount:
                                    bannerController.bannerImageList.length,
                                itemBuilder: (context, index) {
                                  String _baseUrl =
                                      bannerController.bannerDataList[index]
                                              is BasicCampaignModel
                                          ? Get.find<SplashController>()
                                              .configModel
                                              .baseUrls
                                              .campaignImageUrl
                                          : Get.find<SplashController>()
                                              .configModel
                                              .baseUrls
                                              .bannerImageUrl;
                                  return InkWell(
                                    onTap: () {
                                      if (bannerController.bannerDataList[index]
                                          is Product) {
                                        Product _product = bannerController
                                            .bannerDataList[index];
                                        ResponsiveHelper.isMobile(context)
                                            ? showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (con) =>
                                                    ProductBottomSheet(
                                                        product: _product),
                                              )
                                            : showDialog(
                                                context: context,
                                                builder: (con) => Dialog(
                                                    child: ProductBottomSheet(
                                                        product: _product)),
                                              );
                                      } else if (bannerController
                                              .bannerDataList[index]
                                          is Restaurant) {
                                        Restaurant _restaurant =
                                            bannerController
                                                .bannerDataList[index];
                                        Get.toNamed(
                                          RouteHelper.getRestaurantRoute(
                                              _restaurant.id),
                                          arguments: RestaurantScreen(
                                              restaurant: _restaurant),
                                        );
                                      } else if (bannerController
                                              .bannerDataList[index]
                                          is BasicCampaignModel) {
                                        BasicCampaignModel _campaign =
                                            bannerController
                                                .bannerDataList[index];
                                        Get.toNamed(
                                            RouteHelper.getBasicCampaignRoute(
                                                _campaign));
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          bottom: 16,
                                          top: 8),
                                      decoration: BoxDecoration(
                                        color: appStore.isDarkModeOn
                                            ? cardDarkColor
                                            : primaryColor.shade300,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            flex: 0,
                                            child: Text.rich(
                                              //And get it in less then 60 minutes
                                              TextSpan(
                                                //text: 'Pay\n\n',
                                                style: boldTextStyle(size: 26),
                                                children: [
                                                  TextSpan(
                                                      text: 'Pay Now\n\n',
                                                      style: boldTextStyle(
                                                          size: 16)),
                                                  TextSpan(
                                                    text:
                                                        'And get it in less, \nthen 60 minutes',
                                                    style: secondaryTextStyle(
                                                        size: 14),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Image.network(
                                                '$_baseUrl/${bannerController.bannerImageList[index]}'),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            Align(
                              alignment: Alignment(0, 0.75),
                              child: SmoothPageIndicator(
                                controller: pageController,
                                count: bannerController.bannerImageList.length,
                                effect: CustomizableEffect(
                                    activeDotDecoration: LightActiveDecoration,
                                    dotDecoration: LightDecoration),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Shimmer(
                      duration: Duration(seconds: 2),
                      enabled: bannerController.bannerImageList == null,
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Dimensions.RADIUS_SMALL),
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300],
                          )),
                    ),
            );
    });
  }
}
