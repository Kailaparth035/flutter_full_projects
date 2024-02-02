// To parse this JSON data, do
//
//     final coachDetailsModel = coachDetailsModelFromJson(jsonString);

import 'dart:convert';

CoachDetailsModel coachDetailsModelFromJson(String str) =>
    CoachDetailsModel.fromJson(json.decode(str));

String coachDetailsModelToJson(CoachDetailsModel data) =>
    json.encode(data.toJson());

class CoachDetailsModel {
  int? status;
  CoachDetailsData? data;
  String? message;

  CoachDetailsModel({
    this.status,
    this.data,
    this.message,
  });

  factory CoachDetailsModel.fromJson(Map<String, dynamic> json) =>
      CoachDetailsModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : CoachDetailsData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class CoachDetailsData {
  List<SignatureItem>? signatureItems;
  List<ActionItem>? actionItems;
  List<Assessment>? assessment;

  CoachDetailsData({
    this.signatureItems,
    this.actionItems,
    this.assessment,
  });

  factory CoachDetailsData.fromJson(Map<String, dynamic> json) =>
      CoachDetailsData(
        signatureItems: json["Signature_Items"] == null
            ? []
            : List<SignatureItem>.from(
                json["Signature_Items"]!.map((x) => SignatureItem.fromJson(x))),
        actionItems: json["Action_Items"] == null
            ? []
            : List<ActionItem>.from(
                json["Action_Items"]!.map((x) => ActionItem.fromJson(x))),
        assessment: json["Assessment"] == null
            ? []
            : List<Assessment>.from(
                json["Assessment"]!.map((x) => Assessment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Signature_Items": signatureItems == null
            ? []
            : List<dynamic>.from(signatureItems!.map((x) => x.toJson())),
        "Action_Items": actionItems == null
            ? []
            : List<dynamic>.from(actionItems!.map((x) => x.toJson())),
        "Assessment": assessment == null
            ? []
            : List<dynamic>.from(assessment!.map((x) => x.toJson())),
      };
}

class ActionItem {
  int? id;
  String? sessionName;
  Type? type;
  String? internalUrl;
  String? actionItemName;
  String? date;
  String? status;
  String? feedbackUrl;

  ActionItem({
    this.id,
    this.sessionName,
    this.type,
    this.internalUrl,
    this.actionItemName,
    this.date,
    this.status,
    this.feedbackUrl,
  });

  factory ActionItem.fromJson(Map<String, dynamic> json) => ActionItem(
        id: json["id"],
        sessionName: json["session_name"]!,
        type: typeValues.map[json["type"]] ?? Type.OTHER,
        internalUrl: json["internal_url"],
        actionItemName: json["action_item_name"],
        date: json["Date"],
        status: json["Status"].toString(),
        feedbackUrl: json["Feedback_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "session_name": sessionName,
        "type": typeValues.reverse[type] ?? Type.OTHER,
        "internal_url": internalUrl,
        "action_item_name": actionItemName,
        "Date": date,
        "Status": status,
        "Feedback_url": feedbackUrl,
      };
}

// ignore: constant_identifier_names
enum Type { FEEDBACK, OTHER, VIDEO, Form, Su }

final typeValues = EnumValues(
    {"Feedback": Type.FEEDBACK, "Other": Type.OTHER, "Video": Type.VIDEO});

class Assessment {
  String? pdfFile;
  String? productName;

  Assessment({
    this.pdfFile,
    this.productName,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) => Assessment(
        pdfFile: json["pdf_file"],
        productName: json["Product_Name"],
      );

  Map<String, dynamic> toJson() => {
        "pdf_file": pdfFile,
        "Product_Name": productName,
      };
}

class SignatureItem {
  String? mySignature;
  String? teamSignatureIdentity;
  String? commitments;
  String? keyThemes;

  SignatureItem({
    this.mySignature,
    this.teamSignatureIdentity,
    this.commitments,
    this.keyThemes,
  });

  factory SignatureItem.fromJson(Map<String, dynamic> json) => SignatureItem(
        mySignature: json["my_signature"],
        teamSignatureIdentity: json["team_signature_identity"],
        commitments: json["commitments"],
        keyThemes: json["key_themes"],
      );

  Map<String, dynamic> toJson() => {
        "my_signature": mySignature,
        "team_signature_identity": teamSignatureIdentity,
        "commitments": commitments,
        "key_themes": keyThemes,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
