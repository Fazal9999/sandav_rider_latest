import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/controller/category_controller.dart';
import 'package:sandav/controller/splash_controller.dart';
import 'package:sandav/controller/theme_controller.dart';
import 'package:sandav/helper/responsive_helper.dart';
import 'package:sandav/helper/route_helper.dart';
import 'package:sandav/util/dimensions.dart';
import 'package:sandav/util/styles.dart';
import 'package:sandav/view/base/custom_image.dart';
import 'package:sandav/view/base/title_widget.dart';
import 'package:sandav/view/screens/home/widget/category_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class NewCategoryView extends StatefulWidget {
  @override
  State<NewCategoryView> createState() => _NewCategoryViewState();
}

class _NewCategoryViewState extends State<NewCategoryView> {
  double width;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    width = MediaQuery.of(context).size.width;
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = ScrollController();

    return GetBuilder<CategoryController>(builder: (categoryController) {
      return (categoryController.categoryList != null &&
              categoryController.categoryList.length == 0)
          ? SizedBox()
          : Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: TitleWidget(
                      title: 'categories'.tr,
                      onTap: () => Get.toNamed(RouteHelper.getCategoryRoute())),
                ),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 85,
                        child: categoryController.categoryList != null
                            ? ListView.builder(
                                controller: _scrollController,
                                itemCount:
                                    categoryController.categoryList.length > 15
                                        ? 15
                                        : categoryController
                                            .categoryList.length,
                                padding: EdgeInsets.only(
                                    left: Dimensions.PADDING_SIZE_SMALL),
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 1),
                                    child: InkWell(
                                      onTap: () => Get.toNamed(
                                          RouteHelper.getCategoryProductRoute(
                                        categoryController
                                            .categoryList[index].id,
                                        categoryController
                                            .categoryList[index].name,
                                      )),
                                      child: SizedBox(
                                        width: 60,
                                        child: Column(children: [
                                          Container(
                                            height: 50,
                                            width: 50,
                                            margin: EdgeInsets.only(
                                              left: index == 0
                                                  ? 0
                                                  : Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL,
                                              right: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL,
                                            ),
                                            child: Wrap(
                                              direction: Axis.horizontal,
                                              alignment: WrapAlignment.start,
                                              children: List.generate(
                                                categoryController
                                                    .categoryList.length,
                                                (index) => GestureDetector(
                                                  onTap: () {
                                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => WishListScreen()));
                                                  },
                                                  child: SizedBox(
                                                    width: (width / 4),
                                                    height: 80,
                                                    child: Column(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(6),
                                                          decoration:
                                                              boxDecorationWithRoundedCorners(
                                                            boxShape:
                                                                BoxShape.circle,
                                                            backgroundColor: appStore
                                                                    .isDarkModeOn
                                                                ? cardDarkColor
                                                                : gray
                                                                    .withOpacity(
                                                                        0.2),
                                                          ),
                                                          child: Image.network(
                                         '${Get.find<SplashController>().configModel.baseUrls.categoryImageUrl}/${categoryController.categoryList[index].image}',

                                                            fit: BoxFit.cover,
                                                            width: 30,
                                                            height: 30,
                                                            color: appStore
                                                                    .isDarkModeOn
                                                                ? white
                                                                : black,
                                                          ),
                                                        ),
                                                        SizedBox(height: 2),
                                                        Text(
                                                            categoryController
                                                  .categoryList[index].name,
                                                            style:
                                                                primaryTextStyle()),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: index == 0
                                                    ? Dimensions
                                                        .PADDING_SIZE_EXTRA_SMALL
                                                    : 0),
                                            child: Text(
                                              categoryController
                                                  .categoryList[index].name,
                                              style: robotoMedium.copyWith(
                                                  fontSize: 11),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : CategoryShimmer(
                                categoryController: categoryController),
                      ),
                    ),
                    ResponsiveHelper.isMobile(context)
                        ? SizedBox()
                        : categoryController.categoryList != null
                            ? Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (con) => Dialog(
                                              child: Container(
                                                  height: 550,
                                                  width: 600,
                                                  child: CategoryPopUp(
                                                    categoryController:
                                                        categoryController,
                                                  ))));
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: Dimensions.PADDING_SIZE_SMALL),
                                      child: CircleAvatar(
                                        radius: 35,
                                        backgroundColor:
                                            Theme.of(context).primaryColor,
                                        child: Text('view_all'.tr,
                                            style: TextStyle(
                                                fontSize: Dimensions
                                                    .PADDING_SIZE_DEFAULT,
                                                color: Theme.of(context)
                                                    .cardColor)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  )
                                ],
                              )
                            : CategoryAllShimmer(
                                categoryController: categoryController)
                  ],
                ),
              ],
            );
    });
  }
}

class CategoryShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: categoryController.categoryList == null,
              child: Column(children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300],
                    borderRadius:
                        BorderRadius.circular(Dimensions.RADIUS_SMALL),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    height: 10,
                    width: 50,
                    color: Colors.grey[
                        Get.find<ThemeController>().darkTheme ? 700 : 300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  final CategoryController categoryController;
  CategoryAllShimmer({@required this.categoryController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: categoryController.categoryList == null,
          child: Column(children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}
