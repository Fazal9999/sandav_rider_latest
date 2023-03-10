import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:delivery_man/data/model/response/address_model.dart';
import 'package:http_parser/http_parser.dart';

import 'package:delivery_man/data/model/response/error_response.dart';
import 'package:delivery_man/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:http/http.dart' as Http;

import '../../controller/auth_controller.dart';
import '../model/body/delivery_man_body.dart';

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage = 'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String token;
  Map<String, String> _mainHeaders;

  ApiClient({ this.appBaseUrl,  this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.TOKEN);
    debugPrint('Token: $token');
    AddressModel _addressModel;
    try {
      _addressModel = AddressModel.fromJson(jsonDecode(sharedPreferences.getString(AppConstants.USER_ADDRESS)));
      print('-------------');
      print( _addressModel.toJson());
    }catch(e) {}
    updateHeader(token, _addressModel == null ? null : _addressModel.zoneIds, sharedPreferences.getString(AppConstants.LANGUAGE_CODE));
  }

  void updateHeader(String token, List<int> zoneIDs, String languageCode) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.ZONE_ID: zoneIDs != null ? jsonEncode(zoneIDs) : null,
      AppConstants.LOCALIZATION_KEY: languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': 'Bearer $token'
    };
  }

  Future<Response> getData(String uri, {Map<String, dynamic> query, Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response _response = await Http.get(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body, {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.post(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
  Future<Response> getVehicles(String uri,
      {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');

      Http.Response _response = await Http.post(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(""),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      print("ApiError6 ${e.toString()}");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
  Future<Response> postMultipartData(String uri, Map<String, String> body,
      List<MultipartBody> multipartBody,
      List<MultipartBody> licensemultiParts,
      List<MultipartBody> driverLicensemultiParts,
      List<MultipartBody> vehiclemultiParts,
      String path, String path_bank, {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body with ${multipartBody.length} files');
      Http.MultipartRequest _request = Http.MultipartRequest('POST', Uri.parse(appBaseUrl+uri));
      _request.headers.addAll(headers ?? _mainHeaders);
      for(MultipartBody multipart in multipartBody) {
        if(multipart.file != null) {
          if(Foundation.kIsWeb) {
            Uint8List _list = await multipart.file.readAsBytes();
            Http.MultipartFile _part = Http.MultipartFile(
              multipart.key, multipart.file.readAsBytes().asStream(), _list.length,
              filename: basename(multipart.file.path), contentType: MediaType('image', 'jpg'),
            );
            _request.files.add(_part);
          }else {
            File _file = File(multipart.file.path);
            _request.files.add(Http.MultipartFile(
              multipart.key, _file.readAsBytes().asStream(), _file.lengthSync(), filename: _file.path.split('/').last,
            ));
          }
        }
      }

      for (MultipartBody multipart in licensemultiParts) {
        if (multipart.file != null) {
          Uint8List _list = await multipart.file.readAsBytes();
          _request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            _list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      for (MultipartBody multipart in driverLicensemultiParts) {
        if (multipart.file != null) {
          Uint8List _list = await multipart.file.readAsBytes();
          _request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            _list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      for (MultipartBody multipart in vehiclemultiParts) {
        if (multipart.file != null) {
          Uint8List _list = await multipart.file.readAsBytes();
          _request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            _list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      File imgRes = File(path);
      File imgbank = File(path_bank);

      Uint8List imgbytesRes = await imgRes.readAsBytes();
      Uint8List imgbytesBank = await imgbank.readAsBytes();
      //  Uint8List imgbytesbank = await imgbank.readAsBytes();
      _request.files.add(Http.MultipartFile(
        "resident_file",
        imgRes.readAsBytes().asStream(),
        imgbytesRes.length,
        filename: '${DateTime.now().toString()}.pdf',
      ));
      _request.files.add(Http.MultipartFile(
        "bank_file",
        imgbank.readAsBytes().asStream(),
        imgbytesBank.length,
        filename: '${DateTime.now().toString()}.pdf',
      ));


      _request.fields.addAll(body);
      print("residintFile ${path}");
      print("bankFile ${path_bank}");
      print("requestFile ${_request.files}");

      Http.Response _response = await Http.Response.fromStream(await _request.send());
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }


  Future<Response> postMultipartDataUpdate(String uri, DeliveryManBody body,

      List<MultipartBody> licensemultiParts,
      List<MultipartBody> driverLicensemultiParts,
      List<MultipartBody> vehiclemultiParts,
      String path, String path_bank, {Map<String, String> headers}) async {
    try {
      String token =Get.find<AuthController>().getUserToken();

      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
       Http.MultipartRequest _request = Http.MultipartRequest('POST', Uri.parse(appBaseUrl+uri));
    //  _request.headers.addAll(headers ?? _mainHeaders);
      _request.headers.addAll(<String,String>{'Authorization': 'Bearer $token'});
      for (MultipartBody multipart in licensemultiParts) {
        if (multipart.file != null) {
          Uint8List _list = await multipart.file.readAsBytes();
          _request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            _list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      for (MultipartBody multipart in driverLicensemultiParts) {
        if (multipart.file != null) {
          Uint8List _list = await multipart.file.readAsBytes();
          _request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            _list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      for (MultipartBody multipart in vehiclemultiParts) {
        if (multipart.file != null) {
          Uint8List _list = await multipart.file.readAsBytes();
          _request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readAsBytes().asStream(),
            _list.length,
            filename: '${DateTime.now().toString()}.png',
          ));
        }
      }
      File imgRes = File(path);
      File imgbank = File(path_bank);
      Uint8List imgbytesRes = await imgRes.readAsBytes();
      Uint8List imgbytesBank = await imgbank.readAsBytes();
      //  Uint8List imgbytesbank = await imgbank.readAsBytes();
      Map<String, String> _fields = Map();
      _request.files.add(Http.MultipartFile(
        "resident_file",
        imgRes.readAsBytes().asStream(),
        imgbytesRes.length,
        filename: '${DateTime.now().toString()}.pdf',
      ));
      _request.files.add(Http.MultipartFile(
        "bank_file",
        imgbank.readAsBytes().asStream(),
        imgbytesBank.length,
        filename: '${DateTime.now().toString()}.pdf',
      ));
      _request.fields.addAll(body.toJson());
      _fields.addAll(<String, String>{
        '_method': 'put',
        'is_criminal_bg_check': body.is_criminal_bg_check,
        'is_total_amount': body.is_total_amount,
        'is_paid_every_week':body.is_paid_every_week,
        'is_vehicle_responsibility':body.is_vehicle_responsibility,
        'is_paid_per_km':body.is_paid_per_km,
        'is_max_order':body.is_max_order,
        'is_track_event':body.is_track_event,
        'is_max_waiting_period':body.is_max_waiting_period,
        'is_version_seven_plus':body.is_version_seven_plus,
        'is_agree_terms':body.is_agree_terms,
        'is_agree_privacy':body.is_agree_privacy,
         'token': token
      });
      _request.fields.addAll(_fields);

      Http.Response _response = await Http.Response.fromStream(await _request.send());
      return handleResponse(_response, uri);
    } catch (e) {
      print("regError ${e.toString()}");
      return Response(statusCode: 1, statusText: e.toString());
    }
  }
  Future<Response> putData(String uri, dynamic body, {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.put(
        Uri.parse(appBaseUrl+uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {

      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri, {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response _response = await Http.delete(
        Uri.parse(appBaseUrl+uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Response handleResponse(Http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    }catch(e) {}
    Response _response = Response(
      body: _body != null ? _body : response.body, bodyString: response.body.toString(),
      headers: response.headers, statusCode: response.statusCode, statusText: response.reasonPhrase,
    );
    if(_response.statusCode != 200 && _response.body != null && _response.body is !String) {
      if(_response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _errorResponse.errors[0].message);
      }else if(_response.body.toString().startsWith('{message')) {
        _response = Response(statusCode: _response.statusCode, body: _response.body, statusText: _response.body['message']);
      }
    }else if(_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint('====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}