// To parse this JSON data, do
//
//     final userAboutModel = userAboutModelFromJson(jsonString);

import 'dart:convert';

UserAboutModel userAboutModelFromJson(String str) =>
    UserAboutModel.fromJson(json.decode(str));

String userAboutModelToJson(UserAboutModel data) => json.encode(data.toJson());

class UserAboutModel {
  UserAboutModel({
    this.status,
    this.data,
    this.message,
  });

  int? status;
  UserAboutData? data;
  String? message;

  factory UserAboutModel.fromJson(Map<String, dynamic> json) => UserAboutModel(
        status: json["status"],
        data:
            json["data"] == null ? null : UserAboutData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class UserAboutData {
  UserAboutData({
    this.personalInfo,
    this.mySignature,
    this.position,
    this.roleResponsibilities,
    this.myFavoriteQuote,
    this.interests,
  });

  PersonalInfo? personalInfo;
  MySignature? mySignature;
  Position? position;
  List<RoleResponsibility>? roleResponsibilities;
  MyFavoriteQuote? myFavoriteQuote;
  List<Interest>? interests;

  factory UserAboutData.fromJson(Map<String, dynamic> json) => UserAboutData(
        personalInfo: json["Personal_Info"] == null
            ? null
            : PersonalInfo.fromJson(json["Personal_Info"]),
        mySignature: json["My_Signature"] == null
            ? null
            : MySignature.fromJson(json["My_Signature"]),
        position: json["Position"] == null
            ? null
            : Position.fromJson(json["Position"]),
        roleResponsibilities: json["Role_Responsibilities"] == null
            ? []
            : List<RoleResponsibility>.from(json["Role_Responsibilities"]!
                .map((x) => RoleResponsibility.fromJson(x))),
        myFavoriteQuote: json["My_Favorite_Quote"] == null
            ? null
            : MyFavoriteQuote.fromJson(json["My_Favorite_Quote"]),
        interests: json["Interests"] == null
            ? []
            : List<Interest>.from(
                json["Interests"]!.map((x) => Interest.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Personal_Info": personalInfo?.toJson(),
        "My_Signature": mySignature?.toJson(),
        "Position": position?.toJson(),
        "Role_Responsibilities": roleResponsibilities == null
            ? []
            : List<dynamic>.from(roleResponsibilities!.map((x) => x.toJson())),
        "My_Favorite_Quote": myFavoriteQuote?.toJson(),
        "Interests": interests == null
            ? []
            : List<dynamic>.from(interests!.map((x) => x.toJson())),
      };
}

class Interest {
  Interest({
    this.title,
    this.detail,
  });

  String? title;
  String? detail;

  factory Interest.fromJson(Map<String, dynamic> json) => Interest(
        title: json["title"],
        detail: json["detail"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "detail": detail,
      };
}

class MyFavoriteQuote {
  MyFavoriteQuote({
    this.dsc,
  });

  String? dsc;

  factory MyFavoriteQuote.fromJson(Map<String, dynamic> json) =>
      MyFavoriteQuote(
        dsc: json["dsc"],
      );

  Map<String, dynamic> toJson() => {
        "dsc": dsc,
      };
}

class MySignature {
  MySignature({
    this.mySignature,
    this.purposeStatement,
    this.importantToMe,
    this.teamSignature,
  });

  String? mySignature;
  String? purposeStatement;
  String? importantToMe;
  String? teamSignature;

  factory MySignature.fromJson(Map<String, dynamic> json) => MySignature(
        mySignature: json["my_signature"],
        purposeStatement: json["purpose_statement"],
        importantToMe: json["important_to_me"],
        teamSignature: json["team_signature"],
      );

  Map<String, dynamic> toJson() => {
        "my_signature": mySignature,
        "purpose_statement": purposeStatement,
        "important_to_me": importantToMe,
        "team_signature": teamSignature,
      };
}

class PersonalInfo {
  PersonalInfo({
    this.email,
    this.birthday,
    this.occupation,
    this.birthplace,
    this.aboutMe,
    this.joined,
    this.webUrl,
    this.fromLocation,
  });

  String? email;
  String? birthday;
  String? occupation;
  String? birthplace;
  String? aboutMe;
  String? joined;
  String? webUrl;
  String? fromLocation;

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
        email: json["email"],
        birthday: json["birthday"],
        occupation: json["occupation"],
        birthplace: json["birthplace"],
        aboutMe: json["about_me"],
        joined: json["joined"],
        webUrl: json["web_url"],
        fromLocation: json["from_location"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "birthday": birthday,
        "occupation": occupation,
        "birthplace": birthplace,
        "about_me": aboutMe,
        "joined": joined,
        "web_url": webUrl,
        "from_location": fromLocation,
      };
}

class Position {
  Position({
    this.title,
    this.description,
  });

  String? title;
  String? description;

  factory Position.fromJson(Map<String, dynamic> json) => Position(
        title: json["title"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
      };
}

class RoleResponsibility {
  RoleResponsibility(
      {this.title, this.description, this.review, this.isExpanded = false});

  String? title;
  String? description;
  List<Review>? review;
  bool isExpanded;

  factory RoleResponsibility.fromJson(Map<String, dynamic> json) =>
      RoleResponsibility(
        title: json["title"],
        description: json["description"],
        review: json["Review"] == null
            ? []
            : List<Review>.from(json["Review"]!.map((x) => Review.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "Review": review == null
            ? []
            : List<dynamic>.from(review!.map((x) => x.toJson())),
      };
}

class Review {
  Review({
    this.reviewTitle,
    this.reviewDesc,
  });

  String? reviewTitle;
  String? reviewDesc;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        reviewTitle: json["review_title"],
        reviewDesc: json["review_desc"],
      );

  Map<String, dynamic> toJson() => {
        "review_title": reviewTitle,
        "review_desc": reviewDesc,
      };
}
