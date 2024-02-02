// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  int? status;
  ProfileData? data;
  String? message;

  ProfileModel({
    this.status,
    this.data,
    this.message,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        data: json["data"] == null ? null : ProfileData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ProfileData {
  int? id;
  String? name;
  String? photo;
  String? coverPhoto;

  String? positionName;
  String? positionDesc;
  String? roleName;
  String? aboutMe;
  String? firstName;
  String? lastName;
  String? dob;
  String? mobileNumber;
  String? genderId;
  String? genderName;
  String? title;

  String? address;
  String? countryId;
  String? countryName;
  String? stateId;
  String? stateName;
  String? city;
  String? zoneId;
  String? zoneName;
  String? zipCode;
  String? email;
  String? backupEmail;
  String? sortname;

  String? isShowMyWorkplace;

  String? meetingLink;
  String? experience;
  String? minPrice;
  String? maxPrice;
  String? bio;
  String? specialties;
  String? roleId;
  String? myReferralCode;
  String? referalSubject;
  String? referalText;

  String? companyPhoto;
  String? badgePhoto;
  String? badgeName;
  String? expirationText;
  int? notificationCount;
  String? circleOfInfluence;

  bool? isShowTourOverlay;

  ProfileData({
    this.id,
    this.name,
    this.photo,
    this.coverPhoto,
    this.positionName,
    this.positionDesc,
    this.roleName,
    this.aboutMe,
    this.firstName,
    this.lastName,
    this.dob,
    this.mobileNumber,
    this.genderId,
    this.genderName,
    this.address,
    this.countryId,
    this.countryName,
    this.city,
    this.zoneId,
    this.zoneName,
    this.zipCode,
    this.email,
    this.backupEmail,
    this.stateId,
    this.stateName,
    this.sortname,
    this.meetingLink,
    this.experience,
    this.minPrice,
    this.maxPrice,
    this.bio,
    this.specialties,
    this.roleId,
    this.isShowMyWorkplace,
    this.myReferralCode,
    this.referalSubject,
    this.referalText,
    this.companyPhoto,
    this.badgePhoto,
    this.badgeName,
    this.expirationText,
    this.notificationCount,
    this.title,
    this.circleOfInfluence,
    this.isShowTourOverlay,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["id"],
        name: json["name"] ?? "",
        title: json["title"] ?? "",
        photo: json["photo"] ?? "",
        coverPhoto: json["cover_photo"] ?? "",
        positionName: json["position_name"] ?? "",
        positionDesc: json["position_desc"] ?? "",
        roleName: json["role_name"] ?? "",
        aboutMe: json["about_me"] ?? "",
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        dob: json["dob"] ?? "",
        mobileNumber: json["mobile_number"] ?? "",
        genderId: json["gender_id"] == null ? "" : json["gender_id"].toString(),
        genderName: json["gender_name"] ?? "",
        address: json["address"] ?? "",
        countryId:
            json["country_id"] == null ? "" : json["country_id"].toString(),
        countryName: json["country_name"] ?? "",
        stateId: json["state_id"] == null ? "" : json["state_id"].toString(),
        stateName: json["state_name"] ?? "",
        city: json["city"] ?? "",
        zoneId: json["zone_id"] == null ? "" : json["zone_id"].toString(),
        zoneName: json["zone_name"] ?? "",
        zipCode: json["zip_code"] ?? "",
        email: json["email"] ?? "",
        sortname: json["sortname"] ?? "",
        backupEmail:
            json["backup_email"] == null ? "" : json["backup_email"].toString(),
        meetingLink:
            json["meeting_link"] == null ? "" : json["meeting_link"].toString(),
        experience:
            json["experience"] == null ? "" : json["experience"].toString(),
        minPrice: json["min_price"] == null ? "" : json["min_price"].toString(),
        maxPrice: json["max_price"] == null ? "" : json["max_price"].toString(),
        bio: json["bio"] == null ? "" : json["bio"].toString(),
        specialties:
            json["specialties"] == null ? "" : json["specialties"].toString(),
        roleId: json["role_id"] == null ? "" : json["role_id"].toString(),
        isShowMyWorkplace: json["is_show_my_workplace"] == null
            ? ""
            : json["is_show_my_workplace"].toString(),
        myReferralCode: json["my_referral_code"] == null
            ? ""
            : json["my_referral_code"].toString(),
        referalSubject: json["referal_subject"] == null
            ? ""
            : json["referal_subject"].toString(),
        referalText:
            json["referal_text"] == null ? "" : json["referal_text"].toString(),
        companyPhoto: json["company_photo"] ?? "",
        badgePhoto: json["badge_photo"] ?? "",
        badgeName: json["badge_name"] ?? "",
        expirationText: json["expiration_text"] ?? "",
        notificationCount: json["notification_count"] ?? 0,
        circleOfInfluence: json["circle_of_influence"]?.toString() ?? "0",
        isShowTourOverlay: json["is_show_tour_overlay"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "photo": photo,
        "position_name": positionName,
        "position_desc": positionDesc,
        "role_name": roleName,
        "about_me": aboutMe,
        "first_name": firstName,
        "last_name": lastName,
        "dob": dob,
        "mobile_number": mobileNumber,
        "gender_id": genderId,
        "gender_name": genderName,
        "address": address,
        "country_id": countryId,
        "country_name": countryName,
        "city": city,
        "zone_id": zoneId,
        "zone_name": zoneName,
        "zip_code": zipCode,
        "sortname": sortname,
        "meeting_link": meetingLink,
        "experience": experience,
        "min_price": minPrice,
        "max_price": maxPrice,
        "bio": bio,
        "specialties": specialties,
        "role_id": roleId,
      };
}
