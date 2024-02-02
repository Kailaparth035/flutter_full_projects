// To parse this JSON data, do
//
//     final notificationSettingModel = notificationSettingModelFromJson(jsonString);

import 'dart:convert';

NotificationSettingModel notificationSettingModelFromJson(String str) =>
    NotificationSettingModel.fromJson(json.decode(str));

String notificationSettingModelToJson(NotificationSettingModel data) =>
    json.encode(data.toJson());

class NotificationSettingModel {
  int? status;
  NotificationSettingData? data;
  String? message;

  NotificationSettingModel({
    this.status,
    this.data,
    this.message,
  });

  factory NotificationSettingModel.fromJson(Map<String, dynamic> json) =>
      NotificationSettingModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : NotificationSettingData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class NotificationSettingData {
  int? appAllowNotification;
  MessagesNotesComments? messagesNotesComments;
  PerformanceInvitation? performanceInvitation;
  DevelopmentInvitation? developmentInvitation;
  FollowersRequest? followersRequest;
  QuestionNotification? questionNotification;
  LicenseAssignNotification? licenseAssignNotification;
  ProjectArchiveNotification? projectArchiveNotification;
  SuccessionPlanningNotification? successionPlanningNotification;
  DailyqReminder? dailyqReminder;

  NotificationSettingData({
    this.messagesNotesComments,
    this.performanceInvitation,
    this.developmentInvitation,
    this.followersRequest,
    this.questionNotification,
    this.licenseAssignNotification,
    this.projectArchiveNotification,
    this.successionPlanningNotification,
    this.appAllowNotification,
    this.dailyqReminder,
  });

  factory NotificationSettingData.fromJson(Map<String, dynamic> json) =>
      NotificationSettingData(
        messagesNotesComments: json["Messages_Notes_Comments"] == null
            ? null
            : MessagesNotesComments.fromJson(json["Messages_Notes_Comments"]),
        performanceInvitation: json["Performance_Invitation"] == null
            ? null
            : PerformanceInvitation.fromJson(json["Performance_Invitation"]),
        developmentInvitation: json["Development_Invitation"] == null
            ? null
            : DevelopmentInvitation.fromJson(json["Development_Invitation"]),
        followersRequest: json["Followers_Request"] == null
            ? null
            : FollowersRequest.fromJson(json["Followers_Request"]),
        questionNotification: json["Question_Notification"] == null
            ? null
            : QuestionNotification.fromJson(json["Question_Notification"]),
        licenseAssignNotification: json["License_Assign_Notification"] == null
            ? null
            : LicenseAssignNotification.fromJson(
                json["License_Assign_Notification"]),
        projectArchiveNotification: json["Project_Archive_Notification"] == null
            ? null
            : ProjectArchiveNotification.fromJson(
                json["Project_Archive_Notification"]),
        successionPlanningNotification:
            json["Succession_Planning_Notification"] == null
                ? null
                : SuccessionPlanningNotification.fromJson(
                    json["Succession_Planning_Notification"]),
        appAllowNotification: json["app_allow_notification"],
        dailyqReminder: json["Dailyq_Reminder"] == null
            ? null
            : DailyqReminder.fromJson(json["Dailyq_Reminder"]),
      );

  Map<String, dynamic> toJson() => {
        "Messages_Notes_Comments": messagesNotesComments?.toJson(),
        "Performance_Invitation": performanceInvitation?.toJson(),
        "Development_Invitation": developmentInvitation?.toJson(),
        "Followers_Request": followersRequest?.toJson(),
        "Question_Notification": questionNotification?.toJson(),
        "License_Assign_Notification": licenseAssignNotification?.toJson(),
        "Project_Archive_Notification": projectArchiveNotification?.toJson(),
        "Succession_Planning_Notification":
            successionPlanningNotification?.toJson(),
        "Dailyq_Reminder": dailyqReminder?.toJson(),
      };
}

class DevelopmentInvitation {
  int? developmentInvitationInbox;
  int? developmentInvitationMail;
  int? developmentInvitationSlack;
  int? isSlackAvailable;

  DevelopmentInvitation({
    this.developmentInvitationInbox,
    this.developmentInvitationMail,
    this.developmentInvitationSlack,
    this.isSlackAvailable,
  });

  factory DevelopmentInvitation.fromJson(Map<String, dynamic> json) =>
      DevelopmentInvitation(
        developmentInvitationInbox: json["development_invitation_inbox"],
        developmentInvitationMail: json["development_invitation_mail"],
        developmentInvitationSlack: json["development_invitation_slack"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "development_invitation_inbox": developmentInvitationInbox,
        "development_invitation_mail": developmentInvitationMail,
        "development_invitation_slack": developmentInvitationSlack,
        "is_slack_available": isSlackAvailable,
      };
}

class FollowersRequest {
  int? followerRequestInbox;
  int? followerRequestMail;
  int? followerRequestSlack;
  int? isSlackAvailable;

  FollowersRequest({
    this.followerRequestInbox,
    this.followerRequestMail,
    this.followerRequestSlack,
    this.isSlackAvailable,
  });

  factory FollowersRequest.fromJson(Map<String, dynamic> json) =>
      FollowersRequest(
        followerRequestInbox: json["follower_request_inbox"],
        followerRequestMail: json["follower_request_mail"],
        followerRequestSlack: json["follower_request_slack"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "follower_request_inbox": followerRequestInbox,
        "follower_request_mail": followerRequestMail,
        "follower_request_slack": followerRequestSlack,
        "is_slack_available": isSlackAvailable,
      };
}

class LicenseAssignNotification {
  int? licenseAssignNotificationInbox;
  int? licenseAssignNotificationMail;
  int? licenseAssignNotificationSlack;
  int? isSlackAvailable;

  LicenseAssignNotification({
    this.licenseAssignNotificationInbox,
    this.licenseAssignNotificationMail,
    this.licenseAssignNotificationSlack,
    this.isSlackAvailable,
  });

  factory LicenseAssignNotification.fromJson(Map<String, dynamic> json) =>
      LicenseAssignNotification(
        licenseAssignNotificationInbox:
            json["license_assign_notification_inbox"],
        licenseAssignNotificationMail: json["license_assign_notification_mail"],
        licenseAssignNotificationSlack:
            json["license_assign_notification_slack"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "license_assign_notification_inbox": licenseAssignNotificationInbox,
        "license_assign_notification_mail": licenseAssignNotificationMail,
        "license_assign_notification_slack": licenseAssignNotificationSlack,
        "is_slack_available": isSlackAvailable,
      };
}

class MessagesNotesComments {
  int? oneNoteInbox;
  int? oneNoteMail;
  int? oneNoteSlack;
  int? oneNoteSMS;
  int? isSlackAvailable;

  MessagesNotesComments({
    this.oneNoteInbox,
    this.oneNoteMail,
    this.oneNoteSlack,
    this.isSlackAvailable,
    this.oneNoteSMS,
  });

  factory MessagesNotesComments.fromJson(Map<String, dynamic> json) =>
      MessagesNotesComments(
        oneNoteInbox: json["one_note_inbox"],
        oneNoteMail: json["one_note_mail"],
        oneNoteSlack: json["one_note_slack"],
        oneNoteSMS: json["one_note_sms"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "one_note_inbox": oneNoteInbox,
        "one_note_mail": oneNoteMail,
        "one_note_slack": oneNoteSlack,
        "one_note_sms": oneNoteSMS,
        "is_slack_available": isSlackAvailable,
      };
}

class PerformanceInvitation {
  int? performanceInvitationInbox;
  int? performanceInvitationMail;
  int? performanceInvitationSlack;
  int? isSlackAvailable;

  PerformanceInvitation({
    this.performanceInvitationInbox,
    this.performanceInvitationMail,
    this.performanceInvitationSlack,
    this.isSlackAvailable,
  });

  factory PerformanceInvitation.fromJson(Map<String, dynamic> json) =>
      PerformanceInvitation(
        performanceInvitationInbox: json["performance_invitation_inbox"],
        performanceInvitationMail: json["performance_invitation_mail"],
        performanceInvitationSlack: json["performance_invitation_slack"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "performance_invitation_inbox": performanceInvitationInbox,
        "performance_invitation_mail": performanceInvitationMail,
        "performance_invitation_slack": performanceInvitationSlack,
        "is_slack_available": isSlackAvailable,
      };
}

class ProjectArchiveNotification {
  int? projectArchiveNotificationInbox;
  int? projectArchiveNotificationEmail;
  int? projectArchiveNotificationSlack;
  int? isSlackAvailable;

  ProjectArchiveNotification({
    this.projectArchiveNotificationInbox,
    this.projectArchiveNotificationEmail,
    this.projectArchiveNotificationSlack,
    this.isSlackAvailable,
  });

  factory ProjectArchiveNotification.fromJson(Map<String, dynamic> json) =>
      ProjectArchiveNotification(
        projectArchiveNotificationInbox:
            json["project_archive_notification_inbox"],
        projectArchiveNotificationEmail:
            json["project_archive_notification_email"],
        projectArchiveNotificationSlack:
            json["project_archive_notification_slack"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "project_archive_notification_inbox": projectArchiveNotificationInbox,
        "project_archive_notification_email": projectArchiveNotificationEmail,
        "project_archive_notification_slack": projectArchiveNotificationSlack,
        "is_slack_available": isSlackAvailable,
      };
}

class QuestionNotification {
  int? questionNotificationInbox;
  int? questionNotificationMail;
  int? questionNotificationSlack;
  int? isSlackAvailable;

  QuestionNotification({
    this.questionNotificationInbox,
    this.questionNotificationMail,
    this.questionNotificationSlack,
    this.isSlackAvailable,
  });

  factory QuestionNotification.fromJson(Map<String, dynamic> json) =>
      QuestionNotification(
        questionNotificationInbox: json["question_notification_inbox"],
        questionNotificationMail: json["question_notification_mail"],
        questionNotificationSlack: json["question_notification_slack"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "question_notification_inbox": questionNotificationInbox,
        "question_notification_mail": questionNotificationMail,
        "question_notification_slack": questionNotificationSlack,
        "is_slack_available": isSlackAvailable,
      };
}

class SuccessionPlanningNotification {
  int? successionalInvitationInbox;
  int? successionalInvitationEmail;
  int? successionalInvitationSlack;
  int? isSlackAvailable;

  SuccessionPlanningNotification({
    this.successionalInvitationInbox,
    this.successionalInvitationEmail,
    this.successionalInvitationSlack,
    this.isSlackAvailable,
  });

  factory SuccessionPlanningNotification.fromJson(Map<String, dynamic> json) =>
      SuccessionPlanningNotification(
        successionalInvitationInbox: json["successional_invitation_inbox"],
        successionalInvitationEmail: json["successional_invitation_email"],
        successionalInvitationSlack: json["successional_invitation_slack"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "successional_invitation_inbox": successionalInvitationInbox,
        "successional_invitation_email": successionalInvitationEmail,
        "successional_invitation_slack": successionalInvitationSlack,
        "is_slack_available": isSlackAvailable,
      };
}

class DailyqReminder {
  int? dailyqReminderEmail;
  int? dailyqReminderSms;
  int? dailyqReminderSlack;
  int? isSlackAvailable;

  DailyqReminder({
    this.dailyqReminderEmail,
    this.dailyqReminderSms,
    this.dailyqReminderSlack,
    this.isSlackAvailable,
  });

  factory DailyqReminder.fromJson(Map<String, dynamic> json) => DailyqReminder(
        dailyqReminderEmail: json["dailyq_reminder_email"],
        dailyqReminderSms: json["dailyq_reminder_sms"],
        dailyqReminderSlack: json["dailyq_reminder_slack"],
        isSlackAvailable: json["is_slack_available"],
      );

  Map<String, dynamic> toJson() => {
        "dailyq_reminder_email": dailyqReminderEmail,
        "dailyq_reminder_sms": dailyqReminderSms,
        "dailyq_reminder_slack": dailyqReminderSlack,
        "is_slack_available": isSlackAvailable,
      };
}
