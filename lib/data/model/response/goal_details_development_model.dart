// To parse this JSON data, do
//
//     final goalDetailsForDevelopmentModel = goalDetailsForDevelopmentModelFromJson(jsonString);

import 'dart:convert';

GoalDetailsForDevelopmentModel goalDetailsForDevelopmentModelFromJson(
        String str) =>
    GoalDetailsForDevelopmentModel.fromJson(json.decode(str));

String goalDetailsForDevelopmentModelToJson(
        GoalDetailsForDevelopmentModel data) =>
    json.encode(data.toJson());

class GoalDetailsForDevelopmentModel {
  int? status;
  GoalDetailsForDevelopmentData? data;
  String? message;

  GoalDetailsForDevelopmentModel({
    this.status,
    this.data,
    this.message,
  });

  factory GoalDetailsForDevelopmentModel.fromJson(Map<String, dynamic> json) =>
      GoalDetailsForDevelopmentModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : GoalDetailsForDevelopmentData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class GoalDetailsForDevelopmentData {
  String? id;
  String? devlopmentStyle;
  String? styleName;
  String? fromUser;
  String? toUser;
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
  String? keyResults;
  List<DailyqDetail>? dailyqDetails;
  String? riskReputationPresent;
  String? developmentPlanDetailId;
  String? photo;
  String? dataStyleName;
  String? goalType;
  String? progressBarScore;
  String? canUpdate;
  String? showHideTagAsDevPlanChkbox;
  String? showHideManageFollowerBtn;
  String? showHideArchiveBtn;
  String? updateCurrentScore;
  String? updateTargetScore;

  String? showHideDailyqSection;
  String? showHideEditObjectiveBtn;
  DailyQ? dailyQ;
  String? isShowSettingIcon;

  GoalDetailsForDevelopmentData({
    this.id,
    this.devlopmentStyle,
    this.styleName,
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
    this.isConfidential,
    this.tagAsDp,
    this.keyResults,
    this.dailyqDetails,
    this.riskReputationPresent,
    this.developmentPlanDetailId,
    this.photo,
    this.dataStyleName,
    this.goalType,
    this.progressBarScore,
    this.canUpdate,
    this.showHideTagAsDevPlanChkbox,
    this.showHideManageFollowerBtn,
    this.showHideArchiveBtn,
    this.updateCurrentScore,
    this.updateTargetScore,
    this.showHideDailyqSection,
    this.showHideEditObjectiveBtn,
    this.dailyQ,
    this.isShowSettingIcon,
  });

  factory GoalDetailsForDevelopmentData.fromJson(Map<String, dynamic> json) =>
      GoalDetailsForDevelopmentData(
        id: json["id"] == null ? "" : json["id"].toString(),
        devlopmentStyle: json["devlopment_style"] == null
            ? ""
            : json["devlopment_style"].toString(),
        styleName:
            json["style_name"] == null ? "" : json["style_name"].toString(),
        fromUser: json["from_user"] == null ? "" : json["from_user"].toString(),
        toUser: json["to_user"] == null ? "" : json["to_user"].toString(),
        areaId: json["area_id"] == null ? "" : json["area_id"].toString(),
        styleId: json["style_id"] == null ? "" : json["style_id"].toString(),
        score: json["score"] == null ? "" : json["score"].toString(),
        markingType:
            json["marking_type"] == null ? "" : json["marking_type"].toString(),
        objIWill:
            json["obj_i_will"] == null ? "" : json["obj_i_will"].toString(),
        subObjIWill: json["sub_obj_i_will"] == null
            ? ""
            : json["sub_obj_i_will"].toString(),
        objSituationalCue: json["obj_situational_cue"] == null
            ? ""
            : json["obj_situational_cue"].toString(),
        objMyPlannedActions: json["obj_my_planned_actions"] == null
            ? ""
            : json["obj_my_planned_actions"].toString(),
        subObjTitle: json["sub_obj_title"] == null
            ? ""
            : json["sub_obj_title"].toString(),
        objDesiredOutcomes: json["obj_desired_outcomes"] == null
            ? ""
            : json["obj_desired_outcomes"].toString(),
        startDate:
            json["start_date"] == null ? "" : json["start_date"].toString(),
        beginningDate: json["beginning_date"] == null
            ? ""
            : json["beginning_date"].toString(),
        targetDate:
            json["target_date"] == null ? "" : json["target_date"].toString(),
        startingScore: json["starting_score"] == null
            ? ""
            : json["starting_score"].toString(),
        targetScore:
            json["target_score"] == null ? "" : json["target_score"].toString(),
        currentScore: json["current_score"] == null
            ? ""
            : json["current_score"].toString(),
        keyTitle: json["key_title"] == null ? "" : json["key_title"].toString(),
        followers:
            json["followers"] == null ? "" : json["followers"].toString(),
        unitType: json["unit_type"] == null ? "" : json["unit_type"].toString(),
        isArchive:
            json["is_archive"] == null ? "" : json["is_archive"].toString(),
        goalTobe: json["goal_tobe"] == null ? "" : json["goal_tobe"].toString(),
        isConfidential: json["is_confidential"] == null
            ? ""
            : json["is_confidential"].toString(),
        tagAsDp: json["tag_as_dp"] == null ? "" : json["tag_as_dp"].toString(),
        keyResults:
            json["key_results"] == null ? "" : json["key_results"].toString(),
        dailyqDetails: json["dailyq_details"] == null
            ? []
            : List<DailyqDetail>.from(
                json["dailyq_details"]!.map((x) => DailyqDetail.fromJson(x))),
        riskReputationPresent: json["risk_reputation_present"] == null
            ? ""
            : json["risk_reputation_present"].toString(),
        developmentPlanDetailId: json["development_plan_detail_id"] == null
            ? ""
            : json["development_plan_detail_id"].toString(),
        photo: json["photo"] == null ? "" : json["photo"].toString(),
        dataStyleName:
            json["style_name"] == null ? "" : json["style_name"].toString(),
        goalType: json["Goal_type"] == null ? "" : json["Goal_type"].toString(),
        progressBarScore: json["progress_bar_score"] == null
            ? ""
            : json["progress_bar_score"].toString(),
        canUpdate:
            json["can_update"] == null ? "" : json["can_update"].toString(),
        showHideTagAsDevPlanChkbox:
            json["show_hide_tag_as_dev_plan_chkbox"] == null
                ? ""
                : json["show_hide_tag_as_dev_plan_chkbox"].toString(),
        showHideManageFollowerBtn: json["show_hide_manage_follower_btn"] == null
            ? ""
            : json["show_hide_manage_follower_btn"].toString(),
        showHideArchiveBtn: json["show_hide_archive_btn"] == null
            ? ""
            : json["show_hide_archive_btn"].toString(),
        updateCurrentScore: json["update_current_score"] == null
            ? ""
            : json["update_current_score"].toString(),
        updateTargetScore: json["update_target_score"] == null
            ? ""
            : json["update_target_score"].toString(),
        showHideDailyqSection: json["show_hide_dailyq_section"] == null
            ? ""
            : json["show_hide_dailyq_section"].toString(),
        showHideEditObjectiveBtn: json["show_hide_edit_objective_btn"] == null
            ? ""
            : json["show_hide_edit_objective_btn"].toString(),
        isShowSettingIcon: json["is_show_setting_icon"].toString(),
        dailyQ: json["DailyQ"] == null ? null : DailyQ.fromJson(json["DailyQ"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "devlopment_style": devlopmentStyle,
        "styleName": styleName,
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
        "key_results": keyResults,
        "dailyq_details": dailyqDetails == null
            ? []
            : List<dynamic>.from(dailyqDetails!.map((x) => x.toJson())),
        "risk_reputation_present": riskReputationPresent,
        "development_plan_detail_id": developmentPlanDetailId,
        "photo": photo,
        "style_name": dataStyleName,
        "Goal_type": goalType,
        "progress_bar_score": progressBarScore,
        "can_update": canUpdate,
        "show_hide_tag_as_dev_plan_chkbox": showHideTagAsDevPlanChkbox,
        "show_hide_manage_follower_btn": showHideManageFollowerBtn,
        "show_hide_archive_btn": showHideArchiveBtn,
        "update_current_score": updateCurrentScore,
        "update_target_score": updateTargetScore,
        "DailyQ": dailyQ?.toJson(),
      };
}

class DailyQ {
  String? id;
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
        id: json["id"].toString(),
        toBe: json["to_be"].toString(),
        iWill: json["i_will"].toString(),
        situationalCue: json["situational_cue"].toString(),
        plannedAction: json["planned_action"].toString(),
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

class DailyqDetail {
  String? id;
  String? styleId;
  String? devlopvueReatingId;
  String? userId;
  String? areaId;
  String? score;
  String? dailyScore;
  String? lastScore;
  String? isNew;
  DateTime? created;
  DateTime? modified;

  DailyqDetail({
    this.id,
    this.styleId,
    this.devlopvueReatingId,
    this.userId,
    this.areaId,
    this.score,
    this.dailyScore,
    this.lastScore,
    this.isNew,
    this.created,
    this.modified,
  });

  factory DailyqDetail.fromJson(Map<String, dynamic> json) => DailyqDetail(
        id: json["id"].toString(),
        styleId: json["style_id"].toString(),
        devlopvueReatingId: json["devlopvue_reating_id"].toString(),
        userId: json["user_id"].toString(),
        areaId: json["area_id"].toString(),
        score: json["score"].toString(),
        dailyScore: json["daily_score"].toString(),
        lastScore: json["last_score"].toString(),
        isNew: json["is_new"].toString(),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
        modified:
            json["modified"] == null ? null : DateTime.parse(json["modified"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "style_id": styleId,
        "devlopvue_reating_id": devlopvueReatingId,
        "user_id": userId,
        "area_id": areaId,
        "score": score,
        "daily_score": dailyScore,
        "last_score": lastScore,
        "is_new": isNew,
        "created": created?.toIso8601String(),
        "modified": modified?.toIso8601String(),
      };
}
