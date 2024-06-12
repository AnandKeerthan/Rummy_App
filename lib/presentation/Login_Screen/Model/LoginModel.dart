class LoginModel {
  bool? status;
  String? message;
  Data? data;
  String? token;
  String? session;

  LoginModel({this.status, this.message, this.data, this.token, this.session});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    token = json['token'];
    session = json['session'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['token'] = this.token;
    data['session'] = this.session;
    return data;
  }
}

class Data {
  dynamic referralId;
  String? sId;
  String? email;
  String? password;
  String? encryptOTP;
  String? lastloginIpAddress;
  String? date;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? parentId;
  String? referralCode;

  Data(
      {this.referralId,
      this.sId,
      this.email,
      this.password,
      this.encryptOTP,
      this.lastloginIpAddress,
      this.date,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.parentId,
      this.referralCode});

  Data.fromJson(Map<String, dynamic> json) {
    referralId = json['referral_Id'];
    sId = json['_id'];
    email = json['email'];
    password = json['password'];
    encryptOTP = json['encryptOTP'];
    lastloginIpAddress = json['lastloginIpAddress'];
    date = json['date'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    parentId = json['parent_Id'];
    referralCode = json['referral_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['referral_Id'] = this.referralId;
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['password'] = this.password;
    data['encryptOTP'] = this.encryptOTP;
    data['lastloginIpAddress'] = this.lastloginIpAddress;
    data['date'] = this.date;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['parent_Id'] = this.parentId;
    data['referral_code'] = this.referralCode;
    return data;
  }
}
