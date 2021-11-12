import 'dart:io';

import 'dart:isolate';

final defaultNum = Platform.numberOfProcessors;

void main(List<String> args) async {
  List<ReceivePort> ports = [];
  for (int i = 0; i < (args.length == 1 ? int.tryParse(args[0]) ?? defaultNum : defaultNum); i++) {
    final port = ReceivePort();
    ports.add(port);
    Isolate x = await Isolate.spawn(spawnClient, [port.sendPort, i]);
    x.setErrorsFatal(true);
    port.listen(print);
  }
}

const messages = [
  "Hello",
  "Hi There",
  "Bonjour",
  "Ni Hao",
  "Konichiwa",
  "Hola",
  "Hei",
  "Hallo",
  "Privet",
  "Ciao",
  "Ola",
  "Xin Chào",
  "Halo",
  "Namasté",
  "Salut",
  "Hallå",
  "Guten Tag",
  "Salaam",
  "Merhaba",
  "Szia",
  "Sveiki",
  "Zdravstvuyte",
  "Sawubona",
  "Halo",
];

void spawnClient(List<dynamic> values) async {
  int count = 0;
  SendPort port = values[0];
  int index = values[1];
  Socket client = await Socket.connect('127.0.0.1', 8080);
  print('Client $index connected');
  client.listen(printBytesToString);

  while (true) {
    await Future.delayed(const Duration(milliseconds: 8));
    client.add("${messages[index]} ${count++}".codeUnits);
  }
}



void printBytesToString(List<int> bytes) => print(String.fromCharCodes(bytes));