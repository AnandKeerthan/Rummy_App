import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dsrummy/App_Export/app_export.dart';
import 'package:dsrummy/Storage/ProfileData.dart';
import 'package:dsrummy/Utlilities/App_Text/App_Text.dart';
import 'package:dsrummy/Utlilities/Images/image_constant.dart';
import 'package:dsrummy/Utlilities/Loader/Loader.dart';
import 'package:dsrummy/api_service/Remote/Network/ApiEndPoints.dart';
import 'package:dsrummy/presentation/GetProfile_Screen/ViewModel/GetProfileVm.dart';
import 'package:dsrummy/presentation/PlayNow/GameConst.dart';
import 'package:dsrummy/presentation/PlayNow/Model/RoomResponseModel.dart';
import 'package:dsrummy/presentation/PlayNow/SequenceList.dart';
import 'package:dsrummy/presentation/PlayNow/card_sprite_utils.dart';
import 'package:dsrummy/presentation/PopUp/PlayExitAlert.dart';
import 'package:dsrummy/presentation/PopUp/WinnerPopUp.dart';
import 'package:dsrummy/presentation/PopUp/WrongDeclare.dart';
import 'package:dsrummy/socketsDetails/WebSocketStream.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PlayBattle extends StatefulWidget {
  bool playerStatus;
  dynamic amount;
  bool cpu;
  PlayBattle(
      {Key? key,
      required this.playerStatus,
      required this.amount,
      required this.cpu})
      : super(key: key);

  @override
  _PlayBattleState createState() => _PlayBattleState();
}

class _PlayBattleState extends State<PlayBattle> {
  bool sizeChange = false;
  int itemLen = 12;
  List<bool> servedPages = [];
  List<bool> flipPages = [];
  late Timer servingTimer;
  late Timer flipingTimer;

  int _duration = 30;
  final CountDownController _controller = CountDownController();

  @override
  void initState() {
    socket = IO.io(ApiEndPoints().baseUrl,
        IO.OptionBuilder().setTransports(['websocket']).build());
    Future.delayed(Duration(milliseconds: 1000), () {
      connectToServer();
      pureSequenceFetch();
      sequenceFetch();
      cardShuffle();
    });
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    // sizeChangeAnimation();
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    // servingTimer.cancel();
    // flipingTimer.cancel();
    super.dispose();
  }

  //------------------------Socket Functions Start-----------------------------

  late IO.Socket socket;
  WebSocketStream webSocketStream = WebSocketStream();
  int? roomIdVal;
  int? matchStatus;
  BuildContext? ctxt;
  int? userInvolvedLength;
  String? cpuID;

  // GetProfileVM getProfileVM = GetProfileVM();

  void connectToServer() {
    socket.onConnect((data) => print('Connection established'));
    socket.onConnectError((data) => print('Connect Error: $data'));
    socket.onDisconnect((data) => print('Socket.IO server disconnected'));
  }

  bool admin = false;

  socketFetch(List playerCards) {
    List fourPlayerCards = [];
    fourPlayerCards.addAll(playerCards + playerCards);
    print(walletAddress.$);
    socket.emit("createRoom", {
      "userAddress": walletAddress.$,
      "players": widget.cpu
          ? 1
          : widget.playerStatus
              ? 4
              : 2,
      "shuffledNumbers": widget.playerStatus ? fourPlayerCards : playerCards,
      "jokerName": GameConst.cardsName[playerCards[0]],
      "amount": widget.amount
    });
    print(walletAddress.$);
    socket.on("createRoomRes", (response) {
      print(response);
      Future.delayed(Duration(seconds: 15), () {
        // setState(() {
        admin = true;
        // });
        if (response["matchStatus"] == 0 && response["gameStatus"] == 0) {
          socket.emit("createRoom", {
            "admin": "admin",
            // "userAddress": walletAddress.$,
            "players": widget.cpu
                ? 1
                : widget.playerStatus
                    ? 4
                    : 2,
            "shuffledNumbers":
                widget.playerStatus ? fourPlayerCards : playerCards,
            "jokerName": GameConst.cardsName[playerCards[0]],
            "amount": widget.amount
          });
        }
      });
      matchStatus = response["matchStatus"];
      userInvolvedLength = response["usersInvolved"].length;
      if (response["winner"]["cardNumbers"].isNotEmpty &&
          response["roomId"] == roomIdVal) {
        socket.off("createRoomRes");
        print(userID.$);
        if ((response["winner"]["userId"] == userID.$ &&
            response["winner"]["winningStatus"] == true)) {
          showDialog(
            context: ctxt!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Winner(snapshotData: response);
            },
          );
        } else if (response["winner"]["userId"] != userID.$ &&
            response["winner"]["winningStatus"] == false) {
          showDialog(
            context: ctxt!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Winner(snapshotData: response);
            },
          );
        } else if (widget.playerStatus == false ||
            response["usersInvolved"].length <= 2 ||
            response["winner"]["wrongDeclare"] == false) {
          showDialog(
            context: ctxt!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return WrongDeclare(snapshotData: response);
            },
          );
        }
      }
      for (var item in response["usersInvolved"]) {
        if (item["userId"] == userID.$ &&
            response["matchStatus"] == 1 &&
            response["gameStatus"] == 1) {
          webSocketStream.addResponse(response);
          _controller.start();
          if (_controller.isStarted == false) {
            _controller.restart(duration: _duration);
          }
          Future.delayed(Duration(milliseconds: 400), () {
            drag = true;

            // startTimer();
            // socket.off("createRoomRes");
          });
        } else if (widget.cpu == true && item["userId"] != userID.$) {
          cpuID = item["_id"];
        }
      }
      for (var item in response["usersInvolved"]) {
        if (item["userId"] == userID.$) {
          roomIdVal = response["roomId"];
          rummyJoker = response["jokerName"];
        }
      }
      // if (roomIdVal != null &&
      //     response["roomId"] == roomIdVal &&
      //     response["usersInvolved"].contains(userID.$) == false) {
      //   Navigator.pop(ctxt!);
      // }
    });
    socket.on("exitUserRes", (response) {
      print("!!!!!!!!!$response");
      if (response["userId"] == userID.$) {
        Navigator.pop(ctxt!);
        Navigator.pop(ctxt!);
      }
    });
  }

  changeTurn(Map<String, dynamic> data) {
    socket.emit("changeTurn", data);
  }

  takeCard(Map<String, dynamic> data) {
    socket.emit("cardsTaken", data);
  }

  dropCard(Map<String, dynamic> data) {
    socket.emit("dropCards", data);
    if (widget.cpu || admin) {
      cpuTakenDrop();
    }
    // _controller.restart(duration: _duration);
  }

  cpuTakenDrop() {
    socket.emit("cardsTaken",
        {"roomId": roomIdVal, "userId": cpuID, "cardNo": "", "takenFrom": ""});
    Future.delayed((Duration(seconds: admin ? 15 : 3)), () {
      socket.emit(
          "dropCards", {"roomId": roomIdVal, "userId": cpuID, "cardNo": ""});
    });
  }

  finishCard(Map<String, dynamic> data) {
    print("@@@@@@@$data");
    if (widget.cpu == true && data["wrongDeclare"] == false) {
      data.addAll({"type": "practice"});
    }
    if (widget.playerStatus &&
        declaration() == false &&
        userInvolvedLength! > 2) {
      changeTurn({"roomId": roomIdVal, "userId": userID.$});
      showDialog(
        context: ctxt!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WrongDeclare(snapshotData: "");
        },
      );
    }
    socket.emit("publishWinners", data);
  }

  exitGame(Map<String, dynamic> data) {
    socket.emit("exitUser", data);
  }

  //------------------------Socket Functions End-------------------------------

  //------------------------Card Functions Start-------------------------------

  List cardIndex = [];
  List balanceCards = [];
  List droppedCards = [];
  List finished = [];
  String? rummyJoker;
  bool drag = false;

  List<int> firstPhase = [];
  List<int> secondPhase = [];
  List<int> thirdPhase = [];
  List<int> fourthPhase = [];
  List<int> fifthPhase = [];
  List<int> sixthPhase = [];

  int one = 0;
  int two = 0;
  int three = 0;
  int four = 0;
  int five = 0;

  Map<String, dynamic> tempCard = {};

  cardShuffle() {
    // for (var i = 0; i <= itemLen; i++) {
    //   setState(() {
    //     servedPages.add(false);
    //     flipPages.add(false);
    //   });
    // }
    for (var i = 1; i <= 54; i++) {
      setState(() {
        cardIndex.add(i);
      });
    }
    cardIndex.shuffle();
    socketFetch(cardIndex);
  }

  List pureSequenceList = [];
  List sequenceList = [];

  pureSequenceFetch() {
    for (int i = 3; i <= 13; i++) {
      for (int j = 0; j <= 13 - i; j++) {
        List<int> innerList = [];

        for (int k = 1; k <= i; k++) {
          innerList.add(k + j);
        }
        pureSequenceList.add(innerList);
      }
    }
  }

  sequenceFetch() {
    for (int i = 3; i <= 13; i++) {
      for (int j = 0; j <= 13 - i; j++) {
        List<int> innerList = [];
        for (int k = 1; k <= i; k++) {
          innerList.add(k + j);
        }
        for (int l = 0; l < innerList.length; l++) {
          List oneJoker = List.from(innerList);
          oneJoker[l] = 53;
          sequenceList.add(oneJoker);

          List twoJoker = List.from(innerList);

          if (l < innerList.length - 1) {
            twoJoker[l] = 53;
            twoJoker[l + 1] = 53;
            sequenceList.add(twoJoker);
          }

          List threeJoker = List.from(innerList);

          if (l < innerList.length - 2 && innerList.length > 3) {
            threeJoker[l] = 53;
            threeJoker[l + 1] = 53;
            threeJoker[l + 2] = 53;
            sequenceList.add(threeJoker);
          }

          List fourJoker = List.from(innerList);

          if (l < innerList.length - 3 && innerList.length > 4) {
            fourJoker[l] = 53;
            fourJoker[l + 1] = 53;
            fourJoker[l + 2] = 53;
            fourJoker[l + 3] = 53;
            sequenceList.add(fourJoker);
          }

          List fiveJoker = List.from(innerList);

          if (l < innerList.length - 4 && innerList.length > 5) {
            fiveJoker[l] = 53;
            fiveJoker[l + 1] = 53;
            fiveJoker[l + 2] = 53;
            fiveJoker[l + 3] = 53;
            fiveJoker[l + 4] = 53;
            sequenceList.add(fiveJoker);
          }

          List sixJoker = List.from(innerList);

          if (l < innerList.length - 5 && innerList.length > 6) {
            sixJoker[l] = 53;
            sixJoker[l + 1] = 53;
            sixJoker[l + 2] = 53;
            sixJoker[l + 3] = 53;
            sixJoker[l + 4] = 53;
            sixJoker[l + 5] = 53;
            sequenceList.add(sixJoker);
          }

          List sevenJoker = List.from(innerList);

          if (l < innerList.length - 6 && innerList.length > 7) {
            sevenJoker[l] = 53;
            sevenJoker[l + 1] = 53;
            sevenJoker[l + 2] = 53;
            sevenJoker[l + 3] = 53;
            sevenJoker[l + 4] = 53;
            sevenJoker[l + 5] = 53;
            sevenJoker[l + 6] = 53;
            sequenceList.add(sevenJoker);
          }

          List eightJoker = List.from(innerList);

          if (l < innerList.length - 7 && innerList.length > 8) {
            eightJoker[l] = 53;
            eightJoker[l + 1] = 53;
            eightJoker[l + 2] = 53;
            eightJoker[l + 3] = 53;
            eightJoker[l + 4] = 53;
            eightJoker[l + 5] = 53;
            eightJoker[l + 6] = 53;
            eightJoker[l + 7] = 53;
            sequenceList.add(eightJoker);
          }
        }
      }
    }
  }

  cardSplit(AsyncSnapshot<dynamic> snapshot) {
    String str = json.encode(snapshot.data);
    RoomResponseModel roomResponseModel =
        RoomResponseModel.fromJson(jsonDecode(str));
    for (var userCards in roomResponseModel.usersInvolved!) {
      if (userCards.userId == userID.$) {
        // setState(() {
        // rummyJoker = roomResponseModel.jokerName;
        // print(rummyJoker);
        // droppedCards.add(roomResponseModel.remainingCards![0]);
        // });
        if (drag == false) {
          for (var cardNumber in userCards.cardNumbers!) {
            if (cardNumber <= 13) {
              firstPhase.add(cardNumber);
              one++;
            } else if (cardNumber >= 14 && cardNumber <= 26) {
              secondPhase.add(cardNumber);
              two++;
            } else if (cardNumber >= 27 && cardNumber <= 39) {
              thirdPhase.add(cardNumber);
              three++;
            } else if (cardNumber >= 40 && cardNumber <= 52) {
              fourthPhase.add(cardNumber);
              four++;
            } else if (cardNumber >= 53 && cardNumber <= 54) {
              fifthPhase.add(cardNumber);
              five++;
            }
          }
        }
      }
    }
  }

  //------------------------Card Functions End---------------------------------

  sizeChangeAnimation() {
    int serveCounter = 0;
    int flipCounter = 0;
    servingTimer =
        Timer.periodic(const Duration(milliseconds: 400), (serveTimer) {
      if (!mounted) return;
      setState(() {
        servedPages[serveCounter] = true;
      });
      serveCounter++;
      if (serveCounter == itemLen + 1) {
        serveTimer.cancel();
        servingTimer.cancel();
        flipingTimer = Timer.periodic(Duration(milliseconds: 400), (flipTimer) {
          if (!mounted) return;
          setState(() {
            flipPages[flipCounter] = true;
          });
          flipCounter++;
          if (flipCounter == itemLen + 1) {
            flipTimer.cancel();
            flipingTimer.cancel();
          }
        });
      }
    });
  }

  //------------------------Calculation Functions Start------------------------

  int cardLength() {
    int len = firstPhase.length +
        secondPhase.length +
        thirdPhase.length +
        fourthPhase.length +
        fifthPhase.length +
        sixthPhase.length;
    return len;
  }

  int findMissingNumber(List<int> values) {
    int min = values.reduce((curr, next) => curr < next ? curr : next);
    int max = values.reduce((curr, next) => curr > next ? curr : next);

    for (int i = min; i <= max; i++) {
      if (!values.contains(i)) {
        return i;
      }
    }

    return -1;
  }

  int declarePoints() {
    int pointsValue = 0;
    setState(() {
      if (firstPhase.isNotEmpty) {
        pointsValue += (isSequential(firstPhase) == 1 ||
                    isSequentialKQJA(firstPhase) == 1 ||
                    toSetCheck(firstPhase)) &&
                firstPhase.length >= 3
            ? 0
            : points(firstPhase);
        print(pointsValue);
      }
      if (secondPhase.isNotEmpty) {
        pointsValue += (isSequential(secondPhase) == 1 ||
                    isSequentialKQJA(secondPhase) == 1 ||
                    toSetCheck(secondPhase)) &&
                secondPhase.length >= 3
            ? 0
            : points(secondPhase);
      }
      if (thirdPhase.isNotEmpty) {
        pointsValue += (isSequential(thirdPhase) == 1 ||
                    isSequentialKQJA(thirdPhase) == 1 ||
                    toSetCheck(thirdPhase)) &&
                thirdPhase.length >= 3
            ? 0
            : points(thirdPhase);
      }
      if (fourthPhase.isNotEmpty) {
        pointsValue += (isSequential(fourthPhase) == 1 ||
                    isSequentialKQJA(fourthPhase) == 1 ||
                    toSetCheck(fourthPhase)) &&
                fourthPhase.length >= 3
            ? 0
            : points(fourthPhase);
      }
      if (fifthPhase.isNotEmpty) {
        pointsValue += (isSequential(fifthPhase) == 1 ||
                    isSequentialKQJA(fifthPhase) == 1 ||
                    toSetCheck(fifthPhase)) &&
                fifthPhase.length >= 3
            ? 0
            : points(fifthPhase);
      }
      if (sixthPhase.isNotEmpty) {
        pointsValue += (isSequential(sixthPhase) == 1 ||
                    isSequentialKQJA(sixthPhase) == 1 ||
                    toSetCheck(sixthPhase)) &&
                sixthPhase.length >= 3
            ? 0
            : points(sixthPhase);
      }
    });
    print(pointsValue);
    return pointsValue;
  }

  int points(List<int> val) {
    int totalPoints = 0;
    for (int i = 0; i < val.length; i++) {
      if (rummyJoker!.contains(GameConst.cardsName[val[i]])) {
        totalPoints = totalPoints + 0;
      } else {
        totalPoints = totalPoints + GameConst.points[val[i]];
      }
    }
    return totalPoints;
  }

  //------------------------Calculation Functions End--------------------------

  //------------------------Boolean Functions Start----------------------------

  String statusName(int val) {
    return val == 0
        ? "Invalid"
        : val == 1
            ? "Pure Sequence"
            : "Sequence";
  }

  int isSequential1(List<int> numbers) {
    if (numbers.length >= 3) {
      int? val = 0;
      bool rummy = false;
      List<int> num = List.from(numbers);
      for (int i = 0; i < num.length; i++) {
        if (rummyJoker == GameConst.cardsName[num[i]] ||
            GameConst.cardsName[num[i]] == "Joker") {
          int n = num[i];
          num.removeAt(i);
          if (findMissingNumber(num) > 0) {
            if (findMissingNumber(num) != n) {
              rummy = true;
            }
            num.add(findMissingNumber(num));
          } else {
            rummy = true;
          }
        }
      }
      num.sort((a, b) => a.toInt().compareTo(b.toInt()));
      for (int i = 1; i < num.length; i++) {
        if (num[i] != num[i - 1] + 1) {
          val = 0;
          break;
        }
        val = rummy ? 2 : 1;
      }
      return val!;
    }
    return 0;
  }

  int isSequential(List<int> numbers) {
    if (numbers.length >= 3) {
      int? val = 0;
      List<int> num = List.from(numbers);
      // num.sort((a, b) => a.compareTo(b));
      // print(rummyJoker);

      num.sort((a, b) => a.compareTo(b));
      // print(num);
      for (int i = 0; i < GameConst.pureSequence.length; i++) {
        if (listEqual(GameConst.pureSequence[i], num)) {
          val = 1;
          // print(val);
          break;
        }
      }
      if (val == 0) {
        for (int i = 0; i < num.length; i++) {
          print(GameConst.cardsName[num[i]] == rummyJoker);
          if (GameConst.cardsName[num[i]] == rummyJoker) {
            num.remove(num[i]);
            num.add(53);
          }
          if (GameConst.cardsName[num[i]] == rummyJoker) {
            num.remove(num[i]);
            num.add(53);
          }
          if (GameConst.cardsName[num[i]] == rummyJoker) {
            num.remove(num[i]);
            num.add(53);
          }
          if (GameConst.cardsName[num[i]] == rummyJoker) {
            num.remove(num[i]);
            num.add(53);
          }
          if (GameConst.cardsName[num[i]] == "Joker") {
            num.remove(num[i]);
            num.add(53);
          }
          if (num[i] == 54) {
            num.remove(num[i]);
            num.add(53);
          }
        }
        num.sort((a, b) => a.compareTo(b));
        for (int i = 0; i < sequence54.$.length; i++) {
          if (listEqual(sequence54.$[i], num)) {
            val = 2;
            // print(val);
            break;
          }
        }
      }
      // val = GameConst.pureSequence.contains(num)
      //     ? 1
      //     : GameConst.sequence.contains(num)
      //         ? 2
      //         : 0;
      return val!;
    }
    return 0;
  }

  int isSequentialKQJA1(List<int> numbers) {
    if (numbers.length >= 3) {
      int? val = 0;
      bool rummy = false;
      List<int> num = List.from(numbers);
      for (int i = 0; i < num.length; i++) {
        if (rummyJoker == GameConst.cardsName[num[i]] ||
            GameConst.cardsName[num[i]] == "Joker") {
          rummy = true;
          num.removeAt(i);
          num.add(54);
        }
      }
      List a = [], b = [], c = [], d = [], e = [], f = [], g = [];

      num.sort((a, b) => a.toInt().compareTo(b.toInt()));
      if (num[0] <= 13) {
        a = [1, 12, 13];
        b = [1, 13, 54];
        c = [1, 12, 54];
        d = [1, 11, 12, 13];
        e = [1, 12, 13, 54];
        f = [1, 11, 13, 54];
        g = [1, 11, 12, 54];
      } else if (num[0] >= 14 && num[0] <= 26) {
        a = [1 + 13, 12 + 13, 13 + 13];
        b = [1 + 13, 13 + 13, 54];
        c = [1 + 13, 12 + 13, 54];
        d = [1 + 13, 11 + 13, 12 + 13, 13 + 13];
        e = [1 + 13, 12 + 13, 13 + 13, 54];
        f = [1 + 13, 11 + 13, 13 + 13, 54];
        g = [1 + 13, 11 + 13, 12 + 13, 54];
      } else if (num[0] >= 27 && num[0] <= 39) {
        a = [1 + 26, 12 + 26, 13 + 26];
        b = [1 + 26, 13 + 26, 54];
        c = [1 + 26, 12 + 26, 54];
        d = [1 + 26, 11 + 26, 12 + 26, 13 + 26];
        e = [1 + 26, 12 + 26, 13 + 26, 54];
        f = [1 + 26, 11 + 26, 13 + 26, 54];
        g = [1 + 26, 11 + 26, 12 + 26, 54];
      } else if (num[0] >= 40 && num[0] <= 52) {
        a = [1 + 39, 12 + 39, 13 + 39];
        b = [1 + 39, 13 + 39, 54];
        c = [1 + 39, 12 + 39, 54];
        d = [1 + 39, 11 + 39, 12 + 39, 13 + 39];
        e = [1 + 39, 12 + 39, 13 + 39, 54];
        f = [1 + 39, 11 + 39, 13 + 39, 54];
        g = [1 + 39, 11 + 39, 12 + 39, 54];
      }
      if (listEqual(num, a) ||
          listEqual(num, b) ||
          listEqual(num, c) ||
          listEqual(num, d) ||
          listEqual(num, e) ||
          listEqual(num, f) ||
          listEqual(num, g)) {
        val = rummy ? 2 : 1;
        return val;
      } else {
        return 0;
      }
    }
    return 0;
  }

  int isSequentialKQJA(List<int> numbers) {
    if (numbers.length >= 3) {
      int? val = 0;
      List<int> num = List.from(numbers);

      num.sort((a, b) => a.compareTo(b));
      print(num);
      for (int i = 0; i < pureSequenceKQJA.$.length; i++) {
        if (listEqual(pureSequenceKQJA.$[i], num)) {
          val = 1;
          break;
        }
      }

      if (val == 0) {
        for (int i = 0; i < num.length; i++) {
          print(GameConst.cardsName[num[i]] == rummyJoker);
          if (GameConst.cardsName[num[i]] == rummyJoker) {
            num.remove(num[i]);
            num.add(53);
          }
          if (GameConst.cardsName[num[i]] == rummyJoker) {
            num.remove(num[i]);
            num.add(53);
          }
          if (GameConst.cardsName[num[i]] == rummyJoker) {
            num.remove(num[i]);
            num.add(53);
          }
          if (GameConst.cardsName[num[i]] == rummyJoker) {
            num.remove(num[i]);
            num.add(53);
          }
          if (GameConst.cardsName[num[i]] == "Joker") {
            num.remove(num[i]);
            num.add(53);
          }
          if (num[i] == 54) {
            num.remove(num[i]);
            num.add(53);
          }
        }
        num.sort((a, b) => a.toInt().compareTo(b.toInt()));
        for (int i = 0; i < sequenceKQJA.$.length; i++) {
          if (listEqual(sequenceKQJA.$[i], num)) {
            val = 2;
            // print(val);
            break;
          }
        }
      }
      return val!;
    }
    return 0;
  }

  bool listEqual(var list1, var list2) {
    if (!(list1 is List && list2 is List) || list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  bool toSetCheck(List sequence1) {
    bool? val;
    List<int> sequence = List.from(sequence1);
    if (sequence.length >= 3) {
      // if (rummyJoker!.contains(GameConst.cardsName[sequence[0]]) ||
      //     GameConst.cardsName[sequence[0]] == "Joker") {
      //   var firstElement = sequence.removeAt(0);
      //   sequence.add(firstElement);
      // }
      List<int> jokers = [];

      for (int i = 0; i < sequence.length; i++) {
        if (rummyJoker!.contains(GameConst.cardsName[sequence[i]]) ||
            GameConst.cardsName[sequence[i]] == "Joker") {
          jokers.add(sequence[i]);
        }
      }

      // Remove jokers from original sequence
      sequence.removeWhere((element) => jokers.contains(element));

      // Add jokers to the end of the sequence
      sequence.addAll(jokers);
      for (int i = 0; i < sequence.length; i++) {
        if (rummyJoker!.contains(GameConst.cardsName[sequence[i]]) ||
            GameConst.cardsName[sequence[i]] == "Joker") {
          val = true;
        } else if (GameConst.cardsName[sequence[0]] ==
            GameConst.cardsName[sequence[i]]) {
          val = true;
        } else {
          val = false;
          break;
        }
      }
    } else {
      val = false;
    }
    return val!;
  }

  bool hasRepeatedElements<T>(List<T> list) {
    Set<T> encounteredElements = Set<T>();

    for (T element in list) {
      if (encounteredElements.contains(element)) {
        return true; // Repeated element found
      } else {
        encounteredElements.add(element);
      }
    }
    return false; // No repeated elements found
  }

  bool declaration() {
    bool declare = false;
    List<String> statusList = [
      "Invalid",
      "Invalid",
      "Invalid",
      "Invalid",
      "Invalid",
      "Invalid"
    ];
    // setState(() {
    statusList[0] = firstPhase.isEmpty
        ? "Set"
        : isSequential(firstPhase) != 0
            ? statusName(isSequential(firstPhase))
            : isSequentialKQJA(firstPhase) != 0
                ? statusName(isSequentialKQJA(firstPhase))
                : toSetCheck(firstPhase)
                    ? "Set"
                    : "Invalid";

    statusList[1] = secondPhase.isEmpty
        ? "Set"
        : isSequential(secondPhase) != 0
            ? statusName(isSequential(secondPhase))
            : isSequentialKQJA(secondPhase) != 0
                ? statusName(isSequentialKQJA(secondPhase))
                : toSetCheck(secondPhase)
                    ? "Set"
                    : "Invalid";

    statusList[2] = thirdPhase.isEmpty
        ? "Set"
        : isSequential(thirdPhase) != 0
            ? statusName(isSequential(thirdPhase))
            : isSequentialKQJA(thirdPhase) != 0
                ? statusName(isSequentialKQJA(thirdPhase))
                : toSetCheck(thirdPhase)
                    ? "Set"
                    : "Invalid";

    statusList[3] = fourthPhase.isEmpty
        ? "Set"
        : isSequential(fourthPhase) != 0
            ? statusName(isSequential(fourthPhase))
            : isSequentialKQJA(fourthPhase) != 0
                ? statusName(isSequentialKQJA(fourthPhase))
                : toSetCheck(fourthPhase)
                    ? "Set"
                    : "Invalid";

    statusList[4] = fifthPhase.isEmpty
        ? "Set"
        : isSequential(fifthPhase) != 0
            ? statusName(isSequential(fifthPhase))
            : isSequentialKQJA(fifthPhase) != 0
                ? statusName(isSequentialKQJA(fifthPhase))
                : toSetCheck(fifthPhase)
                    ? "Set"
                    : "Invalid";

    statusList[5] = sixthPhase.isEmpty
        ? "Set"
        : isSequential(sixthPhase) != 0
            ? statusName(isSequential(sixthPhase))
            : isSequentialKQJA(sixthPhase) != 0
                ? statusName(isSequentialKQJA(sixthPhase))
                : toSetCheck(sixthPhase)
                    ? "Set"
                    : "Invalid";
    // });

    // int count =
    //     statusList.where((element) => element == "Pure Sequence").length;

    if ((phraseStatusCount("Pure Sequence") >= 2 &&
            statusList.contains("Invalid") == false) ||
        (statusList.contains("Pure Sequence") &&
            statusList.contains("Sequence") &&
            statusList.contains("Invalid") == false)) {
      declare = true;
    }
    return declare;
  }

  List phraseStatus() {
    List<String> statusList = [
      "Invalid",
      "Invalid",
      "Invalid",
      "Invalid",
      "Invalid",
      "Invalid"
    ];
    // setState(() {
    statusList[0] = firstPhase.isEmpty
        ? "Set"
        : isSequential(firstPhase) != 0
            ? statusName(isSequential(firstPhase))
            : isSequentialKQJA(firstPhase) != 0
                ? statusName(isSequentialKQJA(firstPhase))
                : toSetCheck(firstPhase)
                    ? "Set"
                    : "Invalid";

    statusList[1] = secondPhase.isEmpty
        ? "Set"
        : isSequential(secondPhase) != 0
            ? statusName(isSequential(secondPhase))
            : isSequentialKQJA(secondPhase) != 0
                ? statusName(isSequentialKQJA(secondPhase))
                : toSetCheck(secondPhase)
                    ? "Set"
                    : "Invalid";

    statusList[2] = thirdPhase.isEmpty
        ? "Set"
        : isSequential(thirdPhase) != 0
            ? statusName(isSequential(thirdPhase))
            : isSequentialKQJA(thirdPhase) != 0
                ? statusName(isSequentialKQJA(thirdPhase))
                : toSetCheck(thirdPhase)
                    ? "Set"
                    : "Invalid";

    statusList[3] = fourthPhase.isEmpty
        ? "Set"
        : isSequential(fourthPhase) != 0
            ? statusName(isSequential(fourthPhase))
            : isSequentialKQJA(fourthPhase) != 0
                ? statusName(isSequentialKQJA(fourthPhase))
                : toSetCheck(fourthPhase)
                    ? "Set"
                    : "Invalid";

    statusList[4] = fifthPhase.isEmpty
        ? "Set"
        : isSequential(fifthPhase) != 0
            ? statusName(isSequential(fifthPhase))
            : isSequentialKQJA(fifthPhase) != 0
                ? statusName(isSequentialKQJA(fifthPhase))
                : toSetCheck(fifthPhase)
                    ? "Set"
                    : "Invalid";

    statusList[5] = sixthPhase.isEmpty
        ? "Set"
        : isSequential(sixthPhase) != 0
            ? statusName(isSequential(sixthPhase))
            : isSequentialKQJA(sixthPhase) != 0
                ? statusName(isSequentialKQJA(sixthPhase))
                : toSetCheck(sixthPhase)
                    ? "Set"
                    : "Invalid";
    // });
    return statusList;
  }

  int phraseStatusCount(String val) {
    int count = phraseStatus().where((element) => element == val).length;
    return count;
  }

  //------------------------Boolean Functions End------------------------------

  @override
  Widget build(BuildContext context) {
    ctxt = context;
    // getProfileVM = context.watch<GetProfileVM>();
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        StreamBuilder(
            stream: webSocketStream.getResponse,
            builder: (context, snapshot) {
              bool? movable;
              bool? playableStatus;
              if (snapshot.hasData) {
                for (var item in snapshot.data["usersInvolved"]) {
                  if (item["userId"] == userID.$) {
                    movable = item["movableStatus"];
                    playableStatus = item["playableStatus"];
                  }
                }
                balanceCards = snapshot.data["remainingCards"];
                droppedCards = snapshot.data["droppedCards"];
                roomIdVal = snapshot.data["roomId"];
                return Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularCountDownTimer(
                              duration: _duration,
                              initialDuration: 0,
                              controller: _controller,
                              width: 50,
                              height: 50,
                              ringColor: Colors.grey[300]!,
                              ringGradient: null,
                              fillColor:
                                  movable == true //&& playableStatus == true
                                      ? Colors.green[300]!
                                      : Colors.red[300]!,
                              fillGradient: null,
                              backgroundColor:
                                  movable == true //&& playableStatus == true
                                      ? Colors.green[500]
                                      : Colors.red[500],
                              backgroundGradient: null,
                              strokeWidth: 10.0,
                              strokeCap: StrokeCap.round,
                              textStyle: const TextStyle(
                                fontSize: 33.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textFormat: CountdownTextFormat.S,
                              isReverse: true,
                              isReverseAnimation: false,
                              isTimerTextShown: true,
                              autoStart: true,
                              onStart: () {
                                debugPrint('Countdown Started');
                              },
                              onComplete: () {
                                debugPrint('Countdown Ended');
                                cpuTakenDrop();
                                if (movable == true) {
                                  if (cardLength() == 14 &&
                                      tempCard["balanceCard"] == true) {
                                    print("temp${tempCard["cardIndex"]}");
                                    print("userID${userID.$}");
                                    changeTurn({
                                      "roomId": roomIdVal,
                                      "userId": userID.$,
                                      "cardNo": tempCard["cardIndex"]
                                    });
                                  } else if (cardLength() == 14 &&
                                      tempCard["balanceCard"] == false) {
                                    print("temp${tempCard["cardIndex"]}");
                                    dropCard({
                                      "roomId": snapshot.data["roomId"],
                                      "userId": userID.$,
                                      "cardNo": tempCard["cardIndex"]
                                    });
                                  } else {
                                    changeTurn({
                                      "roomId": roomIdVal,
                                      "userId": userID.$
                                    });
                                  }
                                  setState(() {
                                    if (cardLength() == 14) {
                                      if (firstPhase
                                          .contains(tempCard["cardIndex"])) {
                                        firstPhase
                                            .remove(tempCard["cardIndex"]);
                                      } else if (secondPhase
                                          .contains(tempCard["cardIndex"])) {
                                        secondPhase
                                            .remove(tempCard["cardIndex"]);
                                      } else if (thirdPhase
                                          .contains(tempCard["cardIndex"])) {
                                        thirdPhase
                                            .remove(tempCard["cardIndex"]);
                                      } else if (fourthPhase
                                          .contains(tempCard["cardIndex"])) {
                                        fourthPhase
                                            .remove(tempCard["cardIndex"]);
                                      } else if (fifthPhase
                                          .contains(tempCard["cardIndex"])) {
                                        fifthPhase
                                            .remove(tempCard["cardIndex"]);
                                      } else if (sixthPhase
                                          .contains(tempCard["cardIndex"])) {
                                        sixthPhase
                                            .remove(tempCard["cardIndex"]);
                                      }
                                    }
                                  });
                                }
                              },
                              onChange: (String timeStamp) {
                                debugPrint('Countdown Changed $timeStamp');
                              },
                              timeFormatterFunction:
                                  (defaultFormatterFunction, duration) {
                                if (duration.inSeconds == 0) {
                                  return "30";
                                } else {
                                  return Function.apply(
                                      defaultFormatterFunction, [duration]);
                                }
                              },
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                SizedBox(
                                  width: 140,
                                  height: 100,
                                  child: Center(
                                    child: Transform.rotate(
                                        angle: -math.pi / 2,
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                                // height: 90,
                                                // width: 60,
                                                child: getSpriteImage(
                                                    GameConst.cardsName
                                                        .indexOf(rummyJoker),
                                                    context)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(3.0),
                                              child: Image.asset(
                                                ImageConstant.jokerCap,
                                                width: 20,
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                balanceCards.isNotEmpty
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (cardLength() == 13 &&
                                                      movable ==
                                                          true //&& playableStatus == true
                                                  ) {
                                                if (firstPhase.isEmpty) {
                                                  firstPhase
                                                      .add(balanceCards[0]);
                                                } else if (secondPhase
                                                    .isEmpty) {
                                                  secondPhase
                                                      .add(balanceCards[0]);
                                                } else if (thirdPhase.isEmpty) {
                                                  thirdPhase
                                                      .add(balanceCards[0]);
                                                } else if (fourthPhase
                                                    .isEmpty) {
                                                  fourthPhase
                                                      .add(balanceCards[0]);
                                                } else if (fifthPhase.isEmpty) {
                                                  fifthPhase
                                                      .add(balanceCards[0]);
                                                } else {
                                                  sixthPhase
                                                      .add(balanceCards[0]);
                                                }
                                                tempCard = {
                                                  "balanceCard": true,
                                                  "cardIndex": balanceCards[0]
                                                };
                                                takeCard({
                                                  "roomId":
                                                      snapshot.data["roomId"],
                                                  "userId": userID.$,
                                                  "cardNo": balanceCards[0],
                                                  "takenFrom": ""
                                                });
                                                balanceCards.removeAt(0);
                                              }
                                            });
                                          },
                                          child: Container(
                                              child: Image.asset(
                                            ImageConstant.cardBack,
                                            height: 90,
                                            // width: 60,
                                          )),
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            DecoratedBox(
                              decoration: focus && focusedPhrase == 7
                                  ? focusDecoration
                                  : BoxDecoration(),
                              position: DecorationPosition.foreground,
                              child: DragTarget<int>(
                                builder: (BuildContext context,
                                    List<dynamic> accepted,
                                    List<dynamic> rejected) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: droppedCards.isNotEmpty
                                        ? Draggable(
                                            data: (cardLength() == 13 &&
                                                    movable ==
                                                        true // && playableStatus == true
                                                )
                                                ? droppedCards[
                                                    droppedCards.length - 1]
                                                : null,
                                            onDragCompleted: () {
                                              tempCard = {
                                                "balanceCard": false,
                                                "cardIndex": droppedCards[
                                                    droppedCards.length - 1]
                                              };
                                              takeCard({
                                                "roomId":
                                                    snapshot.data["roomId"],
                                                "userId": userID.$,
                                                "cardNo": droppedCards[
                                                    droppedCards.length - 1],
                                                "takenFrom": "droppedCards"
                                              });
                                              droppedCards.remove(droppedCards[
                                                  droppedCards.length - 1]);
                                            },
                                            childWhenDragging: Image.asset(
                                              ImageConstant.dropCardBG,
                                              // height: 80,
                                              width: AppSize.width(context, 11),
                                            ),
                                            feedback: cardLength() == 13 &&
                                                    movable ==
                                                        true // && playableStatus == true
                                                ? Stack(
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    children: [
                                                      Container(
                                                        // height: 90,
                                                        // width: 60,
                                                        child: getSpriteImage(
                                                            droppedCards[
                                                                droppedCards
                                                                        .length -
                                                                    1],
                                                            context),
                                                        // color: Colors.white,
                                                      ),
                                                      rummyJoker!.contains(GameConst
                                                                  .cardsName[
                                                              droppedCards[
                                                                  droppedCards
                                                                          .length -
                                                                      1]])
                                                          ? Container(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        3.0),
                                                                child:
                                                                    Image.asset(
                                                                  ImageConstant
                                                                      .jokerCap,
                                                                  width: 15,
                                                                  fit: BoxFit
                                                                      .fitWidth,
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                    ],
                                                  )
                                                : SizedBox(),
                                            child: Stack(
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                Image.asset(
                                                  ImageConstant.dropCardBG,
                                                  // height: 80,
                                                  // width: 130,
                                                  width: AppSize.width(
                                                      context, 11),
                                                ),
                                                Container(
                                                  // height: 80,
                                                  // width: 60,
                                                  child: getSpriteImage(
                                                      droppedCards[
                                                          droppedCards.length -
                                                              1],
                                                      context),
                                                  // color: Colors.white,
                                                ),
                                                rummyJoker!.contains(GameConst
                                                            .cardsName[
                                                        droppedCards[
                                                            droppedCards
                                                                    .length -
                                                                1]])
                                                    ? Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Image.asset(
                                                            ImageConstant
                                                                .jokerCap,
                                                            width: 15,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          )
                                        : Image.asset(
                                            ImageConstant.dropCardBG,
                                            // height: 80,
                                            width: AppSize.width(context, 11),
                                          ),
                                  );
                                },
                                onWillAccept: (data) {
                                  if (cardLength() == 14) {
                                    setState(() {
                                      focus = true;
                                      focusedPhrase = 7;
                                    });
                                    return data != null ? true : false;
                                  } else {
                                    return false;
                                  }
                                },
                                onAccept: (data) {
                                  if (cardLength() == 14) {
                                    setState(() {
                                      focus = false;
                                      focusedPhrase = 0;
                                      drag = true;
                                      droppedCards.add(data);
                                      movable = false;
                                    });
                                    dropCard({
                                      "roomId": snapshot.data["roomId"],
                                      "userId": userID.$,
                                      "cardNo": data
                                    });
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              width: 50,
                            ),
                            DecoratedBox(
                              decoration: focus && focusedPhrase == 8
                                  ? focusDecoration
                                  : BoxDecoration(),
                              position: DecorationPosition.foreground,
                              child: DragTarget<int>(
                                builder: (BuildContext context,
                                    List<dynamic> accepted,
                                    List<dynamic> rejected) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: finished.isNotEmpty
                                        ? Draggable(
                                            feedback: SizedBox(),
                                            child: Stack(
                                              alignment: Alignment.centerLeft,
                                              children: [
                                                Container(
                                                  // height: 80,
                                                  // width: 60,
                                                  child: getSpriteImage(
                                                      finished[0], context),
                                                  // color: Colors.white,
                                                ),
                                                rummyJoker!.contains(GameConst
                                                        .cardsName[finished[0]])
                                                    ? Container(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Image.asset(
                                                            ImageConstant
                                                                .jokerCap,
                                                            width: 15,
                                                            fit:
                                                                BoxFit.fitWidth,
                                                          ),
                                                        ),
                                                      )
                                                    : SizedBox(),
                                              ],
                                            ),
                                          )
                                        : Image.asset(
                                            ImageConstant.placeHold,
                                            height: AppSize.height(context, 22),
                                            width: AppSize.width(context, 7),
                                            fit: BoxFit.fill,
                                          ),
                                  );
                                },
                                onWillAccept: (data) {
                                  if (cardLength() == 14) {
                                    setState(() {
                                      focus = true;
                                      focusedPhrase = 8;
                                    });
                                    return data != null ? true : false;
                                  } else {
                                    return false;
                                  }
                                },
                                onAccept: (data) {
                                  if (cardLength() == 14) {
                                    setState(() {
                                      focus = false;
                                      focusedPhrase = 0;
                                      drag = true;
                                      finished.add(data);
                                      if (firstPhase.contains(data)) {
                                        firstPhase.remove(data);
                                      } else if (secondPhase.contains(data)) {
                                        secondPhase.remove(data);
                                      } else if (thirdPhase.contains(data)) {
                                        thirdPhase.remove(data);
                                      } else if (fourthPhase.contains(data)) {
                                        fourthPhase.remove(data);
                                      } else if (fifthPhase.contains(data)) {
                                        fifthPhase.remove(data);
                                      } else if (sixthPhase.contains(data)) {
                                        sixthPhase.remove(data);
                                      }
                                    });
                                    if (declaration()) {
                                      finishCard({
                                        "roomId": snapshot.data["roomId"],
                                        "userId": userID.$,
                                        "wrongDeclare": false,
                                        "sequence": [
                                          firstPhase,
                                          secondPhase,
                                          thirdPhase,
                                          fourthPhase,
                                          fifthPhase,
                                          sixthPhase
                                        ],
                                        "points": 0
                                      });
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return Winner(snapshotData: snapshot.data);
                                      //   },
                                      // );
                                    } else {
                                      finishCard({
                                        "roomId": snapshot.data["roomId"],
                                        "userId": userID.$,
                                        "wrongDeclare": true,
                                        "sequence": [
                                          firstPhase,
                                          secondPhase,
                                          thirdPhase,
                                          fourthPhase,
                                          fifthPhase,
                                          sixthPhase
                                        ],
                                        "points": declarePoints()
                                      });
                                      // showDialog(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return WrongDeclare(
                                      //         snapshotData: snapshot.data);
                                      //   },
                                      // );
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Container(
                            width: MediaQuery.sizeOf(context).width,
                            height: AppSize.height(context, 35), //130
                            child: buildColumnWithItems(snapshot),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, bottom: 8),
                      child: AppText(
                        movable == true //&& playableStatus == true
                            ? "Swipe your card!!!"
                            : playableStatus == false
                                ? "Wrong Declare"
                                : "Please wait!!!",
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: LoadingWidget(),
              );
            }),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, top: 8),
          child: InkWell(
            child: Image.asset(ImageConstant.logout),
            onTap: () {
              showDialog<String>(
                context: ctxt!,
                builder: (BuildContext context) => PlayExitAlert(onTap: () {
                  if (matchStatus != null && matchStatus == 1) {
                    print("Dropppppp");
                    Navigator.pop(ctxt!);
                    finishCard({
                      "roomId": roomIdVal,
                      "userId": userID.$,
                      "wrongDeclare": true,
                      "sequence": [
                        firstPhase,
                        secondPhase,
                        thirdPhase,
                        fourthPhase,
                        fifthPhase,
                        sixthPhase
                      ],
                      "points": declarePoints()
                    });
                    // if (widget.playerStatus == false) {
                    //   Navigator.pop(ctxt!);
                    // }
                  } else {
                    print("exittttt");
                    exitGame({
                      "roomId": roomIdVal,
                      "userId": userID.$,
                      "refundAmount": widget.amount
                    });
                  }
                }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildColumnWithItems(snapshot) {
    cardSplit(snapshot);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardsStatus(firstPhase),
            draggableCards(firstPhase, 1),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardsStatus(secondPhase),
            draggableCards(secondPhase, 2),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardsStatus(thirdPhase),
            draggableCards(thirdPhase, 3),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardsStatus(fourthPhase),
            draggableCards(fourthPhase, 4),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardsStatus(fifthPhase),
            draggableCards(fifthPhase, 5),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            cardsStatus(sixthPhase),
            draggableCards(sixthPhase, 6),
          ],
        ),
      ],
    );
  }

  Widget cardsStatus(List<int> cards) {
    return cards.isEmpty
        ? SizedBox()
        : Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // border: Border.all(color: Colors.red),
                color: Colors.black26),
            // height: 20,
            child: Padding(
                padding: EdgeInsets.all(4.0),
                child: (isSequential(cards) != 0) ||
                        isSequentialKQJA(cards) != 0
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          phraseStatus().contains("Pure Sequence")
                              ? Icon(Icons.done, size: 12, color: Colors.green)
                              : SizedBox(),
                          Text(
                            statusName(isSequential(cards) != 0
                                    ? isSequential(cards)
                                    : isSequentialKQJA(cards)) +
                                (phraseStatus().contains("Pure Sequence")
                                    ? ""
                                    : "(${points(cards)})"),
                            style: TextStyle(
                                color: phraseStatus().contains("Pure Sequence")
                                    ? Colors.green
                                    : Colors.grey,
                                fontSize: 12),
                          ),
                        ],
                      )
                    : (cards.isNotEmpty && toSetCheck(cards))
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              (phraseStatusCount("Pure Sequence") >= 2 ||
                                      (phraseStatus()
                                              .contains("Pure Sequence") &&
                                          phraseStatus().contains("Sequence")))
                                  ? Icon(Icons.done,
                                      size: 12, color: Colors.green)
                                  : SizedBox(),
                              Text(
                                "Set${(phraseStatusCount("Pure Sequence") >= 2 || (phraseStatus().contains("Pure Sequence") && phraseStatus().contains("Sequence"))) ? "" : "(${points(cards)})"}",
                                style: TextStyle(
                                    color:
                                        (phraseStatusCount("Pure Sequence") >=
                                                    2 ||
                                                (phraseStatus().contains(
                                                        "Pure Sequence") &&
                                                    phraseStatus()
                                                        .contains("Sequence")))
                                            ? Colors.green
                                            : Colors.grey,
                                    fontSize: 12),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.close,
                                  size: 12, color: Colors.red),
                              Text(
                                "Invalid(${points(cards)})",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ],
                          )),
          );
  }

  bool focus = false;
  int focusedPhrase = 0;
  BoxDecoration focusDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.red, width: 3));

  Widget draggableCards(List<int> cards, int phrase) {
    return Container(
      decoration:
          focus && focusedPhrase == phrase ? focusDecoration : BoxDecoration(),
      // position: DecorationPosition.foreground,
      child: DragTarget<int>(
        builder: (BuildContext context, List<dynamic> accepted,
            List<dynamic> rejected) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: cards.isNotEmpty
                ? Stack(
                    children: cards.map((card) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: cards.indexOf(card).toDouble() *
                                AppSize.width(context, 3.0)),
                        child: Draggable(
                          data: card,
                          childWhenDragging: SizedBox(
                            height: AppSize.height(context, 20), //80
                            width: AppSize.width(context, 7),
                          ),
                          onDragCompleted: () {
                            cards.remove(card);
                          },
                          feedback: commonContainer(
                              child: getSpriteImage(card, context),
                              cardNo: card),
                          child: commonContainer(
                              child: getSpriteImage(card, context),
                              cardNo: card),
                        ),
                      );
                    }).toList(),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey, width: 2),
                    ),
                    height: AppSize.height(context, 20), //80
                    width: AppSize.width(context, 7), //55
                  ),
          );
        },
        onWillAccept: (data) {
          setState(() {
            focus = true;
            focusedPhrase = phrase;
          });
          return data != null ? true : false;
        },
        onLeave: (data) {
          setState(() {
            focus = false;
            focusedPhrase = 0;
          });
        },
        onAccept: (data) {
          setState(() {
            focus = false;
            focusedPhrase = 0;
            drag = true;
            cards.add(data);
          });
        },
      ),
    );
  }

  Widget commonContainer({required Widget child, required int cardNo}) {
    // margin = margin * AppSize.width(context, 3.0); //30
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Container(
          // margin: margin,
          // height: AppSize.height(context, 20), //100
          // width: AppSize.width(context, 7), //65
          child: child,
          // color: Colors.white,
        ),
        rummyJoker!.contains(GameConst.cardsName[cardNo])
            ? Container(
                // margin: margin,
                // height: 70,
                // width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Image.asset(
                    ImageConstant.jokerCap,
                    width: AppSize.width(context, 2),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              )
            : SizedBox(),
      ],
    );
  }
}
