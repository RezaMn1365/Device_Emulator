import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:emulator/app/network/socket/socket.dart';
import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:emulator/src/generated/socket/socket.pb.dart';

import '../../../src/generated/tcp_socket.pbgrpc.dart';

late Socket socket;

class TcpSocket implements SocketApi {
  @override
  Future<void> initSoket(
      String host, int port, Function(dynamic data) onTcpData) async {
    print('start socket');

    try {
      final socketConnection = await Socket.connect(host, port);
      socket = socketConnection;
      socket.listen(onTcpData,
          onError: errorHandler, onDone: doneHandler, cancelOnError: true);
    } catch (e) {}

    // await Socket.connect(host, port).then((Socket socketConnection) {
    //   socket = socketConnection;
    //   socket.listen((data) {
    //     print('tcpdata: $data');
    //     onTcpData(data);
    //   }, onError: errorHandler, onDone: doneHandler, cancelOnError: true);
    // }).catchError((e) {
    //   print("Unable to connect: $e");
    // });
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket.destroy();
  }

  @override
  Future<void> sendDataOnSocket(dynamic message) async {
    try {
      // HelloRequest helloRequest = HelloRequest(name: message);
      // var buffer = helloRequest.writeToBuffer();
      // socket.add(buffer);

      var buffer = message.writeToBuffer();
      socket.add(buffer);
    } catch (e) {
      print(' connecting to server failed!');
    }
  }

  @override
  Future<void> sendVerifyReqSocket(
      VerificationRequest verificationRequest) async {
    try {
      var buffer = verificationRequest.writeToBuffer();
      socket.add(buffer);

      // List<int> list = 'xxx'.codeUnits; //for Test Server
      // Uint8List bytes = Uint8List.fromList(list); //for Test Server
      // socket.add(bytes);
    } catch (e) {
      print(' connecting to server failed! $e');
    }
  }

  @override
  Future<void> closeSocketConnection() async {
    socket.destroy();
  }
}
