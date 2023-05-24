import 'dart:async';
import 'package:emulator/app/network/socket/socket.dart';
import 'package:emulator/app/network/socket/tcp_socket.dart';
import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'custom_acc_controller.dart';
import 'custom_batt_controller.dart';
import 'custom_compass_controller.dart';
import 'custom_gyro_controller.dart';
import 'custom_map_controller.dart';
import 'custom_mic_controller.dart';
import 'customcamera_controller.dart';

class MainController extends GetxController {
  var camController = Get.find<CustomcameraController>();
  var compassController = Get.find<CustomCompassController>();
  var gyroController = Get.find<CustomGyroController>();
  var accController = Get.find<CustomAccController>();
  var battController = Get.find<CustomBattController>();
  var mapController = Get.find<CustomMapController>();
  var micController = Get.find<CustomMicController>();
  //variable
  SocketApi socketApi = TcpSocket();
  Timer? timer;

  RxDouble sliderValue = 0.0.obs;
  RxDouble zoomsliderValue = 0.0.obs;

  void getPermissions() async {
    await Permission.storage.request();
    await Permission.accessMediaLocation.request();
    await Permission.camera.request();
    await Permission.videos.request();
    await Permission.locationWhenInUse.request();
  }

  @override
  void onInit() async {
    // initSocket();
    getPermissions();
    super.onInit();
  }

  @override
  void onClose() async {
    // closeSocket();
    super.onInit();
  }

  //function
  void initSocket() async {
    await socketApi.initSoket('127.0.0.1', 5555, (data) {
      commandDecoding(data);
      print(data);
    }).then((value) {
      // sendData();
    });
  }

  void sendReport(dynamic message) async {
    await socketApi.sendDataOnSocket(message);
  }

  void commandDecoding(CommandMessage command) async {
    switch (command.whichCommand()) {
      // case CommandMessage_Command.startVideoRecordingCommand:
      //   camController.videoRecordingRequest(
      //       width: command.startVideoRecordingCommand.width,
      //       height: command.startVideoRecordingCommand.height,
      //       duration:
      //           Duration(seconds: command.startVideoRecordingCommand.duration),
      //       zoom: command.startVideoRecordingCommand.zoom,
      //       bitRate: command.startVideoRecordingCommand.bitrate);
      //   break;

      case CommandMessage_Command.getLocation:
        // sendReport(await mapController.requestGPSData());
        break;
      case CommandMessage_Command.getAcceleration:
        // sendReport(await accController.requestGPSData());
        break;
      case CommandMessage_Command.getCompass:
        // TODO: Handle this case.
        break;
      case CommandMessage_Command.getBattery:
        // TODO: Handle this case.
        break;
      case CommandMessage_Command.getGyroscope:
        // TODO: Handle this case.
        break;
      case CommandMessage_Command.notSet:
        // TODO: Handle this case.
        break;
      case CommandMessage_Command.getDirectoryInfo:
        // TODO: Handle this case.
        break;
      case CommandMessage_Command.videoRecord:
        // TODO: Handle this case.
        break;
      case CommandMessage_Command.audioRecord:
        // TODO: Handle this case.
        break;
      case CommandMessage_Command.takePhoto:
        // TODO: Handle this case.
        break;
    }
  }
}
