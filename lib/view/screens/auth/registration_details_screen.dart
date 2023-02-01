import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/controller/auth_controller.dart';
import 'package:sandav/data/model/body/delivery_man_body.dart';

import '../../../commons/images.dart';
import '../../../util/dimensions.dart';
import '../../base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_number/phone_number.dart';

import '../../../commons/images.dart';
class RegistrationDetailsScreen extends StatefulWidget {
  DeliveryManBody deliveryManBody;

  RegistrationDetailsScreen(this.deliveryManBody);

  @override
  _RegistrationDetailsScreenState createState() =>
      _RegistrationDetailsScreenState();
}

class _RegistrationDetailsScreenState extends State<RegistrationDetailsScreen> {
  PageController pageController = PageController(initialPage: 0);
  int pageNumber = 0;

  String vehicle = "";
  List vehicletItems = [
    {
      "id": 1,
      "value": false,
      "title": "Vehicle",
    },
    {
      "id": 2,
      "value": false,
      "title": "Scooter",
    },
  ];
  String bg = "";
  List bgItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String percent_hu = "";
  List percent_huItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String paid_week = "";
  List paid_weekItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String responsibility = "";
  List responsibilityFull = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String paidR7 = "";
  List paidR7Items = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String max_order = "";
  List max_orderItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String track_event = "";
  List track_eventItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String waiting_period = "";
  List waiting_periodItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String sevenplus = "";
  List sevenplusItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String terms = "";
  List termsItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  String privacy = "";
  List privacyItems = [
    {
      "id": 1,
      "value": false,
      "title": "Yes",
    },
    {
      "id": 2,
      "value": false,
      "title": "No",
    },
  ];

  List buildDotIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= 5; i++) {
      list.add(i == pageNumber
          ? indicator(isActive: true)
          : indicator(isActive: false));
    }

    return list;
  }

  @override
  void initState() {
    super.initState();
    Get.find<AuthController>().pickDmImage(false, true);
    Get.find<AuthController>().setIdentityTypeIndex(
        Get.find<AuthController>().identityTypeList[0], false);
    Get.find<AuthController>()
        .setDMTypeIndex(Get.find<AuthController>().dmTypeList[0], false);
    Get.find<AuthController>().getZoneList();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body:
        GetBuilder<AuthController>(builder: (authController) {
          List<int> _zoneIndexList = [];
          if (authController.zoneList != null) {
            for (int index = 0; index < authController.zoneList.length; index++) {
              _zoneIndexList.add(index);
            }
          }

          return  Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: double.infinity,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() {
                  pageNumber = index;
                }),
                controller: pageController,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 70,
                        right: 16,
                        top: size.height * 0.1),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          applogo(),
                          15.height,
                          Text("Delivery Man sign up",
                              style:
                                  boldTextStyle(size: 20, letterSpacing: 0.2)),
                          15.height,
                          Text("Lets get driving...",
                              style: boldTextStyle(
                                size: 18,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          13.height,
                          Text(
                              "Please ensure you have the following documents on hand:",
                              style: boldTextStyle(
                                size: 17,
                                letterSpacing: 0.2,
                                weight: FontWeight.normal,
                              )),
                          16.height,
                          Text("1: ID book, ID card or passport",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          10.height,
                          Text(
                              "2: Work permit or asylum document (non-SA citizens)",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          10.height,
                          Text("3: Drivers license card",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          10.height,
                          Text(
                              "4: Vehicle license disk (vehicle model should not be older than 12 years)",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          10.height,
                          Text("5: Drivers license card",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          10.height,
                          Text("6: Proof of address document",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          16.height,
                          Text(
                              "These documents will need to be photographed when completing the application, \n"
                              "Please ensure that your Phone has access permissions to your camera and location. \n"
                              "For us to approve your application you need to answer the following questions and \n"
                              " comply with the terms.",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 70,
                        right: 16,
                        top: size.height * 0.1),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          applogo(),
                          24.height,
                          Text("Section 1",
                              style:
                                  boldTextStyle(size: 15, letterSpacing: 0.2)),
                          5.height,
                          Text("Do you have a vehicle or scooter?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          // One
                          checkBox(vehicletItems, vehicle, 1),
                          5.height,
                          Text(
                              "Do you agree that your information will be used for background checks \n "
                              "for any criminal records.?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //two
                          checkBox(bgItems, bg, 2),
                          5.height,
                          Text(
                              "Do you agree that you will only receive 100% of the total amount charged \nto each customer as delivery fee? ?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //three
                          checkBox(percent_huItems, percent_hu, 3),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 70,
                        right: 16,
                        top: size.height * 0.1),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          applogo(),
                          24.height,
                          Text("Section 2",
                              style:
                                  boldTextStyle(size: 15, letterSpacing: 0.2)),
                          5.height,
                          Text(
                              "Do you agree that by working as delivery man you will be paid every week and \n funds will reflect to your bank depending on which bank \nyou are using?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //four
                          checkBox(paid_weekItems, paid_week, 4),

                          5.height,
                          Text(
                              "Do you agree that vehicle or scooter is at your full responsibility \n including maintenance and insurance and you will only be paid commission \n you earned?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //five
                          checkBox(responsibilityFull, responsibility, 5),
                          5.height,
                          Text(
                              "Do you agree that you will be paid R7 per kilometer and minimum delivery fee \n"
                              " you going to earn per trip of each order will be R22 for a distance less then \n"
                              " 3 KM. example if you accepted 3 orders sametime and they all at a perimeter \n"
                              " which is less then 3KM you will be payed 22x3= R66?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //six
                          checkBox(paidR7Items, paidR7, 6),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 100,
                        right: 16,
                        top: size.height * 0.05),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          applogo(),
                          24.height,
                          Text("Section 3",
                              style:
                                  boldTextStyle(size: 15, letterSpacing: 0.2)),
                          5.height,
                          Text(
                              "Do you agree that Maximum orders you are allowed to take per trip will be 3 \n Orders and you will be paid per order delivered ?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //seven
                          checkBox(max_orderItems, max_order, 7),
                          5.height,
                          Text(
                              "Do you agree that we will track all events when delivering orders?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //eight
                          checkBox(track_eventItems, track_event, 8),
                          5.height,
                          Text(
                              "Do you agree with our maximum waiting period which is 5 minutes at customer \n destination if the customer doesn't show up you allowed \n to leave with the order?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //nine
                          checkBox(waiting_periodItems, waiting_period, 9),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 100,
                        right: 16,
                        top: size.height * 0.05),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          applogo(),
                          24.height,
                          Text("Section 4",
                              style:
                                  boldTextStyle(size: 15, letterSpacing: 0.2)),
                          5.height,
                          Text(
                              "Good luck at this point you answered most of the questions now we will like to \n know do you have adriod phone with version 7+?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //ten
                          checkBox(sevenplusItems, sevenplus, 10),
                          5.height,
                          Text("Do you agree to our terms and conditions?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //eleven
                          checkBox(termsItems, terms, 11),
                          5.height,
                          Text("Do you agree with our privacy policy?",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          //tweleve
                          checkBox(privacyItems, privacy, 12),
                          5.height,
                          Text("Upload Vehicle license disc",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                             authController.pickedLicenseIdentities.length + 1,
                              itemBuilder: (context, index) {
                                XFile _file = index ==
                                   authController.pickedLicenseIdentities.length
                                    ? null
                                    : authController.pickedLicenseIdentities[index];
                                if (index ==
                                   authController.pickedLicenseIdentities.length) {
                                  return InkWell(
                                    onTap: () => authController.pickRegImage(
                                        false, false,"license"),
                                    child: Container(
                                      height: 120,
                                      width: 150,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        border: Border.all(
                                            color:
                                            Theme.of(context).primaryColor,
                                            width: 2),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_DEFAULT),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.camera_alt,
                                            color:
                                            Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Stack(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      child: GetPlatform.isWeb
                                          ? Image.network(
                                        _file.path,
                                        width: 150,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.file(
                                        File(_file.path),
                                        width: 150,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () => authController.
                                        removeLicenseImage(index),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL),
                                          child: Icon(Icons.delete_forever,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
                          ),
                          5.height,
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16,
                        bottom: 100,
                        right: 16,
                        top: size.height * 0.05),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          applogo(),
                          24.height,
                          Text("Upload Proof Of Resident",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                              authController.pickedResidenceIdentities.length + 1,
                              itemBuilder: (context, index) {
                                PlatformFile _file = index ==
                                    authController.pickedResidenceIdentities.length
                                    ? null
                                    : authController.pickedResidenceIdentities[index];
                                if (index ==
                                    authController.pickedResidenceIdentities.length)
                                {
                                  return InkWell(
                                    onTap: () =>
                                        authController.pickFiles("residence"),
                                    child: Container(
                                      height: 120,
                                      width: 150,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        border: Border.all(
                                            color:
                                            Theme.of(context).primaryColor,
                                            width: 2),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          shape: BoxShape.circle,
                                        ),
                                        child: _file !=null ? Text(_file !=null ? _file.name : "" ,
                                          style: Theme.of(context).textTheme.subtitle1,
                                          textAlign: TextAlign.center,
                                          textScaleFactor: ScaleSize.textScaleFactor(context),

                                        )
                                        :   Icon(
                                            Icons.file_copy,

                                      size: 18
                                    ),

                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                                    child: Stack(children: [

                                      ClipRRect(

                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        child: GetPlatform.isWeb
                                            ?
                                         Text(_file !=null ? _file.name : "",
                                           style: Theme.of(context).textTheme.subtitle1,
                                           textAlign: TextAlign.center,
                                           textScaleFactor: ScaleSize.textScaleFactor(context),

                                         )
                                            :
                                        Text(_file !=null ? _file.name : "",
                                          style: Theme.of(context).textTheme.subtitle1,
                                          textAlign: TextAlign.center,
                                          textScaleFactor: ScaleSize.textScaleFactor(context),

                                        )
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: InkWell(
                                          onTap: () => authController.
                                          removeResidenceImage(index),
                                          child: const Padding(
                                            padding: EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            child: Icon(Icons.delete_forever,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                          5.height,
                          Text(
                              "Upload Banking details (bank confirmation letter or bank statement )",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                              authController.pickedBankingIdentities.length + 1,
                              itemBuilder: (context, index) {
                                PlatformFile _file = index ==
                                    authController.pickedBankingIdentities.length
                                    ? null
                                    : authController.pickedBankingIdentities[index];
                                if (index ==
                                    authController.pickedBankingIdentities.length)
                                {
                                  return InkWell(
                                    onTap: () =>
                                        authController.pickFiles("banking"),
                                    child: Container(
                                      height: 120,
                                      width: 150,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        border: Border.all(
                                            color:
                                            Theme.of(context).primaryColor,
                                            width: 2),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          shape: BoxShape.circle,
                                        ),
                                        child: _file !=null ? Text(_file !=null ? _file.name : "" ,
                                          style: Theme.of(context).textTheme.subtitle1,
                                          textAlign: TextAlign.center,
                                          textScaleFactor: ScaleSize.textScaleFactor(context),

                                        )
                                            :   Icon(
                                            Icons.file_copy,

                                            size: 18
                                        ),

                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2,horizontal: 5),
                                    child: Stack(children: [

                                      ClipRRect(

                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          child: GetPlatform.isWeb
                                              ?
                                          Text(_file !=null ? _file.name : "",
                                            style: Theme.of(context).textTheme.subtitle1,
                                            textAlign: TextAlign.center,
                                            textScaleFactor: ScaleSize.textScaleFactor(context),

                                          )
                                              :
                                          Text(_file !=null ? _file.name : "",
                                            style: Theme.of(context).textTheme.subtitle1,
                                            textAlign: TextAlign.center,
                                            textScaleFactor: ScaleSize.textScaleFactor(context),

                                          )
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: InkWell(
                                          onTap: () => authController.
                                          removeResidenceImage(index),
                                          child: const Padding(
                                            padding: EdgeInsets.all(
                                                Dimensions.PADDING_SIZE_SMALL),
                                            child: Icon(Icons.delete_forever,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ),
                                    ]),
                                  ),
                                );
                              },
                            ),
                          ),
                          5.height,
                          Text("Upload Picture of your drivers license( front)",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                              authController.pickedFrontIdentities.length + 1,
                              itemBuilder: (context, index) {
                                XFile _file = index ==
                                    authController.pickedFrontIdentities.length
                                    ? null
                                    : authController.pickedFrontIdentities[index];
                                if (index ==
                                    authController.pickedFrontIdentities.length) {
                                  return InkWell(
                                    onTap: () => authController.pickRegImage(
                                        false, false,"front"),
                                    child: Container(
                                      height: 120,
                                      width: 150,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        border: Border.all(
                                            color:
                                            Theme.of(context).primaryColor,
                                            width: 2),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_DEFAULT),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.camera_alt,
                                            color:
                                            Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Stack(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      child: GetPlatform.isWeb
                                          ? Image.network(
                                        _file.path,
                                        width: 150,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.file(
                                        File(_file.path),
                                        width: 150,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () => authController.
                                        removeFrontImage(index),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL),
                                          child: Icon(Icons.delete_forever,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
                          ),
                          5.height,
                          Text(
                              "Upload picture of your vehicle or scooter, make sure your number plate is clearly visible.",
                              style: boldTextStyle(
                                size: 15,
                                letterSpacing: 0.2,
                                weight: FontWeight.bold,
                              )),
                          5.height,
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount:
                              authController.pickedVhicleIdentities.length + 1,
                              itemBuilder: (context, index) {
                                XFile _file = index ==
                                    authController.pickedVhicleIdentities.length
                                    ? null
                                    : authController.pickedVhicleIdentities[index];
                                if (index ==
                                    authController.pickedVhicleIdentities.length) {
                                  return InkWell(
                                    onTap: () => authController.pickRegImage(
                                        false, false,"vehicle"),
                                    child: Container(
                                      height: 120,
                                      width: 150,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Dimensions.RADIUS_SMALL),
                                        border: Border.all(
                                            color:
                                            Theme.of(context).primaryColor,
                                            width: 2),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.all(
                                            Dimensions.PADDING_SIZE_DEFAULT),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 2,
                                              color: Theme.of(context)
                                                  .primaryColor),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(Icons.camera_alt,
                                            color:
                                            Theme.of(context).primaryColor),
                                      ),
                                    ),
                                  );
                                }
                                return Container(
                                  margin: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_SMALL),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                        width: 2),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                  ),
                                  child: Stack(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimensions.RADIUS_SMALL),
                                      child: GetPlatform.isWeb
                                          ? Image.network(
                                        _file.path,
                                        width: 150,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                          : Image.file(
                                        File(_file.path),
                                        width: 150,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () => authController.
                                        removeVehicleImage(index),
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_SMALL),
                                          child: Icon(Icons.delete_forever,
                                              color: Colors.red),
                                        ),
                                      ),
                                    ),
                                  ]),
                                );
                              },
                            ),
                          ),
                          5.height,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, right: 16, bottom: 20),
              padding: EdgeInsets.only(left: 20, right: 8),
              width: size.width,
              height: 50,
              decoration: BoxDecoration(
                  color: textPrimaryColor,
                  borderRadius: BorderRadius.circular(15.0)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Text('${pageNumber + 1}',
                        style: primaryTextStyle(
                            size: 16, color: textPrimaryColor)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: buildDotIndicator(),
                  ),
                  pageNumber != 5
                      ? TextButton(
                          onPressed: () {
                       // if(pageNumber==1){
                       //    if(vehicle=="" || bg=="" || percent_hu==""){
                       //      showCustomSnackBar("One or more selections are missings", isError: true);
                       //      return;
                       //    }
                       // }
                       // if(pageNumber==2){
                       //   if(paid_week=="" || responsibility=="" || paidR7==""){
                       //     showCustomSnackBar("One or more selections are missings", isError: true);
                       //     return;
                       //   }
                       // }
                       // if(pageNumber==3){
                       //   if(max_order=="" || track_event=="" || waiting_period==""){
                       //     showCustomSnackBar("One or more selections are missings", isError: true);
                       //     return;
                       //   }
                       // }
                       // if(pageNumber==4){
                       //   if(sevenplus=="" || terms=="" || privacy=="" || authController.license==null
                       //   || authController.pickedLicenseIdentities.isEmpty
                       //   ){
                       //     showCustomSnackBar("One or more selections are missings", isError: true);
                       //     return;
                       //   }
                       // }
                            pageController.nextPage(
                                duration: const Duration(milliseconds: 250),
                                curve: Curves.fastOutSlowIn);
                          },
                          child: Text('Next',
                              style: primaryTextStyle(
                                  size: 16, color: opBackgroundColor)),
                        )
                      : TextButton(
                          onPressed: () {
                            finish(context);
                           authController
                                .registerDeliveryMan(widget.deliveryManBody);
                          },
                          child: Text('Finish',
                              style: primaryTextStyle(
                                  size: 16, color: opBackgroundColor)),
                        )
                ],
              ),
            ),
          ],
        );
        }),
      ),
    );
  }

  _upload(String s) {}

  Widget checkBox(List Items, String item, int number) {
    return Column(
      children: List.generate(
        Items.length,
        (index) => CheckboxListTile(
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          dense: true,
          title: Text(
            Items[index]["title"],
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          value: Items[index]["value"],
          onChanged: (value) {
            setState(() {
              for (var element in Items) {
                element["value"] = false;
              }
              Items[index]["value"] = value;
              item = "${Items[index]["title"]}";

              switch (number) {
                case 1:
                  vehicle = item;
                  break;
                case 2:
                  bg = item;
                  break;
                case 3:
                  percent_hu = item;
                  break;
                case 4:
                  paid_week = item;
                  break;
                case 5:
                  responsibility = item;
                  break;
                case 6:
                  paidR7 = item;
                  break;
                case 7:
                  max_order = item;
                  break;
                case 8:
                  track_event = item;
                  break;
                case 9:
                  waiting_period = item;
                  break;
                case 10:
                  sevenplus = item;
                  break;
                case 11:
                  terms = item;
                  break;
                case 12:
                  privacy = item;
                  break;
                default:
                  print('invalid entry');

              }
              print("Faizy ${item}");
            });
          },
        ),
      ),
    );
  }
}

// authController.registerDeliveryMan(
//     DeliveryManBody(
//   fName: _fName,
//   lName: _lName,
//   password: _password,
//   phone: _numberWithCountryCode,
//   email: _email,
//   identityNumber: _identityNumber,
//   identityType:
//       authController.identityTypeList[authController.identityTypeIndex],
//   earning: authController.dmTypeIndex == 0 ? '1' : '0',
//   zoneId: authController.zoneList[authController.selectedZoneIndex].id
//       .toString(),
// )
//
// );
class ScaleSize {
  static double textScaleFactor(BuildContext context, {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}