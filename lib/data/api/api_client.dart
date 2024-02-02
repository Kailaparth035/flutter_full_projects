import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/main_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/helper/route_helper.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../model/response/error_response.dart';

// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class ApiClient {
  ApiClient({required this.appBaseUrl, required this.sharedPreferences}) {
    token = sharedPreferences.getString(AppConstants.token);
    debugPrint('Token: $token');
    updateHeader(token);
  }

  final String appBaseUrl;
  final SharedPreferences sharedPreferences;
  final int timeoutInSeconds = 60;
  String? token;

  var client = http.Client();

  late Map<String, String> _mainHeaders;

  void updateHeader(String? token) {
    _mainHeaders = {'Authorization': token.toString()};
    // _mainHeaders = {
    //   'Authorization': "s7yy4I19gKqIZtGi3rfZKmO8ORBuZv9VmQAeXkfhF4SExloiCq"
    // };
  }

  Future<Response> postData(String uri, Map<String, dynamic> map,
      {Map<String, String>? headers, bool isJson = false}) async {
    try {
      await _checkInternetConnection();
      debugPrint('====> API Call: $uri');
      debugPrint('====> Header: $_mainHeaders');
      debugPrint('====> API Body: $map');
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            body: isJson ? jsonEncode(map) : map,
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      // return Response(statusCode: 1, statusText: e.toString());
      return _catchReturnResponse(e);
    }
  }

  Future<Response> postDataWithList(String uri, List<dynamic> map,
      {Map<String, String>? headers, bool isJson = false}) async {
    try {
      await _checkInternetConnection();
      debugPrint('====> API Call: $uri');
      debugPrint('====> Header: $_mainHeaders');
      debugPrint('====> API Body: $map');

      Map<String, String> header = {"Content-Type": "application/json"};
      header.addAll(_mainHeaders);
      http.Response response = await http
          .post(
            Uri.parse(appBaseUrl + uri),
            body: isJson ? jsonEncode(map) : map,
            headers: headers ?? header,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      // return Response(statusCode: 1, statusText: e.toString());
      return _catchReturnResponse(e);
    }
  }

  _catchReturnResponse(e) {
    if (e is TimeoutException) {
      return const Response(
          statusCode: 1,
          statusText: "The server is offline, please try again later");
    }
    // else if (e is SocketException) {
    //   return const Response(
    //       statusCode: 1,
    //       statusText:
    //           "Bad internet connection or The server is offline, please try again later");
    // }
    else {
      String error = CommonController().getValidErrorMessage(e.toString());
      return Response(statusCode: 1, statusText: error.toString());
    }
  }

  Future<Response> getData(String uri,
      {Map<String, dynamic>? query, Map<String, String>? headers}) async {
    try {
      await _checkInternetConnection();
      debugPrint('====> API Call: $uri');
      debugPrint('====> Header: $_mainHeaders');

      http.Response response = await http
          .get(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      // return Response(statusCode: 1, statusText: e.toString());
      return _catchReturnResponse(e);
    }
  }

  Future<Response> putData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      await _checkInternetConnection();

      debugPrint('====> API Call: $uri');
      debugPrint('====> Header: $_mainHeaders');
      debugPrint('====> API Body: $body');
      http.Response response = await http
          .put(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      // return Response(statusCode: 1, statusText: e.toString());
      return _catchReturnResponse(e);
    }
  }

  Future<Response> patchData(String uri, dynamic body,
      {Map<String, String>? headers}) async {
    try {
      await _checkInternetConnection();
      debugPrint('====> API Call: $uri');
      debugPrint('====> Header: $_mainHeaders');
      debugPrint('====> API Body: $body');

      http.Response response = await http
          .patch(
            Uri.parse(appBaseUrl + uri),
            body: jsonEncode(body),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      // return Response(statusCode: 1, statusText: e.toString());
      return _catchReturnResponse(e);
    }
  }

  Future<Response> deleteData(String uri,
      {Map<String, String>? headers}) async {
    try {
      await _checkInternetConnection();
      debugPrint('====> API Call: $uri');
      debugPrint('====> Header: $_mainHeaders');

      http.Response response = await http
          .delete(
            Uri.parse(appBaseUrl + uri),
            headers: headers ?? _mainHeaders,
          )
          .timeout(Duration(seconds: timeoutInSeconds));
      return handleResponse(response, uri);
    } catch (e) {
      // return Response(statusCode: 1, statusText: e.toString());
      return _catchReturnResponse(e);
    }
  }

  Future<Response> httpPostWithImageUploadMultiple(
      String uri, List<File> imageFileList, Map<String, dynamic> map,
      {required List<String> parameterName,
      Map<String, String>? headers}) async {
    try {
      await _checkInternetConnection();

      debugPrint('====> API Call: $uri');
      debugPrint('====> Header: $_mainHeaders');
      debugPrint('====> API Body: $map');
      debugPrint('====> API File: $imageFileList');
      debugPrint('====> API Filename: $parameterName');
      var request3 = http.MultipartRequest(
        'POST',
        Uri.parse(appBaseUrl + uri),
      );

      // add headers
      request3.headers.addAll(headers ?? _mainHeaders);

      // add multiple images
      if (imageFileList.isNotEmpty) {
        for (int i = 0; i < imageFileList.length; i++) {
          request3.files.add(await http.MultipartFile.fromPath(
              parameterName[i], imageFileList[i].path,
              contentType: _getMimeType1(imageFileList[i].path)));
        }
      }

      // add request parameter
      map.forEach((key, value) {
        request3.fields[key] = value;
      });

      http.StreamedResponse res3 = await request3.send();
      var response = await http.Response.fromStream(
        res3,
      ).timeout(Duration(seconds: timeoutInSeconds));

      return handleResponse(response, uri);
    } catch (e) {
      // return Response(statusCode: 1, statusText: e.toString());
      return _catchReturnResponse(e);
    }
  }

  // multi part request for array upload file
  Future<Response> httpPostWithImageUploadMultipleArray(
      String uri, List<File> imageFileList, Map<String, dynamic> map,
      {required List<String> parameterName,
      Map<String, String>? headers}) async {
    try {
      await _checkInternetConnection();

      debugPrint('====> API Call: $uri');
      debugPrint('====> Header: $_mainHeaders');
      debugPrint('====> API Body: $map');
      debugPrint('====> API File: $imageFileList');
      debugPrint('====> API Filename: $parameterName');
      var request3 = http.MultipartRequest(
        'POST',
        Uri.parse(appBaseUrl + uri),
      );

      // add headers
      request3.headers.addAll(headers ?? _mainHeaders);

      // add multiple images
      if (imageFileList.isNotEmpty) {
        for (int i = 0; i < imageFileList.length; i++) {
          request3.files.add(await http.MultipartFile.fromPath(
              "${parameterName[i]}[]", imageFileList[i].path,
              contentType: _getMimeType1(imageFileList[i].path)));
        }
      }

      // add request parameter
      map.forEach((key, value) {
        request3.fields[key] = value;
      });

      http.StreamedResponse res3 = await request3.send();
      var response = await http.Response.fromStream(
        res3,
      ).timeout(Duration(seconds: timeoutInSeconds));

      return handleResponse(response, uri);
    } catch (e) {
      // return Response(statusCode: 1, statusText: e.toString());
      return _catchReturnResponse(e);
    }
  }

  MediaType _getMimeType1(String file) {
    try {
      String extension = file.split(".").last;
      if (extension.toLowerCase() == "jpg" ||
          extension.toLowerCase() == "jpeg" ||
          extension.toLowerCase() == "png" ||
          extension.toLowerCase() == "gif") {
        return MediaType('image', extension);
      } else {
        return MediaType('video', extension);
      }
    } catch (e) {
      return MediaType('image', 'jpg');
    }
  }

  Response handleResponse(http.Response response, String uri) {
    dynamic body;
    try {
      body = jsonDecode(response.body);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('====> error caught: $e');
      }
    }
    Response bodyResponse = Response(
      body: body ?? response.body,
      bodyString: response.body.toString(),
      request: Request(
          headers: response.request!.headers,
          method: response.request!.method,
          url: response.request!.url),
      headers: response.headers,
      statusCode: response.statusCode,
      statusText: response.reasonPhrase,
    );

    if (bodyResponse.statusCode == 401) {
      _unAuthorizeAction(bodyResponse);
      bodyResponse = Response(
        statusCode: bodyResponse.statusCode,
        statusText: "",
        body: bodyResponse.body,
      );
    }
    if (bodyResponse.statusCode == 500) {
      bodyResponse = Response(
        statusCode: 1,
        statusText: AppString.internalServerError,
        body: bodyResponse.body,
      );
    }

    if (bodyResponse.statusCode == 404) {
      bodyResponse = Response(
        statusCode: 1,
        statusText: "Oops! Page Not Found!",
        body: bodyResponse.body,
      );
    }

    if (bodyResponse.statusCode != 200 &&
        bodyResponse.statusCode != 401 &&
        bodyResponse.body != null &&
        bodyResponse.body is! String) {
      if (bodyResponse.body.toString().contains('errors')) {
        ErrorResponse errorResponse = ErrorResponse.fromJson(bodyResponse.body);
        List<String>? error = errorResponse.errors;
        bodyResponse = Response(
            statusCode: bodyResponse.statusCode,
            body: bodyResponse.body,
            statusText: error![0].toString());
      } else if (bodyResponse.body.toString().contains('message')) {
        bodyResponse = Response(
            statusCode: bodyResponse.statusCode,
            body: bodyResponse.body,
            statusText: bodyResponse.body['message']);
      }
    } else if (bodyResponse.statusCode != 200 &&
        bodyResponse.statusCode != 401 &&
        bodyResponse.body == null) {
      bodyResponse =
          Response(statusCode: 0, statusText: AppString.internalServerError);
    }
    // debugPrint(
    //     '====> API Response: [${bodyResponse.statusCode}] $uri\n${bodyResponse.body}');
    return bodyResponse;
  }

  _unAuthorizeAction(Response<dynamic> bodyResponse) async {
    var profileController = Get.find<ProfileSharedPrefService>();

    if (profileController.isUnauthorized.value == false) {
      try {
        var mainController = Get.find<MainController>();
        mainController.addToStackAndNavigate(AppConstants.todayIndex);
      } catch (e) {
        debugPrint("====> $e");
      }

      profileController.clearSharedData();
      // showCustomSnackBar(bodyResponse.body['message'], isError: true);

      showCustomSnackBar(AppString.unAuthorizedAccess, isError: true);
      profileController.isUnauthorized(true);

      Future.delayed(const Duration(milliseconds: 100), () {
        Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.signIn));
      });
    }
  }

  _checkInternetConnection() async {
    bool isInternetConnected = await InternetConnection().hasInternetAccess;

    if (isInternetConnected == false) {
      await Future.delayed(const Duration(milliseconds: 5));
      isInternetConnected = await InternetConnection().hasInternetAccess;
      if (isInternetConnected == false) {
        throw AppString.noInternetConnection;
      } else {
        return true;
      }
    } else {
      if (isInternetConnected == false) {
        throw AppString.noInternetConnection;
      } else {
        return true;
      }
    }
  }
}
