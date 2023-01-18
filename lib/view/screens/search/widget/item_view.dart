import 'package:sandav/controller/search_controller.dart';
import 'package:sandav/util/dimensions.dart';
import 'package:sandav/view/base/product_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemView extends StatelessWidget {
  final bool isRestaurant;
  ItemView({@required this.isRestaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SearchController>(builder: (searchController) {
        return SingleChildScrollView(
          child: Center(
              child: SizedBox(
                  width: Dimensions.WEB_MAX_WIDTH,
                  child: ProductView(
                    isRestaurant: isRestaurant,
                    products: searchController.searchProductList,
                    restaurants: searchController.searchRestList,
                  ))),
        );
      }),
    );
  }
}
