import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/controller/auth_controller.dart';
import 'package:sandav/controller/restaurant_controller.dart';
import 'package:sandav/controller/splash_controller.dart';
import 'package:sandav/controller/theme_controller.dart';
import 'package:sandav/controller/wishlist_controller.dart';
import 'package:sandav/data/model/response/restaurant_model.dart';
import 'package:sandav/helper/route_helper.dart';
import 'package:sandav/main.dart';
 import 'package:sandav/util/app_constants.dart';
import 'package:sandav/util/dimensions.dart';
import 'package:sandav/util/styles.dart';
import 'package:sandav/view/base/custom_image.dart';
import 'package:sandav/view/base/custom_snackbar.dart';
import 'package:sandav/view/base/discount_tag.dart';
import 'package:sandav/view/base/not_available_widget.dart';
import 'package:sandav/view/base/rating_bar.dart';
import 'package:sandav/view/base/title_widget.dart';
import 'package:sandav/view/screens/restaurant/restaurant_screen.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../commons/colors.dart';
import '../../../../commons/constants.dart';
import '../../../../store/logicprovider.dart';
import '../../../../store/search_delagete_ob.dart';

class PopularStores extends StatefulWidget {
  final bool isPopular;
  PopularStores({@required this.isPopular});

  @override
  State<PopularStores> createState() => _PopularStoresState();
}

class _PopularStoresState extends State<PopularStores> {
  SearchDelegateOb observer = SearchDelegateOb();
  LogicProvider businessLogic = LogicProvider();
  final Restaurant restaurant = null;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RestaurantController>(builder: (restController) {
      List<Restaurant> _restaurantList = widget.isPopular
          ? restController.popularRestaurantList
          : restController.latestRestaurantList;
      ScrollController _scrollController = ScrollController();
      return (_restaurantList != null && _restaurantList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                ListTile(
                  title: Text(
                      widget.isPopular
                          ? 'popular_restaurants'.tr
                          : '${'new_on'.tr} ${AppConstants.APP_NAME}',
                      style: boldTextStyle(size: 18)),
                  trailing: TextButton(
                    child: Text('See All', style: primaryTextStyle()),
                    onPressed: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => TopDealsScreen())

                      //         );
                      Get.toNamed(RouteHelper.getAllRestaurantRoute(
                          widget.isPopular ? 'popular' : 'latest'));
                    },
                  ),
                ),
                SizedBox(
                  height: 150,
                  child: _restaurantList != null
                      ? Column(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                height: 45,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _restaurantList.length > 10
                                      ? 10
                                      : _restaurantList.length,
                                  padding: EdgeInsets.only(
                                      left: 16, right: 8, bottom: 8, top: 8),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        observer.changeColor(primaryWhiteColor,
                                            primaryBlackColor, index);
                                        
                                      },
                                      child: Observer(
                                        builder: (context) => Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 4),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: primaryBlackColor),
                                            color: appStore.isDarkModeOn
                                                ? cardDarkColor
                                                : observer.bgColor[index],
                                            borderRadius:
                                                BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            _restaurantList[index].name,
                                            style: TextStyle(
                                                color: appStore.isDarkModeOn
                                                    ? white
                                                    : observer
                                                        .textColor[index]),
                                            textAlign: TextAlign.center,
                                          ),
                                        ).paddingRight(8),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            // Wrap(
                            //       direction: Axis.horizontal,
                            //       runSpacing: 16,
                            //       spacing: 16,
                            //       children: List.generate(
                            //         _restaurantList.length,
                            //         (index) {
                            //           return GestureDetector(
                            //             onTap: () {
                            //               // Navigator.push(
                            //               //   context,
                            //               //   MaterialPageRoute(
                            //               //     builder: (context) => DetailScreen(
                            //               //         image: observer
                            //               //             .list_of_image[index]),
                            //               //   ),
                            //               // );
                            //               Get.toNamed(
                            //                 RouteHelper.getRestaurantRoute(
                            //                     _restaurantList[index].id),
                            //                 arguments: RestaurantScreen(
                            //                     restaurant: _restaurantList[index]),
                            //               );
                            //             },
                            //             child: Container(
                            //               alignment: Alignment.topCenter,
                            //               width: Get.width * 0.5 - 20,
                            //               decoration: BoxDecoration(
                            //                   color: context.cardColor,
                            //                   borderRadius:
                            //                       BorderRadius.circular(15)),
                            //               child: Stack(
                            //                 children: [
                            //                   Column(
                            //                     mainAxisAlignment:
                            //                         MainAxisAlignment.start,
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.start,
                            //                     children: [
                            //                       Observer(
                            //                         builder: (context) => Container(
                            //                           padding: EdgeInsets.all(10),
                            //                           decoration: BoxDecoration(
                            //                             color: appStore.isDarkModeOn
                            //                                 ? cardDarkColor
                            //                                 : primaryColor.shade300,
                            //                             borderRadius:
                            //                                 BorderRadius.circular(
                            //                                     15),
                            //                           ),
                            //                           child: CustomImage(
                            //                             height: 140,
                            //                             width: (Get.width > 450)
                            //                                 ? (Get.width / 2.2)
                            //                                 : 220,
                            //                             image: "",
                            //                           ),
                            //                         ),
                            //                       ),
                            //                       SizedBox(height: 10),
                            //                       Text("Fazal",
                            //                               style: boldTextStyle())
                            //                           .paddingOnly(left: 8),
                            //                       SizedBox(height: 10),
                            //                       Row(
                            //                         children: [
                            //                           Icon(Icons.star_half_rounded,
                            //                               color: Get.iconColor),
                            //                           Text(listOfCarRating[index],
                            //                               style:
                            //                                   primaryTextStyle()),
                            //                           Text(" | "),
                            //                           SizedBox(width: 8),
                            //                           Text(

                            //                             "Fazal",
                            //                             style: TextStyle(
                            //                               color: appStore
                            //                                       .isDarkModeOn
                            //                                   ? white
                            //                                   : primaryBlackColor,
                            //                               fontSize: 10,
                            //                               background: Paint()
                            //                                 ..color = appStore
                            //                                         .isDarkModeOn
                            //                                     ? cardDarkColor
                            //                                     : primaryColor
                            //                                         .shade300
                            //                                 ..strokeWidth = 12
                            //                                 ..strokeCap =
                            //                                     StrokeCap.round
                            //                                 ..strokeJoin =
                            //                                     StrokeJoin.round
                            //                                 ..style = PaintingStyle
                            //                                     .stroke,
                            //                             ),
                            //                           ),
                            //                         ],
                            //                       ).paddingOnly(left: 8),
                            //                       SizedBox(height: 6),
                            //                       Text(
                            //                               "Fazal",
                            //                               style: boldTextStyle())
                            //                           .paddingOnly(left: 8),
                            //                       SizedBox(height: 8),
                            //                     ],
                            //                   ),
                            //                   Align(
                            //                     alignment: Alignment.topRight,
                            //                     child: IconButton(
                            //                       padding: EdgeInsets.zero,
                            //                       constraints: BoxConstraints(),
                            //                       highlightColor:
                            //                           Colors.transparent,
                            //                       splashColor: Colors.transparent,
                            //                       icon: Observer(
                            //                           builder: (context) =>
                            //                               businessLogic
                            //                                   .IconList[index]),
                            //                       onPressed: () {
                            //                         businessLogic
                            //                             .changeIconOfFavarite(
                            //                                 index);
                            //                       },
                            //                     ),
                            //                   ).paddingOnly(top: 8, right: 8),
                            //                 ],
                            //               ),
                            //             ),
                            //           );
                            //         },
                            //       ),
                            //     ),
                            SizedBox(height: 24)
                          ],
                        )
                      : SizedBox(
                          height: 50,
                        ),
                ),
              ],
            );
    });
  }
}

class PopularRestaurantShimmer extends StatelessWidget {
  final RestaurantController restController;
  PopularRestaurantShimmer({@required this.restController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Container(
          height: 150,
          width: 200,
          margin:
              EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL, bottom: 5),
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300],
                    blurRadius: 10,
                    spreadRadius: 1)
              ]),
          child: Shimmer(
            duration: Duration(seconds: 2),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                height: 90,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(Dimensions.RADIUS_SMALL)),
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300]),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 10,
                            width: 100,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300]),
                        SizedBox(height: 5),
                        Container(
                            height: 10,
                            width: 130,
                            color: Colors.grey[
                                Get.find<ThemeController>().darkTheme
                                    ? 700
                                    : 300]),
                        SizedBox(height: 5),
                        RatingBar(rating: 0.0, size: 12, ratingCount: 0),
                      ]),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
