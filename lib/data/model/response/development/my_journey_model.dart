// To parse this JSON data, do
//
//     final myJourneyModel = myJourneyModelFromJson(jsonString);

import 'dart:convert';

MyJourneyModel myJourneyModelFromJson(String str) =>
    MyJourneyModel.fromJson(json.decode(str));

String myJourneyModelToJson(MyJourneyModel data) => json.encode(data.toJson());

class MyJourneyModel {
  int? status;
  MyJourneyData? data;
  String? message;

  MyJourneyModel({
    this.status,
    this.data,
    this.message,
  });

  factory MyJourneyModel.fromJson(Map<String, dynamic> json) => MyJourneyModel(
        status: json["status"],
        data:
            json["data"] == null ? null : MyJourneyData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class MyJourneyData {
  String? styleName;
  String? userId;
  String? styleId;
  String? firstName;
  String? lastName;
  String? roleName;
  String? badgImage;
  String? badgeName;
  String? overallLifeTotal;
  List<BadgeDetail>? badgeDetails;
  String? totalJourneyPoints;
  String? totalJourneyTime;
  String? assignUser;
  List<TimelinedetailForMyjourny>? timelinedetails;
  String? photo;
  String? position;

  String? showAnimation;

  List<ReviewType>? reviewType;

  MyJourneyData({
    this.styleName,
    this.userId,
    this.photo,
    this.styleId,
    this.firstName,
    this.lastName,
    this.roleName,
    this.badgImage,
    this.badgeName,
    this.overallLifeTotal,
    this.badgeDetails,
    this.totalJourneyPoints,
    this.totalJourneyTime,
    this.assignUser,
    this.timelinedetails,
    this.position,
    this.showAnimation,
    this.reviewType,
  });

  factory MyJourneyData.fromJson(Map<String, dynamic> json) => MyJourneyData(
        styleName: json["style_name"]?.toString(),
        userId: json["user_id"]?.toString(),
        photo: json["photo"]?.toString(),
        position: json["position"]?.toString(),
        styleId: json["style_id"]?.toString(),
        firstName: json["first_name"]?.toString(),
        lastName: json["last_name"]?.toString(),
        roleName: json["role_name"]?.toString(),
        badgImage: json["badg_image"]?.toString(),
        badgeName: json["badge_name"]?.toString(),
        overallLifeTotal: json["overall_life_total"],
        badgeDetails: json["badge_details"] == null
            ? []
            : List<BadgeDetail>.from(
                json["badge_details"]!.map((x) => BadgeDetail.fromJson(x))),
        totalJourneyPoints: json["total_journey_points"]?.toString(),
        totalJourneyTime: json["total_journey_time"]?.toString(),
        assignUser: json["assignUser"]?.toString(),
        timelinedetails: json["timelinedetails"] == null
            ? []
            : List<TimelinedetailForMyjourny>.from(json["timelinedetails"]!
                .map((x) => TimelinedetailForMyjourny.fromJson(x))),
        showAnimation: json["show_animation"]?.toString(),
        reviewType: json["review_type"] == null
            ? []
            : List<ReviewType>.from(
                json["review_type"]!.map((x) => ReviewType.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "style_name": styleName,
        "user_id": userId,
        "style_id": styleId,
        "position": position,
        "first_name": firstName,
        "last_name": lastName,
        "role_name": roleName,
        "badg_image": badgImage,
        "badge_name": badgeName,
        "overall_life_total": overallLifeTotal,
        "badge_details": badgeDetails == null
            ? []
            : List<dynamic>.from(badgeDetails!.map((x) => x.toJson())),
        "total_journey_points": totalJourneyPoints,
        "total_journey_time": totalJourneyTime,
        "assignUser": assignUser,
        "timelinedetails": timelinedetails == null
            ? []
            : List<dynamic>.from(timelinedetails!.map((x) => x.toJson())),
      };
}

class BadgeDetail {
  String? image;
  String? title;

  BadgeDetail({
    this.image,
    this.title,
  });

  factory BadgeDetail.fromJson(Map<String, dynamic> json) => BadgeDetail(
      image: json["image"]?.toString(), title: json["title"]?.toString());

  Map<String, dynamic> toJson() => {
        "image": image,
        "title": title,
      };
}

class TimelinedetailForMyjourny {
  String? title;
  String? point;
  String? isCompleted;
  String? link;
  String? isLink;

  TimelinedetailForMyjourny({
    this.title,
    this.point,
    this.isCompleted,
    this.link,
    this.isLink,
  });

  factory TimelinedetailForMyjourny.fromJson(Map<String, dynamic> json) =>
      TimelinedetailForMyjourny(
        title: json["title"]?.toString(),
        point: json["point"]?.toString(),
        isCompleted: json["is_completed"]?.toString(),
        link: json["link"]?.toString(),
        isLink: json["is_link"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "point": point,
        "is_completed": isCompleted,
        "link": link,
        "is_link": isLink,
      };
}

class ReviewType {
  String? title;
  int? value;

  ReviewType({
    this.title,
    this.value,
  });

  factory ReviewType.fromJson(Map<String, dynamic> json) => ReviewType(
        title: json["title"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
      };
}
