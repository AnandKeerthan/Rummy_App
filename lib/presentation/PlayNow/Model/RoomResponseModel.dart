class RoomResponseModel {
  int? roomId;
  int? players;
  List<UsersInvolved>? usersInvolved;
  List<int>? remainingCards;
  int? matchStatus;
  int? gameStatus;
  String? jokerName;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  RoomResponseModel(
      {this.roomId,
      this.players,
      this.usersInvolved,
      this.remainingCards,
      this.matchStatus,
      this.gameStatus,
      this.jokerName,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  RoomResponseModel.fromJson(Map<String, dynamic> json) {
    roomId = json['roomId'];
    players = json['players'];
    if (json['usersInvolved'] != null) {
      usersInvolved = <UsersInvolved>[];
      json['usersInvolved'].forEach((v) {
        usersInvolved!.add(new UsersInvolved.fromJson(v));
      });
    }
    remainingCards = json['remainingCards'].cast<int>();
    matchStatus = json['matchStatus'];
    gameStatus = json['gameStatus'];
    jokerName = json['jokerName'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roomId'] = this.roomId;
    data['players'] = this.players;
    if (this.usersInvolved != null) {
      data['usersInvolved'] =
          this.usersInvolved!.map((v) => v.toJson()).toList();
    }
    data['remainingCards'] = this.remainingCards;
    data['matchStatus'] = this.matchStatus;
    data['gameStatus'] = this.gameStatus;
    data['jokerName'] = this.jokerName;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class UsersInvolved {
  String? userId;
  List<int>? cardNumbers;
  bool? movableStatus;
  String? sId;

  UsersInvolved({this.userId, this.cardNumbers, this.movableStatus, this.sId});

  UsersInvolved.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    cardNumbers = json['cardNumbers'].cast<int>();
    movableStatus = json['movableStatus'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['cardNumbers'] = this.cardNumbers;
    data['movableStatus'] = this.movableStatus;
    data['_id'] = this.sId;
    return data;
  }
}
