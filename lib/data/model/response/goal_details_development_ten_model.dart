// // To parse this JSON data, do
// //
// //     final goalDetailsForDevelopmentTenModel = goalDetailsForDevelopmentTenModelFromJson(jsonString);

// import 'dart:convert';

// GoalDetailsForDevelopmentTenModel goalDetailsForDevelopmentTenModelFromJson(
//         String str) =>
//     GoalDetailsForDevelopmentTenModel.fromJson(json.decode(str));

// String goalDetailsForDevelopmentTenModelToJson(
//         GoalDetailsForDevelopmentTenModel data) =>
//     json.encode(data.toJson());

// class GoalDetailsForDevelopmentTenModel {
//   int? status;
//   GoalDetailsForDevelopmentTenData? data;
//   String? message;

//   GoalDetailsForDevelopmentTenModel({
//     this.status,
//     this.data,
//     this.message,
//   });

//   factory GoalDetailsForDevelopmentTenModel.fromJson(
//           Map<String, dynamic> json) =>
//       GoalDetailsForDevelopmentTenModel(
//         status: json["status"],
//         data: json["data"] == null
//             ? null
//             : GoalDetailsForDevelopmentTenData.fromJson(json["data"]),
//         message: json["message"],
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data?.toJson(),
//         "message": message,
//       };
// }

// class GoalDetailsForDevelopmentTenData {
//   int? id;
//   String? goalType;
//   String? devlopmentStyle;
//   int? fromUser;
//   int? toUser;
//   int? areaId;
//   int? styleId;
//   int? positionId;
//   int? positionDetailsId;
//   int? compentencyId;
//   int? focusId;
//   int? type;
//   String? toBe;
//   String? iWill;
//   String? situationalCue;
//   String? actionPlan;
//   String? objectiveTitle;
//   String? startDate;
//   String? targetDate;
//   String? photo;
//   dynamic keyResult;
//   int? isArchive;
//   int? compentencyPlanDetailId;
//   String? tagAsDp;
//   String? suggestedObjective;
//   int? firstDay;
//   int? currentScore;
//   int? startingScore;
//   int? targetScore;
//   String? styleName;
//   int? progressBarScore;
//   String? canUpdate;
//   String? showHideTagAsDevPlanChkbox;
//   String? showHideArchiveBtn;
//   DailyQ? dailyQ;

//   GoalDetailsForDevelopmentTenData({
//     this.id,
//     this.goalType,
//     this.devlopmentStyle,
//     this.fromUser,
//     this.toUser,
//     this.areaId,
//     this.styleId,
//     this.positionId,
//     this.positionDetailsId,
//     this.compentencyId,
//     this.focusId,
//     this.type,
//     this.toBe,
//     this.iWill,
//     this.situationalCue,
//     this.actionPlan,
//     this.objectiveTitle,
//     this.startDate,
//     this.targetDate,
//     this.photo,
//     this.keyResult,
//     this.isArchive,
//     this.compentencyPlanDetailId,
//     this.tagAsDp,
//     this.suggestedObjective,
//     this.firstDay,
//     this.currentScore,
//     this.startingScore,
//     this.targetScore,
//     this.styleName,
//     this.progressBarScore,
//     this.canUpdate,
//     this.showHideTagAsDevPlanChkbox,
//     this.showHideArchiveBtn,
//     this.dailyQ,
//   });

//   factory GoalDetailsForDevelopmentTenData.fromJson(
//           Map<String, dynamic> json) =>
//       GoalDetailsForDevelopmentTenData(
//         id: json["id"],
//         goalType: json["Goal_type"],
//         devlopmentStyle: json["devlopment_style"],
//         fromUser: json["from_user"],
//         toUser: json["to_user"],
//         areaId: json["area_id"],
//         styleId: json["style_id"],
//         positionId: json["position_id"],
//         positionDetailsId: json["position_details_id"],
//         compentencyId: json["compentency_id"],
//         focusId: json["focus_id"],
//         type: json["type"],
//         toBe: json["to_be"],
//         iWill: json["i_will"],
//         situationalCue: json["situational_cue"],
//         actionPlan: json["action_plan"],
//         objectiveTitle: json["objective_title"],
//         startDate: json["start_date"],
//         targetDate: json["target_date"],
//         photo: json["photo"],
//         keyResult: json["keyResult"],
//         isArchive: json["is_archive"],
//         compentencyPlanDetailId: json["compentency_plan_detail_id"],
//         tagAsDp: json["tag_as_dp"],
//         suggestedObjective: json["suggested_objective"],
//         firstDay: json["first_day"],
//         currentScore: json["current_score"],
//         startingScore: json["starting_score"],
//         targetScore: json["target_score"],
//         styleName: json["style_name"],
//         progressBarScore: json["progress_bar_score"],
//         canUpdate: json["can_update"],
//         showHideTagAsDevPlanChkbox: json["show_hide_tag_as_dev_plan_chkbox"],
//         showHideArchiveBtn: json["show_hide_archive_btn"],
//         dailyQ: json["DailyQ"] == null ? null : DailyQ.fromJson(json["DailyQ"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "Goal_type": goalType,
//         "devlopment_style": devlopmentStyle,
//         "from_user": fromUser,
//         "to_user": toUser,
//         "area_id": areaId,
//         "style_id": styleId,
//         "position_id": positionId,
//         "position_details_id": positionDetailsId,
//         "compentency_id": compentencyId,
//         "focus_id": focusId,
//         "type": type,
//         "to_be": toBe,
//         "i_will": iWill,
//         "situational_cue": situationalCue,
//         "action_plan": actionPlan,
//         "objective_title": objectiveTitle,
//         "start_date": startDate,
//         "target_date": targetDate,
//         "photo": photo,
//         "keyResult": keyResult,
//         "is_archive": isArchive,
//         "compentency_plan_detail_id": compentencyPlanDetailId,
//         "tag_as_dp": tagAsDp,
//         "suggested_objective": suggestedObjective,
//         "first_day": firstDay,
//         "current_score": currentScore,
//         "starting_score": startingScore,
//         "target_score": targetScore,
//         "style_name": styleName,
//         "progress_bar_score": progressBarScore,
//         "can_update": canUpdate,
//         "show_hide_tag_as_dev_plan_chkbox": showHideTagAsDevPlanChkbox,
//         "show_hide_archive_btn": showHideArchiveBtn,
//         "DailyQ": dailyQ?.toJson(),
//       };
// }

// class DailyQ {
//   int? id;
//   String? toBe;
//   String? iWill;
//   String? situationalCue;
//   String? plannedAction;
//   int? previousLastScore;
//   int? todayTodayScore;
//   String? todayUpdateId;
//   int? firstDay;

//   DailyQ({
//     this.id,
//     this.toBe,
//     this.iWill,
//     this.situationalCue,
//     this.plannedAction,
//     this.previousLastScore,
//     this.todayTodayScore,
//     this.todayUpdateId,
//     this.firstDay,
//   });

//   factory DailyQ.fromJson(Map<String, dynamic> json) => DailyQ(
//         id: json["id"],
//         toBe: json["to_be"],
//         iWill: json["i_will"],
//         situationalCue: json["situational_cue"],
//         plannedAction: json["planned_action"],
//         previousLastScore: json["previous_last_score"],
//         todayTodayScore: json["today_today_score"],
//         todayUpdateId: json["today_update_id"],
//         firstDay: json["first_day"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "to_be": toBe,
//         "i_will": iWill,
//         "situational_cue": situationalCue,
//         "planned_action": plannedAction,
//         "previous_last_score": previousLastScore,
//         "today_today_score": todayTodayScore,
//         "today_update_id": todayUpdateId,
//         "first_day": firstDay,
//       };
// }
