import 'package:aspirevue/controller/common_controller.dart';
import 'package:aspirevue/controller/development_controller.dart';
import 'package:aspirevue/data/model/general_model.dart';
import 'package:aspirevue/data/model/response/development/comp_goal_details_model.dart';
import 'package:aspirevue/data/model/response/development/comp_reflect_details_model.dart';
import 'package:aspirevue/data/model/response/development/comp_targatting_details_model.dart';
import 'package:aspirevue/util/colors.dart';
import 'package:aspirevue/util/string.dart';
import 'package:aspirevue/view/base/custom_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompentenciesController extends GetxController {
  final DevelopmentController developmentController;
  CompentenciesController({required this.developmentController});
  //  ========================= self reflact ==========================
  // Local Properties
  bool _isLoadingSelfReflact = true;
  bool _isErrorSelfReflact = false;
  String _errorMsgSelfReflact = "";
  CompReflectDetailsData? _dataSelfReflact;

  // Get Properties
  bool get isLoadingSelfReflact => _isLoadingSelfReflact;
  bool get isErrorSelfReflact => _isErrorSelfReflact;
  String get errorMsgSelfReflact => _errorMsgSelfReflact;
  CompReflectDetailsData? get dataSelfReflact => _dataSelfReflact;

  getSelfReflactData(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "tabName": "reflect",
    };
    try {
      if (isShowLoading == true) {
        _isLoadingSelfReflact = true;
        try {
          update();
        } catch (e) {
          debugPrint(e.toString());
        }
      }

      var response = await developmentController.getCompReflectDetails(
          map, CompetencyType.selfReflact);

      _dataSelfReflact = response;
      _isErrorSelfReflact = false;
      _errorMsgSelfReflact = "";
    } catch (e) {
      _isErrorSelfReflact = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgSelfReflact = error.toString();
    } finally {
      if (isShowLoading == true) {
        _isLoadingSelfReflact = false;
      }
      update();
    }
  }

  //  ========================= Targeting  ==========================
  // Local Properties
  bool _isLoadingTargating = true;
  bool _isErrorTargating = false;
  String _errorMsgTargating = "";
  CompTargattingDetailsData? _dataTargating;

  final DropListModel _ddFilterList = DropListModel([
    DropDownOptionItemMenu(id: null, title: AppString.select),
  ]);
  DropDownOptionItemMenu _ddFilterValue =
      DropDownOptionItemMenu(id: null, title: AppString.select);

  List titleListForTargating = [
    {
      "title": "My Target",
      "color": AppColors.primaryColor,
    },
    {
      "title": "Self-Reflection",
      "color": AppColors.labelColor62,
    },
    {
      "title": "Peers",
      "color": AppColors.labelColor57,
    },
    {
      "title": "Direct-reports",
      "color": AppColors.labelColor56,
    },
    {
      "title": "Supervisor",
      "color": AppColors.labelColor97,
    },
  ];

  // Get Properties
  bool get isLoadingTargating => _isLoadingTargating;
  bool get isErrorTargating => _isErrorTargating;
  String get errorMsgTargating => _errorMsgTargating;
  CompTargattingDetailsData? get dataTargating => _dataTargating;
  DropListModel get ddFilterList => _ddFilterList;
  DropDownOptionItemMenu get ddFilterValue => _ddFilterValue;

  updateDDValue(id) {
    var item = _ddFilterList.listOptionItems
        .where((element) => element.id.toString() == id);

    if (item.isNotEmpty) {
      _ddFilterValue = DropDownOptionItemMenu(id: id, title: item.first.title);
    }
    update();
  }

  onDDChange(DropDownOptionItemMenu optionItem, String userId) {
    _ddFilterValue = optionItem;
    getTargatingData(true, userId);
    update();
  }

  setEmptyValueToDD() {
    _ddFilterValue = DropDownOptionItemMenu(id: null, title: AppString.select);
    update();
  }

  getTargatingData(
    bool isShowLoading,
    String userId,
  ) async {
    Map<String, String> map = {
      "user_id": userId,
      "tabName": "target",
      "position_id":
          _ddFilterValue.id != null ? _ddFilterValue.id.toString() : "0",
    };
    try {
      if (isShowLoading == true) {
        _isLoadingTargating = true;
        try {
          update();
        } catch (e) {
          debugPrint(e.toString());
        }
      }
      var response = await developmentController.getCompReflectDetails(
          map, CompetencyType.targating);

      _dataTargating = response;
      _isErrorTargating = false;
      _errorMsgTargating = "";

      _ddFilterList.listOptionItems = [];
      for (var element in _dataTargating!.positionList!) {
        _ddFilterList.listOptionItems.add(
          DropDownOptionItemMenu(
            id: element.id.toString(),
            title: element.name.toString(),
          ),
        );
      }
      updateDDValue(_dataTargating!.positionId.toString());
    } catch (e) {
      _isErrorTargating = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgTargating = error.toString();
    } finally {
      if (isShowLoading == true) {
        _isLoadingTargating = false;
      }
      update();
    }
  }

  //  ========================= Goal ==========================
  // Local Properties
  bool _isLoadingGoal = true;
  bool _isErrorGoal = false;
  String _errorMsgGoal = "";
  CompGoalDetailsData? _dataGoal;

  // Get Properties
  bool get isLoadingGoal => _isLoadingGoal;
  bool get isErrorGoal => _isErrorGoal;
  String get errorMsgGoal => _errorMsgGoal;
  CompGoalDetailsData? get dataGoal => _dataGoal;

  getGoalData(bool isShowLoading, String userId) async {
    Map<String, String> map = {
      "user_id": userId,
      "tabName": "goal",
    };
    try {
      if (isShowLoading == true) {
        _isLoadingGoal = true;
        try {
          update();
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        buildLoading(Get.context!);
      }
      var response = await developmentController.getCompReflectDetails(
          map, CompetencyType.goal);

      _dataGoal = response;
      _isErrorGoal = false;
      _errorMsgGoal = "";
    } catch (e) {
      _isErrorGoal = true;
      String error = CommonController().getValidErrorMessage(e.toString());
      _errorMsgGoal = error.toString();
    } finally {
      if (isShowLoading == true) {
        _isLoadingGoal = false;
      } else {
        Navigator.pop(Get.context!);
      }
      update();
    }
  }
}
