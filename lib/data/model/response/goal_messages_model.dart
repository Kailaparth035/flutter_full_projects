// To parse this JSON data, do
//
//     final goalMessagesModel = goalMessagesModelFromJson(jsonString);

import 'dart:convert';

GoalMessagesModel goalMessagesModelFromJson(String str) =>
    GoalMessagesModel.fromJson(json.decode(str));

String goalMessagesModelToJson(GoalMessagesModel data) =>
    json.encode(data.toJson());

class GoalMessagesModel {
  int? status;
  List<GoalMessage>? data;
  String? message;

  GoalMessagesModel({
    this.status,
    this.data,
    this.message,
  });

  factory GoalMessagesModel.fromJson(Map<String, dynamic> json) =>
      GoalMessagesModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<GoalMessage>.from(
                json["data"]!.map((x) => GoalMessage.fromJson(x))),
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

class GoalMessage {
  String? senderUserName;
  String? messagesText;
  String? created;

  GoalMessage({
    this.senderUserName,
    this.messagesText,
    this.created,
  });

  factory GoalMessage.fromJson(Map<String, dynamic> json) => GoalMessage(
        senderUserName: json["sender_user_name"],
        messagesText: json["messages_text"],
        created: json["created"],
      );

  Map<String, dynamic> toJson() => {
        "sender_user_name": senderUserName,
        "messages_text": messagesText,
        "created": created,
      };
}
