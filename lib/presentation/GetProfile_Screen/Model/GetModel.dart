class GetProfileModel {
  bool? status;
  String? message;
  Data? data;

  GetProfileModel({this.status, this.message, this.data});

  GetProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  WalletUser? walletUser;
  String? tFAenablekey;

  Data({this.user, this.walletUser, this.tFAenablekey});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    walletUser = json['walletUser'] != null
        ? new WalletUser.fromJson(json['walletUser'])
        : null;
    tFAenablekey = json['TFAenablekey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.walletUser != null) {
      data['walletUser'] = this.walletUser!.toJson();
    }
    data['TFAenablekey'] = this.tFAenablekey;
    return data;
  }
}

class User {
  String? sId;
  String? userAddress;
  String? email;
  String? password;
  String? firstName;
  String? lastName;
  String? encryptOTP;
  String? encryptMobileOTP;
  num? emailVerifyStatus;
  num? mobileVerifyStatus;
  num? kycVerifyStatus;
  String? reason;
  num? activeStatus;
  String? tFAenablekey;
  num? securityKey;
  num? tFAStatus;
  bool? userStatus;
  List<KycDetails>? kycDetails;
  String? createdAt;
  String? updatedAt;
  num? iV;

  User(
      {this.sId,
      this.userAddress,
      this.email,
      this.password,
      this.firstName,
      this.lastName,
      this.encryptOTP,
      this.encryptMobileOTP,
      this.emailVerifyStatus,
      this.mobileVerifyStatus,
      this.kycVerifyStatus,
      this.reason,
      this.activeStatus,
      this.tFAenablekey,
      this.securityKey,
      this.tFAStatus,
      this.userStatus,
      this.kycDetails,
      this.createdAt,
      this.updatedAt,
      this.iV});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userAddress = json['userAddress'];
    email = json['email'];
    password = json['password'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    encryptOTP = json['encryptOTP'];
    encryptMobileOTP = json['encryptMobileOTP'];
    emailVerifyStatus = json['emailVerifyStatus'];
    mobileVerifyStatus = json['mobileVerifyStatus'];
    kycVerifyStatus = json['kycVerifyStatus'];
    reason = json['reason'];
    activeStatus = json['active_status'];
    tFAenablekey = json['TFAenablekey'];
    securityKey = json['securityKey'];
    tFAStatus = json['TFAStatus'];
    userStatus = json['user_status'];
    if (json['kycDetails'] != null) {
      kycDetails = <KycDetails>[];
      json['kycDetails'].forEach((v) {
        kycDetails!.add(new KycDetails.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userAddress'] = this.userAddress;
    data['email'] = this.email;
    data['password'] = this.password;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['encryptOTP'] = this.encryptOTP;
    data['encryptMobileOTP'] = this.encryptMobileOTP;
    data['emailVerifyStatus'] = this.emailVerifyStatus;
    data['mobileVerifyStatus'] = this.mobileVerifyStatus;
    data['kycVerifyStatus'] = this.kycVerifyStatus;
    data['reason'] = this.reason;
    data['active_status'] = this.activeStatus;
    data['TFAenablekey'] = this.tFAenablekey;
    data['securityKey'] = this.securityKey;
    data['TFAStatus'] = this.tFAStatus;
    data['user_status'] = this.userStatus;
    if (this.kycDetails != null) {
      data['kycDetails'] = this.kycDetails!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class KycDetails {
  String? idType;
  String? name;
  String? number;
  List<String>? images;
  String? sId;

  KycDetails({this.idType, this.name, this.number, this.images, this.sId});

  KycDetails.fromJson(Map<String, dynamic> json) {
    idType = json['IdType'];
    name = json['Name'];
    number = json['Number'];
    images = json['Images'].cast<String>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IdType'] = this.idType;
    data['Name'] = this.name;
    data['Number'] = this.number;
    data['Images'] = this.images;
    data['_id'] = this.sId;
    return data;
  }
}

class WalletUser {
  String? sId;
  String? userId;
  String? email;
  num? walletAmount;
  num? depositAmount;
  String? createdAt;
  String? updatedAt;
  num? iV;

  WalletUser(
      {this.sId,
      this.userId,
      this.email,
      this.walletAmount,
      this.depositAmount,
      this.createdAt,
      this.updatedAt,
      this.iV});

  WalletUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    email = json['email'];
    walletAmount = json['walletAmount'];
    depositAmount = json['depositAmount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userId'] = this.userId;
    data['email'] = this.email;
    data['walletAmount'] = this.walletAmount;
    data['depositAmount'] = this.depositAmount;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
