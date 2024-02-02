class ErrorResponse {
  ErrorResponse({
    this.status = false,
    this.errors,
  });

  ErrorResponse.fromJson(dynamic json) {
    status = json['status'];
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }

  bool? status;
  List<String>? errors;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['errors'] = errors;
    return map;
  }
}
