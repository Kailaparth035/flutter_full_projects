import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/response/store/cart_details_model.dart';
import 'package:aspirevue/data/model/response/store/offers_list_model.dart';
import 'package:aspirevue/data/model/response/store/refer_and_earn_model.dart';
import 'package:aspirevue/data/model/response/store/store_detail_model.dart';
import 'package:aspirevue/data/model/response/store/store_user_details.model.dart';
import 'package:aspirevue/data/repository/store_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final StoreRepo storeRepo;

  StoreController({required this.storeRepo});

  bool _isLoadingStore = false;
  bool _isErrorStore = false;
  String _errorMsgStore = "";
  StoreDetailData? _storeData;

  bool get isLoadingStore => _isLoadingStore;
  bool get isErrorStore => _isErrorStore;
  String get errorMsgStore => _errorMsgStore;
  StoreDetailData? get storeData => _storeData;

  Future<void> getStoreDetails(bool isShowLoading) async {
    if (isShowLoading) {
      _isLoadingStore = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    try {
      Response response = await storeRepo.getStoreDetails({});
      if (response.statusCode == 200) {
        StoreDetailsModel data = StoreDetailsModel.fromJson(response.body);
        _storeData = data.data!;
        _updateStore(false, "");
      } else {
        _updateStore(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateStore(true, error);
    } finally {
      if (isShowLoading) {
        _isLoadingStore = false;
      }
      update();
    }
  }

  _updateStore(bool isError, String error) {
    if (isError) {
      _errorMsgStore = error;
    } else {
      _errorMsgStore = "";
    }
    _isErrorStore = isError;
    update();
  }

  // ================================================================================

  final TextEditingController _sessionTextController = TextEditingController();
  bool _isLoadingStoreUser = false;
  bool _isErrorStoreUser = false;
  String _errorMsgStoreUser = "";
  StoreUserDetailData? _storeUserData;

  bool get isLoadingStoreUser => _isLoadingStoreUser;
  bool get isErrorStoreUser => _isErrorStoreUser;
  String get errorMsgStoreUser => _errorMsgStoreUser;
  StoreUserDetailData? get storeUserData => _storeUserData;
  TextEditingController get sessionTextController => _sessionTextController;

  final TextEditingController _promoCodeTextController =
      TextEditingController();
  TextEditingController get promoCodeTextController => _promoCodeTextController;

  bool _isVerifiedPromoCode = false;
  bool get isVerifiedPromoCode => _isVerifiedPromoCode;

  updateVerifyStatus(bool value) {
    _isVerifiedPromoCode = value;
    update();
  }

  Future<void> getStoreUserDetails(String coachId, bool isShowLoading) async {
    if (isShowLoading) {
      _isLoadingStoreUser = true;
      // update();
    }

    try {
      Response response =
          await storeRepo.getStoreCoachDetails({"coach_id": coachId});
      if (response.statusCode == 200) {
        StoreUserDetailsModel res =
            StoreUserDetailsModel.fromJson(response.body);
        _storeUserData = res.data!;

        sessionTextController.text = res.data!.sessionValue.toString();
        promoCodeTextController.text = res.data!.promocode.toString();
        if (res.data!.promoVerify.toString() == "1") {
          updateVerifyStatus(true);
        } else {
          updateVerifyStatus(false);
        }

        updateStoreUser(false, "");
      } else {
        updateStoreUser(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      updateStoreUser(true, error);
    } finally {
      if (isShowLoading) {
        _isLoadingStoreUser = false;
      }
      update();
    }
  }

  Future<StoreUserDetailData> getCoachDetailsForOffer(coachId) async {
    try {
      Response response =
          await storeRepo.getStoreCoachDetails({"coach_id": coachId});
      if (response.statusCode == 200) {
        StoreUserDetailsModel res =
            StoreUserDetailsModel.fromJson(response.body);

        return res.data!;
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error;
    }
  }

  updateStoreUser(bool isError, String error) {
    if (isError) {
      _errorMsgStoreUser = error;
    } else {
      _errorMsgStoreUser = "";
    }
    _isErrorStoreUser = isError;
    update();
  }

  // ===========================================================================

  bool _isLoadingCart = false;
  bool _isErrorCart = false;
  String _errorMsgCart = "";
  CartDetailData? _cartData;

  bool get isLoadingCart => _isLoadingCart;
  bool get isErrorCart => _isErrorCart;
  String get errorMsgCart => _errorMsgCart;
  CartDetailData? get cartData => _cartData;
  Future<bool?> getCartDetailsUri(bool isShowLoading, String type) async {
    if (isShowLoading) {
      _isLoadingCart = true;
      // update();
    }
    Map<String, dynamic> map = {"page_type": type};
    // store,make_payment

    try {
      Response response = await storeRepo.getCartDetails(map);
      if (response.statusCode == 200) {
        CartDetailsModel res = CartDetailsModel.fromJson(response.body);
        _cartData = res.data!;
        updateCart(false, "");
        return true;
      } else {
        updateCart(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      updateCart(true, error);
    } finally {
      if (isShowLoading) {
        _isLoadingCart = false;
      }
      update();
    }
    return null;
  }

  updateCart(bool isError, String error) {
    if (isError) {
      _errorMsgCart = error;
      showCustomSnackBar(error);
    } else {
      _errorMsgCart = "";
    }
    _isErrorCart = isError;

    update();
  }

  addToCardDetail(
      {required String productId,
      required String type,
      required String price,
      required String isChecked,
      required String productType,
      required String session,
      required String promoCode,
      required String promoVerify,
      required String feedbackHours,
      required String coachId,
      required bool isShowSucessMessage,
      required Future Function(bool) onReload,
      bool? isLoadStoreDetails = true,
      bool? isShowLoading = true,
      String? pageType}) async {
    Map<String, dynamic> jsonData = {
      "productId": productId,
      "type": type,
      "price": price,
      "is_checked": isChecked,
      "product_type": productType,
      "session": session,
      "promocode": promoCode,
      "promo_verify": promoVerify,
      "feedback_hours": feedbackHours,
      "coach_id": coachId,
      "pageType": pageType ?? ""
    };
    try {
      if (isShowLoading == true) {
        buildLoading(Get.context!);
      }
      Response response = await storeRepo.addToCardDetail(jsonData);

      if (response.statusCode == 200) {
        if (isLoadStoreDetails == true) {
          await getStoreDetails(false);
        }

        await onReload(false);
        if (isShowSucessMessage) {
          showCustomSnackBar(response.body['message'], isError: false);
        }

        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (isShowLoading == true) {
        Navigator.pop(Get.context!);
      }
    }
  }

  Future<bool?> applyCampaignPromocode(
      {required bool isShowSucessMessage,
      required Future Function(bool) onReload,
      required String promoVal,
      bool? isLoadStoreDetails = true,
      bool? isShowLoading = true,
      String? pageType}) async {
    Map<String, dynamic> jsonData = {
      "promoVal": promoVal,
    };
    try {
      if (isShowLoading == true) {
        buildLoading(Get.context!);
      }
      Response response = await storeRepo.applyCampaignPromocode(jsonData);

      if (response.statusCode == 200) {
        await onReload(false);
        if (isShowSucessMessage) {
          showCustomSnackBar(response.body['message'], isError: false);
        }
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (isShowLoading == true) {
        Navigator.pop(Get.context!);
      }
    }
    return null;
  }

  renewProduct({
    required String productId,
    required String autoRenewChecked,
    required Future Function(bool) onReaload,
  }) async {
    Map<String, dynamic> jsonData = {
      "auto_renew_checked": autoRenewChecked,
      "product_id": productId,
    };
    try {
      buildLoading(Get.context!);
      Response response = await storeRepo.renewProduct(jsonData);

      if (response.statusCode == 200) {
        await getStoreDetails(false);
        await onReaload(false);

        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  verifyPromocode({
    required String coachId,
    required String promoCode,
    required Future Function(bool) onReaload,
    required String productId,
    required String type,
    required String isChecked,
    required String productType,
    required String session,
    required String feedbackHours,
  }) async {
    Map<String, dynamic> jsonData = {
      "coach_id": coachId,
      "promocode": promoCode,
    };
    try {
      buildLoading(Get.context!);
      Response response = await storeRepo.verifyPromocode(jsonData);

      if (response.statusCode == 200) {
        var price = response.body['data']['price'];
        if (price != null) {
          await addToCardDetail(
            productId: productId,
            type: type,
            price: price.toString(),
            isChecked: isChecked,
            productType: productType,
            session: session,
            promoCode: promoCode,
            promoVerify: "1",
            feedbackHours: feedbackHours,
            coachId: coachId,
            onReload: (val) async {},
            isShowLoading: false,
            isShowSucessMessage: true,
          );
          await getStoreUserDetails(coachId, false);
          showCustomSnackBar(response.body['message'], isError: false);
        }

        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
  }

  // --------------------  Offers Perameters --------------------
  bool _isLoadingStoreOffers = false;
  bool _isErrorStoreOffers = false;
  String _errorMsgStoreOffers = "";
  List<OfferData> _storeOffersData = [];

  bool get isLoadingStoreOffers => _isLoadingStoreOffers;
  bool get isErrorStoreOffers => _isErrorStoreOffers;
  String get errorMsgStoreOffers => _errorMsgStoreOffers;
  List<OfferData> get storeOffersData => _storeOffersData;

  Future<void> getOffers(bool isShowLoading, bool isPreCart) async {
    if (isShowLoading) {
      _isLoadingStoreOffers = true;
      try {
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }
    }

    try {
      Response response;
      if (isPreCart) {
        response = await storeRepo.getPreCardDetails({});
      } else {
        response = await storeRepo.getPostCardDetails({});
      }
      if (response.statusCode == 200) {
        OfferListModel objectiveNoteList =
            OfferListModel.fromJson(response.body);
        if (objectiveNoteList.data != null) {
          _storeOffersData = objectiveNoteList.data!;
          _updateOffers(false, "");
        } else {
          _updateOffers(true, AppString.somethingWentWrong);
        }
      } else {
        _updateOffers(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateOffers(true, error);
    } finally {
      if (isShowLoading) {
        _isLoadingStoreOffers = false;
      }
      update();
    }
  }

  _updateOffers(bool isError, String error) {
    if (isError) {
      _errorMsgStoreOffers = error;
    } else {
      _errorMsgStoreOffers = "";
    }
    _isErrorStoreOffers = isError;
    update();
  }

  //

  updateDataInSession({
    required String type,
    required String value,
    required String userId,
    required String productId,
    required Future Function(bool) onReload,
    int? cartID,
    String? discPrice,
    bool? isShowLoading = true,
  }) async {
    Map<String, dynamic> jsonData = {
      "type": type,
      "value": value,
      "user_id": userId,
      "productId": productId
    };

    if (cartID != null) {
      jsonData['cartId'] = cartID.toString();
    }
    if (discPrice != null) {
      jsonData['discPrice'] = discPrice;
    }

    try {
      if (isShowLoading == true) {
        buildLoading(Get.context!);
      }
      Response response = await storeRepo.updateDataInSession(jsonData);

      if (response.statusCode == 200) {
        await onReload(false);
        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (isShowLoading == true) {
        Navigator.pop(Get.context!);
      }
    }
  }

  Future<bool?> makePayment({
    required String paymentMethod,
    required Future Function(bool) onReload,
    bool? isShowLoading = true,
  }) async {
    Map<String, dynamic> jsonData = {
      "payment_type": paymentMethod,
    };
    try {
      if (isShowLoading == true) {
        buildLoading(Get.context!);
      }
      Response response = await storeRepo.makePayment(jsonData);

      if (response.statusCode == 200) {
        await onReload(false);

        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (isShowLoading == true) {
        Navigator.pop(Get.context!);
      }
    }
    return null;
  }

  Future<bool?> emptyCart({
    bool? isShowLoading = true,
  }) async {
    Map<String, dynamic> jsonData = {};
    try {
      if (isShowLoading == true) {
        buildLoading(Get.context!);
      }
      Response response = await storeRepo.emptyCart(jsonData);

      if (response.statusCode == 200) {
        await getCartDetailsUri(false, "store");
        await getStoreDetails(true);
        showCustomSnackBar(response.body['message'], isError: false);
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {
      if (isShowLoading == true) {
        Navigator.pop(Get.context!);
      }
    }
    return null;
  }

  // =========================== Refer and Earn =================================

  bool _isLoadingReferAndEarn = false;
  bool _isErrorReferAndEarn = false;
  String _errorMsgReferAndEarn = "";
  ReferAndEarnData? _referAndEarnData;

  bool get isLoadingReferAndEarn => _isLoadingReferAndEarn;
  bool get isErrorReferAndEarn => _isErrorReferAndEarn;
  String get errorMsgReferAndEarn => _errorMsgReferAndEarn;
  ReferAndEarnData? get referAndEarnData => _referAndEarnData;

  Future<void> referAndEarn(bool isShowLoading) async {
    if (isShowLoading) {
      _isLoadingReferAndEarn = true;
      update();
    }

    try {
      Response response = await storeRepo.referAndEarn({});
      if (response.statusCode == 200) {
        ReferAndEarnModel data = ReferAndEarnModel.fromJson(response.body);
        _referAndEarnData = data.data!;
        _updateReferAndEarn(false, "");
      } else {
        _updateReferAndEarn(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateReferAndEarn(true, error);
    } finally {
      if (isShowLoading) {
        _isLoadingReferAndEarn = false;
      }
      update();
    }
  }

  _updateReferAndEarn(bool isError, String error) {
    if (isError) {
      _errorMsgReferAndEarn = error;
    } else {
      _errorMsgReferAndEarn = "";
    }
    _isErrorReferAndEarn = isError;
    update();
  }
}
