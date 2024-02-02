// To parse this JSON data, do
//
//     final goalDetailsModelForIndividual = goalDetailsModelForIndividualFromJson(jsonString);

import 'dart:convert';

GoalDetailsModelForIndividual goalDetailsModelForIndividualFromJson(
        String str) =>
    GoalDetailsModelForIndividual.fromJson(json.decode(str));

String goalDetailsModelForIndividualToJson(
        GoalDetailsModelForIndividual data) =>
    json.encode(data.toJson());

class GoalDetailsModelForIndividual {
  int? status;
  GoalDetailsModelForIndividualData? data;
  String? message;

  GoalDetailsModelForIndividual({
    this.status,
    this.data,
    this.message,
  });

  factory GoalDetailsModelForIndividual.fromJson(Map<String, dynamic> json) =>
      GoalDetailsModelForIndividual(
        status: json["status"],
        data: json["data"] == null
            ? null
            : GoalDetailsModelForIndividualData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class GoalDetailsModelForIndividualData {
  int? id;
  String? devlopmentStyle;
  String? fromUser;
  String? toUser;
  String? userId;
  String? areaId;
  String? styleId;
  String? score;

  String? markingType;
  String? objIWill;
  String? subObjIWill;
  String? objSituationalCue;
  String? objMyPlannedActions;
  String? subObjTitle;
  String? objDesiredOutcomes;

  String? startDate;
  String? beginningDate;
  String? targetDate;

  String? startingScore;
  String? targetScore;
  String? currentScore;
  String? keyTitle;
  String? followers;
  String? unitType;
  String? isArchive;
  String? goalTobe;

  String? isConfidential;
  String? tagAsDp;
  List<KeyResult>? keyResults;
  List<dynamic>? dailyqDetails;
  String? progressBarScore;
  String? photo;
  String? goalType;
  String? styleName;
  String? canUpdate;
  String? showHideTagAsDevPlanChkbox;
  String? showHideManageFollowerBtn;
  String? showHideArchiveBtn;
  String? showHideEditObjectiveBtn;
  String? showHideDailyqSection;
  DailyQ? dailyQ;

  String? roleId;
  List<String>? licenseList;
  String? isShowSettingIcon;

  GoalDetailsModelForIndividualData(
      {this.id,
      this.devlopmentStyle,
      this.fromUser,
      this.toUser,
      this.areaId,
      this.styleId,
      this.score,
      this.markingType,
      this.objIWill,
      this.subObjIWill,
      this.objSituationalCue,
      this.objMyPlannedActions,
      this.subObjTitle,
      this.objDesiredOutcomes,
      this.startDate,
      this.beginningDate,
      this.targetDate,
      this.startingScore,
      this.targetScore,
      this.currentScore,
      this.keyTitle,
      this.followers,
      this.unitType,
      this.isArchive,
      this.goalTobe,
      this.userId,
      this.isConfidential,
      this.tagAsDp,
      this.keyResults,
      this.dailyqDetails,
      this.progressBarScore,
      this.photo,
      this.goalType,
      this.styleName,
      this.canUpdate,
      this.showHideTagAsDevPlanChkbox,
      this.showHideManageFollowerBtn,
      this.showHideArchiveBtn,
      this.showHideEditObjectiveBtn,
      this.showHideDailyqSection,
      this.dailyQ,
      this.roleId,
      this.isShowSettingIcon,
      this.licenseList});

  factory GoalDetailsModelForIndividualData.fromJson(
          Map<String, dynamic> json) =>
      GoalDetailsModelForIndividualData(
        id: json["id"],
        devlopmentStyle: json["devlopment_style"].toString(),
        fromUser: json["from_user"].toString(),
        userId: json["user_id"].toString(),
        toUser: json["to_user"].toString(),
        areaId: json["area_id"].toString(),
        styleId: json["style_id"].toString(),
        score: json["score"].toString(),
        markingType: json["marking_type"].toString(),
        objIWill: json["obj_i_will"].toString(),
        subObjIWill: json["sub_obj_i_will"].toString(),
        objSituationalCue: json["obj_situational_cue"].toString(),
        objMyPlannedActions: json["obj_my_planned_actions"].toString(),
        subObjTitle: json["sub_obj_title"].toString(),
        objDesiredOutcomes: json["obj_desired_outcomes"].toString(),
        startDate: json["start_date"].toString(),
        beginningDate: json["beginning_date"].toString(),
        targetDate: json["target_date"].toString(),
        startingScore: json["starting_score"].toString(),
        targetScore: json["target_score"].toString(),
        currentScore: json["current_score"].toString(),
        keyTitle: json["key_title"].toString(),
        followers: json["followers"].toString(),
        unitType: json["unit_type"].toString(),
        isArchive: json["is_archive"].toString(),
        goalTobe: json["goal_tobe"].toString(),
        isConfidential: json["is_confidential"].toString(),
        tagAsDp: json["tag_as_dp"].toString(),
        keyResults: json["key_results"] == null
            ? []
            : List<KeyResult>.from(
                json["key_results"]!.map((x) => KeyResult.fromJson(x))),
        dailyqDetails: json["dailyq_details"] == null
            ? []
            : List<dynamic>.from(json["dailyq_details"]!.map((x) => x)),
        progressBarScore: json["progress_bar_score"].toString(),
        photo: json["photo"].toString(),
        goalType: json["Goal_type"].toString(),
        styleName: json["style_name"].toString(),
        canUpdate: json["can_update"].toString(),
        showHideTagAsDevPlanChkbox:
            json["show_hide_tag_as_dev_plan_chkbox"].toString(),
        showHideManageFollowerBtn:
            json["show_hide_manage_follower_btn"].toString(),
        showHideArchiveBtn: json["show_hide_archive_btn"].toString(),
        showHideEditObjectiveBtn:
            json["show_hide_edit_objective_btn"].toString(),
        showHideDailyqSection: json["show_hide_dailyq_section"].toString(),
        dailyQ: json["DailyQ"] == null ? null : DailyQ.fromJson(json["DailyQ"]),
        roleId: json["role_id"].toString(),
        isShowSettingIcon: json["is_show_setting_icon"].toString(),
        licenseList: json["license_list"] == null
            ? []
            : List<String>.from(json["license_list"]!.map((x) => x.toString())),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "devlopment_style": devlopmentStyle,
        "from_user": fromUser,
        "to_user": toUser,
        "area_id": areaId,
        "style_id": styleId,
        "score": score,
        "marking_type": markingType,
        "obj_i_will": objIWill,
        "sub_obj_i_will": subObjIWill,
        "obj_situational_cue": objSituationalCue,
        "obj_my_planned_actions": objMyPlannedActions,
        "sub_obj_title": subObjTitle,
        "obj_desired_outcomes": objDesiredOutcomes,
        "start_date": startDate,
        "beginning_date": beginningDate,
        "target_date": targetDate,
        "starting_score": startingScore,
        "target_score": targetScore,
        "current_score": currentScore,
        "key_title": keyTitle,
        "followers": followers,
        "unit_type": unitType,
        "is_archive": isArchive,
        "goal_tobe": goalTobe,
        "is_confidential": isConfidential,
        "tag_as_dp": tagAsDp,
        "key_results": keyResults == null
            ? []
            : List<dynamic>.from(keyResults!.map((x) => x.toJson())),
        "dailyq_details": dailyqDetails == null
            ? []
            : List<dynamic>.from(dailyqDetails!.map((x) => x)),
        "progress_bar_score": progressBarScore,
        "photo": photo,
        "Goal_type": goalType,
        "style_name": styleName,
        "can_update": canUpdate,
        "show_hide_tag_as_dev_plan_chkbox": showHideTagAsDevPlanChkbox,
        "show_hide_manage_follower_btn": showHideManageFollowerBtn,
        "show_hide_archive_btn": showHideArchiveBtn,
        "show_hide_edit_objective_btn": showHideEditObjectiveBtn,
        "show_hide_dailyq_section": showHideDailyqSection,
        "DailyQ": dailyQ?.toJson(),
        "role_id": roleId,
        "license_list": licenseList == null
            ? []
            : List<dynamic>.from(licenseList!.map((x) => x)),
      };
}

class DailyQ {
  int? id;
  String? toBe;
  String? iWill;
  String? situationalCue;
  String? plannedAction;
  String? todayUpdateId;
  String? todayTodayScore;
  String? firstDay;
  String? previousLastScore;

  DailyQ({
    this.id,
    this.toBe,
    this.iWill,
    this.situationalCue,
    this.plannedAction,
    this.todayUpdateId,
    this.todayTodayScore,
    this.firstDay,
    this.previousLastScore,
  });

  factory DailyQ.fromJson(Map<String, dynamic> json) => DailyQ(
        id: json["id"],
        toBe: json["to_be"],
        iWill: json["i_will"],
        situationalCue: json["situational_cue"],
        plannedAction: json["planned_action"],
        todayUpdateId: json["today_update_id"].toString(),
        todayTodayScore: json["today_today_score"].toString(),
        firstDay: json["first_day"].toString(),
        previousLastScore: json["previous_last_score"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "to_be": toBe,
        "i_will": iWill,
        "situational_cue": situationalCue,
        "planned_action": plannedAction,
        "today_update_id": todayUpdateId,
        "today_today_score": todayTodayScore,
        "first_day": firstDay,
        "previous_last_score": previousLastScore,
      };
}

class KeyResult {
  int? id;
  int? developvueRatingId;
  String? keyTitle;
  int? unitType;
  String? percentageDesc;
  String? percentageTargetDate;
  int? percentagePercent;
  int? rate;
  String? rateTargetDate;
  String? isActive;

  KeyResult({
    this.id,
    this.developvueRatingId,
    this.keyTitle,
    this.unitType,
    this.percentageDesc,
    this.percentageTargetDate,
    this.percentagePercent,
    this.rate,
    this.rateTargetDate,
    this.isActive,
  });

  factory KeyResult.fromJson(Map<String, dynamic> json) => KeyResult(
        id: json["id"],
        developvueRatingId: json["developvue_rating_id"],
        keyTitle: json["key_title"],
        unitType: json["unit_type"],
        percentageDesc: json["percentage_desc"],
        percentageTargetDate: json["percentage_target_date"],
        percentagePercent: json["percentage_percent"],
        rate: json["rate"],
        rateTargetDate: json["rate_target_date"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "developvue_rating_id": developvueRatingId,
        "key_title": keyTitle,
        "unit_type": unitType,
        "percentage_desc": percentageDesc,
        "percentage_target_date": percentageTargetDate,
        "percentage_percent": percentagePercent,
        "rate": rate,
        "rate_target_date": rateTargetDate,
        "is_active": isActive,
      };
}
