import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:emulator/src/generated/message/messages.pb.dart';
import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

import 'custom_file_controller.dart';

class CustomCompassController extends GetxController {
  var fileController = Get.find<CustomFileController>();

  RxList<double> magnetometer = <double>[0, 0, 0].obs;
  RxDouble direction = 0.0.obs;

  late StreamSubscription<MagnetometerEvent> compassStream;
  RxBool isRunning = false.obs;
  RxDouble x = 0.0.obs;
  RxDouble y = 0.0.obs;
  RxDouble z = 0.0.obs;

  RxBool buttomEnable = true.obs;
  RxBool locked = false.obs;
  RxBool onOff = false.obs;
  RxBool blinking = false.obs;
  RxString buttomText = 'Press'.obs;
  void onPressed() async {
    await makeReportFile();
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
    fileController.writeToFile('/data/sensor/compass/compass', data);
  }

  Future<ReportMessage> getSample() async {
    if (isRunning.value) {
      return ReportMessage(
        compass: Compass(
            direction: direction.value,
            xMagnetometer: x.value,
            yMagnetometer: y.value,
            zMagnetometer: z.value),
      );
    } else {
      var result = await magnetometerEvents.first;
      List<double> allValues = [];
      allValues.addAll([result.x, result.y, result.z]);
      double directionValue = 90 - atan(result.y / result.x) * 180 / pi;
      return ReportMessage(
        compass: Compass(
            direction: directionValue,
            xMagnetometer: result.x,
            yMagnetometer: result.y,
            zMagnetometer: result.z),
      );
    }
  }

  Future<void> start() async {
    buttomEnable.value = false;
    locked.value = true;
    onOff.value = true;
    blinking.value = true;
    buttomText.value = 'processing...';
    isRunning.value = true;
    compassStream = magnetometerEvents.listen(
      (MagnetometerEvent event) {
        x.value = event.x;
        y.value = event.y;
        z.value = event.z;
        magnetometer.clear();
        magnetometer.addAll([event.x, event.y, event.z]);
        direction.value = 90 - atan(event.y / event.x) * 180 / pi;
      },
    );
  }

  Future<void> stop() async {
    buttomEnable.value = false;
    locked.value = false;
    onOff.value = false;
    blinking.value = false;
    buttomText.value = 'Press';
    isRunning.value = false;
    await compassStream.cancel();
  }
}
