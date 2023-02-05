import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sandav/controller/location_controller.dart';
import 'package:sandav/controller/splash_controller.dart';
import 'package:sandav/data/api/api_checker.dart';
import 'package:sandav/data/api/api_client.dart';
import 'package:sandav/data/model/body/delivery_man_body.dart';
import 'package:sandav/data/model/body/restaurant_body.dart';
import 'package:sandav/data/model/body/signup_body.dart';
import 'package:sandav/data/model/body/social_log_in_body.dart';
import 'package:sandav/data/model/response/response_model.dart';
import 'package:sandav/data/model/response/zone_model.dart';
import 'package:sandav/data/model/response/zone_response_model.dart';
import 'package:sandav/data/repository/auth_repo.dart';
import 'package:sandav/helper/route_helper.dart';
import 'package:sandav/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({@required this.authRepo}) {
    _notification = authRepo.isNotificationActive();
  }



  String _saveAsFileName;
  //List<PlatformFile> _paths;
  String _directoryPath;
  String _extension="jpg, pdf, doc";
  bool _isImgLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;
  XFile _pickedLogo;
  XFile _pickedCover;
  List<ZoneModel> _zoneList;
  int _selectedZoneIndex = 0;
  LatLng _restaurantLocation;
  List<int> _zoneIds;
  XFile _pickedImage;
  XFile _licensedImage;
  XFile _residenceImage;
  XFile _frontImage;
  XFile _vehicleImage;


  List<XFile> _pickedIdentities = [];
  List<XFile> _pickedLicenseIdentities = [];
  List<XFile> _pickedFrontIdentities = [];
  List<XFile> _pickedVehicleIdentities = [];

  List<String> _identityTypeList = ['passport', 'National Identity'];
  int _identityTypeIndex = 0;
  List<String> _dmTypeList = ['freelancer', 'salary_based'];
  int _dmTypeIndex = 0;

  bool get isLoading => _isLoading;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
  XFile get pickedLogo => _pickedLogo;
  XFile get pickedCover => _pickedCover;
  List<ZoneModel> get zoneList => _zoneList;
  int get selectedZoneIndex => _selectedZoneIndex;
  LatLng get restaurantLocation => _restaurantLocation;
  List<int> get zoneIds => _zoneIds;
  XFile get pickedImage => _pickedImage;

  XFile get license =>  _licensedImage;

  XFile get residence =>  _residenceImage;

  List<XFile> get pickedIdentities => _pickedIdentities;
  List<XFile> get pickedLicenseIdentities => _pickedLicenseIdentities;



  List<XFile> get pickedFrontIdentities => _pickedFrontIdentities;
  List<XFile> get pickedVhicleIdentities => _pickedVehicleIdentities;



  //List<PlatformFile> get pickedResidenceIdentities => _pickedResidenceIdentities;


  List<String> get identityTypeList => _identityTypeList;
  int get identityTypeIndex => _identityTypeIndex;
  List<String> get dmTypeList => _dmTypeList;
  int get dmTypeIndex => _dmTypeIndex;

  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registration(signUpBody);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (!Get.find<SplashController>().configModel.customerVerification) {
        authRepo.saveUserToken(response.body["token"]);
        await authRepo.updateToken();
      }
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();
    Response response = await authRepo.login(phone: phone, password: password);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      if (Get.find<SplashController>().configModel.customerVerification &&
          response.body['is_phone_verified'] == 0) {
      } else {
        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();
      }
      responseModel = ResponseModel(true,
          '${response.body['is_phone_verified']}${response.body['token']}');
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
    _isLoading = true;
    update();
    Response response =
        await authRepo.loginWithSocialMedia(socialLogInBody.email);
    if (response.statusCode == 200) {
      String _token = response.body['token'];
      if (_token != null && _token.isNotEmpty) {
        if (Get.find<SplashController>().configModel.customerVerification &&
            response.body['is_phone_verified'] == 0) {
          Get.toNamed(RouteHelper.getVerificationRoute(
              socialLogInBody.email, _token, RouteHelper.signUp, ''));
        } else {
          authRepo.saveUserToken(response.body['token']);
          await authRepo.updateToken();
          Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
        }
      } else {
        Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInBody));
      }
    } else {
      showCustomSnackBar(response.statusText);
    }
    _isLoading = false;
    update();
  }

  Future<void> registerWithSocialMedia(SocialLogInBody socialLogInBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registerWithSocialMedia(socialLogInBody);
    if (response.statusCode == 200) {
      String _token = response.body['token'];
      if (Get.find<SplashController>().configModel.customerVerification &&
          response.body['is_phone_verified'] == 0) {
        Get.toNamed(RouteHelper.getVerificationRoute(
            socialLogInBody.phone, _token, RouteHelper.signUp, ''));
      } else {
        authRepo.saveUserToken(response.body['token']);
        await authRepo.updateToken();
        Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
      }
    } else {
      showCustomSnackBar(response.statusText);
    }
    _isLoading = false;
    update();
  }

  Future<ResponseModel> forgetPassword(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.forgetPassword(email);

    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyToken(email, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> resetPassword(String resetToken, String number,
      String password, String confirmPassword) async {
    _isLoading = true;
    update();
    Response response = await authRepo.resetPassword(
        resetToken, number, password, confirmPassword);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> checkEmail(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.checkEmail(email);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["token"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyEmail(String email, String token) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyEmail(email, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> verifyPhone(String phone, String token) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyPhone(phone, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(token);
      await authRepo.updateToken();
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateZone() async {
    Response response = await authRepo.updateZone();
    if (response.statusCode == 200) {
      // Nothing to do
    } else {
      ApiChecker.checkApi(response);
    }
  }

  String _verificationCode = '';

  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  void saveUserNumberAndPassword(
      String number, String password, String countryCode) {
    authRepo.saveUserNumberAndPassword(number, password, countryCode);
  }

  String getUserNumber() {
    return authRepo.getUserNumber() ?? "";
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authRepo.setNotificationActive(isActive);
    update();
    return _notification;
  }

  bool clearSharedAddress() {
    return authRepo.clearSharedAddress();
  }

  void pickImage(bool isLogo, bool isRemove) async {
    if (isRemove) {
      _pickedLogo = null;
      _pickedCover = null;
    } else {
      if (isLogo) {
        _pickedLogo =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        _pickedCover =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      }
      update();
    }
  }

  Future<void> getZoneList() async {
    _pickedLogo = null;
    _pickedCover = null;
    _selectedZoneIndex = 0;
    _restaurantLocation = null;
    _zoneIds = null;
    Response response = await authRepo.getZoneList();
    if (response.statusCode == 200) {
      _zoneList = [];
      response.body.forEach((zone) => _zoneList.add(ZoneModel.fromJson(zone)));
      setLocation(LatLng(
        double.parse(
            Get.find<SplashController>().configModel.defaultLocation.lat ??
                '0'),
        double.parse(
            Get.find<SplashController>().configModel.defaultLocation.lng ??
                '0'),
      ));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void setZoneIndex(int index) {
    _selectedZoneIndex = index;
    update();
  }

  void setLocation(LatLng location) async {
    ZoneResponseModel _response = await Get.find<LocationController>().getZone(
      location.latitude.toString(),
      location.longitude.toString(),
      false,
    );
    if (_response != null &&
        _response.isSuccess &&
        _response.zoneIds.length > 0) {
      _restaurantLocation = location;
      _zoneIds = _response.zoneIds;
      for (int index = 0; index < _zoneList.length; index++) {
        if (_zoneIds.contains(_zoneList[index].id)) {
          _selectedZoneIndex = index;
          break;
        }
      }
    } else {
      _restaurantLocation = null;
      _zoneIds = null;
    }
    update();
  }

  Future<void> registerRestaurant(RestaurantBody restaurantBody) async {
    _isLoading = true;
    update();
    Response response = await authRepo.registerRestaurant(
        restaurantBody, _pickedLogo, _pickedCover);
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar('restaurant_registration_successful'.tr,
          isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }

  // bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices) {
  //   int intersectCount = 0;
  //   for (int j = 0; j < vertices.length - 1; j++) {
  //     if (_rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
  //       intersectCount++;
  //     }
  //   }
  //
  //   return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  // }

  // bool _rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
  //   double aY = vertA.latitude;
  //   double bY = vertB.latitude;
  //   double aX = vertA.longitude;
  //   double bX = vertB.longitude;
  //   double pY = tap.latitude;
  //   double pX = tap.longitude;
  //
  //   if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
  //     return false; // a and b can't both be above or below pt.y, and a or
  //     // b must be east of pt.x
  //   }
  //
  //   double m = (aY - bY) / (aX - bX); // Rise over run
  //   double bee = (-aX) * m + aY; // y = mx + b
  //   double x = (pY - bee) / m; // algebra is neat!
  //
  //   return x > pX;
  // }

  void setIdentityTypeIndex(String identityType, bool notify) {
    int _index = 0;
    for (int index = 0; index < _identityTypeList.length; index++) {
      if (_identityTypeList[index] == identityType) {
        _index = index;
        break;
      }
    }
    _identityTypeIndex = _index;
    if (notify) {
      update();
    }
  }

  void setDMTypeIndex(String dmType, bool notify) {
    _dmTypeIndex = _dmTypeList.indexOf(dmType);
    if (notify) {
      update();
    }
  }

  void pickDmImage(bool isLogo, bool isRemove) async {
    if (isRemove) {
      _pickedImage = null;
      _pickedIdentities = [];
    } else {
      if (isLogo) {
        _pickedImage =
            await ImagePicker().pickImage(source: ImageSource.gallery);
      } else {
        XFile _xFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (_xFile != null) {
          _pickedIdentities.add(_xFile);
        }
      }
      update();
    }
  }

  void pickRegImage(bool isLogo, bool isRemove, String s) async {
    if (isRemove) {
      if(s == "license"){
        _licensedImage = null;
        _pickedLicenseIdentities = [];
      }
      if(s == "front"){
        _frontImage = null;
        _pickedFrontIdentities = [];
      }
      if(s == "vehicle"){
        _vehicleImage = null;
        _pickedVehicleIdentities = [];
      }

    } else {
      if (isLogo) {
        if(s == "license"){
          _licensedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
         print("Faziysss ${_licensedImage.path}");
        }
        if(s == "front"){
          _frontImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
        }
        if(s == "vehicle"){
          _vehicleImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);
        }
      } else {
        if(s == "license"){
          XFile _xFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
          if (_xFile != null) {
            _pickedLicenseIdentities.add(_xFile);
          }
        }
        if(s == "front"){
          XFile _xFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
          if (_xFile != null) {
            _pickedFrontIdentities.add(_xFile);
          }
        }
        if(s == "vehicle"){
          XFile _xFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
          if (_xFile != null) {
            _pickedVehicleIdentities.add(_xFile);
          }
        }

      }
      update();
    }
  }









  void removeIdentityImage(int index) {
    _pickedIdentities.removeAt(index);
    update();
  }



  void removeLicenseImage(int index) {

    _pickedLicenseIdentities.removeAt(index);
    update();
  }

  void removeFrontImage(int index) {

    _pickedFrontIdentities.removeAt(index);
    update();
  }

  void removeVehicleImage(int index) {
    _pickedVehicleIdentities.removeAt(index);
    update();
  }













  Future<void> registerDeliveryMan(DeliveryManBody deliveryManBody,

      String path, String path_bank) async {
    _isLoading = true;
    update();
    List<MultipartBody> _multiParts = [];
    List<MultipartBody> _LicensemultiParts = [];
    List<MultipartBody> _DriverLicensemultiParts = [];
    List<MultipartBody> _VehiclemultiParts = [];
    print("Fazzzz ${deliveryManBody.vehicle_id}");
    _multiParts.add(MultipartBody('image', _pickedImage));
    for (XFile file in _pickedIdentities) {
      _multiParts.add(MultipartBody('identity_image[]', file));
    }
    for (XFile file in pickedLicenseIdentities) {
      _LicensemultiParts.add(MultipartBody('vehicle_license_image[]', file));
    }
    for (XFile file in pickedFrontIdentities) {
      _DriverLicensemultiParts.add(MultipartBody('driver_license_image[]', file));
    }
    for (XFile file in pickedVhicleIdentities) {
      _VehiclemultiParts.add(MultipartBody('vehicle_plate_image[]', file));
    }


    Response response =
        await authRepo.registerDeliveryMan(deliveryManBody, _multiParts,_LicensemultiParts,
            _DriverLicensemultiParts,_VehiclemultiParts,
        path,path_bank

        );
    if (response.statusCode == 200) {
      Get.offAllNamed(RouteHelper.getInitialRoute());
      showCustomSnackBar('delivery_man_registration_successful'.tr,
          isError: false);
    } else {
      ApiChecker.checkApi(response);
    }
    _isLoading = false;
    update();
  }
}
