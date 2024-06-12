class GetRegisterGuest {
  bool? status;
  String? message;
  Data? data;

  GetRegisterGuest({this.status, this.message, this.data});

  GetRegisterGuest.fromJson(Map<String, dynamic> json) {
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
  String? id;
  String? userAddress;
  String? guestDeviceId;
  int? guestStatus;

  Data({this.id, this.userAddress, this.guestDeviceId, this.guestStatus});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userAddress = json['userAddress'];
    guestDeviceId = json['guestDeviceId'];
    guestStatus = json['guestStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userAddress'] = this.userAddress;
    data['guestDeviceId'] = this.guestDeviceId;
    data['guestStatus'] = this.guestStatus;
    return data;
  }
}
