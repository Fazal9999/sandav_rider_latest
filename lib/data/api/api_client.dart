import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:get/get_connect/http/src/request/request.dart';

import 'package:sandav/data/model/response/address_model.dart';
import 'package:sandav/data/model/response/error_response.dart';
import 'package:sandav/util/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as Http;
import 'package:image/image.dart' as Img;

class ApiClient extends GetxService {
  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  static final String noInternetMessage =
      'Connection to API server failed due to internet connection';
  final int timeoutInSeconds = 30;

  String token;
  Map<String, String> _mainHeaders;

  ApiClient({@required this.appBaseUrl, @required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.TOKEN);
    debugPrint('Token: $token');
    AddressModel _addressModel;
    try {
      String sharedAddress =
          sharedPreferences.getString(AppConstants.USER_ADDRESS);
      if (sharedAddress != null) {
        _addressModel = AddressModel.fromJson(jsonDecode(sharedAddress));
        print(_addressModel.toJson());
      } else {
        print(sharedAddress);
      }
    } catch (e) {
      print("ApiError1 ${e.toString()}");
    }
    updateHeader(
      token,
      _addressModel == null ? null : _addressModel.zoneIds,
      sharedPreferences.getString(AppConstants.LANGUAGE_CODE),
    );
  }

  void updateHeader(String token, List<int> zoneIDs, String languageCode) {
    _mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
      AppConstants.ZONE_ID: zoneIDs != null ? jsonEncode(zoneIDs) : null,
      AppConstants.LOCALIZATION_KEY:
          languageCode ?? AppConstants.languages[0].languageCode,
      'Authorization': 'Bearer $token'
    };
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic> query, Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response _response = await Http.get(
        Uri.parse(appBaseUrl + uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      print("ApiError2 ${e.toString()}");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postData(String uri, dynamic body,
      {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.post(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    }
    catch (e) {
      print("ApiError4 ${e.toString()}");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> postAvailability(String uri, dynamic body,
      {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.post(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      print("ApiError5 ${e.toString()}");
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












  Future<Response> deleteAvailability(String uri, dynamic body,
      {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.post(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      print("ApiError7 ${e.toString()}");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }


  Future<Response> postMultipartData(
      String uri, Map<String, String> body,
      List<MultipartBody> multipartBody,
      List<MultipartBody> licensemultiParts,
      List<MultipartBody> driverLicensemultiParts,
      List<MultipartBody> vehiclemultiParts, List<MultipartBody2> pickedResidenceParts,
      List<MultipartBody2> pickedBankingParts,
      {Map<String, String> headers}) async {
    debugPrint('====> Fazal1: $body with ${pickedResidenceParts.length} files');
    debugPrint('====> Fazal2: $body with ${pickedBankingParts.length} files');
    debugPrint('====> Fazal3: $body with ${multipartBody.length} files');
    debugPrint('====> Fazal3: $body with ${licensemultiParts.length} files');
    try {

      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body with ${multipartBody.length} files');
      debugPrint('====> API Body: $body with ${licensemultiParts.length} files');
      debugPrint('====> API Body: $body with ${driverLicensemultiParts.length} files');
      debugPrint('====> API Body: $body with ${vehiclemultiParts.length} files');
      debugPrint('====> API Body: $body with ${pickedResidenceParts.length} files');
      debugPrint('====> API Body: $body with ${pickedBankingParts.length} files');
      Http.MultipartRequest _request =
          Http.MultipartRequest('POST', Uri.parse(appBaseUrl + uri));
      _request.headers.addAll(headers ?? _mainHeaders);
      for (MultipartBody multipart in multipartBody) {
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
      for (MultipartBody2 multipart in pickedResidenceParts) {
        if (multipart != null) {
          Uint8List _list = await _readFileByte(multipart.file.path);


          _request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readStream,
            _list.length,
            filename: '${DateTime.now().toString()}.pdf',

          ));









        }
      }
      for (MultipartBody2 multipart in pickedBankingParts) {
        if (multipart.file != null) {
          Uint8List _list = await _readFileByte(multipart.file.path);
          _request.files.add(Http.MultipartFile(
            multipart.key,
            multipart.file.readStream,
            _list.length,
            filename: '${DateTime.now().toString()}.pdf',
          ));
        }
      }
      _request.fields.addAll(body);
      Http.Response _response =
          await Http.Response.fromStream(await _request.send());
      return handleResponse(_response, uri);
    } catch (e) {
      print("ApiError8 ${e.toString()}");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      debugPrint('====> API Body: $body');
      Http.Response _response = await Http.put(
        Uri.parse(appBaseUrl + uri),
        body: jsonEncode(body),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      print("ApiError10 ${e.toString()}");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }

  Future<Response> deleteData(String uri, {Map<String, String> headers}) async {
    try {
      debugPrint('====> API Call: $uri\nHeader: $_mainHeaders');
      Http.Response _response = await Http.delete(
        Uri.parse(appBaseUrl + uri),
        headers: headers ?? _mainHeaders,
      ).timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(_response, uri);
    } catch (e) {
      print("ApiError12 ${e.toString()}");
      return Response(statusCode: 1, statusText: noInternetMessage);
    }
  }
  Future<Uint8List> _readFileByte(String filePath) async {
    Uri myUri = Uri.parse(filePath);
    File audioFile = new File.fromUri(myUri);
    Uint8List bytes;
    await audioFile.readAsBytes().then((value) {
      bytes = Uint8List.fromList(value);
      print('reading of bytes is completed');
    }).catchError((onError) {
      print('Exception Error while reading audio from path:' +
          onError.toString());
    });
    return bytes;
  }
  Response handleResponse(Http.Response response, String uri) {
    dynamic _body;
    try {
      _body = jsonDecode(response.body);
    } on FormatException catch(e) {
      e.printError();

    }
    Response _response = Response(
      body: _body != null ? _body : response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request.headers,
          method: response.request.method,
          url: response.request.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );
    if (_response.statusCode != 200 &&
        _response.body != null &&
        _response.body is! String) {
      if (_response.body.toString().startsWith('{errors: [{code:')) {
        ErrorResponse _errorResponse = ErrorResponse.fromJson(_response.body);
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _errorResponse.errors[0].message);
      } else if (_response.body.toString().startsWith('{message')) {
        _response = Response(
            statusCode: _response.statusCode,
            body: _response.body,
            statusText: _response.body['message']);
      }
    } else if (_response.statusCode != 200 && _response.body == null) {
      _response = Response(statusCode: 0, statusText: noInternetMessage);
    }
    debugPrint(
        '====> API Response: [${_response.statusCode}] $uri\n${_response.body}');
    return _response;
  }
}

class MultipartBody {
  String key;
  XFile file;

  MultipartBody(this.key, this.file);
}
class MultipartBody2 {
  String key;
  PlatformFile file;

  MultipartBody2(this.key, this.file);
}
