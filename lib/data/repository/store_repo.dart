import 'package:aspirevue/data/api/api_client.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  StoreRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> getStoreDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getStoreDetailsUri, map);
  }

  Future<Response> getStoreCoachDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getStoreCoachDetailsUri, map);
  }

  Future<Response> getCartDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getCartDetailsUri, map);
  }

  Future<Response> addToCardDetail(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.addToCardDetailUri, map);
  }

  Future<Response> renewProduct(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.renewProductUri, map);
  }

  Future<Response> verifyPromocode(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.verifyPromocodeUri, map);
  }

  Future<Response> getPreCardDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getPreCardDetailsUri, map);
  }

  Future<Response> getPostCardDetails(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.getPostCardDetailsUri, map);
  }

  Future<Response> updateDataInSession(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.updateDataInSessionUri, map);
  }

  Future<Response> makePayment(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.makePaymentUri, map);
  }

  Future<Response> emptyCart(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.emptyCartUri, map);
  }

  Future<Response> applyCampaignPromocode(Map<String, dynamic> map) async {
    return await apiClient.postData(
        AppConstants.applyCampaignPromocodeUri, map);
  }

  Future<Response> referAndEarn(Map<String, dynamic> map) async {
    return await apiClient.postData(AppConstants.referAndEarnUri, map);
  }
}
