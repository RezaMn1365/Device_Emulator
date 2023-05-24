import 'package:emulator/src/generated/socket/socket.pbgrpc.dart';

abstract class SocketApi {
  ///
  ///initialinig Socket I/O then start listening to it.
  ///
  Future<void> initSoket(
      String host, int port, Function(dynamic data) onTcpData);

  ///
  ///this function sends data on previously opened Socket
  ///
  Future<void> sendDataOnSocket(dynamic message);
  Future<void> sendVerifyReqSocket(VerificationRequest verificationRequest);

  ///
  ///this function invokes when closing socket needed
  ///
  Future<void> closeSocketConnection();
}
