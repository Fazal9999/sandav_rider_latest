import 'dart:io';
import 'dart:math';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:ui' as ui;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:delivery_man/controller/auth_controller.dart';
import 'package:delivery_man/controller/order_controller.dart';
import 'package:delivery_man/data/model/body/delivery_man_body.dart';
import 'package:delivery_man/view/screens/auth/widget/code_picker_widget.dart';
import '../../../common/colors.dart';
import '../../../controller/splash_controller.dart';
import '../../../main.dart';
import '../../../store/AppStore.dart';

import '../../../store/profile_ob.dart';
import '../../../store/user_signup.dart';
import '../../../util/app_constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../../util/widget.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_number/phone_number.dart';


class RegistrationScreen extends StatefulWidget {
  RegistrationScreen();

  @override
  _RegistrationScreenState createState() =>
      _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {
  int vehicleTypeSelected = 0;
  double base_price = 0.0;
  double additional_distance_price = 0.0;
  List selectedVehicle;
  bool selected = false;

  final TextEditingController _identityNumberController =
  TextEditingController();


  var image;


  //final _form_state_key = GlobalKey<FormState>();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _confirmPasswordController =
  TextEditingController();
  String _countryDialCode;
  ProfileOb pr_ob = ProfileOb();
  PageController pageController = PageController(initialPage: 0);
  int pageNumber = 0;
  String _fileName;
  String _bankingName;
  String _platformVersion = 'Unknown';


  AnimationController loadingController;
  String _path = '-';
  String _path_bank = '-';
  bool _pickFileInProgress = false;
  bool _pickBankFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  bool isIconCheck1 = false;
  bool isIconCheck2 = false;
  final _utiController = TextEditingController(
    text: 'com.sandav.customer',
  );
  int vehicle_id=-1;

  final _extensionController = TextEditingController(
    text: 'pdf,doc,png',
  );

  final _mimeTypeController = TextEditingController(
    text: 'application/pdf image/png',
  );


  String _saveAsFileName;

  //List<PlatformFile> _paths;
  String _directoryPath;
  String _extension = "jpg, pdf, doc";
  bool _isImgLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  String vehicle = "";
  List vehicletItems = [];
  List<dynamic> ve=[];

  List vehiclestItems = [];
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
  // static const kSubtitleStyle = TextStyle(
  //   fontSize: 18.0,
  //   height: 1.2,
  // );
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
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  List buildDotIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= 6; i++) {
      list.add(i == pageNumber
          ? indicator(isActive: true)
          : indicator(isActive: false));
    }

    return list;
  }
  List buildDotIndicator2() {
    List<Widget> list = [];
    for (int i = 0; i <= 5; i++) {
      list.add(i == pageNumber
          ? indicator(isActive: true)
          : indicator(isActive: false));
    }

    return list;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _path = null;
    _path = '-';
    _path_bank = null;
    _path_bank = '-';
    Get
        .find<AuthController>()
        .pickedFrontIdentities
        .clear();

    Get
        .find<AuthController>()
        .pickedLicenseIdentities
        .clear();

    Get
        .find<AuthController>()
        .pickedVhicleIdentities
        .clear();
    Get
        .find<AuthController>()
        .pickedIdentities
        .clear();
  }

  // void _clearCachedFiles() async {
  //   _resetState("");
  //   try {
  //     bool result = await FilePicker.platform.clearTemporaryFiles();
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: result ? Colors.green : Colors.red,
  //         content: Text((result
  //             ? 'Temporary files removed with success.'
  //             : 'Failed to clean temporary files')),
  //       ),
  //     );
  //   } on PlatformException catch (e) {
  //     _logException('Unsupported operation' + e.toString());
  //   } catch (e) {
  //     _logException(e.toString());
  //   } finally {
  //     //setState(() => Get.find<AuthController>().isLoading = false);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    initPlatformState();

    loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )
      ..addListener(() {
        setState(() {});
      });

    _countryDialCode = CountryCode
        .fromCountryCode(
        Get
            .find<SplashController>()
            .configModel
            .country)
        .dialCode;
    Get.find<AuthController>().pickDmImage(false, true);
    Get.find<AuthController>().setIdentityTypeIndex(
        Get
            .find<AuthController>()
            .identityTypeList[0], false);
    Get.find<AuthController>()
        .setDMTypeIndex(Get
        .find<AuthController>()
        .dmTypeList[0], false);
    Get.find<AuthController>().getZoneList();
    get_vehicle();
  }
  initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // platformVersion = await SimplePermissions.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
    print(_platformVersion);
  }

  Future<void> get_vehicle() async {
    vehicletItems = (await Get.find<AuthController>().get_Vehicles());
    for (int index = 0; index < vehicletItems.length; index++) {
      ve.add([vehicletItems[index]['id'],
        vehicletItems[index]['value'] == 0 ? false : true,
        vehicletItems[index]['name']]) ;
    }
    print("FazalBhatti ${ve}");
  }


  // void _resetState(String s) {
  //   if (!this.mounted) {
  //     return;
  //   }
  //
  //   setState(() {
  //     _isImgLoading = true;
  //     _directoryPath = null;
  //     _fileName = null;
  //     _bankingName = null;
  //     if (s == 'banking') {
  //       // pickedBankingIdentities = null;
  //     } else {
  //       //pickedResidenceIdentities = null;
  //     }
  //
  //     _saveAsFileName = null;
  //     _userAborted = false;
  //   });
  // }

  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return SafeArea(
      child: Scaffold(
        body: GetBuilder<AuthController>(builder: (authController) {
          List<int> _zoneIndexList = [];
          if (authController.zoneList != null) {
            for (int index = 0;
            index < authController.zoneList.length;
            index++) {
              _zoneIndexList.add(index);
            }
          }

          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                margin: EdgeInsets.only(left: 0, right: 0, bottom: 7, top: 20),
                padding: EdgeInsets.only(left: 3, right: 3),
                height: double.infinity,
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) =>
                      setState(() {
                        pageNumber = index;
                      }),
                  controller: pageController,
                  children: [

                    Container(
                      padding: EdgeInsets.only(
                          left: 16, bottom: 70, right: 16, top: 5),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 60),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            applogo(),
                            10.height,
                            Text("Delivery Man sign up",
                                style: primaryTextStyle(
                                    size: 20, letterSpacing: 0.2)),
                            10.height,
                            Text("Lets get driving...",
                                style: primaryTextStyle(
                                  size: 18,
                                  letterSpacing: 0.2,

                                )),
                            13.height,
                            Text(
                                "Please ensure you have the following documents on hand:",
                                style: primaryTextStyle(
                                  size: 17,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.normal,
                                )),
                            16.height,
                            Text("1: ID book, ID card or passport",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            Text(
                                "2: Work permit or asylum document (non-SA citizens)",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            Text("3: Drivers license card",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            Text(
                                "4: Vehicle license disk (vehicle model should not be older than 12 years)",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            Text("5: Drivers license card",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            Text("6: Proof of address document",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            16.height,
                            Text(
                                "These documents will need to be photographed when completing the application,"
                                    "Please ensure that your Phone has access permissions to your camera and location."
                                    "For us to approve your application you need to answer the following questions and comply with the terms.",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, bottom: 70, right: 16, top: 5),
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
                                style: primaryTextStyle(
                                    size: 15, letterSpacing: 0.2)),
                            10.height,
                            Text("Select a Vehicle.",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            checkBoxVehicle(ve, vehicle, 1),
                            40.height,
                            Text(
                                "Do you agree that your information will be used for background checks \n "
                                    "for any criminal records.?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //two
                            checkBox(bgItems, bg, 2),
                            10.height,
                            Text(
                                "Do you agree that you will only receive 100% of the total amount charged "
                                    "to each customer as delivery fee? ?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //three
                            checkBox(percent_huItems, percent_hu, 3),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, bottom: 70, right: 19, top: 5),
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
                                style: primaryTextStyle(
                                    size: 15, letterSpacing: 0.2)),
                            10.height,
                            Text(
                                "Do you agree that by working as delivery man you will be paid every week and "
                                    " funds will reflect to your bank depending on which bank you are using?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //four
                            checkBox(paid_weekItems, paid_week, 4),

                            10.height,
                            Text(
                                "Do you agree that vehicle or scooter is at your full responsibility \n including maintenance and insurance and you will only be paid commission \n you earned?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //five
                            checkBox(responsibilityFull, responsibility, 5),
                            10.height,
                            Text(
                                "Do you agree that you will be paid R7 per kilometer and minimum delivery fee "
                                    " you going to earn per trip of each order will be R22 for a distance less then "
                                    " 3 KM. example if you accepted 3 orders sametime and they all at a perimeter "
                                    " which is less then 3KM you will be payed 22x3= R66?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //six
                            checkBox(paidR7Items, paidR7, 6),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, bottom: 100, right: 16, top: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            applogo(),
                            24.height,
                            Text("Section 3",
                                style: primaryTextStyle(
                                    size: 15, letterSpacing: 0.2)),
                            10.height,
                            Text(
                                "Do you agree that Maximum orders you are allowed to take per trip will be 3  Orders and you will be paid per order delivered ?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //seven
                            checkBox(max_orderItems, max_order, 7),
                            10.height,
                            Text(
                                "Do you agree that we will track all events when delivering orders?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //eight
                            checkBox(track_eventItems, track_event, 8),
                            10.height,
                            Text(
                                "Do you agree with our maximum waiting period which is 5 minutes at customer "
                                    " destination if the customer doesn't show up you allowed to leave with the order?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //nine
                            checkBox(waiting_periodItems, waiting_period, 9),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, bottom: 100, right: 16, top: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            applogo(),
                            24.height,
                            Text("Section 4",
                                style: primaryTextStyle(
                                    size: 15, letterSpacing: 0.2)),
                            10.height,
                            Text(
                                "Good luck at this point you answered most of the questions now we will like to know do you have adriod phone with version 7+?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //ten
                            checkBox(sevenplusItems, sevenplus, 10),
                            10.height,
                            Text("Do you agree to our terms and conditions?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //eleven
                            checkBox(termsItems, terms, 11),
                            10.height,
                            Text("Do you agree with our privacy policy?",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            //tweleve
                            checkBox(privacyItems, privacy, 12),
                            10.height,
                            Text("Upload Vehicle license img",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: authController
                                    .pickedLicenseIdentities.length +
                                    1,
                                itemBuilder: (context, index) {
                                  XFile _file = index ==
                                      authController
                                          .pickedLicenseIdentities.length
                                      ? null
                                      : authController
                                      .pickedLicenseIdentities[index];
                                  if (index ==
                                      authController
                                          .pickedLicenseIdentities.length) {
                                    return InkWell(
                                      onTap: () =>
                                          authController.pickRegImage(
                                              false, false, "license"),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              width: 2),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.camera_alt,
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    margin: EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
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
                                          onTap: () =>
                                              authController
                                                  .removeLicenseImage(index),
                                          child: const Padding(
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
                            10.height,
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 16, bottom: 100, right: 16, top: 5),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            applogo(),
                            24.height,
                            Text("Upload Proof Of Resident.",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            // 10.height,
                            // SizedBox(
                            //   height: 80,
                            //   child: ListView.builder(
                            //     scrollDirection: Axis.horizontal,
                            //     physics: BouncingScrollPhysics(),
                            //     itemCount: pickedResidenceIdentities != null
                            //         ? pickedResidenceIdentities.length + 1
                            //         : 1,
                            //     itemBuilder: (context, index) {
                            //       PlatformFile _file;
                            //       if(pickedResidenceIdentities!=null){
                            //         _file =
                            //         index == pickedResidenceIdentities.length
                            //             ? null
                            //             : pickedResidenceIdentities[index];
                            //       }
                            //
                            //       if (index ==
                            //           pickedResidenceIdentities.length) {
                            //         return InkWell(
                            //           onTap: () => pickFiles("residence"),
                            //           child: Container(
                            //             height: 120,
                            //             width: 150,
                            //             alignment: Alignment.center,
                            //             decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.circular(
                            //                   Dimensions.RADIUS_SMALL),
                            //               border: Border.all(
                            //                   color: Theme.of(context)
                            //                       .primaryColor,
                            //                   width: 2),
                            //             ),
                            //             child: Container(
                            //               padding: EdgeInsets.all(Dimensions
                            //                   .PADDING_SIZE_EXTRA_SMALL),
                            //               decoration: BoxDecoration(
                            //                 border: Border.all(
                            //                     width: 2,
                            //                     color: Theme.of(context)
                            //                         .primaryColor),
                            //                 shape: BoxShape.circle,
                            //               ),
                            //               child: _file != null
                            //                   ? Text(
                            //                       _file != null
                            //                           ? _file.name
                            //                           : "",
                            //                       style: Theme.of(context)
                            //                           .textTheme
                            //                           .subtitle1,
                            //                       textAlign: TextAlign.center,
                            //                       textScaleFactor:
                            //                           ScaleSize.textScaleFactor(
                            //                               context),
                            //                     )
                            //                   : Icon(Icons.file_copy, size: 18),
                            //             ),
                            //           ),
                            //         );
                            //       }
                            //       return Container(
                            //         margin: EdgeInsets.only(
                            //             right: Dimensions.PADDING_SIZE_SMALL),
                            //         decoration: BoxDecoration(
                            //           border: Border.all(
                            //               color: Theme.of(context).primaryColor,
                            //               width: 2),
                            //           borderRadius: BorderRadius.circular(
                            //               Dimensions.RADIUS_SMALL),
                            //         ),
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(
                            //               vertical: 2, horizontal: 5),
                            //           child: Stack(children: [
                            //             ClipRRect(
                            //                 borderRadius: BorderRadius.circular(
                            //                     Dimensions.RADIUS_SMALL),
                            //                 child: GetPlatform.isWeb
                            //                     ? Text(
                            //                         _file != null
                            //                             ? _file.name
                            //                             : "",
                            //                         style: Theme.of(context)
                            //                             .textTheme
                            //                             .subtitle1,
                            //                         textAlign: TextAlign.center,
                            //                         textScaleFactor: ScaleSize
                            //                             .textScaleFactor(
                            //                                 context),
                            //                       )
                            //                     : Text(
                            //                         _file != null
                            //                             ? _file.name
                            //                             : "",
                            //                         style: Theme.of(context)
                            //                             .textTheme
                            //                             .subtitle1,
                            //                         textAlign: TextAlign.center,
                            //                         textScaleFactor: ScaleSize
                            //                             .textScaleFactor(
                            //                                 context),
                            //                       )),
                            //             Positioned(
                            //               right: 0,
                            //               bottom: 0,
                            //               child: InkWell(
                            //                 onTap: () =>
                            //                     removeResidenceImage(index),
                            //                 child: const Padding(
                            //                   padding: EdgeInsets.all(Dimensions
                            //                       .PADDING_SIZE_SMALL),
                            //                   child: Icon(Icons.delete_forever,
                            //                       color: Colors.red),
                            //                 ),
                            //               ),
                            //             ),
                            //           ]),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: _pickFileInProgress ? null : _pickDocument,
                              child:
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20.0),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(10),
                                    dashPattern: [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: Colors.blue.shade400,
                                    child: Container(
                                      width: 150,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade50
                                              .withOpacity(.3),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Iconsax.folder_open,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'Select your file',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey.shade400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            _path != null
                                ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected File',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade200,
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 2,
                                              )
                                            ]),
                                        child: Row(
                                          children: [
                                            // ClipRRect(
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             8),
                                            //     child: Image.file(
                                            //       _file,
                                            //       width: 70,
                                            //     )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    _path == '-'
                                                        ? "No File Selected"
                                                        : _path,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                        Colors.black),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  // Text(
                                                  //   _path=='-' ? "No File Selected" : _path,
                                                  //   style: TextStyle(
                                                  //       fontSize: 13,
                                                  //       color: Colors
                                                  //           .grey.shade500),
                                                  // ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      height: 5,
                                                      clipBehavior:
                                                      Clip.hardEdge,
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            5),
                                                        color: Colors
                                                            .blue.shade50,
                                                      ),
                                                      child:
                                                      LinearProgressIndicator(
                                                        value:
                                                        loadingController
                                                            .value,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // MaterialButton(
                                    //   minWidth: double.infinity,
                                    //   height: 45,
                                    //   onPressed: () {},
                                    //   color: Colors.black,
                                    //   child: Text('Upload', style: TextStyle(color: Colors.white),),
                                    // )
                                  ],
                                ))
                                : Container(),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                                "Upload Banking details (bank confirmation letter or bank statement).",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            GestureDetector(
                              onTap: _pickBankFileInProgress
                                  ? null
                                  : _pickBankDocument,
                              child:
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20.0),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    radius: Radius.circular(10),
                                    dashPattern: [10, 4],
                                    strokeCap: StrokeCap.round,
                                    color: Colors.blue.shade400,
                                    child: Container(
                                      width: 150,
                                      height: 100,
                                      decoration: BoxDecoration(
                                          color: Colors.blue.shade50
                                              .withOpacity(.3),
                                          borderRadius:
                                          BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Iconsax.folder_open,
                                            color: Colors.blue,
                                            size: 40,
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            'Select your file',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.grey.shade400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                            _path_bank != null
                                ? Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 5),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Selected File',
                                      style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 15,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.shade200,
                                                offset: Offset(0, 1),
                                                blurRadius: 3,
                                                spreadRadius: 2,
                                              )
                                            ]),
                                        child: Row(
                                          children: [
                                            // ClipRRect(
                                            //     borderRadius:
                                            //         BorderRadius.circular(
                                            //             8),
                                            //     child: Image.file(
                                            //       _file,
                                            //       width: 70,
                                            //     )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                    _path_bank == '-'
                                                        ? "No File Selected"
                                                        : _path_bank,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color:
                                                        Colors.black),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  // Text(
                                                  //   '${(_path_bank.length / 1024).ceil()} KB',
                                                  //   style: TextStyle(
                                                  //       fontSize: 13,
                                                  //       color: Colors
                                                  //           .grey.shade500),
                                                  // ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                      height: 5,
                                                      clipBehavior:
                                                      Clip.hardEdge,
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            5),
                                                        color: Colors
                                                            .blue.shade50,
                                                      ),
                                                      child:
                                                      LinearProgressIndicator(
                                                        value:
                                                        loadingController
                                                            .value,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        )),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // MaterialButton(
                                    //   minWidth: double.infinity,
                                    //   height: 45,
                                    //   onPressed: () {},
                                    //   color: Colors.black,
                                    //   child: Text('Upload', style: TextStyle(color: Colors.white),),
                                    // )
                                  ],
                                ))
                                : Container(),
                            SizedBox(
                              height: 5,
                            ),
                            10.height,
                            Text(
                                "Upload Picture of your drivers license(front).",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: authController
                                    .pickedFrontIdentities.length +
                                    1,
                                itemBuilder: (context, index) {
                                  XFile _file = index ==
                                      authController
                                          .pickedFrontIdentities.length
                                      ? null
                                      : authController
                                      .pickedFrontIdentities[index];
                                  if (index ==
                                      authController
                                          .pickedFrontIdentities.length) {
                                    return InkWell(
                                      onTap: () =>
                                          authController.pickRegImage(
                                              false, false, "front"),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              width: 2),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.camera_alt,
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    margin: EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
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
                                          onTap: () =>
                                              authController
                                                  .removeFrontImage(index),
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
                            10.height,
                            Text(
                                "Upload picture of your vehicle or scooter, make sure your number plate is clearly visible.",
                                style: primaryTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,

                                )),
                            10.height,
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: authController
                                    .pickedVhicleIdentities.length +
                                    1,
                                itemBuilder: (context, index) {
                                  XFile _file = index ==
                                      authController
                                          .pickedVhicleIdentities.length
                                      ? null
                                      : authController
                                      .pickedVhicleIdentities[index];
                                  if (index ==
                                      authController
                                          .pickedVhicleIdentities.length) {
                                    return InkWell(
                                      onTap: () =>
                                          authController.pickRegImage(
                                              false, false, "vehicle"),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor,
                                              width: 2),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              Dimensions.PADDING_SIZE_DEFAULT),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: Theme
                                                    .of(context)
                                                    .primaryColor),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(Icons.camera_alt,
                                              color: Theme
                                                  .of(context)
                                                  .primaryColor),
                                        ),
                                      ),
                                    );
                                  }
                                  return Container(
                                    margin: EdgeInsets.only(
                                        right: Dimensions.PADDING_SIZE_SMALL),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Theme
                                              .of(context)
                                              .primaryColor,
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
                                          onTap: () =>
                                              authController
                                                  .removeVehicleImage(index),
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
                            10.height,
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
                      children: buildDotIndicator2(),
                    ),
                    pageNumber != 5
                        ? TextButton(
                      onPressed: () async {
                        print("pageNumber ${pageNumber} -- ${vehicle}");
                        bool _isValid = GetPlatform.isWeb ? true : false;


                        if (pageNumber == 1) {
                          if (
                          vehicle_id == -1 ||
                              bg == "" ||
                              percent_hu == "") {
                            showCustomSnackBar(
                                "One or more selections are missings",
                                isError: true);
                            return;
                          }
                        }
                        if (pageNumber == 2) {
                          if (paid_week == "" ||
                              responsibility == "" ||
                              paidR7 == "") {
                            showCustomSnackBar(
                                "One or more selections are missings",
                                isError: true);
                            return;
                          }
                        }
                        if (pageNumber == 3) {
                          if (max_order == "" ||
                              track_event == "" ||
                              waiting_period == "") {
                            showCustomSnackBar(
                                "One or more selections are missings",
                                isError: true);
                            return;
                          }
                        }
                        if (pageNumber == 4) {
                          if (sevenplus == "" ||
                              terms == "" ||
                              privacy == "" ||

                              authController
                                  .pickedLicenseIdentities.isEmpty) {
                            showCustomSnackBar(
                                "One or more selections are missings",
                                isError: true);
                            return;
                          }
                        }
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
                        if (pageNumber == 5) {
                          if (_path == '-' ||
                              _path_bank == '-' ||
                              authController.pickedFrontIdentities.length ==
                                  0 ||

                              authController.pickedFrontIdentities.isEmpty ||

                              authController.pickedVhicleIdentities.length ==
                                  0 ||

                              authController.pickedVhicleIdentities.isEmpty

                          ) {
                            showCustomSnackBar(
                                "One or more selections are missings",
                                isError: true);
                            return;
                          }
                        }
                        authController.UpdateDeliveryMan(
                            DeliveryManBody(
                              fName: Get.find<AuthController>().profileModel.fName,
                              lName: Get.find<AuthController>().profileModel.lName,
                              password: "",
                              phone: Get.find<AuthController>().profileModel.phone,
                              email: Get.find<AuthController>().profileModel.email,
                              identityNumber: Get.find<AuthController>().profileModel.identityNumber,
                              identityType: authController.identityTypeList[authController.identityTypeIndex],
                              earning: authController.dmTypeIndex == 0 ? '1' : '0',
                              zoneId: authController.zoneList[authController.selectedZoneIndex].id.toString(),
                              vehicle_id: vehicle_id,
                              is_criminal_bg_check: bg,
                              is_total_amount: percent_hu,
                              is_paid_every_week: paid_week,
                              is_vehicle_responsibility: responsibility,
                              is_paid_per_km: paidR7,
                              is_max_order: max_order,
                              is_track_event: track_event,
                              is_max_waiting_period: waiting_period,
                              is_version_seven_plus: sevenplus,
                              is_agree_terms: terms,
                              is_agree_privacy: privacy,
                            ),
                            _path,
                            _path_bank
                        );
                        finish(context);
                      },
                      child: !authController.isLoading
                          ? Text('Finish',
                          style: primaryTextStyle(
                              size: 16, color: opBackgroundColor))
                          : SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator()),
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


  Widget checkBox(List Items, String item, int number) {
    return Column(
      children: List.generate(
        Items.length,
            (index) =>
            CheckboxListTile(
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
              value: Items[index]['value'] ,
              onChanged: (value) {
                setState(() {
                  for (var element in Items) {
                    element["value"] = false;
                  }
                  if(value){
                    item = "${Items[index]["title"]}";
                    Items[index]["value"] = value;
                  }
                  else{
                    item = "";
                  }
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
  Widget checkBoxVehicle(List Items, String item, int number) {
    return Column(
      children: List.generate(
        Items.length,
            (index) =>
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text(
                Items[index][2]
                ,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              value: Items[index][1],
              onChanged: (value) {
                setState(() {
                  for (var element in Items) {
                    element[1]=false;
                  }
                  item = "${Items[index][2]}";
                  Items[index][1] = value;
                  int vehId=Items[index][0];
                  vehicle_id=vehId;
                  print("Faziy ${vehicle_id}");
                  vehicle=item;

                });
              },
            ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {

    // set up the button
    Widget okButton = TextButton(
      child: Text("OK"),
      onPressed: () { },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  _pickDocument() async {
    String result;
    try {
      setState(() {
        _path = '-';
        _pickFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList(),
        allowedMimeTypes: _checkByMimeType
            ? _mimeTypeController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList()
            : null,
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickFileInProgress = false;
      });
    }

    setState(() {
      _path = result;
    });
  }
  _pickBankDocument() async {
    String result;
    try {
      setState(() {
        _path_bank = '-';
        _pickBankFileInProgress = true;
      });

      FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
        allowedFileExtensions: _checkByCustomExtension
            ? _extensionController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList()
            : null,
        allowedUtiTypes: _iosPublicDataUTI
            ? null
            : _utiController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList(),
        allowedMimeTypes: _checkByMimeType
            ? _mimeTypeController.text
            .split(' ')
            .where((x) => x.isNotEmpty)
            .toList()
            : null,
      );

      result = await FlutterDocumentPicker.openDocument(params: params);
    } catch (e) {
      print(e);
      result = 'Error: $e';
    } finally {
      setState(() {
        _pickBankFileInProgress = false;
      });
    }

    setState(() {
      _path_bank = result;
    });
  }

// _buildIOSParams() {
//   return ParamsCard(
//     title: 'iOS Params',
//     children: <Widget>[
//       Text(
//         'Example app is configured to pick custom document type with extension ".mwfbak"',
//         style: Theme.of(context).textTheme.bodyText2,
//       ),
//       Param(
//         isEnabled: !_iosPublicDataUTI,
//         description:
//         'Allow pick all documents("public.data" UTI will be used).',
//         controller: _utiController,
//         onEnabledChanged: (value) {
//           if (value != null) {
//             setState(() {
//               _iosPublicDataUTI = value;
//             });
//           }
//         },
//         textLabel: 'Uniform Type Identifier to pick:',
//       ),
//     ],
//   );
// }
//
// _buildAndroidParams() {
//   return ParamsCard(
//     title: 'Android Params',
//     children: <Widget>[
//       Param(
//         isEnabled: _checkByMimeType,
//         description: 'Filter files by MIME type',
//         controller: _mimeTypeController,
//         onEnabledChanged: (value) {
//           if (value != null) {
//             setState(() {
//               _checkByMimeType = value;
//             });
//           }
//         },
//         textLabel: 'Allowed MIME types (separated by space):',
//       ),
//     ],
//   );
// }
//
// _buildCommonParams() {
//   return ParamsCard(
//     title: 'Common Params',
//     children: <Widget>[
//       Param(
//         isEnabled: _checkByCustomExtension,
//         description:
//         'Check file by extension - if picked file does not have wantent extension - return "extension_mismatch" error',
//         controller: _extensionController,
//         onEnabledChanged: (value) {
//           if (value != null) {
//             setState(() {
//               _checkByCustomExtension = value;
//             });
//           }
//         },
//         textLabel: 'File extensions (separated by space):',
//       ),
//     ],
//   );
// }
//


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
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}

class Veh {
  final int id;
  bool value;
  final String title;

  Veh(this.id, this.value, this.title);
}
// - Subscription transaction and other related issues solved.
// - Order edit issue solved.
// - Order Refund Improved.
// - Some notification issues fixed.
// - Social Login issue solved.
// - Fixed some page export issues.
// - Best reviewed food price-related issue fixed in user app.
// - Some order request-related issues solved.
// - Fixed some other small issues
// - Make compatible for react web version

class Param extends StatelessWidget {
  final bool isEnabled;
  final ValueChanged<bool> onEnabledChanged;
  final TextEditingController controller;
  final String description;
  final String textLabel;

  Param({
    @required this.isEnabled,
    @required this.onEnabledChanged,
    @required this.controller,
    @required this.description,
    @required this.textLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  description,
                  softWrap: true,
                ),
              ),
            ),
            Checkbox(
              value: isEnabled,
              onChanged: onEnabledChanged,
            ),
          ],
        ),
        TextField(
          controller: controller,
          enabled: isEnabled,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: textLabel,
          ),
        ),
      ],
    );
  }
}

class ParamsCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  ParamsCard({
    @required this.title,
    @required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .headline5,
                ),
              ),
            ]
              ..addAll(children),
          ),
        ),
      ),
    );
  }
}



