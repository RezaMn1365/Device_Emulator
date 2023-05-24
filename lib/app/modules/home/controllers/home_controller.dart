import 'dart:typed_data';

import 'package:emulator/app/data/file_reader/local_data.dart';
import 'package:emulator/app/data/file_reader/parse_local_data.dart';
import 'package:emulator/app/data/storage/storage.dart';
import 'package:emulator/app/modules/home/device_model.dart';
import 'package:emulator/app/modules/main/controllers/custom_beacon_controller.dart';
import 'package:emulator/app/modules/main/controllers/custom_file_controller.dart';
import 'package:emulator/app/network/socket/tcp_socket.dart';
import 'package:emulator/app/routes/app_pages.dart';
import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:emulator/src/generated/socket/socket.pb.dart';
import 'package:emulator/src/generated/tcp_socket.pb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../network/http/http_implement.dart';
import '../../../network/socket/socket.dart';
import '../../main/controllers/custom_acc_controller.dart';
import '../../main/controllers/custom_batt_controller.dart';
import '../../main/controllers/custom_compass_controller.dart';
import '../../main/controllers/custom_gyro_controller.dart';
import '../../main/controllers/custom_map_controller.dart';
import '../../main/controllers/custom_mic_controller.dart';
import '../../main/controllers/customcamera_controller.dart';

class HomeController extends GetxController {
  var fileController = Get.find<CustomFileController>();
  var gyroController = Get.find<CustomGyroController>();
  var accController = Get.find<CustomAccController>();
  var beaconController = Get.find<CustomBeaconController>();

  //variable
  //variable
  LocalData localData = ParseLocalData();
  RxList<String> deviceList = RxList();
  RxString dropDownValue = 'test'.obs;
  Map<String, String>? deviceConfig;
  RxMap<String, dynamic> tokens = RxMap();

  final dynamicVar = Rx<dynamic>(null);

  RxBool socketConnection = false.obs;

  final httpInstance = HttpImplement();

  final deviceData = Device();

  String localId = '';
  String serial = '';
  String secret = '';

  void nextPage() {
    Get.offNamed(Routes.MAIN, arguments: deviceConfig);
  }

  Future<bool> signInRequest() async {
    // deviceData.deviceId = ' ';
    deviceData.serial = serial;
    deviceData.localId = localId;
    deviceData.secret = secret;

    bool response = await httpInstance.signInRequest(
        'http://192.168.1.180:8081/authentication/signin', deviceData);
    return response;
  }

  Future<bool> ticketRequest() async {
    bool response = await httpInstance
        .requestTicket('http://192.168.1.180:8081/connector/get');
    return response;
  }

  Future<bool> logout() async {
    var response = await httpInstance.logout();

    if (response.success) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> refreshToken() async {
    var response = await httpInstance.tryRefreshToken();
    print('refresh: $response');

    if (response) {
      // tokens.value = await Storage().getTokens();
      // print(tokens.value);
      return true;
    } else {
      return false;
    }
  }

  var recivedData;

  SocketApi socketApi = TcpSocket();
  Future<void> initSocket(String ip, int port) async {
    print(port);
    print(ip);

    await socketApi.initSoket(ip, port, _socketListener);
    // .then((value) {});
  }

  _socketListener(data) {
    dynamicVar(data);

    // var response = HelloResponse(msg: data);
    // print(response);
    // var helloResponse = HelloResponse.fromBuffer(data).msg;
    // print(helloResponse);
    if (data != null) {
      socketConnection.value = true;
    }
    // String s = String.fromCharCodes(data);
    // var outputAsUint8List = Uint8List.fromList(s.codeUnits);

    // var response = VerificationRequest.fromBuffer(data).ticket;
    // streamController.add(helloResponse);
    // print('response: $response');

    // print('recieved: ${outputAsUint8List}');
  }

  Future<void> sendData(ReportMessage sample) async {
    print('start send data');
    // timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
    await socketApi.sendDataOnSocket(sample);
    // });
  }

  Future<void> sendVerficationSocket(
      VerificationRequest verificationRequest) async {
    print('start send verification data');
    // timer = Timer.periodic(const Duration(seconds: 2), (timer) async {
    await socketApi.sendVerifyReqSocket(verificationRequest);
    // });
  }

  //override

  @override
  void onInit() {
    // initListDevice();

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //function
  // void initListDevice() async {
  //   deviceList.value = await localData.directorySurvey();
  //   dropDownValue.value = deviceList.first;
  // }

  // void onSelected(String value) {
  //   dropDownValue.value = value;
  // }

  void submit() async {
    if (await signInRequest()) {
      // Get.offNamed(Routes.MAIN, arguments: deviceConfig);
      Get.defaultDialog(
          title: 'Success', content: const Text('Press ticket to get ticket'));
    } else {
      Get.defaultDialog(
          title: 'Alert', content: const Text('Http connection problem'));
    }
  }

  void ticket() async {
    if (await ticketRequest()) {
      var ticket = await Storage().getTicket();
      Get.defaultDialog(
          title: 'Success', content: Text('Ticket got successfully $ticket'));
    } else {
      Get.defaultDialog(
          title: 'Alert', content: const Text('connection problem '));
    }
  }

  void openSocket() async {
    var ticket = await Storage().getTicket();
    // await initSocket(ticket['broker_ip'], int.parse(ticket['broker_port']));
    await initSocket('192.168.1.180', int.parse(ticket['broker_port']));
    // if (socketConnection.value) {
    //   Get.defaultDialog(title: 'Socket status', content: Text('connected'));
    // } else {
    //   Get.defaultDialog(
    //       title: 'Alert', content: Text('Socket was not connected'));
    // }
  }

  void sendTicketSocket() async {
    var ticket = await Storage().getTicket();
    print(ticket['ticket']);
    await sendVerficationSocket(VerificationRequest(ticket: ticket['ticket']));

    if (socketConnection.value) {
      Get.defaultDialog(title: 'Socket response', content: Text('...'));
    } else {
      Get.defaultDialog(
          title: 'Alert', content: Text('Socket was not connected'));
    }
  }

  Future<void> sendSampleData() async {
    var sample = await accController.getSample();
    await sendData(sample);
    Get.defaultDialog(
        content: Text(
            'hasVideoRecord: ${CommandMessage.fromBuffer(dynamicVar.value).hasVideoRecord()}'));
    Get.defaultDialog(
        content: Text(
            'VideoRecordValue: ${CommandMessage.fromBuffer(dynamicVar.value).videoRecord}'));
  }
}
