import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'custom_file_controller.dart';

class CustomAccController extends GetxController {
  var fileController = Get.find<CustomFileController>();

  late StreamSubscription<UserAccelerometerEvent> accStream;
  RxBool isRunning = false.obs;

  RxDouble acceleration = 0.0.obs;
  RxDouble x = 0.0.obs;
  RxDouble y = 0.0.obs;
  RxDouble z = 0.0.obs;

  RxBool buttomEnable = true.obs;
  RxBool locked = false.obs;
  RxBool onOff = false.obs;
  RxBool blinking = false.obs;
  RxString buttomText = 'Press'.obs;

  void onPressed() {
    makeReportFile();
  }

  @override
  void onInit() {
    // startSensorsListening();
    super.onInit();
  }

  Future<void> startStream() async {
    if (!isRunning.value) {
      await start();
    }
  }

  Future<void> stoptStream() async {
    if (isRunning.value) {
      await stop();
    }
  }

  Future<void> makeReportFile() async {
    var rawData = await getSample();
    var data = base64Encode(rawData.writeToBuffer()) + '\n';
    fileController.writeToFile('/data/sensor/acceleration/acceleration', data);
  }

  Future<ReportMessage> getSample() async {
    if (isRunning.value) {
      return ReportMessage(
          acceleration: Acceleration(
              totalAcceleration: acceleration.value,
              xAcceleration: x.value,
              yAcceleration: y.value,
              zAcceleration: z.value));
    } else {
      var result = await userAccelerometerEvents.first;
      var totalAcc =
          sqrt((pow(result.x, 2) + pow(result.y, 2) + pow(result.z, 2)));
      print(totalAcc);
      return ReportMessage(
          acceleration: Acceleration(
              totalAcceleration: totalAcc,
              xAcceleration: result.x,
              yAcceleration: result.y,
              zAcceleration: result.z));
    }
  }

  Future<void> start() async {
    buttomEnable.value = false;
    locked.value = true;
    onOff.value = true;
    blinking.value = true;
    buttomText.value = 'processing...';
    isRunning.value = true;
    accStream = userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      x.value = event.x;
      y.value = event.y;
      z.value = event.z;
      acceleration.value =
          sqrt((pow(event.x, 2) + pow(event.y, 2) + pow(event.z, 2)));
    });
  }

  Future<void> stop() async {
    buttomEnable.value = false;
    locked.value = false;
    onOff.value = false;
    blinking.value = false;
    buttomText.value = 'Press';
    isRunning.value = false;
    await accStream.cancel();
  }
}
