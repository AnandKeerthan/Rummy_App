class GuestRegisterModel {
  bool? status;
  String? message;
  String? deviceID;

  GuestRegisterModel({this.status, this.message, this.deviceID});

  GuestRegisterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    deviceID = json['deviceID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['deviceID'] = this.deviceID;
    return data;
  }
}
