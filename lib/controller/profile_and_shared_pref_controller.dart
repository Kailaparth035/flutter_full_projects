import 'dart:convert';
import 'dart:io';

import 'package:aligned_tooltip/aligned_tooltip.dart';
import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/api/api_client.dart';
import 'package:aspirevue/data/model/response/integration_setting_model.dart';
import 'package:aspirevue/data/model/response/login_model.dart';
import 'package:aspirevue/data/model/response/my_connection_setting_model.dart';
import 'package:aspirevue/data/model/response/notification_setting_model.dart';
import 'package:aspirevue/data/model/response/privacy_setting_model.dart';
import 'package:aspirevue/data/model/response/profile_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/model/response/signature_setting_model.dart';
import 'package:aspirevue/data/repository/main_repo.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSharedPrefService extends GetxController {
  final SharedPreferences sharedPreferences;
  final ApiClient apiClient;
  final MainRepo mainRepo;

  ProfileSharedPrefService(
      {required this.sharedPreferences,
      required this.apiClient,
      required this.mainRepo});

  Rx<LoginData> loginData = LoginData().obs;
  Rx<ProfileData> profileData = ProfileData().obs;

  RxString profileImage = "".obs;
  setProfileImage(String url) {
    profileImage.value = url;
  }

  RxBool isUnauthorized = false.obs;

  Future<void> setUserData({required LoginData? userData}) async {
    setIsLogin();
    isUnauthorized(false);
    sharedPreferences.setString('UserData', jsonEncode(userData));
    sharedPreferences.setString(AppConstants.token, jsonEncode(userData));
    apiClient.token = userData!.apiKey.toString();
    apiClient.updateHeader(userData.apiKey.toString());
    setProfileImage(userData.sampleProfilePicture.toString());
    if (isFromNotification.value == false) {
      isShowOverlayView.value = userData.isShowTourOverlay!;
    }
    isShowWelcomeScreen.value = userData.appWelcomeScreenShow == 1;
    isShowTrailScreen.value = userData.showTrailScreen == 1;

    loginData(userData);
  }

// ----------------- for overlay ------------------

  RxBool isShowOverlayView = false.obs;
  RxBool isFromNotification = false.obs;

  RxBool isShowWelcomeScreen = false.obs;
  RxBool isShowTrailScreen = false.obs;

  final profileOverLayController = AlignedTooltipController();
  final notificationOverLayController = AlignedTooltipController();
  final getStartVideoOverLayController = AlignedTooltipController();
  final quickLinkOverLayController = AlignedTooltipController();
  final goalOverLayController = AlignedTooltipController();

  final insightStreamOverLayController = AlignedTooltipController();
  final actionItemOverLayController = AlignedTooltipController();

  final forumPullOverLayController = AlignedTooltipController();
  final gloabalOverLayController = AlignedTooltipController();

  final connectionOverLayController = AlignedTooltipController();
  final personalGrowthOverLayController = AlignedTooltipController();

  final storeOverLayController = AlignedTooltipController();
  final discoverOverLayController = AlignedTooltipController();
  final menuOverLayController = AlignedTooltipController();
  final startUpMenuOverLayController = AlignedTooltipController();

  var appbarGlobalKey = GlobalKey(debugLabel: "appbarGlobalKey");
  var videoANDQUickLinkGlobalKey =
      GlobalKey(debugLabel: "videoANDQUickLinkGlobalKey");
  var insightGlobalKey = GlobalKey(debugLabel: "insightGlobalKey");
  var actionItemGlobalKey = GlobalKey(debugLabel: "actionItemGlobalKey");
  var forumPollGlobalKey = GlobalKey(debugLabel: "forumPollGlobalKey");

  showOverLay(int index) {
    if (index == AppConstants.profileOverLayIndex) {
      Scrollable.ensureVisible(
        appbarGlobalKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        profileOverLayController.showTooltip(
          immediately: false,
        );
      });
    }
    if (index == AppConstants.notificationOverLayIndex) {
      Scrollable.ensureVisible(
        appbarGlobalKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        notificationOverLayController.showTooltip(immediately: false);
      });
    }
    if (index == AppConstants.getStartVideoOverLayIndex) {
      Scrollable.ensureVisible(
        videoANDQUickLinkGlobalKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        getStartVideoOverLayController.showTooltip(immediately: false);
      });
    }
    if (index == AppConstants.quickLinkOverLayIndex) {
      Scrollable.ensureVisible(
        videoANDQUickLinkGlobalKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        quickLinkOverLayController.showTooltip(immediately: false);
      });
    }
    if (index == AppConstants.insightStreamOverLayIndex) {
      Scrollable.ensureVisible(
        insightGlobalKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        insightStreamOverLayController.showTooltip(immediately: false);
      });
    }
    if (index == AppConstants.actionItemOverLayIndex) {
      Scrollable.ensureVisible(
        actionItemGlobalKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        actionItemOverLayController.showTooltip(immediately: false);
      });
    }
    if (index == AppConstants.forumPullOverLayIndex) {
      Scrollable.ensureVisible(
        forumPollGlobalKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        forumPullOverLayController.showTooltip(immediately: false);
      });
    }
    if (index == AppConstants.gloabalSearchOverLayIndex) {
      Scrollable.ensureVisible(
        videoANDQUickLinkGlobalKey.currentContext!,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
      );
      Future.delayed(const Duration(milliseconds: 300), () {
        gloabalOverLayController.showTooltip(immediately: false);
      });
    }

    // bottom
    if (index == AppConstants.connectionOverLayIndex) {
      connectionOverLayController.showTooltip(immediately: false);
    }
    if (index == AppConstants.personalGrowthOverLayIndex) {
      personalGrowthOverLayController.showTooltip(immediately: false);
    }
    if (index == AppConstants.goalOverLayIndex) {
      goalOverLayController.showTooltip(immediately: false);
    }
    if (index == AppConstants.storeOverLayIndex) {
      storeOverLayController.showTooltip(immediately: false);
    }
    if (index == AppConstants.discoverOverLayIndex) {
      discoverOverLayController.showTooltip(immediately: false);
    }
    if (index == AppConstants.menuOverLayIndex) {
      menuOverLayController.showTooltip(immediately: false);
    }
    if (index == AppConstants.startUpMenuOverLayIndex) {
      startUpMenuOverLayController.showTooltip(immediately: false);
    }
  }

  closeOverLay(int index) {
    if (index == AppConstants.profileOverLayIndex) {
      profileOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.notificationOverLayIndex) {
      notificationOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.getStartVideoOverLayIndex) {
      getStartVideoOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.quickLinkOverLayIndex) {
      quickLinkOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.insightStreamOverLayIndex) {
      insightStreamOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.actionItemOverLayIndex) {
      actionItemOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.forumPullOverLayIndex) {
      forumPullOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.gloabalSearchOverLayIndex) {
      gloabalOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.connectionOverLayIndex) {
      connectionOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.personalGrowthOverLayIndex) {
      personalGrowthOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.goalOverLayIndex) {
      goalOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.storeOverLayIndex) {
      storeOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.discoverOverLayIndex) {
      discoverOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.menuOverLayIndex) {
      menuOverLayController.hideTooltip(immediately: false);
    }
    if (index == AppConstants.startUpMenuOverLayIndex) {
      startUpMenuOverLayController.hideTooltip(immediately: false);
    }
  }

// ----------------- dynamic link variables ------------------
  RxString referralCodeFromLink = "".obs;

  setIsShowRegisterScreen(bool isShow) {
    sharedPreferences.setBool('isShowRegisterScreen', isShow);
  }

  getIsShowRegisterScreen() {
    return sharedPreferences.getBool("isShowRegisterScreen");
  }

// ----------------- for overlay ------------------

  getUserData() async {
    var temp = sharedPreferences.getString("UserData");
    var dataToRetun = LoginData.fromJson(jsonDecode(temp.toString()));
    loginData(dataToRetun);
    apiClient.token = dataToRetun.apiKey.toString();
    apiClient.updateHeader(dataToRetun.apiKey.toString());
  }

  setAppleUserKey(
    String firstName,
    String lastName,
    String email,
    String appleIdentifier,
  ) {
    sharedPreferences.setString('appleUserKeyFirstName', firstName);
    sharedPreferences.setString('appleUserKeyLastName', lastName);
    sharedPreferences.setString('appleUserKeyEmail', email);
    sharedPreferences.setString('appleUserKeyAppleIdentifier', appleIdentifier);
  }

  getAppleUserKeyFirstName() {
    return sharedPreferences.getString("appleUserKeyFirstName");
  }

  getAppleUserKeyLastName() {
    return sharedPreferences.getString("appleUserKeyLastName");
  }

  getAppleUserKeyEmail() {
    return sharedPreferences.getString("appleUserKeyEmail");
  }

  getAppleUserKeyAppleIdentifier() {
    return sharedPreferences.getString("appleUserKeyAppleIdentifier");
  }

  setIsLogin() async {
    await sharedPreferences.setBool(AppConstants.isLogin, true);
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.isLogin);
  }

  setOnboarding() async {
    await sharedPreferences.setBool(AppConstants.isOnBoadring, true);
  }

  bool isShowOnBoarding() {
    return sharedPreferences.containsKey(AppConstants.isOnBoadring);
  }

  Future<void> setToken({required String? token}) async {
    sharedPreferences.setString(AppConstants.token, token.toString());
    apiClient.token = token.toString();
    apiClient.updateHeader(token.toString());
  }

  Future<void> setUserNamePassword(
      {required String? username, required String? password}) async {
    sharedPreferences.setString(AppConstants.useName, username.toString());
    sharedPreferences.setString(AppConstants.passWord, password.toString());
  }

  String? getUsernameAndPassword() {
    String? username = sharedPreferences.getString(
      AppConstants.useName,
    );
    String? password = sharedPreferences.getString(AppConstants.passWord);

    if (username != null && password != null) {
      return "$username&&&$password";
    } else {
      return null;
    }
  }

  bool clearSharedData() {
    sharedPreferences.remove("UserData");
    sharedPreferences.remove(AppConstants.isLogin);
    sharedPreferences.remove(AppConstants.token);
    apiClient.token = null;
    return true;
  }

  // get Profile Data

  bool _isLoading = false;
  bool _isError = false;
  String _errorMsg = "";

  // get local properties
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMsg => _errorMsg;

  Future<void> getMyProfile(Map<String, dynamic> map, {isShowLoading}) async {
    _isLoading = true;
    update();

    try {
      Response response = await mainRepo.getMyProfile(map);
      if (response.statusCode == 200) {
        _isLoading = false;

        ProfileModel data = ProfileModel.fromJson(response.body);
        profileData(data.data);
        if (isFromNotification.value == false) {
          isShowOverlayView.value = data.data!.isShowTourOverlay ?? false;
        }

        _isError = false;
        _errorMsg = "";
      } else {
        if (response.statusCode == 401) {
          throw AppString.unAuthorizedAccess;
        } else {
          _isError = true;
          _errorMsg = response.statusText.toString();
          showCustomSnackBar(_errorMsg);
          _isLoading = false;
        }
      }
    } catch (e) {
      if (e == AppString.unAuthorizedAccess) {
        rethrow;
      } else {
        _isError = true;
        _isLoading = false;

        String error = CommonController().getValidErrorMessage(e.toString());
        _errorMsg = error.toString();
        showCustomSnackBar(_errorMsg);
      }
    } finally {
      _isLoading = false;
    }
    update();
  }

  // update profile
  Future<ResponseModel> updatePersonalInfo(Map<String, dynamic> map) async {
    ResponseModel responseModel;
    Response response = await mainRepo.updatePersonalInfo(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // change password
  Future<ResponseModel> changePassword(Map<String, dynamic> map) async {
    ResponseModel responseModel;
    Response response = await mainRepo.changePassword(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // getNotificationSettings
  Future<NotificationSettingData> getNotificationSettings(
      Map<String, dynamic> map) async {
    Response response = await mainRepo.getNotificationSettings(map);

    if (response.statusCode == 200) {
      NotificationSettingModel data =
          NotificationSettingModel.fromJson(response.body);
      return data.data!;
    } else {
      throw response.statusText.toString();
    }
  }

  // update notification date
  Future<ResponseModel> updateNotificationSettings(
      Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.updateNotificationSettings(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // getPrivacySettings
  Future<PrivacySettingData> getPrivacySettings(
      Map<String, dynamic> map) async {
    Response response = await mainRepo.getPrivacySettings(map);

    if (response.statusCode == 200) {
      PrivacySettingModel data = PrivacySettingModel.fromJson(response.body);
      return data.data!;
    } else {
      throw response.statusText.toString();
    }
  }

  // zupdate Privacy date
  Future<ResponseModel> updatePrivacySettings(
      Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.updatePrivacySettings(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // upload Profile Picture
  Future<ResponseModel> uploadProfilePicture(File imageCache) async {
    ResponseModel responseModel;
    Response response = await mainRepo.uploadProfilePicture(imageCache);

    if (response.statusCode == 200) {
      responseModel =
          ResponseModel(true, response.body['message'], responseT: response);
      await getMyProfile({});
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

// upload Profile Picture
  Future<ResponseModel> uploadProfileCover(File imageCache) async {
    ResponseModel responseModel;
    Response response = await mainRepo.uploadCoverPicture(imageCache);

    if (response.statusCode == 200) {
      responseModel =
          ResponseModel(true, response.body['message'], responseT: response);
      await getMyProfile({});
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // ===================   my connection setting =======================

  bool _isLoadingGetConnectionSettings = false;
  bool get isLoadingGetConnectionSettings => _isLoadingGetConnectionSettings;
  Future<MyConnectionSettingData> getConnectionSettings(
      Map<String, dynamic> map) async {
    try {
      _isLoadingGetConnectionSettings = true;
      Response response = await mainRepo.getConnectionSettings(map);

      if (response.statusCode == 200) {
        MyConnectionSettingModel data =
            MyConnectionSettingModel.fromJson(response.body);
        if (data.data != null) {
          return data.data!;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error.toString();
    } finally {
      _isLoadingGetConnectionSettings = false;
      update();
    }
  }

  Future<ResponseModel> updateConnectionSettings(
      Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.updateConnectionSettings(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> deleteReceiveFeedbackUser(
      Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.deleteReceiveFeedbackUser(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }
  // ===================   signature setting =======================

  bool _isLoadingGetSignatureSettings = false;
  bool get isLoadingGetSignatureSettings => _isLoadingGetSignatureSettings;
  Future<SignatureSettingData> getSignatureSetting(
      Map<String, dynamic> map) async {
    try {
      _isLoadingGetConnectionSettings = true;
      Response response = await mainRepo.getSignature(map);

      if (response.statusCode == 200) {
        SignatureSettingModel data =
            SignatureSettingModel.fromJson(response.body);
        if (data.data != null) {
          return data.data!;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error.toString();
    } finally {
      _isLoadingGetSignatureSettings = false;
      update();
    }
  }

  Future<ResponseModel> updateSignature(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.updateSignature(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // ===================   integration setting =======================

  bool _isLoadingGetIntegrationSettings = false;
  bool get isLoadingGetIntegrationSettings => _isLoadingGetIntegrationSettings;
  Future<IntegrationSettingData> getIntegrationSetting(
      Map<String, dynamic> map) async {
    try {
      _isLoadingGetConnectionSettings = true;
      Response response = await mainRepo.getIntegrationData(map);

      if (response.statusCode == 200) {
        IntegrationSettingModel data =
            IntegrationSettingModel.fromJson(response.body);
        if (data.data != null) {
          return data.data!;
        } else {
          throw AppString.somethingWentWrong;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error.toString();
    } finally {
      _isLoadingGetIntegrationSettings = false;
      update();
    }
  }

  Future<ResponseModel> updateIntegration(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.updateIntegrationData(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }
}
