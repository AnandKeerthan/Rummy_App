class TwoFaModel {
  bool? status;
  String? message;
  int? type;

  TwoFaModel({this.status, this.message, this.type});

  TwoFaModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['type'] = this.type;
    return data;
  }
}
