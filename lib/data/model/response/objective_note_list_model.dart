// To parse this JSON data, do
//
//     final objectiveNoteListModel = objectiveNoteListModelFromJson(jsonString);

import 'dart:convert';

ObjectiveNoteListModel objectiveNoteListModelFromJson(String str) =>
    ObjectiveNoteListModel.fromJson(json.decode(str));

String objectiveNoteListModelToJson(ObjectiveNoteListModel data) =>
    json.encode(data.toJson());

class ObjectiveNoteListModel {
  int? status;
  ObjectiveNoteListData? data;
  String? message;

  ObjectiveNoteListModel({
    this.status,
    this.data,
    this.message,
  });

  factory ObjectiveNoteListModel.fromJson(Map<String, dynamic> json) =>
      ObjectiveNoteListModel(
        status: json["status"],
        data: json["data"] == null
            ? null
            : ObjectiveNoteListData.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class ObjectiveNoteListData {
  String? generalNotes;
  String? developmentNotes;
  String? alignmentNotes;
  List<DevelopmentObjective>? developmentObjectives;
  List<AlignmentObjective>? alignmentObjectives;

  ObjectiveNoteListData({
    this.generalNotes,
    this.developmentNotes,
    this.alignmentNotes,
    this.developmentObjectives,
    this.alignmentObjectives,
  });

  factory ObjectiveNoteListData.fromJson(Map<String, dynamic> json) =>
      ObjectiveNoteListData(
        generalNotes: json["General_Notes"],
        developmentNotes: json["Development_Notes"],
        alignmentNotes: json["Alignment_Notes"],
        developmentObjectives: json["Development_Objectives"] == null
            ? []
            : List<DevelopmentObjective>.from(json["Development_Objectives"]!
                .map((x) => DevelopmentObjective.fromJson(x))),
        alignmentObjectives: json["Alignment_Objectives"] == null
            ? []
            : List<AlignmentObjective>.from(json["Alignment_Objectives"]!
                .map((x) => AlignmentObjective.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "General_Notes": generalNotes,
        "Development_Notes": developmentNotes,
        "Alignment_Notes": alignmentNotes,
        "Development_Objectives": developmentObjectives == null
            ? []
            : List<dynamic>.from(developmentObjectives!.map((x) => x.toJson())),
        "Alignment_Objectives": alignmentObjectives == null
            ? []
            : List<dynamic>.from(alignmentObjectives!.map((x) => x.toJson())),
      };
}

class AlignmentObjective {
  String? title;
  List<AlignmentObjectiveChildData>? child;

  AlignmentObjective({
    this.title,
    this.child,
  });

  factory AlignmentObjective.fromJson(Map<String, dynamic> json) =>
      AlignmentObjective(
        title: json["title"],
        child: json["child"] == null
            ? []
            : List<AlignmentObjectiveChildData>.from(json["child"]!
                .map((x) => AlignmentObjectiveChildData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "child": child == null
            ? []
            : List<dynamic>.from(child!.map((x) => x.toJson())),
      };
}

class AlignmentObjectiveChildData {
  String? id;
  String? title;

  AlignmentObjectiveChildData({
    this.id,
    this.title,
  });

  factory AlignmentObjectiveChildData.fromJson(Map<String, dynamic> json) =>
      AlignmentObjectiveChildData(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

class DevelopmentObjective {
  int? id;
  String? name;
  int? noteType;

  DevelopmentObjective({
    this.id,
    this.name,
    this.noteType,
  });

  factory DevelopmentObjective.fromJson(Map<String, dynamic> json) =>
      DevelopmentObjective(
        id: json["id"],
        name: json["name"],
        noteType: json["note_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "note_type": noteType,
      };
}
