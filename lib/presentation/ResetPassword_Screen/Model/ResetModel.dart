class ResetModel {
  bool? status;
  String? message;
  Error? error;

  ResetModel({this.status, this.message, this.error});

  ResetModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    error = json['error'] != null ? new Error.fromJson(json['error']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.error != null) {
      data['error'] = this.error!.toJson();
    }
    return data;
  }
}

class Error {
  String? name;
  String? message;
  String? expiredAt;

  Error({this.name, this.message, this.expiredAt});

  Error.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    message = json['message'];
    expiredAt = json['expiredAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['message'] = this.message;
    data['expiredAt'] = this.expiredAt;
    return data;
  }
}
