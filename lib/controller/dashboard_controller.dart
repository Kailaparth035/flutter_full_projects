import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/action_item_model.dart';
import 'package:aspirevue/data/model/response/assign_test_model.dart';
import 'package:aspirevue/data/model/response/dailyq_habit_journal_history_model.dart';
import 'package:aspirevue/data/model/response/dashboard_dailyq_list_model.dart';
import 'package:aspirevue/data/model/response/forum_poll_detail_model.dart';
import 'package:aspirevue/data/model/response/forum_poll_listing_for_dashboard_model.dart';
import 'package:aspirevue/data/model/response/forum_poll_view_response_model.dart';
import 'package:aspirevue/data/model/response/forum_polls_list_model.dart';
import 'package:aspirevue/data/model/response/my_learning_model.dart';
import 'package:aspirevue/data/model/response/quick_link_and_video_model.dart';
import 'package:aspirevue/data/model/response/reminder_option_model.dart';
import 'package:aspirevue/data/model/response/response_model.dart';
import 'package:aspirevue/data/repository/main_repo.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:aspirevue/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DashboardController extends GetxController {
  final MainRepo mainRepo;

  DashboardController({required this.mainRepo});

  // ============================== Assign Test Section ===============================

  // Local Properties
  bool _isLoadingAssignTestList = false;
  bool _isErrorAssignTestList = false;
  String _errorMsgAssignTestList = "";
  List<AssignedTestsData> _assignTestList = [];

  // Get Properties
  bool get isLoadingAssignTestList => _isLoadingAssignTestList;
  bool get isErrorAssignTestList => _isErrorAssignTestList;
  String get errorMsgAssignTestList => _errorMsgAssignTestList;
  List<AssignedTestsData> get assignTestList => _assignTestList;

  Future getAssignedTests(Map<String, dynamic> map) async {
    _isLoadingAssignTestList = true;
    try {
      update();
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      Response response = await mainRepo.getAssignedTests(map);
      if (response.statusCode == 200) {
        _assignTestList = [];
        AssignedTestsModel model = AssignedTestsModel.fromJson(response.body);

        if (model.data != null) {
          _assignTestList = model.data!;
          _updateAssignedErrorState(false, "");
        } else {
          _updateAssignedErrorState(true, AppString.noDataFound);
        }
      } else {
        _updateAssignedErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      _updateAssignedErrorState(true, message);
    } finally {
      _isLoadingAssignTestList = false;
    }
    update();
    return null;
  }

  _updateAssignedErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgAssignTestList = error;
    } else {
      _errorMsgAssignTestList = "";
    }

    _isErrorAssignTestList = isError;
    update();
  }

  Future<ResponseModel> saveAssessmentLink(String id) async {
    Map<String, dynamic> map = {"id": id};
    ResponseModel responseModel;
    Response response = await mainRepo.saveAssessmentLink(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // ============================== Action Item Section ===============================

  // Local Properties
  bool _isLoadingActionItemList = false;
  bool _isErrorActionItemList = false;
  String _errorMsgActionItemList = "";
  List<ActionItemsData> _actionItemList = [];

  // Get Properties
  bool get isLoadingActionItemList => _isLoadingActionItemList;
  bool get isErrorActionItemList => _isErrorActionItemList;
  String get errorMsgActionItemList => _errorMsgActionItemList;
  List<ActionItemsData> get actionItemList => _actionItemList;

  Future<void> getActionItems(Map<String, dynamic> map) async {
    _isLoadingActionItemList = true;
    try {
      update();
    } catch (e) {
      debugPrint(e.toString());
    }

    try {
      Response response = await mainRepo.getActionItems(map);
      if (response.statusCode == 200) {
        _actionItemList = [];
        ActionItemsModel model = ActionItemsModel.fromJson(response.body);

        if (model.data != null) {
          _actionItemList = model.data!;
          _updateActionItemErrorState(false, "");
        } else {
          _updateActionItemErrorState(true, AppString.noDataFound);
        }
      } else {
        _updateActionItemErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      _updateActionItemErrorState(true, message);
    } finally {
      _isLoadingActionItemList = false;
    }
    update();
  }

  _updateActionItemErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgActionItemList = error;
    } else {
      _errorMsgActionItemList = "";
    }

    _isErrorActionItemList = isError;
    update();
  }

  // ============================== DailyQ Section Controll ===============================

  // Local Properties
  bool _isLoadingDailyQ = false;
  bool _isErrorDailyQ = false;
  String _errorMsgDailyQ = "";
  List<DailyQDataForDashboard> _dailyQBullets = [];

  // Get Properties
  bool get isLoadingDailyQ => _isLoadingDailyQ;
  bool get isErrorDailyQ => _isErrorDailyQ;
  String get errorMsgDailyQ => _errorMsgDailyQ;
  List<DailyQDataForDashboard> get dailyQButllets => _dailyQBullets;

  String selectedDate = DateFormat('MM/dd/yyyy').format(DateTime.now());
  String currentDate = DateFormat('MM/dd/yyyy').format(DateTime.now());

  changeSelectedDate(String selectedate) {
    selectedDate = selectedate;
    update();
  }

  Future<void> getHabitJournalBulletsDetail(
      bool isShowLoading, bool isBullet) async {
    if (isShowLoading) {
      _isLoadingDailyQ = true;
      try {
        update();
      } catch (e) {
        debugPrint("====> ${e.toString()}");
      }
    }

    Map<String, dynamic> map = {
      "last_date": selectedDate,
      "type": isBullet ? "1" : "2"
    };

    try {
      Response response = await mainRepo.getHabitJournalBulletsDetail(map);
      if (response.statusCode == 200) {
        _dailyQBullets = [];
        DashboardDailyQListModel model =
            DashboardDailyQListModel.fromJson(response.body);

        if (model.data != null) {
          _dailyQBullets = model.data!;
          _updateDailyQErrorState(false, "");
        } else {
          _updateDailyQErrorState(true, AppString.noDataFound);
        }
      } else {
        _updateDailyQErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      _updateDailyQErrorState(true, message);
    } finally {
      if (isShowLoading) {
        _isLoadingDailyQ = false;
      }
    }
    update();
  }

  _updateDailyQErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgDailyQ = error;
    } else {
      _errorMsgDailyQ = "";
    }
    _isErrorDailyQ = isError;
    update();
  }

  Future<ResponseModel> saveHabitBullet(String name) async {
    Map<String, dynamic> map = {"name": name};
    ResponseModel responseModel;
    Response response = await mainRepo.saveHabitBullet(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> saveJournalData(String note) async {
    Map<String, dynamic> map = {"note": note};
    ResponseModel responseModel;
    Response response = await mainRepo.saveJournalData(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<ResponseModel> deleteHabitJournalReminder(
      bool isBullet, String id) async {
    Map<String, dynamic> map = {
      "type": isBullet ? "1" : "2",
      "id": id,
    };
    ResponseModel responseModel;
    Response response = await mainRepo.deleteHabitJournalReminder(map);
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // ========================== Habbit bullet and journal popup ========================

  Future<List<DailyqHabitJournalHistoryData>> getDailyqHabitJournalHistory(
      Map<String, dynamic> map) async {
    try {
      Response response = await mainRepo.getDailyqHabitJournalHistory(map);
      if (response.statusCode == 200) {
        DailyqHabitJournalHistoryModel data =
            DailyqHabitJournalHistoryModel.fromJson(response.body);

        if (data.data == null) {
          throw AppString.somethingWentWrong;
        } else {
          return data.data!;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      throw message;
    }
  }

  Future<ReminderOptionData> getdailyqhabitJournaleminder(
      Map<String, dynamic> map) async {
    try {
      Response response = await mainRepo.getdailyqhabitJournaleminder(map);
      if (response.statusCode == 200) {
        ReminderOptionModel data = ReminderOptionModel.fromJson(response.body);

        if (data.data == null) {
          throw AppString.somethingWentWrong;
        } else {
          return data.data!;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      throw message;
    }
  }

  Future<ResponseModel> savedailyqhabitJournaleminder(
      Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.savedailyqhabitJournaleminder(jsonData);

    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body['message']);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // ==============================  ForumPoll Question Answer ===============================
  // Local Properties
  bool _isLoadingForumPoll = false;
  bool _isErrorForumPoll = false;
  String _errorMsgForumPoll = "";
  List<ForumDataForDashboard> _forumPollBullets = [];

  // Get Properties
  bool get isLoadingForumPoll => _isLoadingForumPoll;
  bool get isErrorForumPoll => _isErrorForumPoll;
  String get errorMsgForumPoll => _errorMsgForumPoll;
  List<ForumDataForDashboard> get forumPollButlletsList => _forumPollBullets;

  Future<void> getForumPollQuestionAnswer(Map<String, dynamic> map) async {
    _isLoadingForumPoll = true;
    try {
      Response response = await mainRepo.getForumPollQuestionAnswer(map);
      if (response.statusCode == 200) {
        ForumPollQuestionAnswerForDashBoardModel data =
            ForumPollQuestionAnswerForDashBoardModel.fromJson(response.body);

        if (data.data != null) {
          _forumPollBullets = data.data!;
          _updateForumPollErrorState(false, "");
        } else {
          _updateForumPollErrorState(true, AppString.noDataFound);
        }
      } else {
        _updateForumPollErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      _updateForumPollErrorState(true, message);
    } finally {
      _isLoadingForumPoll = false;
    }
    update();
  }

  _updateForumPollErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgForumPoll = error;
    } else {
      _errorMsgForumPoll = "";
    }
    _isErrorForumPoll = isError;
    update();
  }

  // ==============================  ForumPoll List Pagination ===============================
  // local
  bool _isLoadingFPP = false;
  bool _isErrorFPP = false;
  String _errorMsgFPP = "";
  List<ForumPollsData> _listFPP = [];
  // get
  bool get isLoadingFPP => _isLoadingFPP;
  bool get isErrorFPP => _isErrorFPP;
  String get errorMsgFPP => _errorMsgFPP;
  List<ForumPollsData> get listFPP => _listFPP;

  // pagination variables
  final int pageCountFPP = 10;
  int pageNumberFPP = 1;
  bool isLoadMoreRunningFPP = false;
  bool isnotMoreDataFPP = false;

  Future<void> showAllForumPolls(
    bool isInit, {
    required String search,
    required String filter,
  }) async {
    if (isInit) {
      _listFPP = [];
      _isLoadingFPP = true;
      isnotMoreDataFPP = false;
      pageNumberFPP = 1;
      try {
        update();
      } catch (e) {
        debugPrint("====> error =======> $e");
      }
    } else {
      isLoadMoreRunningFPP = true;
      update();
    }

    Map<String, dynamic> map = {
      "count": pageCountFPP.toString(),
      "pagenum": pageNumberFPP.toString(),
      "search": search,
      "filter": filter,
    };
    try {
      Response response = await mainRepo.showAllForumPolls(map);

      if (response.statusCode == 200) {
        ForumPollListModel data = ForumPollListModel.fromJson(response.body);
        if (data.data != null) {
          if (data.data != null) {
            if (data.data!.isNotEmpty) {
              data.data?.forEach((element) {
                _listFPP.add(element);
              });
            } else {
              isnotMoreDataFPP = true;
            }
            _updateuserStreamErrorState(false, "");
          } else {
            _updateuserStreamErrorState(true, AppString.somethingWentWrong);
          }
        } else {
          _updateuserStreamErrorState(true, AppString.somethingWentWrong);
        }
      } else {
        _updateuserStreamErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      _updateuserStreamErrorState(true, message);
    } finally {
      _isLoadingFPP = false;
      isLoadMoreRunningFPP = false;
      update();
    }
  }

  _updateuserStreamErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgFPP = error;
    } else {
      _errorMsgFPP = "";
    }
    _isErrorFPP = isError;
    update();
  }

  // =================================== add answer======================================

  Future<ResponseModel> addAnswer(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.addAnswer(jsonData);

    if (response.statusCode == 200) {
      responseModel =
          ResponseModel(true, response.body['message'], responseT: response);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  // ==================== View Response for forum poll chart ========================

  Future<ForumPollViewResponseData> viewResponse(
      Map<String, dynamic> map) async {
    try {
      Response response = await mainRepo.viewResponse(map);
      if (response.statusCode == 200) {
        ForumPollViewResponseModel data =
            ForumPollViewResponseModel.fromJson(response.body);

        if (data.data == null) {
          throw AppString.somethingWentWrong;
        } else {
          return data.data!;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      throw message;
    }
  }

  // ==================== View Response for forum poll chart ========================

  Future<ForumPollDetailData> viewQuestionAnswerDetail(
      Map<String, dynamic> map) async {
    try {
      Response response = await mainRepo.viewQuestionAnswerDetail(map);
      if (response.statusCode == 200) {
        ForumPollDetailModel data =
            ForumPollDetailModel.fromJson(response.body);

        if (data.data == null) {
          throw AppString.somethingWentWrong;
        } else {
          return data.data!;
        }
      } else {
        throw response.statusText.toString();
      }
    } catch (e) {
      String error = CommonController().getValidErrorMessage(e.toString());
      throw error;
    }
  }

  // =================================== add suggestion question======================================

  Future<ResponseModel> suggestQuestion(Map<String, dynamic> jsonData) async {
    ResponseModel responseModel;
    Response response = await mainRepo.suggestQuestion(jsonData);

    if (response.statusCode == 200) {
      responseModel =
          ResponseModel(true, response.body['message'], responseT: response);
    } else if (response.statusCode == 1) {
      responseModel = ResponseModel(false, response.statusText);
    } else {
      responseModel = ResponseModel(false, response.body['message']);
    }
    return responseModel;
  }

  Future<bool?> addRemoveReminderTag(
      {required String id,
      required String isChecked,
      required String newcheckid,
      required Future Function() onReload}) async {
    Map<String, dynamic> jsonData = {
      "id": id,
      "is_checked": isChecked,
      "newcheckid": newcheckid,
      "selected_date": selectedDate
    };

    try {
      buildLoading(Get.context!);
      Response response = await mainRepo.addRemoveReminderTag(jsonData);

      if (response.statusCode == 200) {
        await onReload();
        showCustomSnackBar(response.body['message'], isError: false);
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

  // Local Properties
  bool _isLoadingQuickLinkData = false;
  bool _isErrorQuickLinkData = false;
  String _errorMsgQuickLinkData = "";
  QuickLinkAndVideoData? _quickLinkData;
  List<QuickLinksPopup> _quickLinksPopupMain = [];

  // Get Properties
  bool get isLoadingQuickLinkData => _isLoadingQuickLinkData;
  bool get isErrorQuickLinkData => _isErrorQuickLinkData;
  String get errorMsgQuickLinkData => _errorMsgQuickLinkData;
  QuickLinkAndVideoData? get quickLinkData => _quickLinkData;
  List<QuickLinksPopup> get quickLinksPopupMain => _quickLinksPopupMain;

  setQuickLinksPopupMain() {
    if (_quickLinkData != null) {
      _quickLinksPopupMain = [];
      _quickLinksPopupMain =
          _quickLinkData!.quickLinksPopup!.map((obj) => obj.clone()).toList();

      update();
    }
  }

  setCheckedInQuickLink(int index) {
    int? value = _quickLinksPopupMain[index].isSelected;
    _quickLinksPopupMain[index].isSelected = value == 1 ? 0 : 1;
    update();
  }

  Future<void> getDashboardVideoQuickLinkDetails(Map<String, dynamic> map,
      {required bool isShowLoading}) async {
    if (isShowLoading) {
      _isLoadingQuickLinkData = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    try {
      Response response = await mainRepo.getDashboardVideoQuickLinkDetails(map);
      if (response.statusCode == 200) {
        _quickLinkData = null;
        QuickLinkAndVideoModel model =
            QuickLinkAndVideoModel.fromJson(response.body);

        if (model.data != null) {
          _quickLinkData = model.data!;
          addUrlInWebView(_quickLinkData!.learnMoreUrl);
          if (model.data!.quickLinksPopup != null) {
            setQuickLinksPopupMain();
          }
          if (model.data!.myEnterprise != null &&
              model.data!.myEnterprise!.isNotEmpty) {
            addMenuInMenuList(model.data!.myEnterprise!);
          }

          _updateQuickLinkErrorState(false, "");
        } else {
          _updateQuickLinkErrorState(true, AppString.noDataFound);
        }
      } else {
        _updateQuickLinkErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      _updateQuickLinkErrorState(true, message);
    } finally {
      _isLoadingQuickLinkData = false;
    }
    update();
  }

  //================ learn more webview manage ================

  WebViewController? learnMoreWebviewController;
  bool isErrorWebView = false;
  addUrlInWebView(url) {
    try {
      learnMoreWebviewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(url));

      isErrorWebView = false;
    } catch (e) {
      isErrorWebView = true;
    } finally {
      update();
    }
  }

  _updateQuickLinkErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgQuickLinkData = error;
    } else {
      _errorMsgQuickLinkData = "";
    }
    _isErrorQuickLinkData = isError;
    update();
  }

  Future<bool?> updateToViewQuickLinks({
    required List<QuickLinksPopup> quickLinksPopup,
    Map<String, dynamic>? defaultJsonData,
  }) async {
    Map<String, dynamic> jsonData = {
      "data": List<dynamic>.from(quickLinksPopup.map((x) => x.toJson())),
    };

    if (defaultJsonData != null) {
      jsonData = defaultJsonData;
    }

    try {
      buildLoading(Get.context!);
      Response response = await mainRepo.updateToViewQuickLinks(jsonData);

      if (response.statusCode == 200) {
        // showCustomSnackBar(response.body['message'], isError: false);
        await getDashboardVideoQuickLinkDetails({}, isShowLoading: false);
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

  // =============== my learnings ==========================

  // Local Properties
  bool _isLoadingMyLearning = false;
  bool _isErrorMyLearning = false;
  String _errorMsgMyLearning = "";
  List<MyLearningData>? _myLearning;

  // Get Properties
  bool get isLoadingMyLearning => _isLoadingMyLearning;
  bool get isErrorMyLearning => _isErrorMyLearning;
  String get errorMsgMyLearning => _errorMsgMyLearning;
  List<MyLearningData>? get myLearning => _myLearning;

  Future<void> getMyLearning({required bool isShowLoading}) async {
    if (isShowLoading) {
      _isLoadingMyLearning = true;
      try {
        update();
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    try {
      Response response = await mainRepo.myLearning({});
      if (response.statusCode == 200) {
        MyLearningModel model = MyLearningModel.fromJson(response.body);

        if (model.data != null) {
          _myLearning = model.data!;

          _updateMyLearningErrorState(false, "");
        } else {
          _updateMyLearningErrorState(true, AppString.noDataFound);
        }
      } else {
        _updateMyLearningErrorState(true, response.statusText.toString());
      }
    } catch (e) {
      String message = CommonController().getValidErrorMessage(e.toString());
      _updateMyLearningErrorState(true, message);
    } finally {
      _isLoadingMyLearning = false;
    }
    update();
  }

  _updateMyLearningErrorState(bool isError, String error) {
    if (isError) {
      _errorMsgMyLearning = error;
    } else {
      _errorMsgMyLearning = "";
    }
    _isErrorMyLearning = isError;
    update();
  }

  Future<bool?> updateMyChecklist({
    required String id,
    required String isChecked,
  }) async {
    Map<String, dynamic> jsonData = {
      "id": id,
      "is_checked": isChecked,
    };

    try {
      buildLoading(Get.context!);
      Response response = await mainRepo.updateMyChecklist(jsonData);

      if (response.statusCode == 200) {
        // shoswCustomSnackBar(response.body['message'], isError: false);
        await getDashboardVideoQuickLinkDetails({}, isShowLoading: false);
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

  Future<bool?> updateTourOverlayFlag(String value) async {
    Map<String, dynamic> jsonData = {"is_show_tour_overlay": value};

    try {
      buildLoading(Get.context!);
      Response response = await mainRepo.updateTourOverlayFlag(jsonData);

      if (response.statusCode == 200) {
        await getDashboardVideoQuickLinkDetails({}, isShowLoading: false);
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

  DropListModel mainMenuList = DropListModel([
    DropDownOptionItemMenu(id: "1", title: AppString.personalinfo),
    DropDownOptionItemMenu(id: "2", title: AppString.account),
    DropDownOptionItemMenu(id: "3", title: AppString.privacy),
    DropDownOptionItemMenu(id: "4", title: AppString.notifications),
    DropDownOptionItemMenu(id: "5", title: AppString.myConnections),
    DropDownOptionItemMenu(id: "6", title: AppString.integrations),
    DropDownOptionItemMenu(id: "7", title: AppString.signature),
  ]);
  DropDownOptionItemMenu optionMenuItem =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  addMenuInMenuList(List<MyEnterprise> myEnterprise) {
    bool isAdded = mainMenuList.listOptionItems
        .where((element) => element.title == "AspireVue University")
        .isNotEmpty;
    if (isAdded == false) {
      for (var value in myEnterprise) {
        mainMenuList.listOptionItems.add(
          DropDownOptionItemMenu(
              id: value.id.toString(),
              title: value.title.toString(),
              sortName: "EnterPrise"),
        );
      }
      update();
    }
  }
}
