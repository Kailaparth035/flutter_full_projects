import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/profile_and_shared_pref_controller.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/common_model.dart';
import '../data/model/response/login_model.dart';
import '../data/model/response/response_model.dart';
import '../data/repository/auth_repo.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  Future<ResponseModel> registration(Map<String, dynamic> map) async {
    Response response = await authRepo.registration(map);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      CommonModel commonResponse = CommonModel.fromJson(response.body);
      responseModel = ResponseModel(true, commonResponse.message);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> login(Map<String, dynamic> map,
      ProfileSharedPrefService profileSharedPrefServiceController) async {
    Response response = await authRepo.login(map);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      LoginModel loginResponse = LoginModel.fromJson(response.body);

      if (loginResponse.data != null) {
        await profileSharedPrefServiceController.setUserData(
            userData: loginResponse.data);
      }
      responseModel = ResponseModel(
        true,
        loginResponse.message,
      );
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> forgotPassword(Map<String, dynamic> map) async {
    Response response = await authRepo.forgotPassword(map);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      CommonModel commonResponse = CommonModel.fromJson(response.body);
      responseModel = ResponseModel(true, commonResponse.message);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> socialLogin(Map<String, dynamic> map,
      ProfileSharedPrefService profileSharedPrefServiceController) async {
    Response response = await authRepo.socialLogin(map);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      LoginModel loginResponse = LoginModel.fromJson(response.body);
      if (loginResponse.data != null) {
        await profileSharedPrefServiceController.setUserData(
            userData: loginResponse.data);
      }
      responseModel = ResponseModel(true, loginResponse.message);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  Future<ResponseModel> logout(Map<String, dynamic> map,
      ProfileSharedPrefService profileSharedPrefServiceController) async {
    Response response = await authRepo.logout(map);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      profileSharedPrefServiceController.clearSharedData();
      CommonModel commonResponse = CommonModel.fromJson(response.body);
      responseModel = ResponseModel(true, commonResponse.message);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    update();
    return responseModel;
  }

  updateSmsConsent(bool isChecked) async {
    Map<String, dynamic> jsonData = {
      "is_sms_consent": isChecked ? "1" : "0",
    };
    try {
      buildLoading(Get.context!);
      Response response = await authRepo.updateSmsConsent(jsonData);
      if (response.statusCode == 200) {
        // showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  deleteAccount() async {
    Map<String, dynamic> jsonData = {};
    try {
      buildLoading(Get.context!);
      Response response = await authRepo.deleteAccount(jsonData);
      if (response.statusCode == 200) {
        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error);
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }
}
