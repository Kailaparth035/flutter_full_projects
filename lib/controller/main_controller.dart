import 'dart:io';

import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/dashboard_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/controller/insight_stream_controller.dart';
import 'package:aspirevue/data/model/common_data_model.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/common_model.dart';
import 'package:aspirevue/data/model/response/country_model.dart';
import 'package:aspirevue/data/model/response/hashtag_list_model.dart';
import 'package:aspirevue/data/model/response/notification_list_model.dart';
import 'package:aspirevue/data/model/response/state_and_timezone_model.dart';
import 'package:aspirevue/data/model/response/workplace_menu_list_model.dart';
import 'package:aspirevue/util/app_constants.dart';
import 'package:aspirevue/util/permission_utils.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../data/repository/main_repo.dart';
import '../view/base/custom_snackbar.dart';

class MainController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final MainRepo mainRepo;

  MainController({required this.mainRepo});

  // ================ bottom sheet manage ===============
  RxInt currentBottomSheetIndex = 0.obs;

  late Rx<TabController> tabController =
      TabController(vsync: this, length: 4).obs;

  RxList<int> indexList = <int>[].obs;

  final commonData = Rxn<CommonData>();
  RxInt notificationCount = 0.obs;

  RxList<DropDownOptionItemMenu> optionList = <DropDownOptionItemMenu>[].obs;
  Rx<DropDownOptionItemMenu> optionValue =
      DropDownOptionItemMenu(id: "", title: AppString.select).obs;

  final _dashboardcontroller = Get.find<DashboardController>();
  final _developmentController = Get.find<DevelopmentController>();
  final _insightStreamController = Get.find<InsightStreamController>();

  initController() async {
    try {
      await Future.wait([
        getCommonData(),
        _dashboardcontroller.getAssignedTests({}),
        _dashboardcontroller
            .getDashboardVideoQuickLinkDetails({}, isShowLoading: true),
        _developmentController.existdevelopmentMenu(),
      ]);

      await Future.wait([
        _insightStreamController.getInsightFeed(true),
        _dashboardcontroller.getActionItems({})
      ]);

      await Future.wait([
        _dashboardcontroller.getHabitJournalBulletsDetail(true, true),
        _dashboardcontroller.getForumPollQuestionAnswer({}),
      ]);

      await Future.wait([
        getMyworkplaceMenuList(),
        getAllCountries(),
      ]);
    } catch (e) {
      debugPrint("====> main load workplace =========> $e");
    }
  }

  disposeController() {}

  addToStackAndNavigate(int screenNo) {
    if (screenNo != currentBottomSheetIndex.value) {
      try {
        indexList.add(screenNo);
        currentBottomSheetIndex.value = screenNo;
        update();
        debugPrint("====> ${currentBottomSheetIndex.value}");
      } catch (e) {
        debugPrint("====> $e");
      }
    }
  }

  remoteToStackAndNavigateBack(bool isFromMainScreen) {
    if (indexList.isNotEmpty) {
      indexList.removeLast();
    }

    if (indexList.isEmpty) {
      indexList.add(0);
    }

    try {
      currentBottomSheetIndex(indexList.last);
      update();
    } catch (e) {
      debugPrint("====> $e");
    }
  }

  // ================= work place ============
  bool isLoadingworkplaceData = false;
  bool isErrorworkplaceData = false;
  String errorMessageworkplaceData = "";
  WorkplaceMenuData? workplaceData;

  Future<void> getMyworkplaceMenuList() async {
    Map<String, dynamic> map = {};
    isLoadingworkplaceData = true;
    try {
      update();
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    }

    try {
      Response response = await mainRepo.getMyworkplaceMenuList(map);
      if (response.statusCode == 200) {
        WorkplaceMenuListModel workplaceMenuListModel =
            WorkplaceMenuListModel.fromJson(response.body);

        workplaceData = workplaceMenuListModel.data;

        isErrorworkplaceData = false;
        errorMessageworkplaceData = "";
      } else if (response.statusCode == 401) {
        throw AppString.unAuthorizedAccess;
      } else {
        showCustomSnackBar(response.statusText);
        isErrorworkplaceData = true;
        errorMessageworkplaceData = response.statusText.toString();
      }
    } catch (e) {
      isErrorworkplaceData = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      errorMessageworkplaceData = error;
    } finally {
      isLoadingworkplaceData = false;
    }

    update();
  }

  // ================= work place ============
  List<CountryData> _countryList = [];
  List<CountryData> get countryList => _countryList;

  Future<void> getAllCountries() async {
    Map<String, dynamic> map = {};
    Response response = await mainRepo.getAllCountries(map);
    if (response.statusCode == 200) {
      CountryModel daata = CountryModel.fromJson(response.body);
      _countryList = daata.data!;
    } else {
      showCustomSnackBar(response.statusText);
    }
    update();
  }

  Future<StateAndTimeZoneData> getStateTimeZoneList(String countryId) async {
    Map<String, dynamic> map = {"country_sortname": countryId};
    Response response = await mainRepo.getStateTimeZoneList(map);
    if (response.statusCode == 200) {
      StateAndTimeZoneModel daata =
          StateAndTimeZoneModel.fromJson(response.body);
      return daata.data!;
    } else {
      throw response.statusText.toString();
    }
  }

  // Permission management
  bool isLoadingPermission = false;
  final List<PermissionModel> permissionList = [
    PermissionModel(
        permission: Permission.photos, isGranted: false, name: "Photos"),
    PermissionModel(
        permission: Permission.videos, isGranted: false, name: "videos"),
    PermissionModel(
        permission: Permission.notification,
        isGranted: false,
        name: "notification"),
    PermissionModel(
        permission: Permission.contacts, isGranted: false, name: "contacts"),
  ];

  getPermissionStatus() async {
    isLoadingPermission = true;
    for (var item in permissionList) {
      PermissionStatus value = await item.permission.status;

      var modelNew = PermissionModel(
          permission: item.permission,
          isGranted: value.isGranted,
          name: item.name);
      int index = permissionList.indexOf(item);
      permissionList[index] = modelNew;
    }
    isLoadingPermission = false;
    update();
  }

  requestPermission(PermissionModel permissionModel) async {
    bool res = await PermissionUtils.takePermission(permissionModel.permission);
    if (res) {
      var modelNew = PermissionModel(
          permission: permissionModel.permission,
          isGranted: true,
          name: permissionModel.name);
      int index = permissionList.indexOf(permissionModel);
      permissionList[index] = modelNew;
      update();
    }
  }

  Future<bool?> saveSupportData(
      {required String id, required String message}) async {
    try {
      buildLoading(Get.context!);
      Map<String, dynamic> jsonData = {"id": id, "message": message};
      Response response = await mainRepo.saveSupportData(jsonData);

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
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  // ================= get Hashtag list ============

  bool isLoadingHashtag = false;
  bool isErrorHashtag = false;
  String errorMessageHashtag = "";
  List<HashtagData>? hashtagList;

  checkHashTagList(String id, bool isChecked) {
    var item = hashtagList!
        .where((element) => element.id.toString() == id.toString())
        .first;
    int index = hashtagList!.indexOf(item);
    hashtagList![index].isChecked = isChecked;
    update();
  }

  Future<void> getWelcomeHashtags() async {
    Map<String, dynamic> map = {};
    isLoadingHashtag = true;
    try {
      update();
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      Response response = await mainRepo.getWelcomeHashtags(map);
      if (response.statusCode == 200) {
        HashTagListModel model = HashTagListModel.fromJson(response.body);

        hashtagList = model.data;

        isErrorHashtag = false;
        errorMessageHashtag = "";
      } else if (response.statusCode == 401) {
        throw AppString.unAuthorizedAccess;
      } else {
        showCustomSnackBar(response.statusText);
        isErrorHashtag = true;
        errorMessageHashtag = response.statusText.toString();
      }
    } catch (e) {
      isErrorHashtag = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      errorMessageHashtag = error;
    } finally {
      isLoadingHashtag = false;
      update();
    }
  }

  RxBool isLoadingCommonData = false.obs;
  Future<void> getCommonData() async {
    try {
      isLoadingCommonData(true);
      Response response = await mainRepo.getCommonData({});
      if (response.statusCode == 200) {
        CommonDataModel model = CommonDataModel.fromJson(response.body);

        if (model.data != null) {
          commonData.value = model.data!;
          notificationCount.value = model.data!.notificationCount ?? 0;
        }
        if (optionList.isEmpty) {
          for (var element in commonData.value!.supportScreenDropdownOptions!) {
            optionList.add(
              DropDownOptionItemMenu(
                id: element.id,
                title: element.value.toString(),
              ),
            );
          }
        }

        if (optionList.isNotEmpty) {
          optionValue(optionList.first);
        }
      }
    } catch (e) {
      debugPrint("====> ${e.toString()}");
    } finally {
      isLoadingCommonData(false);
    }
  }

  Future<bool?> allowNotification(bool isAllow) async {
    try {
      buildLoading(Get.context!);
      Map<String, dynamic> jsonData = {
        "app_allow_notification": isAllow ? "1" : "0",
      };
      Response response = await mainRepo.allowNotification(jsonData);

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
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  // =================== notification list with pagination =======================

  // local properties
  bool _isLoadingNotificationList = false;
  bool _isErrorNotificationList = false;
  String _errorMsgNotificationList = "";
  List<NotificationListData> _notificationList = [];
  final int _pageCountNotificationList = 15;
  int _pageNumberNotificationList = 1;

  bool _isLoadMoreRunningNotificationList = false;
  bool _isnotMoreDataNotificationList = false;

// get properties
  bool get isLoadingNotificationList => _isLoadingNotificationList;
  bool get isErrorNotificationList => _isErrorNotificationList;
  String get errorMsgNotificationList => _errorMsgNotificationList;
  List<NotificationListData> get notificationList => _notificationList;

  int get pageCountNotificationList => _pageCountNotificationList;
  int get pageNumberNotificationList => _pageNumberNotificationList;
  bool get isLoadMoreRunningNotificationList =>
      _isLoadMoreRunningNotificationList;
  bool get isnotMoreDataNotificationList => _isnotMoreDataNotificationList;

  setPageNumber(int newPageNumber) {
    _pageNumberNotificationList = newPageNumber;
    update();
  }

  removeNotificationItem(int id) {
    _notificationList.removeWhere((element) => element.id == id);
    update();
  }

  Future<void> getNotificationList(
    bool isInit,
  ) async {
    if (isInit) {
      _notificationList = [];
      _isLoadingNotificationList = true;
      _isnotMoreDataNotificationList = false;
      _pageNumberNotificationList = 1;
      try {
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }
    } else {
      _isLoadMoreRunningNotificationList = true;
      try {
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }
    }

    Map<String, dynamic> map = {
      "count": _pageCountNotificationList.toString(),
      "pagenum": _pageNumberNotificationList.toString(),
    };
    try {
      Response response = await mainRepo.notificationList(map);
      if (response.statusCode == 200) {
        NotificationListModel insightFeedModel =
            NotificationListModel.fromJson(response.body);
        if (insightFeedModel.data != null) {
          if (insightFeedModel.data != null) {
            if (insightFeedModel.data!.isNotEmpty) {
              insightFeedModel.data?.forEach((element) {
                _notificationList.add(element);
              });
            } else {
              _isnotMoreDataNotificationList = true;
            }
            _updateNewsErrorState(false, "");
          } else {
            _updateNewsErrorState(true, AppString.somethingWentWrong);
          }
        } else {
          _updateNewsErrorState(true, AppString.somethingWentWrong);
        }
      } else if (response.statusCode == 401) {
        throw AppString.unAuthorizedAccess;
      } else {
        _updateNewsErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      _updateNewsErrorState(true, error.toString());
    } finally {
      _isLoadingNotificationList = false;
      _isLoadMoreRunningNotificationList = false;
      update();
    }
  }

  _updateNewsErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgNotificationList = error;
    } else {
      _errorMsgNotificationList = "";
    }
    _isErrorNotificationList = isError;
    update();
  }

  // ============= clear notification ================\
  Future<bool?> clearAllNotification() async {
    try {
      buildLoading(Get.context!);
      Map<String, dynamic> jsonData = {};
      Response response = await mainRepo.clearAll(jsonData);

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
      showCustomSnackBar(error.toString());
    } finally {
      Navigator.pop(Get.context!);
    }
    return null;
  }

  Future<bool?> acceptDeclineGlobalInvitation({
    required int indexId,
    required bool isAccept,
    required String inviterId,
  }) async {
    try {
      buildLoading(Get.context!);
      Map<String, dynamic> jsonData = {
        "inbox_id": indexId.toString(),
        "invitation_type": isAccept ? "2" : "3",
        "inviter_id": inviterId,
      };
      Response response =
          await mainRepo.acceptDeclineGlobalInvitation(jsonData);

      if (response.statusCode == 200) {
        removeNotificationItem(indexId);
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
    return null;
  }

  Future<bool?> readAllNotification() async {
    try {
      Map<String, dynamic> jsonData = {};
      Response response = await mainRepo.readAll(jsonData);

      if (response.statusCode == 200) {
        notificationCount.value = 0;
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {}
    return null;
  }

  Future<bool?> archiveInbox(String id, String notType) async {
    try {
      buildLoading(Get.context!);
      Map<String, dynamic> jsonData = {
        "id": id,
        "not_type": notType,
      };
      Response response = await mainRepo.archiveInbox(jsonData);

      if (response.statusCode == 200) {
        showCustomSnackBar(response.statusText, isError: false);
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
    return null;
  }

  Future<bool?> updateUserDeviceToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    try {
      Map<String, dynamic> jsonData = {
        "device_token": token ?? "",
        "app_version": AppConstants.appVersion.toString(),
        "device_version": "0",
        "device_type": Platform.isAndroid ? "android" : "ios",
      };
      Response response = await mainRepo.updateUserDeviceToken(jsonData);

      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 1) {
        showCustomSnackBar(response.statusText, isError: true);
      } else {
        showCustomSnackBar(response.body['message'], isError: true);
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      showCustomSnackBar(error.toString());
    } finally {}
    return null;
  }
}
