import 'dart:async';
import 'dart:io';

import 'dart:isolate';

import 'package:io/ansi.dart';

List<SendPort> sendPorts = [];

int j = 0;
void main() async {
  StreamController<Object?> controller = StreamController<Object?>();
  List<ReceivePort> ports = [];
  for (int i = 0; i < Platform.numberOfProcessors ~/ 2; i++) {
    final port = ReceivePort();
    port.listen(print);
    await Isolate.spawn(spawnServer, SimpleInfo(port.sendPort, i));
  }
}

class SimpleInfo {
  final SendPort port;
  final int index;
  SimpleInfo(this.port, this.index);
}

const List<AnsiCode> codes = [
  red,
  green,
  yellow,
  blue,
  magenta,
  cyan,
  lightRed,
  lightGreen,
  lightYellow,
  lightBlue,
  lightMagenta,
  lightCyan,
];

void spawnServer(SimpleInfo info) async {
  ServerSocket serverSocket = await ServerSocket.bind('127.0.0.1', 8080, shared: true, backlog: 10);
  await for (final conn in serverSocket) {
    final socket = conn;
    socket.listen((data) {
      print(wrapWith('Server ${info.index} received: ${String.fromCharCodes(data)}', [codes[info.index]]));
      // info.port.send(data);
    }, onDone: () {
      print('${info.index} done');
    });
  }
}