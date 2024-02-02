import 'dart:convert';

GraphDetailsModel graphDetailsModelFromJson(String str) =>
    GraphDetailsModel.fromJson(json.decode(str));

String graphDetailsModelToJson(GraphDetailsModel data) =>
    json.encode(data.toJson());

class GraphDetailsModel {
  int? status;
  GraphDetailsData? data;
  String? message;

  GraphDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory GraphDetailsModel.fromJson(Map<String, dynamic> json) =>
      GraphDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : GraphDetailsData.fromJson(json["data"]),
        message: json["message"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class GraphDetailsData {
  String? styleName;
  String? userId;
  String? styleId;
  String? firstName;
  String? lastName;
  String? totalJourneyPoints;
  String? totalJourneyTime;
  String? photo;

  List<Timelinedetail>? timelinedetails;

  GraphDetailsData({
    this.styleName,
    this.userId,
    this.styleId,
    this.firstName,
    this.lastName,
    this.totalJourneyPoints,
    this.totalJourneyTime,
    this.timelinedetails,
    this.photo,
  });

  factory GraphDetailsData.fromJson(Map<String, dynamic> json) =>
      GraphDetailsData(
        styleName: json["style_name"]?.toString(),
        photo: json["photo"]?.toString(),
        userId: json["user_id"]?.toString(),
        styleId: json["style_id"]?.toString(),
        firstName: json["first_name"]?.toString(),
        lastName: json["last_name"]?.toString(),
        totalJourneyPoints: json["total_journey_points"]?.toString(),
        totalJourneyTime: json["total_journey_time"]?.toString(),
        timelinedetails: json["timelinedetails"] == null
            ? []
            : List<Timelinedetail>.from(json["timelinedetails"]!
                .map((x) => Timelinedetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "style_name": styleName,
        "user_id": userId,
        "style_id": styleId,
        "first_name": firstName,
        "last_name": lastName,
        "total_journey_points": totalJourneyPoints,
        "total_journey_time": totalJourneyTime,
        "timelinedetails": timelinedetails == null
            ? []
            : List<dynamic>.from(timelinedetails!.map((x) => x.toJson())),
      };
}

class Timelinedetail {
  String? title;
  String? subtitle;
  String? hoverText;
  String? date;
  String? completed;
  String? flagShow;
  String? flagPoint;
  String? flagText;
  String? eventType;
  String? isFlagShow;

  Timelinedetail({
    this.title,
    this.subtitle,
    this.hoverText,
    this.date,
    this.completed,
    this.flagShow,
    this.flagPoint,
    this.flagText,
    this.eventType,
    this.isFlagShow,
  });

  factory Timelinedetail.fromJson(Map<String, dynamic> json) => Timelinedetail(
        title: json["title"]?.toString(),
        subtitle: json["subtitle"]?.toString(),
        hoverText: json["hover_text"]?.toString(),
        date: json["date"]?.toString(),
        completed: json["completed"]?.toString(),
        flagShow: json["flag_show"]?.toString(),
        flagPoint: json["flag_point"]?.toString(),
        flagText: json["flag_text"]?.toString(),
        eventType: json["eventType"]?.toString(),
        isFlagShow: json["is_flag_show"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "subtitle": subtitle,
        "hover_text": hoverText,
        "date": date,
        "completed": completed,
        "flag_show": flagShow,
        "flag_point": flagPoint,
        "flag_text": flagText,
        "eventType": eventType,
      };
}
