// To parse this JSON data, do
//
//     final editObjectiveModel = editObjectiveModelFromJson(jsonString);

import 'dart:convert';

EditObjectiveModel editObjectiveModelFromJson(String str) =>
    EditObjectiveModel.fromJson(json.decode(str));

String editObjectiveModelToJson(EditObjectiveModel data) =>
    json.encode(data.toJson());

class EditObjectiveModel {
  int? status;
  EditObjectiveData? data;
  String? message;

  EditObjectiveModel({
    this.status,
    this.data,
    this.message,
  });

  factory EditObjectiveModel.fromJson(Map<String, dynamic> json) =>
      EditObjectiveModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : EditObjectiveData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class EditObjectiveData {
  int? id;
  String? userId;
  String? subObjTitle;

  String? objDesiredOutcomes;
  int? areaOfFocus;
  int? isConfidential;
  int? tagAsDp;
  String? beginningDate;
  String? targetDate;
  String? objSupport;
  String? objPotential;
  String? feedbackSolicited;
  String? feedbackUnsolicited;
  String? feedbackDocument;
  String? feedbackDirect;
  String? follower;
  List<KeyResult>? keyResult;
  String? roleId;
  List<String>? licenseList;

  EditObjectiveData({
    this.id,
    this.userId,
    this.subObjTitle,
    this.objDesiredOutcomes,
    this.areaOfFocus,
    this.isConfidential,
    this.tagAsDp,
    this.beginningDate,
    this.targetDate,
    this.objSupport,
    this.objPotential,
    this.feedbackSolicited,
    this.feedbackUnsolicited,
    this.feedbackDocument,
    this.feedbackDirect,
    this.follower,
    this.keyResult,
    this.roleId,
    this.licenseList,
  });

  factory EditObjectiveData.fromJson(Map<String, dynamic> json) =>
      EditObjectiveData(
        id: json["id"],
        userId: json["user_id"],
        subObjTitle: json["sub_obj_title"],
        objDesiredOutcomes: json["obj_desired_outcomes"],
        areaOfFocus: json["area_of_focus"],
        isConfidential: json["is_confidential"],
        tagAsDp: json["tag_as_dp"],
        beginningDate: json["beginning_date"],
        targetDate: json["target_date"],
        objSupport: json["obj_support"],
        objPotential: json["obj_potential"],
        feedbackSolicited: json["feedback_solicited"],
        feedbackUnsolicited: json["feedback_unsolicited"],
        feedbackDocument: json["feedback_document"],
        feedbackDirect: json["feedback_direct"],
        follower: json["follower"],
        keyResult: json["keyResult"] == null
            ? []
            : List<KeyResult>.from(
                json["keyResult"]!.map((x) => KeyResult.fromJson(x))),
        roleId: json["role_id"].toString(),
        licenseList: json["license_list"] == null
            ? []
            : List<String>.from(json["license_list"]!.map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "sub_obj_title": subObjTitle,
        "obj_desired_outcomes": objDesiredOutcomes,
        "area_of_focus": areaOfFocus,
        "is_confidential": isConfidential,
        "tag_as_dp": tagAsDp,
        "beginning_date": beginningDate,
        "target_date": targetDate,
        "obj_support": objSupport,
        "obj_potential": objPotential,
        "feedback_solicited": feedbackSolicited,
        "feedback_unsolicited": feedbackUnsolicited,
        "feedback_document": feedbackDocument,
        "feedback_direct": feedbackDirect,
        "follower": follower,
        "keyResult": keyResult == null
            ? []
            : List<dynamic>.from(keyResult!.map((x) => x.toJson())),
        "role_id": roleId,
        "license_list": licenseList == null
            ? []
            : List<dynamic>.from(licenseList!.map((x) => x)),
      };
}

class KeyResult {
  int? id;
  String? keyTitle;
  int? unitType;
  String? percentageDesc;
  String? percentageTargetDate;
  int? percentagePercent;
  int? rate;
  String? rateTargetDate;

  KeyResult(
      {this.id,
      this.keyTitle,
      this.unitType,
      this.percentageDesc,
      this.percentageTargetDate,
      this.percentagePercent,
      this.rateTargetDate,
      this.rate});

  factory KeyResult.fromJson(Map<String, dynamic> json) => KeyResult(
        id: json["id"],
        keyTitle: json["key_title"],
        unitType: json["unit_type"],
        percentageDesc: json["percentage_desc"],
        percentageTargetDate: json["percentage_target_date"],
        percentagePercent: json["percentage_percent"],
        rate: json["rate"],
        rateTargetDate: json["rate_target_date"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key_title": keyTitle,
        "unit_type": unitType,
        "percentage_desc": percentageDesc,
        "percentage_target_date": percentageTargetDate,
        "percentage_percent": percentagePercent,
        "rate_target_date": rateTargetDate,
        "rate": rate,
      };
}
