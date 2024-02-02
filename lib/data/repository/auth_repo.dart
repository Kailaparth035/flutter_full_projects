import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> registration(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.registerUri, map);
  }

  Future<Response> login(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.loginUri, map);
  }

  Future<Response> forgotPassword(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.forgotPasswordUri, map);
  }

  Future<Response> socialLogin(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.socialLoginUri, map);
  }

  Future<Response> logout(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.logoutUri, map);
  }

  Future<Response> deleteAccount(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.deleteAccountUri, map);
  }

  Future<Response> updateSmsConsent(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateSmsConsentUri, map);
  }
}
