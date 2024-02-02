// To parse this JSON data, do
//
//     final showcaseJourneyModel = showcaseJourneyModelFromJson(jsonString);

import 'dart:convert';

ShowcaseJourneyModel showcaseJourneyModelFromJson(String str) =>
    ShowcaseJourneyModel.fromJson(json.decode(str));

String showcaseJourneyModelToJson(ShowcaseJourneyModel data) =>
    json.encode(data.toJson());

class ShowcaseJourneyModel {
  int? status;
  List<ShowcaseJourneyData>? data;
  String? message;

  ShowcaseJourneyModel({
    this.status,
    this.data,
    this.message,
  });

  factory ShowcaseJourneyModel.fromJson(Map<String, dynamic> json) =>
      ShowcaseJourneyModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<ShowcaseJourneyData>.from(
                json["data"]!.map((x) => ShowcaseJourneyData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class ShowcaseJourneyData {
  String? mainTitle;
  String? subTitle;
  String? image;
  String? description;
  String? ongoingTitle;
  String? ongoingDescription;
  List<InfoDescription>? infoDescription;
  List<String>? hours;
  AssessmentDetails? assessmentDetails;

  ShowcaseJourneyData({
    this.mainTitle,
    this.subTitle,
    this.image,
    this.description,
    this.ongoingTitle,
    this.ongoingDescription,
    this.infoDescription,
    this.hours,
    this.assessmentDetails,
  });

  factory ShowcaseJourneyData.fromJson(Map<String, dynamic> json) =>
      ShowcaseJourneyData(
        mainTitle: json["main_title"],
        subTitle: json["sub_title"],
        image: json["image"],
        description: json["description"],
        ongoingTitle: json["ongoing_title"],
        ongoingDescription: json["ongoing_description"],
        infoDescription: json["info_description"] == null
            ? []
            : List<InfoDescription>.from(json["info_description"]!
                .map((x) => InfoDescription.fromJson(x))),
        hours: json["hours"] == null
            ? []
            : List<String>.from(json["hours"]!.map((x) => x)),
        assessmentDetails: json["assessment_details"] == null
            ? null
            : AssessmentDetails.fromJson(json["assessment_details"]),
      );

  Map<String, dynamic> toJson() => {
        "main_title": mainTitle,
        "sub_title": subTitle,
        "image": image,
        "description": description,
        "ongoing_title": ongoingTitle,
        "ongoing_description": ongoingDescription,
        "info_description": infoDescription == null
            ? []
            : List<dynamic>.from(infoDescription!.map((x) => x.toJson())),
        "hours": hours == null ? [] : List<dynamic>.from(hours!.map((x) => x)),
        "assessment_details": assessmentDetails?.toJson(),
      };
}

class AssessmentDetails {
  String? title;
  List<ListElement>? list;

  AssessmentDetails({
    this.title,
    this.list,
  });

  factory AssessmentDetails.fromJson(Map<String, dynamic> json) =>
      AssessmentDetails(
        title: json["title"],
        list: json["list"] == null
            ? []
            : List<ListElement>.from(
                json["list"]!.map((x) => ListElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class ListElement {
  String? title;
  String? description;

  ListElement({
    this.title,
    this.description,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}

class InfoDescription {
  String? title;
  String? description;
  List<String>? descriptionList;

  InfoDescription({
    this.title,
    this.description,
    this.descriptionList,
  });

  factory InfoDescription.fromJson(Map<String, dynamic> json) =>
      InfoDescription(
        title: json["title"],
        description: json["description"],
        descriptionList: json["description_list"] == null
            ? []
            : List<String>.from(json["description_list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "description_list": descriptionList == null
            ? []
            : List<dynamic>.from(descriptionList!.map((x) => x)),
      };
}
