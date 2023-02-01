import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sandav/controller/auth_controller.dart';
import 'package:sandav/controller/order_controller.dart';
import 'package:sandav/data/model/body/delivery_man_body.dart';
import 'package:sandav/view/screens/auth/widget/code_picker_widget.dart';

import '../../../commons/colors.dart';
import '../../../commons/images.dart';
import '../../../commons/widgets.dart';
import '../../../controller/splash_controller.dart';
import '../../../main.dart';
import '../../../store/AppStore.dart';
import '../../../store/profile_ob.dart';
import '../../../store/user_signup.dart';
import '../../../util/app_constants.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_number/phone_number.dart';

import '../../../commons/images.dart';
import '../../base/custom_text_field.dart';

class RegistrationDetailsScreen extends StatefulWidget {
  RegistrationDetailsScreen();

  @override
  _RegistrationDetailsScreenState createState() =>
      _RegistrationDetailsScreenState();
}

class _RegistrationDetailsScreenState extends State<RegistrationDetailsScreen> {
  int vehicleTypeSelected = 0;
  double base_price = 0.0;
  double additional_distance_price = 0.0;
  List selectedVehicle;
  bool selected = false;
  final TextEditingController _fNameController = TextEditingController();
  final TextEditingController _lNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _identityNumberController =
      TextEditingController();
  final FocusNode _fNameNode = FocusNode();
  final FocusNode _lNameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _passwordNode = FocusNode();
  final FocusNode _identityNumberNode = FocusNode();
  String _countryDialCode;
  ProfileOb pr_ob = ProfileOb();
  PageController pageController = PageController(initialPage: 0);
  int pageNumber = 0;
  String _fileName;
  String _bankingName;
  List<PlatformFile> pickedResidenceIdentities = [];
  List<PlatformFile> pickedBankingIdentities = [];
  bool isIconCheck2 = false;
  String _saveAsFileName;

  //List<PlatformFile> _paths;
  String _directoryPath;
  String _extension = "jpg, pdf, doc";
  bool _isImgLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;
  String vehicle = "";
  List vehicletItems = [];
  List<Veh> ve;

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
  static const kSubtitleStyle = TextStyle(
    fontSize: 18.0,
    height: 1.2,
  );
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _clearCachedFiles() async {
    _resetState();
    try {
      bool result = await FilePicker.platform.clearTemporaryFiles();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: result ? Colors.green : Colors.red,
          content: Text((result
              ? 'Temporary files removed with success.'
              : 'Failed to clean temporary files')),
        ),
      );
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    } finally {
      //setState(() => Get.find<AuthController>().isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _countryDialCode = CountryCode.fromCountryCode(
            Get.find<SplashController>().configModel.country)
        .dialCode;
    Get.find<AuthController>().pickDmImage(false, true);
    Get.find<AuthController>().setIdentityTypeIndex(
        Get.find<AuthController>().identityTypeList[0], false);
    Get.find<AuthController>()
        .setDMTypeIndex(Get.find<AuthController>().dmTypeList[0], false);
    Get.find<AuthController>().getZoneList();
    get_vehicle();
  }

  Future<void> get_vehicle() async {
    vehicletItems = (await Get.find<OrderController>().get_Vehicles());

    for (int index = 0; index < vehicletItems.length; index++) {
      ve.add(Veh(
          vehicletItems[index]['id'],
          vehicletItems[index]['value'] == 0 ? false : true,
          vehicletItems[index]['name']));
    }
    ;
    print("patti ${ve}");
  }

  void pickFiles(String s) async {
    _resetState();

    try {
      _directoryPath = null;
      if (s == "residence") {
        pickedResidenceIdentities = (await FilePicker.platform.pickFiles(
          type: _pickingType,
          allowMultiple: _multiPick,
          onFileLoading: (FilePickerStatus status) => print(status),
        ))
            ?.files;
      }
      if (s == "banking") {
        pickedBankingIdentities = (await FilePicker.platform.pickFiles(
          type: _pickingType,
          allowMultiple: _multiPick,
          onFileLoading: (FilePickerStatus status) => print(status),
        ))
            ?.files;
      }
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
      print("Fazal ${e.toString()}");
    }
    if (!this.mounted) return;
    setState(() {
      if (s == "residence") {
        _isImgLoading = false;
        _fileName = pickedResidenceIdentities != null
            ? pickedResidenceIdentities.map((e) => e.name).toString()
            : '...';
        _userAborted = pickedResidenceIdentities == null;
      }
      if (s == "banking") {
        _isImgLoading = false;
        _bankingName = pickedBankingIdentities != null
            ? pickedBankingIdentities.map((e) => e.name).toString()
            : '...';
        _userAborted = pickedBankingIdentities == null;
        print("Faziy ${pickedBankingIdentities.toString()}");
      }
    });
  }

  void removeResidenceImage(int index) {
    pickedResidenceIdentities.removeAt(index);
    Get.find<AuthController>().update();
  }

  void removeBankingImage(int index) {
    pickedBankingIdentities.removeAt(index);
    Get.find<AuthController>().update();
  }

  void _resetState() {
    if (!this.mounted) {
      return;
    }

    setState(() {
      _isImgLoading = true;
      _directoryPath = null;
      _fileName = null;
      _bankingName = null;
      pickedResidenceIdentities = null;
      pickedBankingIdentities = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

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
    Size size = MediaQuery.of(context).size;

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
                margin: EdgeInsets.only(left: 0, right: 0, bottom: 70, top: 40),
                padding: EdgeInsets.only(left: 3, right: 3),
                height: double.infinity,
                child: PageView(
                  //physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) => setState(() {
                    pageNumber = index;
                  }),
                  controller: pageController,
                  children: [
                    Column(children: [
                      Expanded(
                          child: SingleChildScrollView(
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        physics: BouncingScrollPhysics(),
                        child: Center(
                            child: SizedBox(
                                width: Dimensions.WEB_MAX_WIDTH,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment: Alignment.center,
                                          child: Stack(children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimensions.RADIUS_SMALL),
                                              child:
                                                  authController.pickedImage !=
                                                          null
                                                      ? GetPlatform.isWeb
                                                          ? Image.network(
                                                              authController
                                                                  .pickedImage
                                                                  .path,
                                                              width: 150,
                                                              height: 120,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.file(
                                                              File(authController
                                                                  .pickedImage
                                                                  .path),
                                                              width: 150,
                                                              height: 120,
                                                              fit: BoxFit.cover,
                                                            )
                                                      : Image.asset(
                                                          placeholderimg,
                                                          width: 150,
                                                          height: 120,
                                                          fit: BoxFit.cover,
                                                        ),
                                            ),
                                            Positioned(
                                              bottom: 0,
                                              right: 0,
                                              top: 0,
                                              left: 0,
                                              child: InkWell(
                                                onTap: () => authController
                                                    .pickDmImage(true, false),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .RADIUS_SMALL),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                  child: Container(
                                                    margin: EdgeInsets.all(25),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Colors.white),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                        Icons.camera_alt,
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ])),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      Row(children: [
                                        Container(
                                          width: 170,
                                          child: TextFormField(
                                            controller: _fNameController,
                                            focusNode: _fNameNode,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter first name';
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (v) {
                                              _fNameNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(_lNameNode);
                                            },
                                            decoration: inputDecoration(context,
                                                hintText: "First name"),
                                          ),
                                        ),
                                        SizedBox(width: 2),
                                        Container(
                                          width: 170,
                                          child: TextFormField(
                                            controller: _lNameController,
                                            focusNode: _lNameNode,
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return 'Please enter last name';
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (v) {
                                              _lNameNode.unfocus();
                                              FocusScope.of(context)
                                                  .requestFocus(_emailNode);
                                            },
                                            decoration: inputDecoration(
                                              context,
                                              hintText: "Lastname",
                                            ),
                                          ),
                                        ),
                                      ]),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      TextFormField(
                                        controller: _emailController,
                                        focusNode: _emailNode,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              !value.contains('@')) {
                                            return 'Enter correct email';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (v) {
                                          _emailNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(_phoneNode);
                                        },
                                        decoration: inputDecoration(
                                          context,
                                          hintText: "Email",
                                          suffixIcon: Icon(
                                              Icons.mail_outline_rounded,
                                              size: 16,
                                              color: appStore.isDarkModeOn
                                                  ? white
                                                  : gray),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      TextFormField(
                                        controller: _phoneController,
                                        focusNode: _phoneNode,
                                        validator: (value) {
                                          if (int.tryParse(value) == null) {
                                            return 'Phone number required!!';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (v) {
                                          _emailNode.unfocus();
                                          FocusScope.of(context)
                                              .requestFocus(_passwordNode);
                                        },
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          hintText: 'Phone number',
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: radius(defaultRadius),
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0.0),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: radius(defaultRadius),
                                            borderSide: BorderSide(
                                                color: Colors.transparent,
                                                width: 0.0),
                                          ),
                                          filled: true,
                                          fillColor: appStore.isDarkModeOn
                                              ? cardDarkColor
                                              : editTextBgColor,
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(left: 12),
                                            child: Observer(
                                              builder: (context) =>
                                                  DropdownButtonHideUnderline(
                                                child: DropdownButton(
                                                  value: pr_ob
                                                      .pickedValuseOfDropDownMenu1,
                                                  style: primaryTextStyle(),
                                                  items: [
                                                    DropdownMenuItem(
                                                        child: Text('🇿🇦'),
                                                        value: 0),
                                                  ],
                                                  onChanged: (val) {
                                                    pr_ob.pickedValuseOfDropDownMenu1 =
                                                        val.toDouble();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      Observer(
                                        builder: (context) => TextFormField(
                                          obscureText: isIconCheck2,
                                          focusNode: _passwordNode,
                                          controller: _passwordController,
                                          validator: (value) {
                                            return Validate.validate(value);
                                          },
                                          onFieldSubmitted: (v) {
                                            _passwordNode.unfocus();
                                            FocusScope.of(context).requestFocus(
                                                _identityNumberNode);
                                          },
                                          decoration: InputDecoration(
                                            hintText: 'Enter Password',
                                            filled: true,
                                            fillColor: AppStore().isDarkModeOn
                                                ? cardDarkColor
                                                : editTextBgColor,
                                            border: InputBorder.none,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  radius(defaultRadius),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0.0),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  radius(defaultRadius),
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 0.0),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  radius(defaultRadius),
                                              borderSide: BorderSide(
                                                  color: Colors.red,
                                                  width: 1.0),
                                            ),
                                            errorMaxLines: 2,
                                            errorStyle: primaryTextStyle(
                                                color: Colors.red, size: 12),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  radius(defaultRadius),
                                              borderSide: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 0.0),
                                            ),
                                            prefixIcon: Icon(Icons.lock,
                                                color: Get.iconColor, size: 22),
                                            suffixIcon: Theme(
                                              data: ThemeData(
                                                splashColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                              ),
                                              child: IconButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                color: Get.iconColor,
                                                onPressed: () {
                                                  setState(() {
                                                    isIconCheck2 = isIconCheck2;
                                                  });
                                                },
                                                icon: Icon(
                                                  (isIconCheck2)
                                                      ? Icons.visibility_rounded
                                                      : Icons.visibility_off,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      TextFormField(
                                        controller: _identityNumberController,
                                        focusNode: _identityNumberNode,
                                        textInputAction: TextInputAction.done,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter last name';
                                          }
                                          return null;
                                        },
                                        onFieldSubmitted: (v) {
                                          _identityNumberNode.unfocus();
                                          // FocusScope.of(context).requestFocus(_emailNode);
                                        },
                                        decoration: inputDecoration(
                                          context,
                                          hintText: 'identity_number'.tr,
                                          suffixIcon: Icon(Icons.person),
                                        ),
                                      ),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      Row(children: [
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                              Text(
                                                'delivery_man_type'.tr,
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                              ),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .RADIUS_SMALL),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey[
                                                            Get.isDarkMode
                                                                ? 800
                                                                : 200],
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 5))
                                                  ],
                                                ),
                                                child: DropdownButton<String>(
                                                  value:
                                                      authController.dmTypeList[
                                                          authController
                                                              .dmTypeIndex],
                                                  items: authController
                                                      .dmTypeList
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value.tr),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    authController
                                                        .setDMTypeIndex(
                                                            value, true);
                                                  },
                                                  isExpanded: true,
                                                  underline: SizedBox(),
                                                ),
                                              ),
                                            ])),
                                        SizedBox(
                                            width:
                                                Dimensions.PADDING_SIZE_SMALL),
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                              Text(
                                                'zone'.tr,
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                              ),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              authController.zoneList != null
                                                  ? Container(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: Dimensions
                                                              .PADDING_SIZE_SMALL),
                                                      decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .cardColor,
                                                        borderRadius: BorderRadius
                                                            .circular(Dimensions
                                                                .RADIUS_SMALL),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors
                                                                      .grey[
                                                                  Get.isDarkMode
                                                                      ? 800
                                                                      : 200],
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset:
                                                                  Offset(0, 5))
                                                        ],
                                                      ),
                                                      child:
                                                          DropdownButton<int>(
                                                        value: authController
                                                            .selectedZoneIndex,
                                                        items: _zoneIndexList
                                                            .map((int value) {
                                                          return DropdownMenuItem<
                                                              int>(
                                                            value: value,
                                                            child: Text(
                                                                authController
                                                                    .zoneList[
                                                                        value]
                                                                    .name),
                                                          );
                                                        }).toList(),
                                                        onChanged: (value) {
                                                          authController
                                                              .setZoneIndex(
                                                                  value);
                                                        },
                                                        isExpanded: true,
                                                        underline: SizedBox(),
                                                      ),
                                                    )
                                                  : Center(
                                                      child:
                                                          CircularProgressIndicator()),
                                            ])),
                                      ]),
                                      SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      Row(children: [
                                        Expanded(
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                              Text(
                                                'identity_type'.tr,
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .fontSizeSmall),
                                              ),
                                              SizedBox(
                                                  height: Dimensions
                                                      .PADDING_SIZE_EXTRA_SMALL),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: Dimensions
                                                        .PADDING_SIZE_SMALL),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .cardColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .RADIUS_SMALL),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.grey[
                                                            Get.isDarkMode
                                                                ? 800
                                                                : 200],
                                                        spreadRadius: 2,
                                                        blurRadius: 5,
                                                        offset: Offset(0, 5))
                                                  ],
                                                ),
                                                child: DropdownButton<String>(
                                                  value: authController
                                                          .identityTypeList[
                                                      authController
                                                          .identityTypeIndex],
                                                  items: authController
                                                      .identityTypeList
                                                      .map((String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(value.tr),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    authController
                                                        .setIdentityTypeIndex(
                                                            value, true);
                                                  },
                                                  isExpanded: true,
                                                  underline: SizedBox(),
                                                ),
                                              ),
                                            ])),
                                        SizedBox(
                                            width:
                                                Dimensions.PADDING_SIZE_SMALL),
                                      ]),
                                      const SizedBox(
                                          height:
                                              Dimensions.PADDING_SIZE_LARGE),
                                      Text(
                                        'identity_images'.tr,
                                        style: robotoRegular.copyWith(
                                            fontSize: Dimensions.fontSizeSmall),
                                      ),
                                      const SizedBox(
                                          height: Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                      SizedBox(
                                        height: 120,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          physics: BouncingScrollPhysics(),
                                          itemCount: authController
                                                  .pickedIdentities.length +
                                              1,
                                          itemBuilder: (context, index) {
                                            XFile _file = index ==
                                                    authController
                                                        .pickedIdentities.length
                                                ? null
                                                : authController
                                                    .pickedIdentities[index];
                                            if (index ==
                                                authController
                                                    .pickedIdentities.length) {
                                              return InkWell(
                                                onTap: () => authController
                                                    .pickDmImage(false, false),
                                                child: Container(
                                                  height: 120,
                                                  width: 150,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .RADIUS_SMALL),
                                                    border: Border.all(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        width: 2),
                                                  ),
                                                  child: Container(
                                                    padding: EdgeInsets.all(
                                                        Dimensions
                                                            .PADDING_SIZE_DEFAULT),
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 2,
                                                          color: Theme.of(
                                                                  context)
                                                              .primaryColor),
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(
                                                        Icons.camera_alt,
                                                        color: Theme.of(context)
                                                            .primaryColor),
                                                  ),
                                                ),
                                              );
                                            }
                                            return Container(
                                              margin: EdgeInsets.only(
                                                  right: Dimensions
                                                      .PADDING_SIZE_SMALL),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    width: 2),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimensions
                                                            .RADIUS_SMALL),
                                              ),
                                              child: Stack(children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimensions
                                                              .RADIUS_SMALL),
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
                                                    onTap: () => authController
                                                        .removeIdentityImage(
                                                            index),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          Dimensions
                                                              .PADDING_SIZE_SMALL),
                                                      child: Icon(
                                                          Icons.delete_forever,
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                            );
                                          },
                                        ),
                                      ),
                                    ]))),
                      )),
                    ]),
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
                                style: boldTextStyle(
                                    size: 20, letterSpacing: 0.2)),
                            10.height,
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
                                style: boldTextStyle(
                                    size: 15, letterSpacing: 0.2)),
                            10.height,
                            Text("Select a Vehicle.",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: const [
                                        BoxShadow(
                                          offset: Offset(0, 0),
                                          blurRadius: 1,
                                          spreadRadius: 1,
                                          color: Colors.black12,
                                        ),
                                      ],
                                    ),
                                    margin: const EdgeInsets.only(
                                        top: 15, right: 10, left: 3),
                                    height: 85,
                                    child:
                                        // One
                                        FutureBuilder(
                                            future: Get.find<OrderController>()
                                                .get_Vehicles(),
                                            builder: (context,
                                                AsyncSnapshot<List> snapshot) {
                                              if (!snapshot.hasData) {
                                                return Container(
                                                    height: 60,
                                                    width: 80,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.transparent,
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                        left:
                                                            Radius.circular(20),
                                                        right:
                                                            Radius.circular(20),
                                                      ),
                                                    ),
                                                    padding: EdgeInsets.all(8),
                                                    child:
                                                        CircularProgressIndicator());
                                              } else {
                                                return SizedBox(
                                                    height: 55,
                                                    child: ListView.separated(
                                                      physics:
                                                          ClampingScrollPhysics(),
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: snapshot
                                                              .data?.length ??
                                                          0,
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return VerticalDivider(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          width: 0,
                                                        );
                                                      },
                                                      shrinkWrap: true,
                                                      itemBuilder:
                                                          (context, index) {
                                                        // bool selected =
                                                        //     vehicleTypeSelected?.id == vehicleType.id;
                                                        int id = snapshot
                                                            .data[index]['id'];
                                                        selected =
                                                            vehicleTypeSelected ==
                                                                id;
                                                        return InkWell(
                                                          onTap: () async {
                                                            if (selected) {
                                                              setState(() {
                                                                vehicleTypeSelected =
                                                                    snapshot.data[
                                                                            index]
                                                                        ['id'];
                                                                base_price = snapshot
                                                                    .data[index]
                                                                        [
                                                                        'base_price']
                                                                    .toString()
                                                                    .toDouble();
                                                                additional_distance_price = snapshot
                                                                    .data[index]
                                                                        [
                                                                        'additional_distance_pricing']
                                                                    .toString()
                                                                    .toDouble();

                                                                vehicleTypeSelected =
                                                                    null;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                vehicleTypeSelected =
                                                                    snapshot.data[
                                                                            index]
                                                                        ['id'];
                                                                base_price = snapshot
                                                                    .data[index]
                                                                        [
                                                                        'base_price']
                                                                    .toString()
                                                                    .toDouble();
                                                                additional_distance_price = snapshot
                                                                    .data[index]
                                                                        [
                                                                        'additional_distance_pricing']
                                                                    .toString()
                                                                    .toDouble();
                                                              });
                                                            }
                                                          },
                                                          child: Container(
                                                            width: 80,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: vehicleTypeSelected ==
                                                                      id
                                                                  ? Theme.of(
                                                                          context)
                                                                      .primaryColor
                                                                  : Colors
                                                                      .transparent,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .horizontal(
                                                                left: index == 0
                                                                    ? Radius
                                                                        .circular(
                                                                            20)
                                                                    : Radius
                                                                        .zero,
                                                                right: index ==
                                                                        snapshot.data.length -
                                                                            1
                                                                    ? Radius
                                                                        .circular(
                                                                            20)
                                                                    : Radius
                                                                        .zero,
                                                              ),
                                                            ),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8),
                                                            child: Column(
                                                              children: [
                                                                AutoSizeText(
                                                                  snapshot.data[
                                                                          index]
                                                                      ['name'],
                                                                  style: kSubtitleStyle
                                                                      .copyWith(
                                                                    color: selected
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                  minFontSize:
                                                                      8,
                                                                  maxLines: 1,
                                                                ),
                                                                if (snapshot.data[
                                                                            index]
                                                                        [
                                                                        'logo'] !=
                                                                    null)
                                                                  CachedNetworkImage(
                                                                    progressIndicatorBuilder: (context,
                                                                            url,
                                                                            progress) =>
                                                                        Center(
                                                                      child:
                                                                          SizedBox(
                                                                        width:
                                                                            55,
                                                                        height:
                                                                            55,
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          value:
                                                                              progress.progress,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    imageUrl:
                                                                        '${AppConstants.BASE_URL}/storage/app/public/vehicles/${snapshot.data[index]['logo']}',
                                                                    height: 44,
                                                                    fit: BoxFit
                                                                        .contain,
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    color: selected
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ));
                                              }
                                            }),
                                  ),
                                ]),
                            40.height,
                            Text(
                                "Do you agree that your information will be used for background checks \n "
                                "for any criminal records.?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            //two
                            checkBox(bgItems, bg, 2),
                            10.height,
                            Text(
                                "Do you agree that you will only receive 100% of the total amount charged \nto each customer as delivery fee? ?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
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
                          left: 16,
                          bottom: 70,
                          right: 19,
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
                                style: boldTextStyle(
                                    size: 15, letterSpacing: 0.2)),
                            10.height,
                            Text(
                                "Do you agree that by working as delivery man you will be paid every week and \n funds will reflect to your bank depending on which bank \nyou are using?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            //four
                            checkBox(paid_weekItems, paid_week, 4),

                            10.height,
                            Text(
                                "Do you agree that vehicle or scooter is at your full responsibility \n including maintenance and insurance and you will only be paid commission \n you earned?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            //five
                            checkBox(responsibilityFull, responsibility, 5),
                            10.height,
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
                            10.height,
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
                                style: boldTextStyle(
                                    size: 15, letterSpacing: 0.2)),
                            10.height,
                            Text(
                                "Do you agree that Maximum orders you are allowed to take per trip will be 3 \n Orders and you will be paid per order delivered ?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            //seven
                            checkBox(max_orderItems, max_order, 7),
                            10.height,
                            Text(
                                "Do you agree that we will track all events when delivering orders?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            //eight
                            checkBox(track_eventItems, track_event, 8),
                            10.height,
                            Text(
                                "Do you agree with our maximum waiting period which is 5 minutes at customer \n destination if the customer doesn't show up you allowed \n to leave with the order?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
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
                                style: boldTextStyle(
                                    size: 15, letterSpacing: 0.2)),
                            10.height,
                            Text(
                                "Good luck at this point you answered most of the questions now we will like to \n know do you have adriod phone with version 7+?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            //ten
                            checkBox(sevenplusItems, sevenplus, 10),
                            10.height,
                            Text("Do you agree to our terms and conditions?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            //eleven
                            checkBox(termsItems, terms, 11),
                            10.height,
                            Text("Do you agree with our privacy policy?",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            //tweleve
                            checkBox(privacyItems, privacy, 12),
                            10.height,
                            Text("Upload Vehicle license img",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
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
                                      onTap: () => authController.pickRegImage(
                                          false, false, "license"),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                              color: Theme.of(context)
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
                                          onTap: () => authController
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
                            Text("Upload Proof Of Resident.",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: pickedResidenceIdentities != null
                                    ? pickedResidenceIdentities.length + 1
                                    : 1,
                                itemBuilder: (context, index) {
                                  PlatformFile _file =
                                      index == pickedResidenceIdentities.length
                                          ? null
                                          : pickedResidenceIdentities[index];
                                  if (index ==
                                      pickedResidenceIdentities.length) {
                                    return InkWell(
                                      onTap: () => pickFiles("residence"),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            shape: BoxShape.circle,
                                          ),
                                          child: _file != null
                                              ? Text(
                                                  _file != null
                                                      ? _file.name
                                                      : "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1,
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor:
                                                      ScaleSize.textScaleFactor(
                                                          context),
                                                )
                                              : Icon(Icons.file_copy, size: 18),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      child: Stack(children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL),
                                            child: GetPlatform.isWeb
                                                ? Text(
                                                    _file != null
                                                        ? _file.name
                                                        : "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  )
                                                : Text(
                                                    _file != null
                                                        ? _file.name
                                                        : "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  )),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: InkWell(
                                            onTap: () =>
                                                removeResidenceImage(index),
                                            child: const Padding(
                                              padding: EdgeInsets.all(Dimensions
                                                  .PADDING_SIZE_SMALL),
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
                            10.height,
                            Text(
                                "Upload Banking details (bank confirmation letter or bank statement).",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
                                )),
                            10.height,
                            SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: pickedBankingIdentities != null
                                    ? pickedBankingIdentities.length + 1
                                    : 1,
                                itemBuilder: (context, index) {
                                  PlatformFile _file =
                                      index == pickedBankingIdentities.length
                                          ? null
                                          : pickedBankingIdentities[index];
                                  if (index == pickedBankingIdentities.length) {
                                    return InkWell(
                                      onTap: () => pickFiles("banking"),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              width: 2),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.all(Dimensions
                                              .PADDING_SIZE_EXTRA_SMALL),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            shape: BoxShape.circle,
                                          ),
                                          child: _file != null
                                              ? Text(
                                                  _file != null
                                                      ? _file.name
                                                      : "",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1,
                                                  textAlign: TextAlign.center,
                                                  textScaleFactor:
                                                      ScaleSize.textScaleFactor(
                                                          context),
                                                )
                                              : Icon(Icons.file_copy, size: 18),
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 5),
                                      child: Stack(children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                Dimensions.RADIUS_SMALL),
                                            child: GetPlatform.isWeb
                                                ? Text(
                                                    _file != null
                                                        ? _file.name
                                                        : "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  )
                                                : Text(
                                                    _file != null
                                                        ? _file.name
                                                        : "",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle1,
                                                    textAlign: TextAlign.center,
                                                    textScaleFactor: ScaleSize
                                                        .textScaleFactor(
                                                            context),
                                                  )),
                                        Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: InkWell(
                                            onTap: () =>
                                                removeBankingImage(index),
                                            child: const Padding(
                                              padding: EdgeInsets.all(Dimensions
                                                  .PADDING_SIZE_SMALL),
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
                            10.height,
                            Text(
                                "Upload Picture of your drivers license(front).",
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
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
                                      onTap: () => authController.pickRegImage(
                                          false, false, "front"),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                              color: Theme.of(context)
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
                                          onTap: () => authController
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
                                style: boldTextStyle(
                                  size: 15,
                                  letterSpacing: 0.2,
                                  weight: FontWeight.bold,
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
                                      onTap: () => authController.pickRegImage(
                                          false, false, "vehicle"),
                                      child: Container(
                                        height: 120,
                                        width: 150,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimensions.RADIUS_SMALL),
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .primaryColor,
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
                                              color: Theme.of(context)
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
                                          onTap: () => authController
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
                      children: buildDotIndicator(),
                    ),
                    pageNumber != 6
                        ? TextButton(
                            onPressed: () async {
                              String _fName = _fNameController.text.trim();
                              String _lName = _lNameController.text.trim();
                              String _email = _emailController.text.trim();
                              String _phone = _phoneController.text.trim();
                              String _password =
                                  _passwordController.text.trim();
                              String _identityNumber =
                                  _identityNumberController.text.trim();

                              String _numberWithCountryCode =
                                  _countryDialCode + _phone;
                              bool _isValid = GetPlatform.isWeb ? true : false;

                              if (pageNumber == 0) {
                                bool isOk = (await _addDeliveryMan(
                                    _fName,
                                    _lName,
                                    _email,
                                    _phone,
                                    _password,
                                    _identityNumber,
                                    _numberWithCountryCode,
                                    _isValid,
                                    authController));
                                if (!isOk) {
                                  return;
                                }
                              }

                              if (pageNumber == 3) {
                                if (vehicle == "" ||
                                    bg == "" ||
                                    percent_hu == "") {
                                  showCustomSnackBar(
                                      "One or more selections are missings",
                                      isError: true);
                                  return;
                                }
                              }
                              if (pageNumber == 4) {
                                if (paid_week == "" ||
                                    responsibility == "" ||
                                    paidR7 == "") {
                                  showCustomSnackBar(
                                      "One or more selections are missings",
                                      isError: true);
                                  return;
                                }
                              }
                              if (pageNumber == 5) {
                                if (max_order == "" ||
                                    track_event == "" ||
                                    waiting_period == "") {
                                  showCustomSnackBar(
                                      "One or more selections are missings",
                                      isError: true);
                                  return;
                                }
                              }
                              if (pageNumber == 6) {
                                if (sevenplus == "" ||
                                    terms == "" ||
                                    privacy == "" ||
                                    authController.license == null ||
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
                              String _fName = _fNameController.text.trim();
                              String _lName = _lNameController.text.trim();
                              String _email = _emailController.text.trim();
                              String _phone = _phoneController.text.trim();
                              String _password =
                                  _passwordController.text.trim();
                              String _identityNumber =
                                  _identityNumberController.text.trim();

                              String _numberWithCountryCode =
                                  _countryDialCode + _phone;
                              bool _isValid = GetPlatform.isWeb ? true : false;

                              finish(context);
                              authController.registerDeliveryMan(
                                  DeliveryManBody(
                                    fName: _fName,
                                    lName: _lName,
                                    password: _password,
                                    phone: _numberWithCountryCode,
                                    email: _email,
                                    identityNumber: _identityNumber,
                                    identityType:
                                        authController.identityTypeList[
                                            authController.identityTypeIndex],
                                    earning: authController.dmTypeIndex == 0
                                        ? '1'
                                        : '0',
                                    zoneId: authController
                                        .zoneList[
                                            authController.selectedZoneIndex]
                                        .id
                                        .toString(),
                                    vehicle_id: 2,
                                    is_criminal_bg_check: bg,
                                    is_total_amount: percent_hu,
                                    is_paid_every_week: paid_week,
                                    is_vehicle_reponsibility: responsibility,
                                    is_paid_per_km: paidR7,
                                    is_max_order: max_order,
                                    is_track_event: track_event,
                                    is_max_waiting_period: waiting_period,
                                    is_version_seven_plus: sevenplus,
                                    is_agree_terms: terms,
                                    is_agree_privacy: privacy,
                                  ),
                                  pickedResidenceIdentities,
                                  pickedBankingIdentities);
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

  Future<bool> _addDeliveryMan(
      String _fName,
      String _lName,
      String _email,
      String _phone,
      String _password,
      String _identityNumber,
      String _numberWithCountryCode,
      bool _isValid,
      AuthController authController) async {
    if (!GetPlatform.isWeb) {
      try {
        PhoneNumber phoneNumber =
            await PhoneNumberUtil().parse(_numberWithCountryCode);
        _numberWithCountryCode =
            '+' + phoneNumber.countryCode + phoneNumber.nationalNumber;
        _isValid = true;
      } catch (e) {}
    }
    if (_fName.isEmpty) {
      showCustomSnackBar('enter_delivery_man_first_name'.tr);
      return false;
    } else if (_lName.isEmpty) {
      showCustomSnackBar('enter_delivery_man_last_name'.tr);
      return false;
    } else if (_email.isEmpty) {
      showCustomSnackBar('enter_delivery_man_email_address'.tr);
      return false;
    } else if (!GetUtils.isEmail(_email)) {
      showCustomSnackBar('enter_a_valid_email_address'.tr);
      return false;
    } else if (_phone.isEmpty) {
      showCustomSnackBar('enter_delivery_man_phone_number'.tr);
      return false;
    } else if (!_isValid) {
      showCustomSnackBar('enter_a_valid_phone_number'.tr);
      return false;
    } else if (_password.isEmpty) {
      showCustomSnackBar('enter_password_for_delivery_man'.tr);
      return false;
    } else if (_password.length < 6) {
      showCustomSnackBar('password_should_be'.tr);
      return false;
    } else if (_identityNumber.isEmpty) {
      showCustomSnackBar('enter_delivery_man_identity_number'.tr);
      return false;
    } else if (authController.pickedImage == null) {
      showCustomSnackBar('upload_delivery_man_image'.tr);
      return false;
    } else {
      return true;
    }
  }

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
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
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
