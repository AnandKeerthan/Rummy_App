import 'dart:async';

class WebSocketStream {
  final _socketResponse = StreamController<dynamic>.broadcast();

  void Function(dynamic) get addResponse => _socketResponse.sink.add;

  Stream<dynamic> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
