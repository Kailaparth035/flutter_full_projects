// To parse this JSON data, do
//
//     final otherUserModel = otherUserModelFromJson(jsonString);

import 'dart:convert';

OtherUserModel otherUserModelFromJson(String str) =>
    OtherUserModel.fromJson(json.decode(str));

String otherUserModelToJson(OtherUserModel data) => json.encode(data.toJson());

class OtherUserModel {
  int? status;
  OtherUserData? data;
  String? message;

  OtherUserModel({
    this.status,
    this.data,
    this.message,
  });

  factory OtherUserModel.fromJson(Map<String, dynamic> json) => OtherUserModel(
        status: json["status"],
        data:
            json["data"] == null ? null : OtherUserData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class OtherUserData {
  int? id;
  String? firstName;
  String? lastName;
  String? name;
  String? photo;
  String? aboutMe;
  String? roleName;
  String? positionName;
  String? positionDescription;
  int? lockProfile;
  int? circleOfInfluence;
  String? coverPhoto;

  OtherUserData(
      {this.id,
      this.firstName,
      this.lastName,
      this.name,
      this.photo,
      this.aboutMe,
      this.roleName,
      this.positionName,
      this.positionDescription,
      this.lockProfile,
      this.circleOfInfluence,
      this.coverPhoto});

  factory OtherUserData.fromJson(Map<String, dynamic> json) => OtherUserData(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        name: json["name"],
        photo: json["photo"],
        aboutMe: json["about_me"],
        roleName: json["role_name"],
        positionName: json["position_name"],
        positionDescription: json["position_description"],
        lockProfile: json["lock_profile"],
        circleOfInfluence: json["circle_of_influence"],
        coverPhoto: json["cover_photo"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "name": name,
        "photo": photo,
        "about_me": aboutMe,
        "role_name": roleName,
        "position_name": positionName,
        "position_description": positionDescription,
        "lock_profile": lockProfile,
        "circle_of_influence": circleOfInfluence,
      };
}
